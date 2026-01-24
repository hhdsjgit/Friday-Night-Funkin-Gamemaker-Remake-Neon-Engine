
//image_speed = func_frc(1)
if Action != 4{
	switch Action {
		case 0:sprite_index = Bf_car_left;break;
		case 1:sprite_index = Bf_car_down;break;
		case 2:sprite_index = Bf_car_up;break;
		case 3:sprite_index = Bf_car_right;break;
		case 4:sprite_index = Bf_car;break;
	}
}

if time <= 0 {
	Action = 4
	sprite_index = Bf_car	
}


if image_index >= sprite_get_number(Bf_car) and can_act = 0 and Action = 4{
	image_index = sprite_get_number(Bf_car)
}
if can_act = 1 and Action = 4{
	image_index = 0
	can_act = 0
}

if image_index >= sprite_get_number(sprite_index) - 1 and time > 0{

	image_index = image_number
	//image_index = sprite_get_number(sprite_index)
}

if time > 0 {
	time -= func_frc(1)
}

