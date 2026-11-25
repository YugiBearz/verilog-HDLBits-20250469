module top_module(
    input clk,
    input in,
    input reset,
    output [7:0] out_byte,
    output done
);
    parameter IDLE = 2'd0, DATA = 2'd1, DONE = 2'd2, WAIT = 2'd3;
    reg [1:0] state, next_state;
    reg [3:0] cnt;
    reg [7:0] data_reg;

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
            state    <= IDLE;
            cnt      <= 4'd0;
            data_reg <= 8'b0;
        end else begin
            state <= next_state;
            if (state == DATA) begin
                cnt <= cnt + 4'd1;
                if (cnt < 4'd8)
                    data_reg <= {in, data_reg[7:1]};
            end else begin
                cnt <= 4'd0;
            end
        end
    end

    assign done     = (state == DONE);
    assign out_byte = done ? data_reg : 8'b0;
endmodule
