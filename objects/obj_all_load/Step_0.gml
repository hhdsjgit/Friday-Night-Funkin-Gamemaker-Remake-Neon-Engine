/// @description
global.fps_time = delta_time / 1000000
anit_time += 0.3
if anit_time >= 3 {
	anit_time = 0	
}

if can_show_gradient = false{
	if can = 0 {
		y_show_gradient += func_frc(35)	
	}
	
	if y_show_gradient >= -45 {
		can = 1
		y_show_gradient = -45
		//suc_gradient = true
	}
}else{
	y_show_gradient -= func_frc(35)	
	if y_show_gradient <= -1440 {
		
		suc_gradient = true
	}
}