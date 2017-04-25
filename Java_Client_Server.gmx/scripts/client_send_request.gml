///client_send_request(socket, buffer, request, size)
var socket = argument0;
var buffer = argument1;
var request = argument2;

var size = 0;
if(argument_count <= 3) {
    size = 32;
} else {
    size = argument[3];
}

client_prepare_buffer(buffer, request, size);

switch(request) {

    case Client.USER_ID_REQUEST:
        show_debug_message("User ID Requested");
        show_debug_message("buffer size: " + string(buffer_get_size(buffer)));
        network_send_packet(socket, buffer, buffer_tell(buffer));
        break;
        
    case Client.UPDATE_REQUEST:
        show_debug_message("Update Requested!");
        network_send_packet(socket, buffer, buffer_tell(buffer));
        break;
        
    case Client.USER_NAME_SEND_REQUEST:
        buffer_write(buffer, buffer_string, Client.player_name);
        network_send_packet(socket, buffer, buffer_tell(buffer));
        break;
        
    case Client.SHUFFLE_GAME_BOARD_REQUEST:
        show_debug_message("Shuffle Game Board Requested!");
        network_send_packet(socket, buffer, buffer_tell(buffer));
        break;
        
    case Client.USER_MOVE_REQUEST:
        show_debug_message("User Move Requested!");
        buffer_write(buffer, buffer_string, direction_last_moved);
        network_send_packet(socket, buffer, buffer_tell(buffer));
        break;
        
    case Client.CHAT_LOG_SEND_REQUEST:
        buffer_write(buffer, buffer_string, ChatInput.chat_text);
        network_send_packet(socket, buffer, buffer_tell(buffer));
        break;
        
    case Client.CHAT_LOG_GET_REQUEST:
        show_debug_message("CHAT_LOG_GET_REQUEST");
        network_send_packet(socket, buffer, buffer_tell(buffer));
        break;
        
    case Client.GET_USERS_ONLINE_REQUEST:
        show_debug_message("Get Users Online Requested!");
        network_send_packet(socket, buffer, buffer_tell(buffer));
        break;
        
    case Client.GET_INITIAL_USERS_ONLINE_REQUEST:
        show_debug_message("Get Users Online Requested!");
        network_send_packet(socket, buffer, buffer_tell(buffer));
        break;

    default:
        show_debug_message("Unknown ID trying to send");
        break;
}
