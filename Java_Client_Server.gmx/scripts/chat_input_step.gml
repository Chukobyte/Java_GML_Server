///chat_input_step()
chat_get_input();

// keyboard shortcuts:
caret_move--;
caret_flash_timer--;

if(player_can_type) {
    
    if(left || right && caret_move <= 0) {
        caret += (right - left);
        caret_move = caret_move_max;
    } else {
        caret_move = 0;
    }
    caret = clamp(caret, 0, array_length_1d(typed_text));

    if(backspace_key) {
        //Deletes last character of string
        if(caret > 0) {
            if(array_length_1d(typed_text) > 1) {
                typed_text[caret - 1] = noone;
                typed_text = array_compress(typed_text, noone);
            } else {
                typed_text[0] = "";
            }
            caret--;
        }
    }

    if(home_key) {
        caret = 0;
    }

    if(end_key) {
        caret = array_length_1d(typed_text);
    }

    if(delete_key) {
        typed_text[caret] = noone;
        typed_text = array_compress(typed_text, noone);
    }


    //typing logic for now
    if(keyboard_check_pressed(vk_anykey)) {
        //Exception for backspace (execption list maybe?)
        //Successful key type press
        if(keyboard_string != "") {  
            //To make inserting '#' not create a newline
            if(keyboard_string == "#") {
                keyboard_string = "\#"
            }     
            if(array_length_1d(typed_text) == 1 && typed_text[0] == "") {
                typed_text[caret] = keyboard_string;
            } else {
                //insert typed text into array
                typed_text = array_insert(typed_text, caret, keyboard_string);
            }
            
            caret++;
            //show_debug_message("caret: " + string(caret));
            keyboard_string = "";
        }
    }
    
    //will loop array into text for now
    var current_text = "";
    for(var i = 0; i < array_length_1d(typed_text); i++) {
        current_text += typed_text[i];
    }

    //Update chat text
    if(chat_text != current_text) {
        chat_text = current_text;
    
        //var dt = string(string_width(chat_text));
        //show_debug_message("chat_text width = " + dt);
    }

    //Update draw property for caret
    var text_width = 0;
    for(var i = 0; i < caret; i++) {
        text_width += string_width(typed_text[i]);
    }

    //update caret
    caret_x_width = text_width - 2;
    //caret flash
    if(caret_flash_timer <= 0) {
        draw_caret = !draw_caret;
        caret_flash_timer = caret_flash_timer_max;
    }


}
