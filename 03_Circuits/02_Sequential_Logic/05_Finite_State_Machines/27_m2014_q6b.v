module top_module (
    input [3:1] y,
    input w,
    output Y2
);
    reg [3:1] next_state;

    always @(*) begin
        case (y)
            3'b000: next_state = w ? 3'b000 : 3'b001;
            3'b001: next_state = w ? 3'b011 : 3'b010;
            3'b010: next_state = w ? 3'b011 : 3'b100;
            3'b011: next_state = w ? 3'b000 : 3'b101;
            3'b100: next_state = w ? 3'b011 : 3'b100;
            3'b101: next_state = w ? 3'b011 : 3'b010;
            default: next_state = 3'b000;
        endcase
    end

    assign Y2 = next_state[2];
endmodule
