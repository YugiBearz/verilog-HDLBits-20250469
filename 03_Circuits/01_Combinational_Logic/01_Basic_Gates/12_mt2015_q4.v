module top_module (input x, input y, output z);
    wire za1, zb1, za2, zb2;
    assign za1 = (x ^ y) & x;
    assign zb1 = ~(x ^ y);
    assign za2 = (x ^ y) & x;
    assign zb2 = ~(x ^ y);
    assign z = (za1 | zb1) ^ (za2 & zb2);
endmodule
