///scr_handle_packet(buffer)

var buffer = argument0;

var n_id = async_load[? "id"];

if(n_id == server) {
    var type = async_load[? "type"];
    var size_in_bytes = buffer_get_size(buffer);
    var header_stuff = 4 + 1 + 2;
    var packet_size = 4;
    var magic_number = buffer_peek(buffer, 0, buffer_u16);  //Peak at magic number and if it is, read to move buffer
    show_debug_message("magic_number = " + string(magic_number));
//    if(size_in_bytes >= header_stuff + packet_size) {       
    //Getting beginning of message
    if(magic_number == MAGIC_NUMBER) {    
        buffer_read(buffer, buffer_u16);  //move buffer is magic number is read
        var message_id = buffer_read(buffer, buffer_s8);
        show_debug_message("message_id = " + string(message_id));
        show_debug_message("size_in_bytes = " + string(size_in_bytes));
        switch(message_id) {
            //8
            case UPDATE_RESPONSE:
                message = buffer_read(buffer, buffer_string);
                show_debug_message("UPDATE_RESPONSE: " + message);
                show_debug_message("update");
                
                var new_board_array = json_decode_two_dimensional_array(message);
                if(new_board_array != noone) {
                    GameController.game_board_array = new_board_array;
                    GameController.update_board = true;
                }
                break;    
                
            case USER_ID_RESPONSE:
                var response = buffer_read(buffer, buffer_string);
                user_id = response;
                show_debug_message("USER_ID = " + response);
                break;
                
            case USER_NAME_SEND_RESPONSE:
                var response = buffer_read(buffer, buffer_bool);
                show_debug_message("USER_SEND_SUCCESS = " + string(response));
                break;
                
            case SHUFFLE_GAME_BOARD_RESPONSE:
                var response = buffer_read(buffer, buffer_string);
                show_debug_message("SHUFFLE_GAME_BOARD_SUCCESS = " + response);
                break;
                
            case USER_MOVE_RESPONSE:
                var response = buffer_read(buffer, buffer_string);
                show_debug_message("Response: " + response);
                break;
                
            case CHAT_LOG_SEND_RESPONSE:
                //var response = buffer_read(buffer, buffer_string);
                show_debug_message("Received chat log response");
                break;
                
            case GET_USERS_ONLINE_RESPONSE:
                var response = buffer_read(buffer, buffer_string);
                show_debug_message("Users Online: " + response);
                var online_users_map = json_decode(response);
                var users_list = ds_map_find_value(online_users_map, "clients");
                show_debug_message("Users: " + string(ds_list_size(users_list)));
                for(var i = 0; i < ds_list_size(users_list); i++) {
                    var list_map = ds_list_find_value(users_list, i);
                    var user_id = ds_map_find_value(list_map, "user_id");
                    var player_name = ds_map_find_value(list_map, "player_name");
                    show_debug_message("user_id = " + string(user_id) + "  |  player_name = " + string(player_name));
                    ds_map_destroy(list_map);
                }
                ds_list_destroy(users_list);
                ds_map_destroy(online_users_map);
                break
                
            default:
                show_debug_message("Error, message id invalid!");
                break;
        }   
    } else {
        //temp work around to fix broken message
        //Section if number isn't magic number it must be a continuation of old stream
        message += buffer_read(buffer, buffer_string);
        show_debug_message("Updated Message = " + message);
        var new_board_array = json_decode_two_dimensional_array(message);
        show_debug_message("second nba: " + string(new_board_array));
        if(new_board_array != noone) {
            GameController.game_board_array = new_board_array;
            GameController.update_board = true;
        }
    }
}
