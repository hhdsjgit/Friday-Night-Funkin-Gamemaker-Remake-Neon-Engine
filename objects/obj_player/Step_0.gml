draw_x = x
draw_y = y 
_test_time += func_frc_main(24)
time -= func_frc_main(24)
if time <= 0 {
	Action = 4	
}
//if keyboard_check_pressed(vk_left) {
//	_test_time = 0
//	Action = 0
//}
//if keyboard_check_pressed(vk_down) {
//	_test_time = 0
//	Action = 1
//}
//if keyboard_check_pressed(vk_up) {
//	_test_time = 0
//	Action = 2
//}
//if keyboard_check_pressed(vk_right) {
//	_test_time = 0 
//	Action = 3
//}