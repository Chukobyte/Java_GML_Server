///client_handle_packet(buffer)

var buffer = argument0;

var success = false;
var n_id = async_load[? "id"];

if(n_id == server) {
    var type = async_load[? "type"];
    
    var header_stuff = 4 + 1 + 2;
    var packet_size = 4;
    var magic_number = buffer_peek(buffer, 0, buffer_u16);  //Peak at magic number and if it is, read to move buffer
    show_debug_message("magic_number = " + string(magic_number)); 
    //Getting beginning of message
    if(magic_number == MAGIC_NUMBER) {    
        buffer_read(buffer, buffer_u16);  //move buffer if magic number is read
        buffering_messages = true;
        response_buffered_messages = "";
        //var size_in_bytes = buffer_get_size(buffer);
        //show_debug_message("size_in_bytes = " + string(size_in_bytes));
        //var message_id = buffer_read(buffer, buffer_s8);
        //show_debug_message("message_id = " + string(message_id));
        //need to buffer response
        
        /*
        var success = client_handle_response(buffer, message_id);
        if(!success) {
            buffered_message_id = message_id;
            buffering_messages = true;
        } 
        */ 
    }
    if(buffering_messages) {
        var buffer_peak = buffer_peek(buffer, 1, buffer_string);
        if(buffer_peak != noone) {
            response_buffered_messages += buffer_read(buffer, buffer_string);
            var incoming_json_map = json_decode(response_buffered_messages);
            if(ds_exists(incoming_json_map, ds_type_map) && incoming_json_map != noone) { 
                var success = client_handle_response_updated(incoming_json_map, buffer);
                if(success) {
                    buffering_messages = false;
                }
                ds_map_destroy(incoming_json_map);
            }        
        } else {
            show_debug_message("no string to buffer");
        }
        /*
        //Temp section until propertly handled
        //Section if number isn't magic number it must be a continuation of old stream
        response_buffered_messages += buffer_read(buffer, buffer_string);
        var success = client_handle_response(buffer, buffered_message_id); //retry request handling
        if(success) {
            buffered_message_id = noone;
            buffering_messages = false;
        }
        */
    } else {
        show_debug_message("Unexpected message: " + string(magic_number));
    }
}

return success;
