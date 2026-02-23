/// @description 
function get_note_y (_note_arrow,_Note_mustHitSection){
	
	var _LEFTARROW_Y = obj_main.obj_left_arrow.y
	var _DOWNARROW_Y =obj_main.obj_down_arrow.y
	var _UPARROW_Y =obj_main.obj_up_arrow.y
	var _RIGHTARROW_Y =obj_main.obj_right_arrow.y
	
	var _OLEFTARROW_Y = obj_main.obj_opponent_left_arrow.y
	var _ODOWNARROW_Y =obj_main.obj_opponent_down_arrow.y
	var _OUPARROW_Y =obj_main.obj_opponent_up_arrow.y
	var _ORIGHTARROW_Y =obj_main.obj_opponent_right_arrow.y
	if _Note_mustHitSection {
		switch _note_arrow {
		    case 0: return _LEFTARROW_Y;
			case 1: return _DOWNARROW_Y;
			case 2: return _UPARROW_Y;
			case 3: return _RIGHTARROW_Y;
		}	
	}else{
		switch _note_arrow {
		    case 0: return _OLEFTARROW_Y;
			case 1: return _ODOWNARROW_Y;
			case 2: return _OUPARROW_Y;
			case 3: return _ORIGHTARROW_Y;
		}	
	}
	return 100;
	//get_note_y(note_arrow,Note_mustHitSection)
}
time_deviation = 0
target_time = 0
spawn_time = 0
note_arrow = 0
Note_length = 0
Check_note_length = 0
Click_arrow_length = 0
check_note = 0
image_xscale = 0.7
image_yscale = 0.7
Note_mustHitSection=0
last_time = 0
miss_note = 0;
depth = -13
move_y = 0
worry_note = "NOONE"
//分箭头皮肤//
/*Note:p为玩家控制,o为对手控制*/
global.sprite_index_note = 
{
	p_note_arrow_left:purple0000,
	p_note_arrow_down:blue0000,
	p_note_arrow_up:green0000,
	p_note_arrow_right:red0000,
	p_note_arrow_left_hold_piece:purple_hold_piece0000,
	p_note_arrow_down_hold_piece:blue_hold_piece0000,
	p_note_arrow_up_hold_piece:green_hold_piece0000,
	p_note_arrow_right_hold_piece:red_hold_piece0000,
	
	o_note_arrow_left:purple0000,
	o_note_arrow_down:blue0000,
	o_note_arrow_up:green0000,
	o_note_arrow_right:red0000,
	o_note_arrow_left_hold_piece:purple_hold_piece0000,
	o_note_arrow_down_hold_piece:blue_hold_piece0000,
	o_note_arrow_up_hold_piece:green_hold_piece0000,
	o_note_arrow_right_hold_piece:red_hold_piece0000,
}
//global.sprite_index_note = 
//{
//	p_note_arrow_left:Notes_Nightflaid_purple,
//	p_note_arrow_down:Notes_Nightflaid_blue,
//	p_note_arrow_up:Notes_Nightflaid_green,
//	p_note_arrow_right:Notes_Nightflaid_red,
//	p_note_arrow_left_hold_piece:Notes_Nightflaid_purple_hold_piece,
//	p_note_arrow_down_hold_piece:Notes_Nightflaid_blue_hold_piece,
//	p_note_arrow_up_hold_piece:Notes_Nightflaid_green_hold_piece,
//	p_note_arrow_right_hold_piece:Notes_Nightflaid_red_hold_piece,
	
//	o_note_arrow_left:Notes_Nightflaid_Assets_purple_1,
//	o_note_arrow_down:Notes_Nightflaid_Assets_blue_1,
//	o_note_arrow_up:Notes_Nightflaid_Assets_green_1,
//	o_note_arrow_right:Notes_Nightflaid_Assets_red_1,
//	o_note_arrow_left_hold_piece:Notes_Nightflaid_Assets_purple_hold_piece_1,
//	o_note_arrow_down_hold_piece:Notes_Nightflaid_Assets_blue_hold_piece_1,
//	o_note_arrow_up_hold_piece:Notes_Nightflaid_Assets_green_hold_piece_1,
//	o_note_arrow_right_hold_piece:Notes_Nightflaid_Assets_red_hold_piece_1,
//}
cr_obj_note = y
now_y = 0

_NOTENOWY = 0
my_target_y = _NOTENOWY
can_hit = true;