module top_module (
    input clk,
    input areset,
    input x,
    output reg z
);
    parameter A = 2'b01, B = 2'b10;
    reg [1:0] state, next_state;

    always @(*) begin
        case (state)
            A: begin
                next_state = x ? B : A;
                z = x;
            end
            B: begin
                next_state = B;
                z = ~x;
            end
            default: begin
                next_state = A;
                z = 1'b0;
            end
        endcase
    end

    always @(posedge clk or posedge areset) begin
        if (areset) state <= A;
        else        state <= next_state;
    end
endmodule
