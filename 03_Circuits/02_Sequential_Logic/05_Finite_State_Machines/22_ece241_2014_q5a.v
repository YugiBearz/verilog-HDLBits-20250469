module top_module (
    input clk,
    input areset,
    input x,
    output z
);
    parameter COPY0 = 2'd0, COPY1 = 2'd1, INV0 = 2'd2, INV1 = 2'd3;
    reg [1:0] state, next_state;

    always @(*) begin
        case (state)
            COPY0: next_state = x ? COPY1 : COPY0;
            COPY1: next_state = x ? INV0  : INV1;
            INV0:  next_state = x ? INV0  : INV1;
            INV1:  next_state = x ? INV0  : INV1;
        endcase
    end

    always @(posedge clk or posedge areset) begin
        if (areset) state <= COPY0;
        else        state <= next_state;
    end

    assign z = (state == COPY1) || (state == INV1);
endmodule
