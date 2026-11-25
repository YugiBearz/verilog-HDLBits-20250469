module top_module(
    input clk,
    input reset,
    input in,
    output disc,
    output flag,
    output err
);
    parameter NONE = 4'd0, ONE1 = 4'd1, TWO1 = 4'd2, THREE1 = 4'd3, FOUR1 = 4'd4,
              FIVE1 = 4'd5, SIX1 = 4'd6, ERR = 4'd7, DISC = 4'd8, FLAG = 4'd9;
    reg [3:0] state, next_state;

    always @(*) begin
        case (state)
            NONE:   next_state = in ? ONE1   : NONE;
            ONE1:   next_state = in ? TWO1   : NONE;
            TWO1:   next_state = in ? THREE1 : NONE;
            THREE1: next_state = in ? FOUR1  : NONE;
            FOUR1:  next_state = in ? FIVE1  : NONE;
            FIVE1:  next_state = in ? SIX1   : DISC;
            SIX1:   next_state = in ? ERR    : FLAG;
            ERR:    next_state = in ? ERR    : NONE;
            DISC:   next_state = in ? ONE1   : NONE;
            FLAG:   next_state = in ? ONE1   : NONE;
            default: next_state = NONE;
        endcase
    end

    always @(posedge clk) begin
        if (reset) state <= NONE;
        else       state <= next_state;
    end

    assign disc = (state == DISC);
    assign flag = (state == FLAG);
    assign err  = (state == ERR);
endmodule
