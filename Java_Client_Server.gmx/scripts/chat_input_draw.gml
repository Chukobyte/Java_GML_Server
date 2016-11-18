///chat_input_draw()


switch(room) {
    default:
        break;
        
    case rm_intro:
    case rm_main:
        draw_text(x, y, chat_text);
        //toggle flash with caret
        if(draw_caret && player_can_type) {
            draw_text_colour(x + caret_x_width, y, caret_symbol, c_white, c_white, c_white, c_white, 1);
        }
        break;
}
