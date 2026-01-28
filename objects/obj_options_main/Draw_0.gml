/// @description 
var i_x = 360
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
	draw_text_bet(string(last_need_read[a]),last_buff_x+better_math,(i_x + 130 * a) + -ui_y,1,1,0,image_alpha)
	image_alpha = 1
	if get_draw_anim(string(last_need_read[a]))[0] > 0 or get_draw_anim(string(last_need_read[a]))[1] = 1{
		draw_sprite_ext(Check_Box_selecting_animation,get_draw_anim(string(last_need_read[a]))[0],last_buff_x+better_math*40 + 30,(i_x + 130 * a) + -ui_y,1,1,0,c_white,1)
	}else{
		draw_sprite_ext(get_draw_box(get_setting(string(last_need_read[a]),-1)),get_draw_anim(string(last_need_read[a]))[0],last_buff_x+better_math*40+ 30,(i_x + 130 * a) + -ui_y,1,1,0,c_white,1)
		
	}
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
	draw_text_bet(string(now_need_read[a]),buff_x+better_math*40,(i_x + 130 * a) + -ui_y,1,1,0,image_alpha)
	
	image_alpha = 1
	if get_draw_anim(string(now_need_read[a]))[0] > 0 or get_draw_anim(string(now_need_read[a]))[1] = 1{
		if get_draw_anim(string(now_need_read[a]))[1] = -1 {
			get_draw_anim(string(now_need_read[a]))[0] --
		}else if get_draw_anim(string(now_need_read[a]))[1] = 1{
			get_draw_anim(string(now_need_read[a]))[0] ++
			if get_draw_anim(string(now_need_read[a]))[0] >= 10 {
				get_draw_anim(string(now_need_read[a]))[1] = 0
			}
		}
		draw_sprite_ext(Check_Box_selecting_animation,get_draw_anim(string(now_need_read[a]))[0],buff_x+better_math*40 + 30,(i_x + 130 * a) + -ui_y,1,1,0,c_white,1)
	}else{
		draw_sprite_ext(get_draw_box(get_setting(string(now_need_read[a]),-1)),get_draw_anim(string(now_need_read[a]))[0],buff_x+better_math*40+ 30,(i_x + 130 * a) + -ui_y,1,1,0,c_white,1)
		
	}
	
	
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
	case "BUBBLE SORT": draw_text_transformed(3,35,"Solve the issue where the facade list time is not sorted in ascending order in special cases through sorting. \n(For large facades, this can consume a significant amount of performance) Low",0.9,0.9,0);break;

	
}

global.debug_settig.debug_y += (105-global.debug_settig.debug_y)/10