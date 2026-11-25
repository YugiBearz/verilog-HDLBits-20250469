module top_module(
    input [31:0] a,
    input [31:0] b,
    input sub,
    output [31:0] sum
);

    wire [31:0] b_eff;
    wire cout_lo;

    assign b_eff = b ^ {32{sub}};

    add16 lo ( .a(a[15:0]),  .b(b_eff[15:0]),  .cin(sub),     .sum(sum[15:0]),  .cout(cout_lo) );
    add16 hi ( .a(a[31:16]), .b(b_eff[31:16]), .cin(cout_lo), .sum(sum[31:16]), .cout()        );

endmodule
