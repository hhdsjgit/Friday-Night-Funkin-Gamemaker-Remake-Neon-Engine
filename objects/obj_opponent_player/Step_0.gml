/// @description
/// @description

//image_speed = func_frc(1)
if can_play_act_else = 1 {
	sprite_index = Act_else
	image_index = play_act_fps
	if image_index >= sprite_get_number(Act_else){
		can_play_act_else = 0
	}	
	play_act_fps += 1
}else{
	if Action != 4{
		switch Action {
			case 0:sprite_index = Action_skin_left;break;
			case 1:sprite_index = Action_skin_down;break;
			case 2:sprite_index = Action_skin_up;break;
			case 3:sprite_index = Action_skin_right;break;
			case 4:sprite_index = Action_skin_idle;break;
		}			
		if image_index > sprite_get_number(sprite_index){
			image_index = sprite_get_number(sprite_index)
		}	
	}		
	
	if time <= 0 {
		Action = 4		
		sprite_index = Action_skin_idle;					
		
	}

	if image_index >= sprite_get_number(Action_skin_idle) and can_act = 0 and Action = 4{
		image_index = sprite_get_number(Action_skin_idle)
	}				

	if can_act = 1 and Action = 4{
		image_index = 0
		can_act = 0
	}

	if image_index >= sprite_get_number(sprite_index) - 0.5 and time > 0{
		image_index = image_number
		//image_index = sprite_get_number(sprite_index)
	}
	if time > 0 {
		time -= func_frc(1)
	}
}



