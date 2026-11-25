`default_nettype none
module top_module(
    input a,
    input b,
    input c,
    input d,
    output out,
    output out_n   ); 

    wire and1, and2, or_out;

    assign and1   = a & b;
    assign and2   = c & d;
    assign or_out = and1 | and2;

    assign out   = or_out;
    assign out_n = ~or_out;

endmodule
