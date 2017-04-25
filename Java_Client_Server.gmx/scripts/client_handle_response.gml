///client_handle_response(buffer, message_id)

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

//if(!ds_map_exists(json_map, MESSAGE_CONTENT)) {
//    return succeeded;
//}


var message_id = floor(ds_map_find_value(json_map, MESSAGE_ID));
show_debug_message("message_id = " + string(message_id));
var content = ds_map_find_value(json_map, MESSAGE_CONTENT);

switch(message_id) {
    //String json responses are accumalated in buffering_messages along with buffered_message_id
    case UPDATE_RESPONSE:        
        var new_board_array = json_decode_two_dimensional_array(json_encode(content));
        show_debug_message("update_response: " + string(new_board_array));
        if(new_board_array != noone) {
            GameController.game_board_array = new_board_array;
            GameController.update_board = true;
            succeeded = true;
        }
        break;    
                
    case USER_ID_RESPONSE:
        if(content != noone) {
            user_id = ds_map_find_value(content, "user_id");
            show_debug_message("user_id = " + string(user_id));
            succeeded = true;
            client_player = instance_create(x, y, Player);
            client_player.user_id = user_id;
            client_player.panel_row = real(ds_map_find_value(content, "panel_row"));
            client_player.panel_col = real(ds_map_find_value(content, "panel_col"));
        }
        break;
                
    case USER_NAME_SEND_RESPONSE:
        if(content != noone) {
            var success = ds_map_find_value(content, "succeed");
            show_debug_message("USER_NAME_SEND_SUCCESS = " + string(success));
            succeeded = true;
            client_send_request(server, buffer, GET_INITIAL_USERS_ONLINE_REQUEST);
        }
        break;
                
    case SHUFFLE_GAME_BOARD_RESPONSE:
        if(content != noone) {
            var success = ds_map_find_value(content, "message");
            show_debug_message("SHUFFLE_GAME_BOARD_SUCCESS = " + string(success));
            succeeded = true;
        }
        break;
                
    case USER_MOVE_RESPONSE:
        if(content != noone) {
            var response = ds_map_find_value(content, "message");
            show_debug_message("MOVE_MESSAGE = " + string(response));
            client_player.panel_row = ds_map_find_value(content, "new_row");
            client_player.panel_col = ds_map_find_value(content, "new_col");
            succeeded = true;
        }
        break;
                
    case CHAT_LOG_SEND_RESPONSE:
        if(content != noone) {
            var mess = ds_map_find_value(content, "message");
            show_debug_message("CHAT_LOG_SEND_RESPONSE MESSAGE = " + string(mess));
            succeeded = true;
        }
        break;
        
    case CHAT_LOG_GET_RESPONSE:
        if(content != noone) {
            var log_list = ds_map_find_value(content, "chat_array");
            show_debug_message("CHAT_LOG_GET_RESPONSE MESSAGE = " + string(log_list));
            
            if(ds_exists(log_list, ds_type_list)) {
                show_debug_message("Chat Logs: " + string(ds_list_size(log_list)));
                for(var i = 0; i < ds_list_size(log_list); i++) {
                    var list_map = ds_list_find_value(log_list, i);
                    var text = ds_map_find_value(list_map, "text");
                    var index = floor(ds_map_find_value(list_map, "index"));
                    //update chat log array
                    Client.chat_log_array[index] = text;
                    
                    ds_map_destroy(list_map);
                }
            }
            
            succeeded = true;
        }
        break;
                
    case GET_USERS_ONLINE_RESPONSE:
        if(content != noone) {
            //var success = ds_map_find_value(response_map, "succeed");
            show_debug_message("SHUFFLE_GAME_BOARD_SUCCESS = " + string(success));
            succeeded = true;
            var users_list = ds_map_find_value(content, "clients");
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
        break;
        
    case GET_INITIAL_USERS_ONLINE_RESPONSE:
        if(content != noone) {
            succeeded = true;
            var users_list = ds_map_find_value(content, "clients");
            show_debug_message("users_list: " + string(users_list));
            if(ds_exists(users_list, ds_type_list)) {
                show_debug_message("Users: " + string(ds_list_size(users_list)));
                for(var i = 0; i < ds_list_size(users_list); i++) {
                    var list_map = ds_list_find_value(users_list, i);
                    var uid = ds_map_find_value(list_map, "user_id");
                    if(client_player.user_id != uid) {
                        var other_player = instance_create(x, y, Player);
                        other_player.user_id = uid;
                        other_player.player_name = ds_map_find_value(list_map, "player_name");
                        other_player.panel_row = floor(ds_map_find_value(list_map, "panel_row"));
                        other_player.panel_col = floor(ds_map_find_value(list_map, "panel_col"));
                        ds_map_add(GameController.player_client_map, other_player.user_id, other_player);
                    }
                    ds_map_destroy(list_map);
                }
            } else {
                show_debug_message("Something happened @ GET_INITIAL_USERS_ONLINE_RESPONSE");
            }
        }
        break;
        
    case DELETE_USER_RESPONSE:
        if(content != noone) {
            var delete_user_id = ds_map_find_value(content, "user_id");
            with(Player) {
                if(user_id == delete_user_id) {
                    ds_map_delete(GameController.player_client_map, user_id);
                    instance_destroy();
                }
            }
            show_debug_message("user_id = " + string(delete_user_id));
            succeeded = true;
        }
        break;
        
    case CREATE_USER_RESPONSE:
        if(content != noone) {
            var new_player = instance_create(0, 0, Player);
            new_player.user_id = ds_map_find_value(content, "user_id");
            new_player.player_name = ds_map_find_value(content, "player_name");
            new_player.panel_row = ds_map_find_value(content, "row");
            new_player.panel_col = ds_map_find_value(content, "col");
            ds_map_add(GameController.player_client_map, new_player.user_id, new_player);
            show_debug_message("user_id = " + string(new_player.user_id));   
        }
        succeeded = true;
        break;
            
    //Set to noone if message_id isn't found    
    default:
        succeeded = noone;
        show_debug_message("Error, message id invalid!");
        break;

                                
}


ds_map_destroy(content);
return succeeded;
