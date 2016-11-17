///chat_input_init()

caret_flash = 0;
caret_flash_rate = 15;
caret_move = 0;
caret_move_max = room_speed * 6;
caret_symbol = "|";
caret_text = ""; //empty spaces to draw carrot_symbol
text = ""; // current text
caret = 0; // caret position
fillchar = "`"; // used as filler character in input handling.
filltext = string_repeat(fillchar, 10);
player_can_type = false; //Controlled by game_controller_step()
typed_text[0] = "";
typed_text_index = 0;
chat_text = "";
caret_x_width = 0; //keeps track of width of text to draw (+2 for padding)
draw_caret = false; //for caret flash
caret_flash_timer_max = 30;
caret_flash_timer = caret_flash_timer_max;
