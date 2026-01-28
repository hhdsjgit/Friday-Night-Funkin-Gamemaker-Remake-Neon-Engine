/// @description 

if keyboard_check_pressed(vk_up) {
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

choose_setting = clamp(choose_setting,0,array_length(now_need_read)-1)
ui_y += func_frc((choose_setting * 130 - ui_y) / 6)

function can_use_options (_bool) {
	if _bool {
		obj_options_main.fanzhuan = true
		obj_options_main.last_buff_x =100
		obj_options_main.buff_x = -1000	
	}else{
		obj_options_main.fanzhuan = false
		obj_options_main.last_buff_x = 100
		obj_options_main.buff_x = 1500
	}
}
if keyboard_check_pressed(vk_escape) {
	
	if now_need_read == test_need_draw.options_gameplay {
		can_use_options(1)
		choose_setting = 1
		last_need_read = now_need_read
		now_need_read = test_need_draw.options
		
	}
	
}
var noo_true = 0
if keyboard_check_pressed(vk_enter) {
	
	if now_need_read[choose_setting] == "GAMEPLAY >" {
		can_use_options(0)
		choose_setting = 0
		last_need_read = now_need_read
		now_need_read = test_need_draw.options_gameplay
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

