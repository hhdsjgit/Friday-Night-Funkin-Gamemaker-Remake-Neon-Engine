/// @description
/////处理音量//////
if keyboard_check_pressed(vk_add) {
	global.setting_game.Volume += 1	
	time = 90
	draw_Volume_ui_y = 22
	audio_play_sound(volume,0,0)
}
if keyboard_check_pressed(vk_subtract) {
	global.setting_game.Volume -= 1	
	time = 90
	draw_Volume_ui_y = 22
	audio_play_sound(volume,0,0)
}

if time > 0 {
	time --	
}
if time <= 30 {
	draw_Volume_ui_y -= 5
}

audio_master_gain(global.setting_game.Volume / 10)

//限制数值,防止超出正常范围!//
global.setting_game.Volume = clamp(global.setting_game.Volume,0,10);
draw_Volume_ui_y = clamp(draw_Volume_ui_y,-30,100)


