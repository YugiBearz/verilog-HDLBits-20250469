module top_module(
    input [31:0] a,
    input [31:0] b,
    output [31:0] sum
);

    wire cout_lo;
    wire [15:0] sum_hi_0, sum_hi_1;

    add16 lo  ( .a(a[15:0]),  .b(b[15:0]),  .cin(1'b0), .sum(sum[15:0]), .cout(cout_lo) );
    add16 hi0 ( .a(a[31:16]), .b(b[31:16]), .cin(1'b0), .sum(sum_hi_0),  .cout()        );
    add16 hi1 ( .a(a[31:16]), .b(b[31:16]), .cin(1'b1), .sum(sum_hi_1),  .cout()        );

    assign sum[31:16] = cout_lo ? sum_hi_1 : sum_hi_0;

endmodule
