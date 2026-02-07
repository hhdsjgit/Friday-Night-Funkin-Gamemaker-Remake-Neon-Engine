/// @description LOAD
var file_path = get_open_filename("json", "选择文件");

if file_path != "" and string_pos(".json",string(file_path)){
	var file_content = buffer_load(file_path)
	var json_string = buffer_read(file_content, buffer_string);
	buffer_delete(file_content);
	var json_data = json_parse(json_string);
	var json_ok = (variable_struct_exists(json_data, "character"))
	try {
		if json_ok {
			buff_char_json = json_data	
			text_box_path.text = buff_char_json.character.properties.json_path
			text_box_path_png.text = buff_char_json.character.properties.png_path
			last_png_name = ""
			path_ok = false
			buff_png_json = []
			
			
			
			var buff_load_path = load_path
			
			
			file_content = buffer_load(working_directory + buff_load_path + windows_extract_filename(buff_char_json.character.properties.json_path))
			json_string = buffer_read(file_content, buffer_string);
			buffer_delete(file_content);
			var buff_json = json_parse(json_string);
			
			buff_json.TextureAtlas.imagePath = buff_load_path + windows_extract_filename(buff_char_json.character.properties.json_path)
					
			buff_json.TextureAtlas.imagePath = buff_load_path + windows_extract_filename(buff_char_json.character.properties.png_path)
					
			var updated_json_string = json_stringify(buff_json, false);

	        var save_path = working_directory + buff_load_path + windows_extract_filename(buff_char_json.character.properties.json_path);
                    
	        var file_handle = file_text_open_write(save_path);
                    
	        if (file_handle != -1) {
	            file_text_write_string(file_handle, updated_json_string);
	            file_text_close(file_handle);
                        
	            //show_debug_message("JSON 文件成功保存！");
	        } else {
				show_message("ERROR：无法打开文件写入")
	        }
		}
	}
	catch(e){
		show_message("Error can open :" + string(file_path))	
	}
}
exit