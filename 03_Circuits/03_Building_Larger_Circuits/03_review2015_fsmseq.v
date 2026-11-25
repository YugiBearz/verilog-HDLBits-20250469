module top_module (
    input clk,
    input reset,
    input data,
    output start_shifting
);
    parameter S0 = 3'd0, S1 = 3'd1, S2 = 3'd2, S3 = 3'd3, DONE = 3'd4;
    reg [2:0] state, next_state;

    always @(*) begin
        case (state)
            S0:   next_state = data ? S1   : S0;
            S1:   next_state = data ? S2   : S0;
            S2:   next_state = data ? S2   : S3;
            S3:   next_state = data ? DONE : S0;
            DONE: next_state = DONE;
            default: next_state = S0;
        endcase
    end

    always @(posedge clk) begin
        if (reset) state <= S0;
        else       state <= next_state;
    end

    assign start_shifting = (state == DONE);
endmodule
