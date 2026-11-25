module top_module(
    input clk,
    input in,
    input reset,
    output done
);
    parameter IDLE = 2'd0, DATA = 2'd1, DONE = 2'd2, WAIT = 2'd3;
    reg [1:0] state, next_state;
    reg [3:0] cnt;

    always @(*) begin
        case (state)
            IDLE: next_state = in ? IDLE : DATA;
            DATA: next_state = (cnt == 4'd8) ? (in ? DONE : WAIT) : DATA;
            DONE: next_state = in ? IDLE : DATA;
            WAIT: next_state = in ? IDLE : WAIT;
        endcase
    end

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            cnt   <= 4'd0;
        end else begin
            state <= next_state;
            if (state == DATA)
                cnt <= cnt + 4'd1;
            else
                cnt <= 4'd0;
        end
    end

    assign done = (state == DONE);
endmodule
