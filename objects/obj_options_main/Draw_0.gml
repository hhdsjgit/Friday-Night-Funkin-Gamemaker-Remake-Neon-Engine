/// @description 
update_animations();
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
	if now_need_read[a] == "SONG OFFSET"{
		draw_text_bet(string(global.setting_game.SONG_OFFSET),buff_x+better_math*40+string_length(string(now_need_read[a]))*90 - 400,(i_x + 130 * a) + -ui_y,1,1,0,image_alpha)
	}
	draw_text_bet(string(now_need_read[a]),buff_x+better_math*40,(i_x + 130 * a) + -ui_y,1,1,0,image_alpha)
	
	var _anim = get_draw_anim(string(now_need_read[a]));
	if (_anim[0] > 0 or _anim[1] != 0) {
	    // 有动画时绘制动画精灵
	    draw_sprite_ext(Check_Box_selecting_animation, _anim[0], 
	        buff_x+better_math*40 + 30, (i_x + 130 * a) + -ui_y, 1, 1, 0, c_white, 1);
	} else if (is_toggle_setting(string(now_need_read[a]))) {
	    // 是开关设置但没有动画，绘制静态复选框
	    var _box_value = get_setting(string(now_need_read[a]), -1) ? 1 : 0;
	    draw_sprite_ext(get_draw_box(_box_value), 0,
	        buff_x+better_math*40 + 30, (i_x + 130 * a) + -ui_y, 1, 1, 0, c_white, 1);
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




//按键设置
if In_Controls {
	draw_set_colour(c_black)
	draw_set_alpha(0.6)
	draw_rectangle(-5,-5,1285,725,0)
	draw_set_colour(c_white)
	draw_set_alpha(1)
	for (var n=0;n<array_length(choose_controls_draw);n++){
		//draw_text(150,320+n*80+choose_controls_y,choose_controls_draw[n][0])
		var alpha = 1
		if choose_controls[1] == n {
			alpha = 0.5	
		}
		draw_text_bet(choose_controls_draw[n][0],150,320+n*100-choose_controls_y,0.98,0.98,0,alpha)
	}
}



