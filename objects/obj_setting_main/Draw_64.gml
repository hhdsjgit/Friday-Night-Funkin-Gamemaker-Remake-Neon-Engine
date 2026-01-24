/// @description 
/////处理音量的绘制//////
if time > 0 {
	draw_set_color(c_black)
	draw_rectangle(draw_Volume_ui_x - 2, draw_Volume_ui_y - 40, draw_Volume_ui_x + 10 * 15 + 2, draw_Volume_ui_y + 22, 0)
	draw_set_color(c_white)
	draw_rectangle(draw_Volume_ui_x, draw_Volume_ui_y, draw_Volume_ui_x + global.setting_game.Volume * 15, draw_Volume_ui_y + 20, 0)
	draw_Outline("Volume:" + string(global.setting_game.Volume * 10) + "%",draw_Volume_ui_x,draw_Volume_ui_y,1,1,c_black,c_white,0,Font_vcr)
	if global.setting_game.Volume >= 10 {
		draw_Outline("MAX Volume",draw_Volume_ui_x,draw_Volume_ui_y - 22,1,1,c_black,c_red,0,Font_vcr)
	}
	if global.setting_game.Volume >= 1 and global.setting_game.Volume <= 9{
		draw_Outline("NOR Volume",draw_Volume_ui_x,draw_Volume_ui_y - 22,1,1,c_black,c_white,0,Font_vcr)
	}
	if global.setting_game.Volume <= 0 {
		draw_Outline("MIN Volume",draw_Volume_ui_x,draw_Volume_ui_y - 22,1,1,c_black,c_blue,0,Font_vcr)
	}
}
