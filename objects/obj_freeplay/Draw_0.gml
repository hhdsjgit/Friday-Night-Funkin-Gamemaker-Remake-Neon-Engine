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
	image_alpha = 1
}