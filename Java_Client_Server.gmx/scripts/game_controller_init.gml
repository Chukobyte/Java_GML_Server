///game_controller_init()

global.MAGIC_NUMBER = 20336;
delta_tracker = instance_create(x, y, DeltaTracker);
//Client create array upon creation
player_client = instance_create(x, y, Client);
player_client_map = ds_map_create();
var client_json_text = player_client.client_pretty_json;
game_board_array = json_decode_two_dimensional_array(client_json_text);
panel_board_array = noone; //stores panel to reference game board array
update_board = false;  //checks if board was updated

//Chat box
chat_input = instance_create(x, y, ChatInput);
//typed_text = "";
//player_can_type = false;
