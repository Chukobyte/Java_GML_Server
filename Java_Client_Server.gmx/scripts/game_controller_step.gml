///game_controller_step()

get_input();

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
        
        //For clicking in chat box for now
        //Set x and  y
        chat_input.x = (64 + 2);
        chat_input.y = room_height div 2 - 116;
        
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
            client_send_request(Client.server, Client.buff, Client.USER_NAME_SEND_REQUEST);
            chat_input.player_can_type = false;
            chat_input.typed_text = reset_typed_array();  //reset array
            chat_input.chat_text = "";
            show_debug_message("chat_input after enter: " + chat_input.chat_text);
            keyboard_string = "";
            room_goto(rm_main);
        }
        
        
        break;
        
    case rm_main:
    
        //For clicking in chat box for now
        //Set x and  y
        chat_input.x = room_width - room_width div 4;
        chat_input.y = room_height  - room_height div 4;
        
        if(mouse_check_button_pressed(mb_left)) {
            var x1 = room_width - room_width div 4;
            var x2 = (room_width - room_width div 4) + 120;
            var y1 = (room_height - room_height div 4) - 120;
            var y2 = (room_height - room_height div 4) + 20;
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
        
        //temp hotkeys
        if(!chat_input.player_can_type) {
            if(update_chat_button) {
                client_send_request(Client.server, Client.buff, Client.CHAT_LOG_GET_REQUEST);                
            }
        }
        
        //keyboard return
        if(keyboard_check_pressed(vk_return)) {
            show_debug_message("chat_input before enter: " + chat_input.chat_text);
            client_send_request(Client.server, Client.buff, Client.CHAT_LOG_SEND_REQUEST);
            chat_input.typed_text = reset_typed_array();
            chat_input.chat_text = "";
            keyboard_string = "";
        }
    
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
                    var panel_map = json_decode(game_board_array[i, j]);
                    
                    var new_color = asset_get_index(string(ds_map_find_value(panel_map, "color")));
                    panel_board_array[i, j].image_blend = new_color;
                    
                    var uid =  ds_map_find_value(panel_map, "player");
                    //update players
                    with(Player) {
                        if(uid == user_id) {
                            panel_row = i;
                            panel_col = j;
                        }
                    }
                }
            }
            update_board = false;
            ds_map_destroy(panel_map);
        }
        break;
}
