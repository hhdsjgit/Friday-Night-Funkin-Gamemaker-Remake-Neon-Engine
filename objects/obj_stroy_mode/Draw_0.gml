/// @description
function alpha_changed(time) {
	if floor(time) % 3 == 0{
		return 1;
	}else{
		return 0;
	}
}

function draw_text_bet_ext(text,_x,_y,_image_xscale,_image_yscale,a,angle,alpha) {
	var use_x = string_length(text) * (sprite_get_width(spr_alphabet) - 37) * _image_xscale
	draw_text_bet(text,_x - use_x/2,_y,_image_xscale,_image_yscale,angle,alpha)
}
for (var a = 0;a < array_length(test_need_draw.weeks);a++) {
	if choose_setting == a {
		image_alpha=alpha_changed(time)		
		show_debug_message("A")
	}else{
		image_alpha = 0.5	
	}
	draw_text_bet_ext(string(test_need_draw.weeks[a].week_name),1280/2-100,(550 + 100 * a) + -ui_y,1,1,0,0,image_alpha)
	//draw_text_bet(string(test_need_draw[a]),50,(500 + 100 * a) + -ui_y,1,1,0,image_alpha)
	image_alpha = 1
}


draw_set_color(c_black)
draw_rectangle(0,0,1280,32,0)
draw_set_color(make_color_rgb(249,207,81))
draw_rectangle(0,32,1280,450,0)
draw_set_halign(fa_right)
draw_set_color(c_white)
draw_text(1278,5,test_need_draw.weeks[choose_setting].note)
draw_set_halign(fa_left)

draw_set_color(make_color_rgb(229,87,119))
draw_set_font(Font_vcr_30)
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_text_transformed(120,520,"TRACKS",0.85,0.85,0)
for (var i = 0;i < array_length(test_need_draw.weeks[choose_setting].songs);i++) {
	draw_text_transformed(120,550+i * 38,test_need_draw.weeks[choose_setting].songs[i],0.85,0.85,0)
	
}
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_font(Font_vcr)
draw_set_color(c_white)
