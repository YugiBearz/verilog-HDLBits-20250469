module top_module (
    input clk,
    input reset,
    input data,
    output [3:0] count,
    output counting,
    output done,
    input ack
);
    parameter S0 = 4'd0, S1 = 4'd1, S2 = 4'd2, S3 = 4'd3,
              B0 = 4'd4, B1 = 4'd5, B2 = 4'd6, B3 = 4'd7,
              COUNT = 4'd8, WAIT = 4'd9;
    reg [3:0] state, next_state;
    reg [3:0] delay;
    reg [9:0] cnt1k;

    always @(*) begin
        case (state)
            S0:    next_state = data ? S1 : S0;
            S1:    next_state = data ? S2 : S0;
            S2:    next_state = data ? S2 : S3;
            S3:    next_state = data ? B0 : S0;
            B0:    next_state = B1;
            B1:    next_state = B2;
            B2:    next_state = B3;
            B3:    next_state = COUNT;
            COUNT: next_state = (cnt1k == 10'd999 && delay == 4'd0) ? WAIT : COUNT;
            WAIT:  next_state = ack ? S0 : WAIT;
            default: next_state = S0;
        endcase
    end

    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            delay <= 4'd0;
            cnt1k <= 10'd0;
        end else begin
            state <= next_state;
            if (state == B0 || state == B1 || state == B2 || state == B3) begin
                delay <= {delay[2:0], data};
                cnt1k <= 10'd0;
            end else if (state == COUNT) begin
                if (cnt1k == 10'd999) begin
                    cnt1k <= 10'd0;
                    if (delay != 4'd0)
                        delay <= delay - 4'd1;
                end else begin
                    cnt1k <= cnt1k + 10'd1;
                end
            end else begin
                cnt1k <= 10'd0;
            end
        end
    end

    assign count    = delay;
    assign counting = (state == COUNT);
    assign done     = (state == WAIT);
endmodule
