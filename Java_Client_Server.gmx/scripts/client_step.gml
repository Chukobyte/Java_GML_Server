///client_step()

get_input();

if(test_button) {
    //json_input_test();
}

if(server != noone) {
    connection_count--
    move_latency--;
    
    
    
    if(room == rm_main) {
        if(connection_count <= 0) {
            if(update_button) {
                //send for update
                client_send_request(server, buff, UPDATE_REQUEST);
                connection_count = connection_rate;
            }
            
            if(shuffle_button) {
                client_send_request(server, buff, SHUFFLE_GAME_BOARD_REQUEST);
                connection_count = connection_rate;
            }
        }
        
    }
    
    
    if(move_latency <= 0) {
                
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
        
    }
}

