///game_controller_init()

//Exit Game
if(keyboard_check_pressed(vk_escape)) {
    game_end();
}

switch(room) {
    default:
        break;
        
    case rm_initialize:
        room_goto(rm_intro);
        break;
        
    case rm_intro:
        //Chat box stuff
        if(mouse_check_button_pressed(mb_left)) {
            var x1 = 64;
            var y1 = 140 - 64;
            var x2 = room_width - 64;
            var y2 = 140;
            var mouse_click = point_in_rectangle(floor(mouse_x), floor(mouse_y), x1, y1, x2, y2);
            if(mouse_click) {
                show_debug_message("Clicked within text box");
                chat_input.player_can_type = true;
            } else {
                show_debug_message("Clicked outside of text box");
                chat_input.player_can_type = false;
            }
            //reset keyboard string when clicking for now
            keyboard_string = "";
        }
        
        //Enters name and goes to next room
        if(keyboard_check_pressed(vk_return)) {
            Client.player_name = chat_input.chat_text; 
            var b = Client.buff;
            buffer_seek(b, buffer_seek_start, 0); // Move buffer to 0
            client_send_request(Client.server, b, Client.USER_NAME_SEND_REQUEST)
            
            room_goto(rm_main);
        }
        
        
        break;
        
    case rm_main:
        var spr_w = 32;
        var spr_h = 32;
        var xx = (room_width div 2) - (spr_w * 2);
        var yy = (room_height div 2) - (spr_h * 2);
        //Init if don't exist for now
        if(!instance_exists(Panel)) {

            if(game_board_array != noone && panel_board_array == noone) {
                for(var i = 0; i < 3; i++) {
                    for(var j = 0; j < 3; j++) {
                        panel_board_array[i, j] =  instance_create(xx + spr_w * j, yy + spr_h * i, Panel);
                    }
                }
            }
        }
        
        if(update_board) {
            //show_debug_message("update init");
            for(var i = 0; i < 3; i++) {
                for(var j = 0; j < 3; j++) {
                    var new_color = asset_get_index(game_board_array[i, j]);
                    panel_board_array[i, j].image_blend = new_color;
                }
            }
            update_board = false;
        }
        break;
}
