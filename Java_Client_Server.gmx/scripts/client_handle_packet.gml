///client_handle_packet(buffer)

var buffer = argument0;

var success = false;
var n_id = async_load[? "id"];

if(n_id == server) {
    var type = async_load[? "type"];
    
    var header_stuff = 4 + 1 + 2;
    var packet_size = 4;
    var magic_number = buffer_peek(buffer, 0, buffer_u16);  //Peak at magic number and if it is, read to move buffer
    //Getting beginning of message
    if(magic_number == MAGIC_NUMBER) {    
        buffer_read(buffer, buffer_u16);  //move buffer if magic number is read
        show_debug_message("magic_number = " + string(magic_number)); 
        buffering_messages = true;
        response_buffered_messages = "";
    } else {
        show_debug_message("non magic_number = " + string(magic_number)); 
    }
    
    if(buffering_messages) {
        //var buffer_peak = buffer_peek(buffer, 1, buffer_string);
        var buffer_peak = buffer_base64_encode(buffer, 0, buffer_get_size(buffer));
        show_debug_message("(debug) buffer_peak = " + string(buffer_peak));
        //buffer_base64_encode returns "GTA=" if blank
        if(buffer_peak != noone && buffer_peak != "GTA=") {
            response_buffered_messages += buffer_read(buffer, buffer_string);
            var incoming_json_map = json_decode(response_buffered_messages);
            if(ds_exists(incoming_json_map, ds_type_map) && ds_map_exists(incoming_json_map, MESSAGE_ID)) { 
                var success = client_handle_response_updated(incoming_json_map, buffer);
                if(success) {
                    buffering_messages = false;
                }
                ds_map_destroy(incoming_json_map);
            }        
        } else {
            show_debug_message("no string to buffer");
        }
    } else {
        show_debug_message("data coming without buffer flag set");
    }
}

return success;
