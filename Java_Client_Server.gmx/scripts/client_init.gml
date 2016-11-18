///client_init()

//json test
json_file = working_directory + "\\array_test.json";
var file = file_text_open_read(json_file);
json_str = "";
while(!file_text_eoln(file)) {
    json_str += file_text_read_string(file);
    file_text_readln(file);
}
file_text_close(file);
//show_debug_message("json_str:");
var pretty = string_replace_all(json_str, " ", "");
//show_debug_message(pretty);
client_pretty_json = pretty;
//Stores current array value for client
client_array = json_decode_two_dimensional_array(pretty);
//end test

//Message ID Constants
MAGIC_NUMBER = 12313;
CLIENT_HEADER = 124;
UPDATE_RESPONSE = 16;
UPDATE_REQUEST = 8;
USER_ID_RESPONSE = 6;
USER_ID_REQUEST = 3;
USER_NAME_SEND_RESPONSE = 22;
USER_NAME_SEND_REQUEST = 11;
SHUFFLE_GAME_BOARD_RESPONSE = 24;
SHUFFLE_GAME_BOARD_REQUEST = 12;
USER_MOVE_RESPONSE = 64;
USER_MOVE_REQUEST = 32;
CHAT_LOG_SEND_RESPONSE = 88;
CHAT_LOG_SEND_REQUEST = 44;
GET_USERS_ONLINE_RESPONSE = 66;
GET_USERS_ONLINE_REQUEST = 33;

server = network_create_socket(network_socket_tcp);
network_set_timeout(server, 20000, 20000); //set read and write to 20 seconds
result = network_connect_raw(server, "127.0.0.1", 6510);
connection_rate = room_speed * 2; //Check every 2 seconds for update data
connection_count = noone;
move_latency_max = room_speed * 2;
move_latency = move_latency_max;
is_initialized = false;
user_id = noone; //unique user id returned from server
player_name = "";
direction_last_moved = "";
//message_count = 0;
message = noone;
log_file = file_text_open_append(working_directory + "\logs\gml_log.txt");
if(result == 0) {
    buff = buffer_create(256, buffer_grow, 1);
    connection_count = connection_rate;
    show_debug_message("Connected to server successfully");
    client_send_request(server, buff, USER_ID_REQUEST);
    
} else {
    if(show_question("Couldn't connect to server, retry?")) {
        network_destroy(server);
        game_restart();
    } else {
        network_destroy(server);
        game_end();
    }
}
