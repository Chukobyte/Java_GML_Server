///game_controller_draw()

switch(room) {
    default:
        break;
    case rm_intro:
        //draw_text(10, 10, "x: " + string(mouse_x) + "#y: " + string(mouse_y));
        draw_text(64 + 2, room_height div 2 - 116, chat_input.chat_text);
        //toggle flash with caret
        if(chat_input.draw_caret) {
            //draw_text((64 + 2) + chat_input.caret_x_width, room_height div 2 - 116, chat_input.caret_symbol);
            draw_text_colour((64 + 2) + chat_input.caret_x_width, room_height div 2 - 116, chat_input.caret_symbol, c_white, c_white, c_white, c_white, 1);
        }
        draw_line(64, room_height div 2 - 100, room_width - 64, room_height div 2 - 100);
        break;
    case rm_main:
        draw_text(10, 10, "player_name: " + Client.player_name);
        //draw_text(10, 24, Client.debug_text);
        break;
}
