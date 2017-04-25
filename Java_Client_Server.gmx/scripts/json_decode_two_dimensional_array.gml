///json_decode_two_dimensional_array(json_string)

// Assumes key for array is grid_array

var json_string = argument0;

var new_array = noone;
var json_map = json_decode(json_string);
if(!ds_exists(json_map, ds_type_map)) {
    return noone;
}
show_debug_message("json_decode 2d = " + string(json_map));
var array_list = ds_map_find_value(json_map, "grid_array");
show_debug_message("array_list = " + string(array_list));

//loop through list
for(var i = 0; i < ds_list_size(array_list); i++) {
    var array_map = ds_list_find_value(array_list, i);
    var row =  floor(ds_map_find_value(array_map, "row"));
    var col = floor(ds_map_find_value(array_map, "col"));
    var val_map = ds_map_find_value(array_map, "val");
    val_json = json_encode(val_map);
    show_debug_message(val_json);
    
    //create array entry
    new_array[row, col] = string(val_json);
    ds_map_destroy(val_map);
    ds_map_destroy(array_map);
}

ds_list_destroy(array_list);
ds_map_destroy(json_map);

//debug
//for(var i = 0; i < 3; i++) {
//    for(var j = 0; j < 3; j++) {
//        show_debug_message("[" + string(i) + "," + string(j) + "] = " + new_array[i, j])
//    }
//}

return new_array;


