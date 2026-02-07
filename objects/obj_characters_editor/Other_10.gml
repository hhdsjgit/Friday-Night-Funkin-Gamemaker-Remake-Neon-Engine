/// @description
var buff_load_path = load_path
var main_copy_path = working_directory + "assets\\imagles\\characters\\";
var file_path = get_open_filename("json", "选择文件");

if (file_path != "") and string_pos(".json",string(file_path)){
	//show_debug_message("完整文件路径: " + file_path);
	//show_debug_message("文件: " + windows_extract_filename(file_path));
	file_copy(file_path, main_copy_path + windows_extract_filename(file_path))
	var file_path_png = get_open_filename("png", "选择文件");

	if (file_path_png != "") {
		//show_debug_message("完整文件路径: " + file_path_png);
		//show_debug_message("文件: " + windows_extract_filename(file_path_png));
		file_copy(file_path_png, main_copy_path + windows_extract_filename(file_path_png))
		
		
		var file_content = buffer_load(working_directory + buff_load_path + windows_extract_filename(file_path))
		var json_string = buffer_read(file_content, buffer_string);
		buffer_delete(file_content);
		var buff_json = json_parse(json_string);
		buff_json.TextureAtlas.imagePath = buff_load_path + windows_extract_filename(file_path_png)
					
		var updated_json_string = json_stringify(buff_json, false);

        var save_path = working_directory + buff_load_path + windows_extract_filename(file_path);
                    
        var file_handle = file_text_open_write(save_path);
                    
        if (file_handle != -1) {
            file_text_write_string(file_handle, updated_json_string);
            file_text_close(file_handle);
                        
            //show_debug_message("JSON 文件成功保存！");
        } else {
			show_message("ERROR：无法打开文件写入")
        }
					  				
		path_ok = false
		text_box_path.text = buff_load_path + windows_extract_filename(file_path)
		text_box_path_png.text = buff_load_path + windows_extract_filename(file_path_png)
		buff_png_json = []
	}
}
