/// @description 
var bpm = 102;
var _current_time = audio_sound_get_track_position(global.tittle_music) * 1000;
draw_subimg += func_frc(0.4)
crochet = (_current_time / ((60 / bpm) * 1000));
choose_setting = clamp(choose_setting,0,array_length(test_need_draw)-1)
ui_y += (choose_setting * 180 - ui_y) / 6

if right_check == false {
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
	//处理enter
	if keyboard_check_pressed(vk_enter) {
		audio_play_sound(confirm,0,0)
		right_check = true
		time = 90
	}
}
if right_check == true {
	if time <= 50 {
		Use_Gradient(0)	
	}
	time -= func_frc(1)
	if time <= 0 {
		switch test_need_draw[choose_setting] {
			case "STORY_MODE": room_goto(room_stroy_mode);break;
			case "FREEPLAY": audio_stop_all();room_goto(Main);global.song_get.song="extirpatient";global.song_get.difficulties="hell";break;
			case "CREDITS": room_goto(room_credions);break;
			case "OPTIONS": room_goto(room_options);break;
		}
	}
}