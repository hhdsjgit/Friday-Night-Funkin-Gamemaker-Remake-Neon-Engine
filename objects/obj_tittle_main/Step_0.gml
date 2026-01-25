/// @description
if check_enter_tittle {run_wait_time -= func_frc(1)};
subimg += func_frc(1);
var bpm = 102;
var _current_time = audio_sound_get_track_position(global.tittle_music) * 1000;
crochet = (_current_time / ((60 / bpm) * 1000));

if keyboard_check_pressed(vk_enter) {
	if check_enter_tittle = false {
		audio_play_sound(confirm,0,0);
		subimg = 0;
		check_enter_tittle = true;
	}
}
if run_wait_time <= 0 {
	room_goto(room_game_choose)	
}