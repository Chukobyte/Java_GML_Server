///client_handle_response_updated(buffer, message_id)

/*
* Returns true if full message is processed successfully
* Returns false if full message isn't processes successfully
* Returns noone (-4) if message_id isn't found for now
*/

//Slight work around for json data while separating logic with buffering_messages boolean

var json_map = argument0;
var buffer = argument1;

var json_text = json_encode(json_map);
show_debug_message("json_map = " + json_text);
var succeeded = false;

if(!ds_map_exists(json_map, MESSAGE_ID)) {
    return succeeded;
}


var message_id = floor(ds_map_find_value(json_map, MESSAGE_ID));
show_debug_message("message_id = " + string(message_id));
var content = ds_map_find_value(json_map, MESSAGE_CONTENT);

switch(message_id) {
    //String json responses are accumalated in buffering_messages along with buffered_message_id
    case UPDATE_RESPONSE:        
        var new_board_array = json_decode_two_dimensional_array(content);
        if(new_board_array != noone) {
            GameController.game_board_array = new_board_array;
            GameController.update_board = true;
            succeeded = true;
        }
        break;    
                
    case USER_ID_RESPONSE:
        var response_map = json_decode(content);
        if(response_map != noone) {
            user_id = ds_map_find_value(response_map, "user_id");
            succeeded = true;
            client_player = instance_create(x, y, Player);
            client_player.user_id = user_id;
            client_player.panel_row = real(ds_map_find_value(response_map, "panel_row"));
            client_player.panel_col = real(ds_map_find_value(response_map, "panel_col"));
        }
        ds_map_destroy(response_map);
        break;
                
    case USER_NAME_SEND_RESPONSE:
        var response_map = json_decode(content);
        if(response_map != noone) {
            var success = ds_map_find_value(response_map, "succeed");
            show_debug_message("USER_SEND_SUCCESS = " + string(success));
            succeeded = true;
            client_send_request(server, buffer, GET_INITIAL_USERS_ONLINE_REQUEST);
        }
        ds_map_destroy(response_map);    
        break;
                
    case SHUFFLE_GAME_BOARD_RESPONSE:
        var response_map = json_decode(content);
        if(response_map != noone) {
            var success = ds_map_find_value(response_map, "succeed");
            show_debug_message("SHUFFLE_GAME_BOARD_SUCCESS = " + string(success));
            succeeded = true;
        }
        ds_map_destroy(response_map); 
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
        var response_map = json_decode(content);
        if(response_map != noone) {
            //var success = ds_map_find_value(response_map, "succeed");
            show_debug_message("SHUFFLE_GAME_BOARD_SUCCESS = " + string(success));
            succeeded = true;
            var users_list = ds_map_find_value(response_map, "clients");
            if(ds_exists(users_list, ds_type_list)) {
                show_debug_message("Users: " + string(ds_list_size(users_list)));
                for(var i = 0; i < ds_list_size(users_list); i++) {
                    var list_map = ds_list_find_value(users_list, i);
                    var uid = ds_map_find_value(list_map, "user_id");
                    var player_name = ds_map_find_value(list_map, "player_name");
                    
                    //Temp checks if player exists
                    with(Player) {
                        if(user_id == uid) {
                            show_debug_message("Updating " + string(uid));
                            panel_row = floor(ds_map_find_value(list_map, "panel_row"));
                            panel_col = floor(ds_map_find_value(list_map, "panel_col"));
                        }
                    }
                    //show_debug_message("user_id = " + string(uid) + "  |  player_name = " + string(player_name));
                    ds_map_destroy(list_map);
                }
            }
        }
        ds_map_destroy(response_map); 
        break;
        
    case GET_INITIAL_USERS_ONLINE_RESPONSE:
        var response_map = json_decode(content);
        if(response_map != noone) {
            ds_map_copy(GameController.player_client_map, response_map);
            succeeded = true;
            var users_list = ds_map_find_value(response_map, "clients");
            if(ds_exists(users_list, ds_type_list)) {
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
            }
        }
        ds_map_destroy(response_map);
        /*
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
                    ds_map_add(GameController.player_client_map, other_player.user_id, other_player);
                }            
                ds_map_destroy(list_map);
            }
            succeeded = true;
            ds_list_destroy(users_list);
        }
        ds_map_destroy(online_users_map);
        */
        break;
        
    case DELETE_USER_RESPONSE:
        var response_map = json_decode(content);
        if(response_map != noone) {
            var delete_user_id = ds_map_find_value(response_map, "user_id");
            with(Player) {
                if(user_id == delete_user_id) {
                    ds_map_delete(GameController.player_client_map, user_id);
                    instance_destroy();
                }
            }
            show_debug_message("user_id = " + string(delete_user_id));
            succeeded = true;
        }
        ds_map_destroy(response_map); 
        break;
        
    case CREATE_USER_RESPONSE:
        var response_map = json_decode(content);
        if(response_map != noone) {
            var new_player = instance_create(0, 0, Player);
            new_player.user_id = ds_map_find_value(response_map, "user_id");
            new_player.player_name = ds_map_find_value(response_map, "player_name");
            new_player.panel_row = ds_map_find_value(response_map, "row");
            new_player.panel_col = ds_map_find_value(response_map, "col");
            ds_map_add(GameController.player_client_map, new_player.user_id, new_player);
            show_debug_message("user_id = " + string(new_player.user_id));   
        }
        ds_map_destroy(response_map); 
        succeeded = true;
        break;
            
    //Set to noone if message_id isn't found    
    default:
        succeeded = noone;
        show_debug_message("Error, message id invalid!");
        break;

                                
}

return succeeded;
