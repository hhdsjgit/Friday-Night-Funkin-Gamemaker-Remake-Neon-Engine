/// @description

if global.game_paused = 1{
	draw_set_color(c_black)
	draw_set_alpha(0.5)
	draw_rectangle(0,0,1280,720,0)
	draw_set_color(c_white)
	draw_set_alpha(1)
	
	//draw_sprite_ext(spr_tittle,0,1280 / 2,(clamp(draw_alpha,1.5,2.5)-1.5) * 160,0.5,0.5,0,c_white,clamp(draw_alpha,1.5,2.5)-1.5)
	draw_set_alpha(draw_alpha)
	var draw_rec_y = (1-clamp(draw_alpha,0,1)) * 120  
	//draw_rectangle(1280 / 2 - 100,(draw_rec_y + 320),1280 / 2 + 100,draw_rec_y + 550,0)
	//draw_Outline("Game stop",100,100,1.2,1.2,c_black,c_white,0,Font_vcr)
	
	//绘制左上角信息
	var draw_tex_y = (clamp(draw_alpha,0,1)-1) * 10
	draw_set_halign(fa_right);
	draw_set_alpha(clamp(draw_alpha,0,1))
	draw_Outline(global.Song_information.song,1270,15+draw_tex_y,1,1,c_black,c_white,0,Font_vcr)
	draw_set_alpha(clamp(draw_alpha,1,2) - 1)
	draw_Outline("HELL",1270,40+draw_tex_y,1,1,c_black,c_white,0,Font_vcr)
	draw_set_alpha(clamp(draw_alpha,1.5,2.5) - 1.5)
	draw_Outline(obj_main.song_time_show,1270,65+draw_tex_y,1,1,c_black,c_white,0,Font_vcr)
	draw_set_halign(fa_left)
	
	//重置
	draw_set_color(c_grey)
	draw_set_halign(fa_center);
	draw_set_valign(fa_middle);
	
	for (var a = 0;a < array_length(test_need_draw);a++) {
		if choose_setting = a {
			image_alpha = 1
		}else{
			image_alpha = 0.5	
		}
		draw_text_bet(string(test_need_draw[a]),50,(300 + 180 * a) + -ui_y,1,1,0,image_alpha)
		image_alpha = 1
	}
	//draw_text_bet("TEST1",50,400 + -ui_y,1,1,0,1)
	draw_Outline("y: " + string(ui_y),100,40,1,1,c_black,c_white,0,Font_vcr)
	draw_Outline("choose_setting: " + string(choose_setting),100,90,1,1,c_black,c_white,0,Font_vcr)

	
	draw_Outline("NEW GAME TEST",50,550,1,1,c_black,c_white,0,Font_vcr)
	//draw_Outline("TEST1",1280/2,draw_rec_y + 340,1.2,1.2,c_black,c_white,0,Font_vcr)
	
	draw_set_halign(fa_left);
	draw_set_valign(fa_top);
	draw_set_color(c_white)
	
	draw_set_alpha(1)
}