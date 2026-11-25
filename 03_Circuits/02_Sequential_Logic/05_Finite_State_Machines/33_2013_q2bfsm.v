module top_module (
    input clk,
    input resetn,
    input x,
    input y,
    output f,
    output g
);
    parameter A = 4'd0, F1 = 4'd1, X0 = 4'd2, X1 = 4'd3, X2 = 4'd4,
              G1_0 = 4'd5, G1_1 = 4'd6, G_PERM = 4'd7, G_ZERO = 4'd8;
    reg [3:0] state, next_state;

    always @(*) begin
        case (state)
            A:      next_state = F1;
            F1:     next_state = X0;
            X0:     next_state = x ? X1 : X0;
            X1:     next_state = x ? X1 : X2;
            X2:     next_state = x ? G1_0 : X0;
            G1_0:   next_state = y ? G_PERM : G1_1;
            G1_1:   next_state = y ? G_PERM : G_ZERO;
            G_PERM: next_state = G_PERM;
            G_ZERO: next_state = G_ZERO;
            default: next_state = A;
        endcase
    end

    always @(posedge clk) begin
        if (!resetn) state <= A;
        else         state <= next_state;
    end

    assign f = (state == F1);
    assign g = (state == G1_0) || (state == G1_1) || (state == G_PERM);
endmodule
