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
        draw_text(10, 10, "player_name: " + Client.player_name);
        var x1 = room_width - room_width div 4;
        var x2 = (room_width - room_width div 4) + 120;
        var y1 = (room_height - room_height div 4) - 120;
        var y2 = (room_height - room_height div 4) + 20;
        draw_rectangle(x1, y1, x2, y2, true);
        break;
}
