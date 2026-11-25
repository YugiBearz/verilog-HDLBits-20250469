module top_module(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    output walk_left,
    output walk_right,
    output aaah
);
    parameter LEFT = 2'd0, RIGHT = 2'd1, FALL_L = 2'd2, FALL_R = 2'd3;
    reg [1:0] state, next_state;

    always @(*) begin
        case (state)
            LEFT:   next_state = !ground ? FALL_L : (bump_left  ? RIGHT : LEFT);
            RIGHT:  next_state = !ground ? FALL_R : (bump_right ? LEFT  : RIGHT);
            FALL_L: next_state =  ground ? LEFT   : FALL_L;
            FALL_R: next_state =  ground ? RIGHT  : FALL_R;
        endcase
    end

    always @(posedge clk or posedge areset) begin
        if (areset) state <= LEFT;
        else        state <= next_state;
    end

    assign walk_left  = (state == LEFT);
    assign walk_right = (state == RIGHT);
    assign aaah       = (state == FALL_L) || (state == FALL_R);
endmodule
