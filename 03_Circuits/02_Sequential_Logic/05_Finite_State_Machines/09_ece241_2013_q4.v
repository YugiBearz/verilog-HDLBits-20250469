module top_module (
    input clk,
    input reset,
    input [3:1] s,
    output reg fr3,
    output reg fr2,
    output reg fr1,
    output reg dfr
);
    parameter A_LOW = 3'd0, B_RISE = 3'd1, B_FALL = 3'd2,
              C_RISE = 3'd3, C_FALL = 3'd4, D_HIGH = 3'd5;
    reg [2:0] state, next_state;

    always @(*) begin
        case (state)
            A_LOW:  next_state = (s == 3'b000) ? A_LOW  : B_RISE;
            B_RISE: next_state = (s == 3'b000) ? A_LOW  : ((s == 3'b001) ? B_RISE : C_RISE);
            B_FALL: next_state = (s == 3'b000) ? A_LOW  : ((s == 3'b001) ? B_FALL : C_RISE);
            C_RISE: next_state = (s == 3'b111) ? D_HIGH : ((s == 3'b011) ? C_RISE : B_FALL);
            C_FALL: next_state = (s == 3'b111) ? D_HIGH : ((s == 3'b011) ? C_FALL : B_FALL);
            D_HIGH: next_state = (s == 3'b111) ? D_HIGH : C_FALL;
            default: next_state = A_LOW;
        endcase
    end

    always @(posedge clk) begin
        if (reset) state <= A_LOW;
        else       state <= next_state;
    end

    always @(*) begin
        case (state)
            A_LOW:  {fr3, fr2, fr1, dfr} = 4'b1111;
            B_RISE: {fr3, fr2, fr1, dfr} = 4'b0110;
            B_FALL: {fr3, fr2, fr1, dfr} = 4'b0111;
            C_RISE: {fr3, fr2, fr1, dfr} = 4'b0010;
            C_FALL: {fr3, fr2, fr1, dfr} = 4'b0011;
            D_HIGH: {fr3, fr2, fr1, dfr} = 4'b0000;
            default:{fr3, fr2, fr1, dfr} = 4'b1111;
        endcase
    end
endmodule
