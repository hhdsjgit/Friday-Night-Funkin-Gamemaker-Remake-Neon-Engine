/// @description 
if audio_is_playing(break_music) = false{
	var sound_play = audio_play_sound(break_music,0,1)		
	audio_sound_gain(sound_play, 1.0, 3000);
}

if global.game_paused = 1{
	if keyboard_check_pressed(vk_up) {
		audio_play_sound(sound_scroll,0,0)
		choose_setting -= 1
		if choose_setting < 0 {
			choose_setting = array_length(test_need_draw)-1
		}
	}

	if keyboard_check_pressed(vk_down) {
		audio_play_sound(sound_scroll,0,0)
		choose_setting += 1
		if choose_setting >= array_length(test_need_draw) {
			choose_setting = 0	
		}
	}

	choose_setting = clamp(choose_setting,0,array_length(test_need_draw)-1)
	ui_y += (choose_setting * 180 - ui_y) / 6
	if keyboard_check_pressed(vk_enter) {
		if test_need_draw[choose_setting] == "RESTART SONG" {
			room_goto(Main)
			audio_stop_all()
		}
		if test_need_draw[choose_setting] == "RESUME" {
			audio_stop_sound(break_music)
			resume_game();
		}
	}
}