if keyboard_check_pressed(vk_up) {
	audio_play_sound(sound_scroll,0,0)
	choose_setting -= 1
	if choose_setting < 0 {
		choose_setting = array_length(test_need_draw.weeks)-1
	}
}

if keyboard_check_pressed(vk_down) {
	audio_play_sound(sound_scroll,0,0)
	choose_setting += 1
	if choose_setting >= array_length(test_need_draw.weeks) {
		choose_setting = 0	
	}
}

choose_setting = clamp(choose_setting,0,array_length(test_need_draw.weeks)-1)
ui_y += (choose_setting * 100 - ui_y) / 6

if keyboard_check_pressed(vk_enter) {
	
}