///array_compress(array, value)
var array = argument0;
var value = argument1;

var new_array = noone;
var new_index = 0;
for(var i = 0; i < array_length_1d(array); i++) {
    if(array[i] != value) {
        new_array[new_index] = array[i];
        new_index++;
    } else {
        //show_debug_message("Array Compress : array[ " + string(i) +  "] = " + string(array[i]));
    }
}

//show_debug_message("New Array = " + string(new_array));

return new_array;
