/// @description 
for (var a = 0;a < array_length(last_need_read);a++) {
	if choose_setting = a {
		image_alpha = 1
	}else{
		image_alpha = 0.5	
	}
	draw_text_bet(string(last_need_read[a]),last_buff_x,(300 + 130 * a) + -ui_y,1,1,0,image_alpha)
	image_alpha = 1
}

for (var a = 0;a < array_length(now_need_read);a++) {
	if choose_setting = a {
		image_alpha = 1
	}else{
		image_alpha = 0.5	
	}
	draw_text_bet(string(now_need_read[a]),buff_x,(300 + 130 * a) + -ui_y,1,1,0,image_alpha)
	image_alpha = 1
}