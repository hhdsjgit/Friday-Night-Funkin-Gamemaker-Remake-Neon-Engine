/// @description 
var draw_x = 80
var draw_y = 100
var draw_need_air = 120
var _alpha = 1
function alpha_changed(time) {
	if floor(time) % 3 == 0{
		return 1;
	}else{
		return 0;
	}
}

for (var a = 0;a < array_length(test_need_draw);a++) {
	switch string(test_need_draw[a]) {
		
		case "STORY_MODE": 		
			if choose_setting == a {
				_alpha = alpha_changed(time)
				draw_sprite_ext(story_mode_white,draw_subimg,draw_x,(draw_y + draw_need_air * a),0.8,0.8,0,c_white,_alpha)
			}else{
				draw_sprite_ext(story_mode_basic,draw_subimg,draw_x,(draw_y + draw_need_air * a),0.8,0.8,0,c_white,1)
			}
			break;
			
		case "FREEPLAY": 
			
			if choose_setting == a {
				_alpha = alpha_changed(time)
				draw_sprite_ext(freeplay_white,draw_subimg,draw_x,(draw_y + draw_need_air * a),0.8,0.8,0,c_white,_alpha)
			}else{
				draw_sprite_ext(freeplay_basic,draw_subimg,draw_x,(draw_y + draw_need_air * a),0.8,0.8,0,c_white,1)
			}
			break;
			
		case "CREDITS": 
			
			if choose_setting == a {
				_alpha = alpha_changed(time)
				draw_sprite_ext(credits_white,draw_subimg,draw_x,(draw_y + draw_need_air * a),0.8,0.8,0,c_white,_alpha)
			}else{
				draw_sprite_ext(credits_basic,draw_subimg,draw_x,(draw_y + draw_need_air * a),0.8,0.8,0,c_white,1)
			}
			break;
			
		case "OPTIONS": 
			
			if choose_setting == a {
				_alpha = alpha_changed(time)
				draw_sprite_ext(options_white,draw_subimg,draw_x,(draw_y + draw_need_air * a),0.8,0.8,0,c_white,_alpha)
			}else{
				draw_sprite_ext(options_basic,draw_subimg,draw_x,(draw_y + draw_need_air * a),0.8,0.8,0,c_white,1)
			}
			break;
			
	}
}