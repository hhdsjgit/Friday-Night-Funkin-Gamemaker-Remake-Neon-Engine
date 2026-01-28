/// @description 
for (var a = 0;a < array_length(last_need_read);a++) {
	var better_math = choose_setting - a
	if better_math > 0 {
		better_math = -better_math*40
	}
	if choose_setting = a {
		image_alpha = 1
	}else{
		image_alpha = 0.5	
	}
	draw_text_bet(string(last_need_read[a]),last_buff_x+better_math,(300 + 130 * a) + -ui_y,1,1,0,image_alpha)
	image_alpha = 1
}

for (var a = 0;a < array_length(now_need_read);a++) {
	var better_math = choose_setting - a
	if better_math > 0 {
		better_math = -better_math	
	}
	if choose_setting = a {
		image_alpha = 1
	}else{
		image_alpha = 0.5	
	}
	draw_text_bet(string(now_need_read[a]),buff_x+better_math*40,(300 + 130 * a) + -ui_y,1,1,0,image_alpha)
	image_alpha = 1
}

draw_set_colour(c_black)
draw_set_alpha(0.6)
draw_roundrect(0,0,1280,100,0)
draw_set_alpha(1)
draw_set_colour(c_white)
draw_set_font(Font_vcr_30)
switch now_need_read {
	case test_need_draw.options: draw_text_transformed(3,3,"OPTIONS >",0.9,0.9,0);break;
	case test_need_draw.options_gameplay: draw_text_transformed(3,3,"OPTIONS > GAMEPLAY >",0.9,0.9,0);break;
}
draw_set_font(Font_vcr)
switch now_need_read[choose_setting] {
	case "CONTROLS": draw_text_transformed(3,35,"Don't ask for me!",1,1,0);break;
	case "GAMEPLAY >":  draw_text_transformed(3,35,"Don't ask for me!",1,1,0);break;
	case "APPEARANCE >": draw_text_transformed(3,35,"Don't ask for me!",1,1,0);break;
	case "MISCELLANEOUS >": draw_text_transformed(3,35,"Don't ask for me!",1,1,0);break;
	case "SHARDER >": draw_text_transformed(3,35,"Don't ask for me!",1,1,0);break;
	
}