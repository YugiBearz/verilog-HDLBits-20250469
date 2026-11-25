module top_module(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);
    parameter LEFT = 3'd0, RIGHT = 3'd1, FALL_L = 3'd2, FALL_R = 3'd3,
              DIG_L = 3'd4, DIG_R = 3'd5, SPLAT = 3'd6;
    reg [2:0] state, next_state;
    reg [4:0] fall_cnt;

    always @(*) begin
        case (state)
            LEFT:   next_state = !ground ? FALL_L : (dig ? DIG_L : (bump_left  ? RIGHT : LEFT));
            RIGHT:  next_state = !ground ? FALL_R : (dig ? DIG_R : (bump_right ? LEFT  : RIGHT));
            FALL_L: next_state =  ground ? ((fall_cnt >= 5'd20) ? SPLAT : LEFT)  : FALL_L;
            FALL_R: next_state =  ground ? ((fall_cnt >= 5'd20) ? SPLAT : RIGHT) : FALL_R;
            DIG_L:  next_state = !ground ? FALL_L : DIG_L;
            DIG_R:  next_state = !ground ? FALL_R : DIG_R;
            SPLAT:  next_state = SPLAT;
            default: next_state = LEFT;
        endcase
    end

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state    <= LEFT;
            fall_cnt <= 5'd0;
        end else begin
            state <= next_state;
            if (state == FALL_L || state == FALL_R) begin
                if (!ground && fall_cnt < 5'd20)
                    fall_cnt <= fall_cnt + 5'd1;
            end else begin
                fall_cnt <= 5'd0;
            end
        end
    end

    assign walk_left  = (state == LEFT);
    assign walk_right = (state == RIGHT);
    assign aaah       = (state == FALL_L) || (state == FALL_R);
    assign digging    = (state == DIG_L)  || (state == DIG_R);
endmodule
