/// @description

//if Note_mustHitSection = 1 {
//	skin_left = Notes_Nightflaid_Arrow_Left
//	skin_down = Notes_Nightflaid_Arrow_Down
//	skin_up = Notes_Nightflaid_Arrow_Up
//	skin_right = Notes_Nightflaid_Arrow_Right

//	skin_left_pass = Notes_Nightflaid_left_press
//	skin_down_pass = Notes_Nightflaid_down_press
//	skin_up_pass = Notes_Nightflaid_up_press
//	skin_right_pass = Notes_Nightflaid_right_press

//	skin_left_pass_ok = Notes_Nightflaid_left_confirm
//	skin_down_pass_ok = Notes_Nightflaid_down_confirm
//	skin_up_pass_ok = Notes_Nightflaid_up_confirm
//	skin_right_pass_ok = Notes_Nightflaid_right_confirm
//}else{
//	skin_left = Notes_Nightflaid_Assets_Arrow_Left
//	skin_down = Notes_Nightflaid_Assets_Arrow_Down
//	skin_up = Notes_Nightflaid_Assets_Arrow_Up
//	skin_right = Notes_Nightflaid_Assets_Arrow_Right

//	skin_left_pass = Notes_Nightflaid_Assets_left_confirm_1
//	skin_down_pass = Notes_Nightflaid_Assets_down_confirm_1
//	skin_up_pass = Notes_Nightflaid_Assets_up_confirm_1
//	skin_right_pass = Notes_Nightflaid_Assets_right_confirm_1

//	skin_left_pass_ok = Notes_Nightflaid_Assets_left_confirm_1
//	skin_down_pass_ok = Notes_Nightflaid_Assets_down_confirm_1
//	skin_up_pass_ok = Notes_Nightflaid_Assets_up_confirm_1
//	skin_right_pass_ok = Notes_Nightflaid_Assets_right_confirm_1	
//}










if Note_mustHitSection = 1{
	if Note_Direction = 0 and global.Game_inf.Note_player2_0=1{
		sprite_index=skin_left_pass_ok
		alarm_time = 4
	}
	if Note_Direction = 1 and global.Game_inf.Note_player2_1=1{
		sprite_index=skin_down_pass_ok
		alarm_time = 4
	}
	if Note_Direction = 2 and global.Game_inf.Note_player2_2=1{
		sprite_index=skin_up_pass_ok
		alarm_time = 4
	}
	if Note_Direction = 3 and global.Game_inf.Note_player2_3=1{
		sprite_index=skin_right_pass_ok
		alarm_time = 4
	}
	//show_debug_message(alarm_time)
	///?//////////////
	
	if Note_Direction = 0 and global.Game_inf.Note_player2_0=2{
		sprite_index=skin_left_pass
		alarm_time = 4
	}
	if Note_Direction = 1 and global.Game_inf.Note_player2_1=2{
		sprite_index=skin_down_pass
		alarm_time = 4
	}
	if Note_Direction = 2 and global.Game_inf.Note_player2_2=2{
		sprite_index=skin_up_pass
		alarm_time = 4
	}
	if Note_Direction = 3 and global.Game_inf.Note_player2_3=2{
		sprite_index=skin_right_pass
		alarm_time = 4
	}
	if alarm_time <= 0 {
		switch Note_Direction {
			case 0:
			sprite_index=skin_left;
			global.Game_inf.Note_player2_0=0;
			break;
			case 1:
			sprite_index=skin_down;
			global.Game_inf.Note_player2_1=0;
			break;
			case 2:
			sprite_index=skin_up;
			global.Game_inf.Note_player2_2=0;
			break;
			case 3:
			sprite_index=skin_right;
			global.Game_inf.Note_player2_3=0;
			break;
		}	
	}else{
		alarm_time -= func_frc(1)	
		if image_index >= 3 {
			image_index = 3	
		}
	}
}

////////////////////////////////////////////////////////
if Note_mustHitSection = 0 {
	if sprite_index=skin_left and global.Game_inf.Note_player1_0=1{
		sprite_index=skin_left_pass_ok
		alarm_time = 4
	}
	if sprite_index=skin_down and global.Game_inf.Note_player1_1=1{
		sprite_index=skin_down_pass_ok
		alarm_time = 4
	}
	if sprite_index=skin_up and global.Game_inf.Note_player1_2=1{
		sprite_index=skin_up_pass_ok
		alarm_time = 4
	}
	if sprite_index=skin_right and global.Game_inf.Note_player1_3=1{
		sprite_index=skin_right_pass_ok
		alarm_time = 4
	}
	if alarm_time <= 0 {
		switch Note_Direction {
			case 0:sprite_index=skin_left;
			global.Game_inf.Note_player1_0=0;
			break;
			case 1:sprite_index=skin_down;
			global.Game_inf.Note_player1_1=0;
			break;
			case 2:sprite_index=skin_up;
			global.Game_inf.Note_player1_2=0;
			break;
			case 3:sprite_index=skin_right;
			global.Game_inf.Note_player1_3=0;
			break;
		}	
	}else{
		alarm_time -= func_frc(1)		
		if image_index >= 3 {
			image_index = 3	
		}
	}
}
/*
if Note_mustHitSection = 1{
	switch Note_Direction {
		case 0:
		if global.Game_inf.Note_player1_0=2{sprite_index=left_press0000};break;
		case 1:
		if global.Game_inf.Note_player1_1=2{sprite_index=down_press0000};break;
		case 2:
		if global.Game_inf.Note_player1_2=2{sprite_index=up_press0000};break;
		case 3:
		if global.Game_inf.Note_player1_3=2{sprite_index=right_press0000};break;
	}
	switch Note_Direction {
		case 0:
		if global.Game_inf.Note_player1_0=1{sprite_index=left_confirm0000};break;
		case 1:
		if global.Game_inf.Note_player1_1=1{sprite_index=down_confirm0000};break;
		case 2:
		if global.Game_inf.Note_player1_2=1{sprite_index=up_confirm0000};break;
		case 3:
		if global.Game_inf.Note_player1_3=1{sprite_index=right_confirm0000};break;
	}
}*/

if image_index >= 3 and sprite_index=skin_left_pass or sprite_index=skin_down_pass or 
	sprite_index=skin_up_pass or sprite_index=skin_right_pass and Note_mustHitSection = 1
	{
	image_index = 3	
}
if image_index >= 3 and sprite_index=skin_left_pass_ok or sprite_index=skin_down_pass_ok or 
	sprite_index=skin_up_pass_ok or sprite_index=skin_right_pass_ok and Note_mustHitSection = 1
	{
	image_index = 3	
}

