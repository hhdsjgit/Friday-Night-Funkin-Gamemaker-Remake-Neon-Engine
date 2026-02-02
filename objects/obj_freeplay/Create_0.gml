/// @description 
choose_setting = 0
ui_y = 0
right_check = false
time = 0
draw_alpha = 1
time = 0
sound_scroll= scroll
test_need_draw = load_all_jsons_from_folder("assets\\weeks\\")

all_songs = [];

for (var i = 0; i < array_length(test_need_draw); i++) {
    var week = test_need_draw[i];
        
    // 添加当前week的所有歌曲
    for (var j = 0; j < array_length(week.songs); j++) {
        array_push(all_songs, week.songs[j]);
    }
}
show_debug_message(all_songs)