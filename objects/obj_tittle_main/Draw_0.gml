/// @description
/*
function draw_text_bet(text,_x,_y,_image_xscale,_image_yscale,angle,alpha) {
	
	for (var i=1;i <= string_length(text);i ++) {
		var _chars = " "
		
		_chars = string_upper(string_char_at(text, i));	
		if func_bet_char(_chars) != -1 {
			draw_sprite_ext(spr_alphabet,func_bet_char(_chars) + obj_all_load.anit_time,_x +
			(sprite_get_width(spr_alphabet) - 37)* i * image_xscale,_y 
			,_image_xscale,_image_yscale,angle,c_white,alpha)	
		}
		
	}
}
*/
function draw_text_bet_ext(text,_x,_y,_image_xscale,_image_yscale,a,angle,alpha) {
	var use_x = string_length(text) * (sprite_get_width(spr_alphabet) - 37) * _image_xscale
	draw_text_bet(text,_x - use_x/2,_y,_image_xscale,_image_yscale,angle,alpha)
}
function show_text(text,_x,_y,_start_p,_end_p,get_time) {
	if get_time >= _start_p and get_time <= _end_p {
		draw_text_bet_ext(text,1280/2-100,_y,1,1,0,0,1)
	}
}
show_text("Neon Engine By",1280/2,120,1,5,crochet)
show_text("Goodtimes2",1280/2,200,3,5,crochet)
show_text("TEST NEW",1280/2,120,6,9,crochet)
show_text("GAME",1280/2,200,7,9,crochet)

if check_enter_tittle = true {
	if subimg > sprite_get_number(spr_tittle_enter_to_begin) {
		subimg = 0	
	}
	draw_sprite(spr_tittle_enter_to_begin,subimg,1280/2,600)
}else{
	if subimg > sprite_get_number(spr_tittle_enter_to_pressed) {
		subimg = 0	
	}
	draw_sprite(spr_tittle_enter_to_pressed,subimg,1280/2,600)	
}

//if crochet >= 80{
//	
//	room_goto(Main)
//}