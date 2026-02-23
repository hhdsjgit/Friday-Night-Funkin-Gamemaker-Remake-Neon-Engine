/// @description


/* ############################################################################## */
/* #############################   DRAW  STEP   ################################# */
/* ############################################################################## */

var main_copy_path = working_directory + "assets\\images\\characters\\";
draw_set_color(make_color_rgb(144,202,249))
draw_rectangle(0,0,1280,20,0)
if point_in_rectangle(mouse_x, mouse_y, 0, 0, 0 + 50, 0 + 20) {

	draw_set_color(make_color_rgb(57,73,251))
	draw_rectangle(0,0,50,20,0)
	draw_Outline_s("File",3,8,0.7,0.7,c_black,c_white,0,Font_vcr)
	//if mouse_check_button_pressed(1) {
	//	if show_lan == 1 {
	//		show_lan = 0
	//	}else{
			show_lan = 1
	//	}
	//}
}else{
	draw_set_color(make_color_rgb(0,255,255))	
	draw_rectangle(0,0,50,20,0)
	draw_Outline_s("File",3,8,0.7,0.7,c_black,c_white,0,Font_vcr)
}
var draw_color = c_yellow
if show_lan = 1 {
	draw_set_color(c_white)
	draw_rectangle(0,20,200,200,0)
	
	for (var n = 0;n < array_length(draw_lanzi_up.File);n++) {
		var _n = n * 20
		if point_in_rectangle(mouse_x, mouse_y, 1, 21 + _n+1, 199, 21 + _n + 20) {
			
			if mouse_check_button_pressed(1) {		
				switch draw_lanzi_up.File[n] {
					case "Load out json": event_user(0);break;
					case "Save": event_user(1);break;
					case "Save as": event_user(2);break;
					case "Load NE": event_user(3);break;
					case "Save as pe": event_user(4);break;
				}
			}
			draw_set_color(make_color_rgb(0,139,139))
		}else{
			draw_set_color(make_color_rgb(0,255,255))
		}
		
		draw_rectangle(1, 21 + _n + 1, 199, 21 + _n + 20,0)		
		draw_Outline_s(draw_lanzi_up.File[n],3,21 + _n + 10,0.9,0.9,c_black,c_white,0,Font_vcr)
	}
	
	if not point_in_rectangle(mouse_x, mouse_y, 0, 0, 200, 200) {
		show_lan = 0
	}
}
draw_set_color(c_white)