///game_controller_draw()

switch(room) {
    default:
        break;
    case rm_intro:
        var x1 = 64;
        var y1 = 140 - 64;
        var x2 = room_width - 64;
        var y2 = 140;
        draw_rectangle(x1, y1, x2, y2, true);
        break;
    case rm_main:
        if(Client.client_player != noone) {
                    draw_text(10, 10, "player_name: " + Client.player_name + "#row: " + string(Client.client_player.panel_row) + " , col: " + string(Client.client_player.panel_col));
        }
        var x1 = room_width - room_width div 4;
        var x2 = (room_width - room_width div 4) + 120;
        var y1 = (room_height - room_height div 4) - 120;
        var y2 = (room_height - room_height div 4) + 20;
        draw_rectangle(x1, y1, x2, y2, true);
        
        //Chat log
        var temp_text = "Chat Log:"
        draw_text(room_width div 24, room_height div 8, temp_text);
        if(Client.chat_log_array != noone) {
            for(var i = 0; i < array_length_1d(Client.chat_log_array); i++) {
                draw_text(room_width div 24, (room_height div 8) + (i * 16 + 20), Client.chat_log_array[i]);
                draw_line(room_width div 24, (room_height div 8) + (i * 16 + 34), room_width div 3, (room_height div 8) + (i * 16 + 34));
            }
        }
        break;
}
