///chat_input_step()
chat_get_input();


// keyboard shortcuts:
//caret_move -= 1 * DeltaTracker.delta;
caret_move--;
caret_flash_timer--;

//caret_move = max(0, caret_move - 1);

if(left || right && caret_move <= 0) {
    caret += (right - left);
    caret_move = caret_move_max;
    //show_debug_message("caret: " + string(caret));
} else {
    caret_move = 0;
}
caret = clamp(caret, 0, array_length_1d(typed_text));

if(home_key) {
    caret = 0;
}

if(end_key) {
    caret = string_length(text);
}

if(delete_key) {
    text = string_delete(text, caret + 1, 1);
}


//typing logic for now
if(keyboard_check_pressed(vk_anykey) && player_can_type) {
    //Exception for backspace (execption list maybe?)
    if(!backspace_key) {
        //Successful key type press
        if(keyboard_string != "") {
        
           if(array_length_1d(typed_text) == 1 && typed_text[0] == "") {
                typed_text[caret] = keyboard_string;
           } else {
                //insert typed text into array
                typed_text = array_insert(typed_text, caret, keyboard_string);
           }
            
            caret++;
            show_debug_message("caret: " + string(caret));
            keyboard_string = "";
        }
    } else {
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




/*
var new_caret_text = "";
for(var i = 0; i < caret + 1; i++) {
    new_caret_text += " ";
}
new_caret_text += caret_symbol;
if(new_caret_text != caret_text) {
    caret_text = new_caret_text;
}
*/

/*
//typing logic for now
if(keyboard_check_pressed(vk_anykey) && player_can_type) {
    //Exception for backspace
    if(!keyboard_check_pressed(vk_backspace)) {
        typed_text += keyboard_string;
        keyboard_string = "";
    } else {
        //Deletes last character of string
        typed_text = string_delete(typed_text, string_length(typed_text), 1);
    }
}
*/


