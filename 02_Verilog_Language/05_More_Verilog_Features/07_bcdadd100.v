module top_module( 
    input [399:0] a, b,
    input cin,
    output cout,
    output [399:0] sum
);

    wire [99:0] c;
    genvar i;

    generate
        for (i = 0; i < 100; i = i + 1) begin : gen_bcd
            bcd_fadd u_bcd (
                .a    (a[4*i +: 4]),
                .b    (b[4*i +: 4]),
                .cin  ((i == 0) ? cin : c[i-1]),
                .cout (c[i]),
                .sum  (sum[4*i +: 4])
            );
        end
    endgenerate

    assign cout = c[99];

endmodule
