module top_module (
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);
    parameter A = 1'b0, B = 1'b1;
    reg state;
    reg [1:0] cyc_cnt, w_cnt;

    always @(posedge clk) begin
        if (reset) begin
            state   <= A;
            cyc_cnt <= 2'd0;
            w_cnt   <= 2'd0;
            z       <= 1'b0;
        end else if (state == A) begin
            z       <= 1'b0;
            cyc_cnt <= 2'd0;
            w_cnt   <= 2'd0;
            if (s) state <= B;
        end else begin
            if (cyc_cnt == 2'd2) begin
                z       <= (w_cnt + w) == 2'd2;
                cyc_cnt <= 2'd0;
                w_cnt   <= 2'd0;
            end else begin
                z       <= 1'b0;
                cyc_cnt <= cyc_cnt + 2'd1;
                w_cnt   <= w_cnt + w;
            end
        end
    end
endmodule
