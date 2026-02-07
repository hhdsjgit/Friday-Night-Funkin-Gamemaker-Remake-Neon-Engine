/// @description
buff_char_json.character.properties.json_path = text_box_path.text
buff_char_json.character.properties.png_path = text_box_path_png.text   
if array_length(buff_char_json) >= 0 and choose_char_json >= 0 and choose_char_json < array_length(buff_char_json.character.animations){
	var updated_json_string = json_stringify(buff_char_json, true);
	
    var save_path = working_directory + "assets\\data\\characters\\" + windows_extract_filename(text_box_path.text);
                    
    var file_handle = file_text_open_write(save_path);
                 
    if (file_handle != -1) {
        file_text_write_string(file_handle, updated_json_string);
        file_text_close(file_handle);
                        
       show_message("Save ok\n" + save_path)
    } else {
		show_message("ERROR：无法打开文件写入")
    }
}