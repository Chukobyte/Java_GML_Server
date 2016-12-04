///client_step()

get_input();

if(server != noone) {
    connection_count--
    move_latency--;
    
    
    
    if(room == rm_main) {
        var chat_input_typing = false;
        if(instance_exists(ChatInput)) {
            if(ChatInput.player_can_type) {
                chat_input_typing = true;
            }
        }
        if(connection_count <= 0 && !chat_input_typing) {
            if(update_button) {
                //send for update
                client_send_request(server, buff, UPDATE_REQUEST);
                connection_count = connection_rate;
            }
            
            if(shuffle_button) {
                client_send_request(server, buff, SHUFFLE_GAME_BOARD_REQUEST);
                connection_count = connection_rate;
            }
            
            if(get_users_online_button) {
                client_send_request(server, buff, GET_USERS_ONLINE_REQUEST);
                connection_count = connection_rate;
            }
        }
        
    }
    
    
    if(move_latency <= 0) {
    
        /*
                
        if(left) {
            direction_last_moved = "left";
            client_send_request(server, buff, USER_MOVE_REQUEST);
            move_latency = move_latency_max;
        } else if(right) {
            direction_last_moved = "right";
            client_send_request(server, buff, USER_MOVE_REQUEST);
            move_latency = move_latency_max;
        } else if(up) {
            direction_last_moved = "up";
            client_send_request(server, buff, USER_MOVE_REQUEST);
            move_latency = move_latency_max;
        } else if(down) {
            direction_last_moved = "down";
            client_send_request(server, buff, USER_MOVE_REQUEST);
            move_latency = move_latency_max;
        }
        */
        
    }
    
    if(player_row != noone && player_col != noone && GameController.panel_board_array != noone) {
        x = GameController.panel_board_array[player_row, player_col].x;
        y = GameController.panel_board_array[player_row, player_col].y;
    }
}

