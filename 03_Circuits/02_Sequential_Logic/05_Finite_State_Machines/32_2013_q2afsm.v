module top_module (
    input clk,
    input resetn,
    input [3:1] r,
    output [3:1] g
);
    parameter A = 2'd0, B = 2'd1, C = 2'd2, D = 2'd3;
    reg [1:0] state, next_state;

    always @(*) begin
        case (state)
            A: next_state = r[1] ? B : (r[2] ? C : (r[3] ? D : A));
            B: next_state = r[1] ? B : A;
            C: next_state = r[2] ? C : A;
            D: next_state = r[3] ? D : A;
        endcase
    end

    always @(posedge clk) begin
        if (!resetn) state <= A;
        else         state <= next_state;
    end

    assign g[1] = (state == B);
    assign g[2] = (state == C);
    assign g[3] = (state == D);
endmodule
