///game_controller_draw()

/*
var xx = 64;
var yy = 48;
var spr_w = 32;
var spr_h = 32;

if(game_board_array != noone) {
    for(var i = 0; i < 3; i++) {
        for(var j = 0; j < 3; j++) {
            draw_sprite(spr_block, 0, xx + spr_w * j, yy + spr_h * i);
        }
    }
}
*/

switch(room) {
    default:
        break;
    case rm_intro:
        //draw_text(10, 10, "x: " + string(mouse_x) + "#y: " + string(mouse_y));
        draw_text(64 + 2, room_height div 2 - 116, typed_text);
        draw_line(64, room_height div 2 - 100, room_width - 64, room_height div 2 - 100);
        break;
    case rm_main:
        draw_text(10, 10, "player_name: " + Client.player_name);
        //draw_text(10, 24, Client.debug_text);
        break;
}
