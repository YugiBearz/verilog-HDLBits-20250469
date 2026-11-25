module top_module (
    input clk,
    input reset,
    input data,
    output shift_ena,
    output counting,
    input done_counting,
    output done,
    input ack
);
    parameter S0 = 4'd0, S1 = 4'd1, S2 = 4'd2, S3 = 4'd3,
              B0 = 4'd4, B1 = 4'd5, B2 = 4'd6, B3 = 4'd7,
              COUNT = 4'd8, WAIT = 4'd9;
    reg [3:0] state, next_state;

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
            COUNT: next_state = done_counting ? WAIT : COUNT;
            WAIT:  next_state = ack ? S0 : WAIT;
            default: next_state = S0;
        endcase
    end

    always @(posedge clk) begin
        if (reset) state <= S0;
        else       state <= next_state;
    end

    assign shift_ena = (state == B0) || (state == B1) || (state == B2) || (state == B3);
    assign counting  = (state == COUNT);
    assign done      = (state == WAIT);
endmodule
