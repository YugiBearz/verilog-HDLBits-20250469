module top_module ();
    reg clk;
    reg reset;
    reg t;
    wire q;

    tff u_tff ( .clk(clk), .reset(reset), .t(t), .q(q) );

    initial clk = 1'b0;
    always #5 clk = ~clk;

    initial begin
        reset = 1'b1; t = 1'b0;
        #10 reset = 1'b0; t = 1'b1;
    end
endmodule
