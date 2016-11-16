/// client_prepare_buffer(buffer, request)
// Prepares the given buffer to be sent as a request.

buffer_resize(argument0, argument2);
buffer_seek(argument0, buffer_seek_start, 0);

//Write magic number
buffer_write(argument0, buffer_s16, Client.MAGIC_NUMBER);

// Write the request type that is to be sent to the
// buffer.
buffer_write(argument0, buffer_s8, argument1);
