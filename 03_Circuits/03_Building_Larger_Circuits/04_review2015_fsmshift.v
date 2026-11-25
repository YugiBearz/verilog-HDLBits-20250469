module top_module (
    input clk,
    input reset,
    output shift_ena
);
    parameter S0 = 3'd0, S1 = 3'd1, S2 = 3'd2, S3 = 3'd3, IDLE = 3'd4;
    reg [2:0] state, next_state;

    always @(*) begin
        case (state)
            S0:   next_state = S1;
            S1:   next_state = S2;
            S2:   next_state = S3;
            S3:   next_state = IDLE;
            IDLE: next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

    always @(posedge clk) begin
        if (reset) state <= S0;
        else       state <= next_state;
    end

    assign shift_ena = (state != IDLE);
endmodule
