/// @description 

if keyboard_check_pressed(vk_up) {
	audio_play_sound(sound_scroll,0,0)
	choose_setting -= 1
	if choose_setting < 0 {
		choose_setting = array_length(test_need_draw.credits)-1
	}
}

if keyboard_check_pressed(vk_down) {
	audio_play_sound(sound_scroll,0,0)
	choose_setting += 1
	if choose_setting >= array_length(test_need_draw.credits) {
		choose_setting = 0	
	}
}

choose_setting = clamp(choose_setting,0,array_length(test_need_draw.credits)-1)
ui_y += func_frc((choose_setting * 140 - ui_y) / 6)
	
