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
for (var a = 0;a < array_length(all_songs);a++) {
	var better_math = choose_setting - a
	if better_math > 0 {
		better_math = -better_math*40
	}else{
		better_math = better_math*40
	}
	if choose_setting == a {
		image_alpha=alpha_changed(time)		
	}else{
		image_alpha = 0.5	
	}
	draw_text_bet(string(all_songs[a][0]),80+better_math,(270 +120 * a) + -ui_y,1,1,0,image_alpha)
	//draw_text_bet(string(test_need_draw[a]),50,(500 + 100 * a) + -ui_y,1,1,0,image_alpha)
	image_alpha = 1
}