/// @description
var main_copy_path = working_directory + "assets\\imagles\\characters\\";
draw_set_color(c_blue)
draw_rectangle(0,0,1280,20,0)
if point_in_rectangle(mouse_x, mouse_y, 0, 0, 0 + 50, 0 + 20) {
	draw_set_color(c_gray)
	draw_rectangle(0,0,50,20,0)
	draw_Outline("File",3,8,0.7,0.7,c_black,c_white,0,Font_vcr)
	//if mouse_check_button_pressed(1) {
	//	if show_lan == 1 {
	//		show_lan = 0
	//	}else{
			show_lan = 1
	//	}
	//}
}else{
	draw_set_color(c_white)
	draw_rectangle(0,0,50,20,0)
	draw_Outline("File",3,8,0.7,0.7,c_black,c_white,0,Font_vcr)
}
if show_lan = 1 {
	draw_set_color(c_white)
	draw_rectangle(0,20,200,200,0)
	if point_in_rectangle(mouse_x, mouse_y, 1, 21, 200, 21 + 20) {
		if mouse_check_button_pressed(1) {
			var file_path = get_open_filename("json", "选择文件");

			if (file_path != "") {
			    show_debug_message("完整文件路径: " + file_path);
				show_debug_message("文件: " + windows_extract_filename(file_path));
				file_copy(file_path, main_copy_path + windows_extract_filename(file_path))
				var file_path_png = get_open_filename("png", "选择文件");

				if (file_path_png != "") {
				    show_debug_message("完整文件路径: " + file_path_png);
					show_debug_message("文件: " + windows_extract_filename(file_path_png));
					file_copy(file_path_png, main_copy_path + windows_extract_filename(file_path_png))
					path_ok = false
					text_box_path.text = "assets\\imagles\\characters\\" + windows_extract_filename(file_path)
				}
			}
		}
		draw_set_color(c_gray)
	}else{
		draw_set_color(c_yellow)
	}
	draw_rectangle(1,21,200,41,0)
	draw_set_color(c_white)
	draw_Outline("Load out json",3,29,0.9,0.9,c_black,c_white,0,Font_vcr)
	if not point_in_rectangle(mouse_x, mouse_y, 0, 0, 200, 200) {
		show_lan = 0
	}
}