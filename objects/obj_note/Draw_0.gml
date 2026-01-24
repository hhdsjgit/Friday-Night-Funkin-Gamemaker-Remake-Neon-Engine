/// @description
if !surface_exists(global.ui_surface) {
	global.ui_surface = surface_create(1280,720)
}

surface_set_target(global.ui_surface);
if Note_length > 0  {
	var _y =y
	if Note_mustHitSection = 1 {
		switch note_arrow {
			case 0:sprite_index=global.sprite_index_note.p_note_arrow_left_hold_piece;break;
			case 1:sprite_index=global.sprite_index_note.p_note_arrow_down_hold_piece;break;
			case 2:sprite_index=global.sprite_index_note.p_note_arrow_up_hold_piece;break;	
			case 3:sprite_index=global.sprite_index_note.p_note_arrow_right_hold_piece;break;
		}
	}else{
		switch note_arrow {
			case 0:sprite_index=global.sprite_index_note.o_note_arrow_left_hold_piece;break;
			case 1:sprite_index=global.sprite_index_note.o_note_arrow_down_hold_piece;break;
			case 2:sprite_index=global.sprite_index_note.o_note_arrow_up_hold_piece;break;	
			case 3:sprite_index=global.sprite_index_note.o_note_arrow_right_hold_piece;break;
		}	
	}
	var k = sprite_index
	if Check_note_length >= Note_length - 20 {
		Check_note_length = Note_length	
	}
	if Note_length >= 10 and Check_note_length <= Note_length - 20{
		for (var i = Check_note_length;i <= Note_length + 100;i += 25) {
			y = _y + i
			if i <= Note_length and (x >= 0 and x <= 1280 and y >= -100 and y <= 920){
				image_yscale = 2
				draw_self()
				//draw_sprite_ext(sprite_index,0,x,y,1,2,0,c_white,1)
				
				//draw_text(x+15,y-0,"LEG "+string(Note_length) + " / " + string(Check_note_length))
				
			}
		
		}
		image_yscale = 1
	}
	y = _y
}


image_yscale = 0.7
if worry_note = "NOONE" {
	if Note_mustHitSection = 1 {
		switch note_arrow {
			case 0:sprite_index=global.sprite_index_note.p_note_arrow_left;break;
			case 1:sprite_index=global.sprite_index_note.p_note_arrow_down;break;
			case 2:sprite_index=global.sprite_index_note.p_note_arrow_up;break;
			case 3:sprite_index=global.sprite_index_note.p_note_arrow_right;break;
		
		
		}
	}else{
		switch note_arrow {
			case 0:sprite_index=global.sprite_index_note.o_note_arrow_left;break;
			case 1:sprite_index=global.sprite_index_note.o_note_arrow_down;break;
			case 2:sprite_index=global.sprite_index_note.o_note_arrow_up;break;
			case 3:sprite_index=global.sprite_index_note.o_note_arrow_right;break;
		
		
		}
	}
}else{
	if Note_mustHitSection = 1 {
		switch note_arrow {
			case 0:sprite_index=global.sprite_index_note.o_note_arrow_left;break;
			case 1:sprite_index=global.sprite_index_note.o_note_arrow_down;break;
			case 2:sprite_index=global.sprite_index_note.o_note_arrow_up;break;
			case 3:sprite_index=global.sprite_index_note.o_note_arrow_right;break;
		}
	}else{
		switch note_arrow {
			case 0:sprite_index=global.sprite_index_note.o_note_arrow_left;break;
			case 1:sprite_index=global.sprite_index_note.o_note_arrow_down;break;
			case 2:sprite_index=global.sprite_index_note.o_note_arrow_up;break;
			case 3:sprite_index=global.sprite_index_note.o_note_arrow_right;break;
		
		
		}
	}	
}
if !check_note {
	draw_self()
}
//draw_text(x+15,y-0,"LEG "+string(Note_length) + " / " + string(Check_note_length))



surface_reset_target();










/*
if note_arrow == 0 {
	sprite_index=purple_hold_piece0000	
}
if note_arrow == 1 {
	sprite_index=blue_hold_piece0000	
}
if note_arrow == 2 {
	sprite_index=green_hold_piece0000	
}
if note_arrow == 3 {
	sprite_index=red_hold_piece0000
}
var draw_length = 0
var end_draw = 0
if Note_length >= 61 {
	for (var i = 0;i <= Note_length;i += 61) {
		y = _y + i
		if i > Note_length - 61 {
			end_draw = 1
			draw_length = Note_length - i
			//show_debug_message("AX")
			break;
		}else{
			draw_self()
		}		
	}
}else{
	draw_length = Note_length
	end_draw = 1
}
if end_draw = 1 {
	image_yscale=draw_length / 61
	draw_self()
}
if note_arrow == 0 {
	sprite_index=pruple_end_hold0000
}
if note_arrow == 1 {
	sprite_index=blue_hold_end0000	
}
if note_arrow == 2 {
	sprite_index=green_hold_end0000	
}
if note_arrow == 3 {
	sprite_index=red_hold_end0000
}
if Note_length >= 0 {
	y = _y + Note_length
	draw_self()
}
y = _y
*/