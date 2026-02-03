/// @description
text_box_path = instance_create_depth(10,50,0,obj_input_box)
text_box_path_png = instance_create_depth(10,140,0,obj_input_box)

atlas_sprite = -1
path_ok = false
test_time = 0
json_data = {}
var file_path = get_open_filename("json", "选择文件");

if (file_path != "") {
    show_debug_message("完整文件路径: " + file_path);
	show_debug_message("文件: " + windows_extract_filename(file_path));
}
show_lan = 0