/// @description


for (var a = 0;a < array_length(test_need_draw.credits);a++) {
	if choose_setting = a {
		image_alpha = 1
	}else{
		image_alpha = 0.6
	}
	draw_text_bet(string(test_need_draw.credits[a].names),50,(300 + 140 * a) + -ui_y,1.12,1.12,0,image_alpha)
	if test_need_draw.credits[a].path != -1 {
		show_debug_message(test_need_draw.credits[a].path)
		draw_sprite_ext(
			test_need_draw.credits[a].path,
			0,
			50+string_length(string(test_need_draw.credits[a].names))*(sprite_get_width(spr_alphabet) - 37)*1.12+128,
			(300 + 140 * a) + -ui_y,
			128/sprite_get_width(test_need_draw.credits[a].path),
			128/sprite_get_height(test_need_draw.credits[a].path),
			0,
			c_white,
			image_alpha
		)
	}
	
	image_alpha = 1
}