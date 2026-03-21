/// @description 
if In_Controls = false {
	if keyboard_check_pressed(vk_up){
		audio_play_sound(sound_scroll,0,0)
		choose_setting -= 1
		if choose_setting < 0 {
			choose_setting = array_length(now_need_read)-1
		}
	}

	if keyboard_check_pressed(vk_down) {
		audio_play_sound(sound_scroll,0,0)
		choose_setting += 1
		if choose_setting >= array_length(now_need_read) {
			choose_setting = 0	
		}
	}
}

choose_setting = clamp(choose_setting,0,array_length(now_need_read)-1)
ui_y += func_frc((choose_setting * 130 - ui_y) / 6)

if keyboard_check_pressed(vk_escape) and In_Controls = false{
	
	if now_need_read == test_need_draw.options_gameplay {
		can_use_options(1)
		choose_setting = 1
		last_need_read = now_need_read
		now_need_read = test_need_draw.options
		
	}
	if now_need_read == test_need_draw.options_appearance {
		can_use_options(1)
		choose_setting = 1
		last_need_read = now_need_read
		now_need_read = test_need_draw.options
		
	}
	
}
var noo_true = 0
if keyboard_check_pressed(vk_enter) and In_Controls = false{
	if now_need_read[choose_setting] == "CONTROLS" {
		In_Controls = true
	}
	if now_need_read[choose_setting] == "GAMEPLAY >" {
		can_use_options(0)
		choose_setting = 0
		last_need_read = now_need_read
		now_need_read = test_need_draw.options_gameplay
		noo_true = 1
	}
	if now_need_read[choose_setting] == "APPEARANCE >" {
		can_use_options(0)
		choose_setting = 0
		last_need_read = now_need_read
		now_need_read = test_need_draw.options_appearance
		noo_true = 1
	}
	
}
if fanzhuan = false {
	buff_x += func_frc((100-buff_x)/12)
	last_buff_x += func_frc((-1000-last_buff_x)/15)
}else{
	buff_x += func_frc((100-buff_x)/12)
	last_buff_x += func_frc((1500-last_buff_x)/15)	
}

if keyboard_check_pressed(vk_enter) and noo_true = 0{
	get_setting(now_need_read[choose_setting],1)
}

switch now_need_read[choose_setting] {
	case "SONG OFFSET":
		if keyboard_check_pressed(vk_left) {
			global.setting_game.SONG_OFFSET --
		}
		if keyboard_check_pressed(vk_right) {
			global.setting_game.SONG_OFFSET ++
		}
		global.setting_game.SONG_OFFSET = clamp(global.setting_game.SONG_OFFSET,0,300)
	break;
}


if In_Controls = true{
	if keyboard_check_pressed(vk_up){
		audio_play_sound(sound_scroll,0,0)
		choose_controls[1] -= 1
		if choose_controls[1] < 0 {
			choose_controls[1] = array_length(choose_controls_draw)-1
		}
	}

	if keyboard_check_pressed(vk_down) {
		audio_play_sound(sound_scroll,0,0)
		choose_controls[1] += 1
		if choose_controls[1] >= array_length(choose_controls_draw) {
			choose_controls[1] = 0	
		}
	}
	if keyboard_check_pressed(vk_escape) {
		In_Controls = false;
	}	
	choose_controls_y += func_frc((choose_controls[1] * 100 - choose_controls_y) / 8)
}





















