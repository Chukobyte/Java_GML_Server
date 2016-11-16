///json_decode_two_dimensional_array(json_string)

// Assumes key for array is grid_array

var json_string = argument0;

var new_array = noone;
var json_map = json_decode(json_string);
if(!ds_exists(json_map, ds_type_map)) {
    return noone;
}
var array_list = ds_map_find_value(json_map, "grid_array");

//loop through list
for(var i = 0; i < ds_list_size(array_list); i++) {
    var array_map = ds_list_find_value(array_list, i);
    var row =  real(ds_map_find_value(array_map, "row"));
    var col = real(ds_map_find_value(array_map, "col"));
    var val = ds_map_find_value(array_map, "val");
    
    //create array entry
    new_array[row, col] = val;
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


