///client_handle_response(buffer, message_id)

/*
* Returns true if full message is processed successfully
* Returns false if full message isn't processes successfully
* Returns noone (-4) if message_id isn't found for now
*/

//Slight work around for json data while separating logic with buffering_messages boolean

var buffer = argument0;
var message_id = argument1;

var succeeded = false;

switch(message_id) {
    //String json responses are accumalated in buffering_messages along with buffered_message_id
    case UPDATE_RESPONSE:
        if(!buffering_messages) {
            response_buffered_messages = buffer_read(buffer, buffer_string);   
        }
        //message = buffer_read(buffer, buffer_string);
        show_debug_message("UPDATE_RESPONSE: " + response_buffered_messages);
        show_debug_message("update");
                
        var new_board_array = json_decode_two_dimensional_array(response_buffered_messages);
        if(new_board_array != noone) {
            GameController.game_board_array = new_board_array;
            GameController.update_board = true;
            succeeded = true;
        }
        break;    
                
    case USER_ID_RESPONSE:
        var response = buffer_read(buffer, buffer_string);
        user_id = response;
        show_debug_message("USER_ID = " + user_id);
        succeeded = true;
        //response = buffer_read(buffer, buffer_s16);
        client_player = instance_create(x, y, Player);
        //will send for update
        //client_send_request(server, buffer, GET_USERS_ONLINE_RESPONSE);
        ds_map_add(GameController.player_client_map, user_id, client_player);
        client_player.user_id = user_id;
        //client_send_request(server, buffer, GET_USERS_ONLINE_RESPONSE);
        client_player.panel_row = buffer_read(buffer, buffer_s16);
        client_player.panel_col = buffer_read(buffer, buffer_s16);
        //get initial users
       // client_send_request(server, buffer, GET_INITIAL_USERS_ONLINE_REQUEST);
        
        //player_row = response;
        //response = buffer_read(buffer, buffer_s16);
        //player_col = response;
        break;
                
    case USER_NAME_SEND_RESPONSE:
        var response = buffer_read(buffer, buffer_bool);
        show_debug_message("USER_SEND_SUCCESS = " + string(response));
        //get initial users
        client_send_request(server, buffer, GET_INITIAL_USERS_ONLINE_REQUEST);
        succeeded = true;
        break;
                
    case SHUFFLE_GAME_BOARD_RESPONSE:
        var response = buffer_read(buffer, buffer_string);
        show_debug_message("SHUFFLE_GAME_BOARD_SUCCESS = " + response);
        succeeded = true;
        break;
                
    case USER_MOVE_RESPONSE:
        var response = buffer_read(buffer, buffer_string);
        show_debug_message("Response: " + response);
        client_player.panel_row = buffer_read(buffer, buffer_s16);
        client_player.panel_col = buffer_read(buffer, buffer_s16);
        succeeded = true;
        break;
                
    case CHAT_LOG_SEND_RESPONSE:
        //var response = buffer_read(buffer, buffer_string);
        show_debug_message("Received chat log response");
        succeeded = true;
        break;
                
    case GET_USERS_ONLINE_RESPONSE:
        if(!buffering_messages) {
            response_buffered_messages = buffer_read(buffer, buffer_string);
        }
        show_debug_message("Users Online: " + response_buffered_messages);
        var online_users_map = json_decode(response_buffered_messages);
        if(online_users_map != noone) {
            //show_debug_message("online_users_map: " + string(online_users_map));
            var users_list = ds_map_find_value(online_users_map, "clients");
            show_debug_message("Users: " + string(ds_list_size(users_list)));
            for(var i = 0; i < ds_list_size(users_list); i++) {
                var list_map = ds_list_find_value(users_list, i);
                var uid = ds_map_find_value(list_map, "user_id");
                var player_name = ds_map_find_value(list_map, "player_name");
                
                //Temp checks if player exists
                with(Player) {
                    if(user_id == uid) {
                        show_debug_message("Updating " + string(uid));
                        panel_row = ds_map_find_value(list_map, "panel_row");
                        panel_col = ds_map_find_value(list_map, "panel_col");
                    }
                }
                //show_debug_message("user_id = " + string(uid) + "  |  player_name = " + string(player_name));
                ds_map_destroy(list_map);
            }
            succeeded = true;
            ds_list_destroy(users_list);
        }
        ds_map_destroy(online_users_map);
        break;
        
    case GET_INITIAL_USERS_ONLINE_RESPONSE:
        if(!buffering_messages) {
            response_buffered_messages = buffer_read(buffer, buffer_string);
        }
        show_debug_message("Users Online: " + response_buffered_messages);
        var online_users_map = json_decode(response_buffered_messages);
        if(online_users_map != noone) {
            ds_map_copy(GameController.player_client_map, online_users_map);
            //show_debug_message("online_users_map: " + string(online_users_map));
            var users_list = ds_map_find_value(GameController.player_client_map, "clients");
            show_debug_message("Users: " + string(ds_list_size(users_list)));
            for(var i = 0; i < ds_list_size(users_list); i++) {
                var list_map = ds_list_find_value(users_list, i);
                var uid = ds_map_find_value(list_map, "user_id");
                if(client_player.user_id != uid) {
                    var other_player = instance_create(x, y, Player);
                    other_player.user_id = uid;
                    other_player.player_name = ds_map_find_value(list_map, "player_name");
                    other_player.panel_row = ds_map_find_value(list_map, "panel_row");
                    other_player.panel_col = ds_map_find_value(list_map, "panel_col");
                }            
                ds_map_destroy(list_map);
            }
            succeeded = true;
            ds_list_destroy(users_list);
        }
        ds_map_destroy(online_users_map);
        break;
            
    //Set to noone if message_id isn't found    
    default:
        succeeded = noone;
        show_debug_message("Error, message id invalid!");
        break;

                                
}

return succeeded;
