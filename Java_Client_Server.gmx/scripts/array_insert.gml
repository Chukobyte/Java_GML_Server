///array_insert(array, position, value)

var array = argument0;
var pos = argument1;
var val = argument2;

//Checks if last element in array
var array_length = array_length_1d(array);
if(array_length == pos) {
    array[pos] = val;
    return array;
}

var new_array = noone;
var new_array_index = 0;
for(var i = 0; i < array_length; i++) {
    if(i == pos) {
        new_array[i] = val;
        new_array_index++;
        
    }
    new_array[new_array_index] = array[i];
    new_array_index++;
}


return new_array;
