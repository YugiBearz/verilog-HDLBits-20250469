module top_module(
    input clk,
    input areset,

    input  predict_valid,
    input  [6:0] predict_pc,
    output predict_taken,
    output reg [6:0] predict_history,

    input train_valid,
    input train_taken,
    input train_mispredicted,
    input [6:0] train_history,
    input [6:0] train_pc
);
    reg [1:0] pht [0:127];
    integer i;

    wire [6:0] pred_idx  = predict_pc ^ predict_history;
    wire [6:0] train_idx = train_pc   ^ train_history;

    assign predict_taken = pht[pred_idx][1];

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            predict_history <= 7'b0;
            for (i = 0; i < 128; i = i + 1)
                pht[i] <= 2'b01;
        end else begin
            if (train_valid) begin
                if (train_taken) begin
                    if (pht[train_idx] != 2'b11)
                        pht[train_idx] <= pht[train_idx] + 2'd1;
                end else begin
                    if (pht[train_idx] != 2'b00)
                        pht[train_idx] <= pht[train_idx] - 2'd1;
                end
            end

            if (train_valid && train_mispredicted)
                predict_history <= {train_history[5:0], train_taken};
            else if (predict_valid)
                predict_history <= {predict_history[5:0], predict_taken};
        end
    end
endmodule
