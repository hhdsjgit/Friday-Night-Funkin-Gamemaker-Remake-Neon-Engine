//global.Game_inf.cam_shark_shake_x = random_range(-10,10)
//global.Game_inf.cam_shark_shake_y = random_range(-10,10)
//global.Game_inf.ui_shark_shake_x = random_range(-5,5)
//global.Game_inf.ui_shark_shake_y = random_range(-5,5)
var bpm = global.Song_information.bpm; // 128
crochet = (60 / bpm) * 1000; // 每拍毫秒数 = 468.75ms
var _current_time = obj_main.song_time; // 你的时间变量
global.crochet = (_current_time / crochet);

if array_length(special_cam) > n {
	var a = special_cam[n]	
	if a <= global.crochet {
		n ++
		camera_zoom_add(0.05,0.015)
	}
}
//show_debug_message(global.crochet)
if array_length(pulse_steps) > n_color and global.game_play=1{
	var a = pulse_steps[n_color]	
	if a <= global.crochet {
		n_color ++
		n_red_color =255
	}
}
if global.crochet >= n_icon {
	n_icon += 2
	obj_main.icon_scale = -1.15
}
if n_red_color > 0 {
	//ui_arrow_set_color_my(0,n_red_color,255-n_red_color,255-n_red_color)
	//ui_arrow_set_color_my(1,n_red_color,255-n_red_color,255-n_red_color)
}else{
	ui_arrow_set_color_my(0,255,255,255)
	ui_arrow_set_color_my(1,255,255,255)	
}
n_red_color += func_frc((0 - n_red_color) / 20)
n_red_color = clamp(n_red_color,0,255)

global.Game_inf.cam_scale += func_frc((3-global.Game_inf.cam_scale)/15)