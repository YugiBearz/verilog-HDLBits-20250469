module top_module (
    input clk,
    input reset,
    output [3:1] ena,
    output [15:0] q
);
    assign ena[1] = (q[3:0] == 4'd9);
    assign ena[2] = ena[1] && (q[7:4] == 4'd9);
    assign ena[3] = ena[2] && (q[11:8] == 4'd9);

    bcd_digit d0 (clk, reset, 1'b1,   q[3:0]);
    bcd_digit d1 (clk, reset, ena[1], q[7:4]);
    bcd_digit d2 (clk, reset, ena[2], q[11:8]);
    bcd_digit d3 (clk, reset, ena[3], q[15:12]);
endmodule

module bcd_digit (
    input clk,
    input reset,
    input ena,
    output reg [3:0] q
);
    always @(posedge clk) begin
        if (reset)
            q <= 4'd0;
        else if (ena) begin
            if (q == 4'd9) q <= 4'd0;
            else           q <= q + 4'd1;
        end
    end
endmodule
