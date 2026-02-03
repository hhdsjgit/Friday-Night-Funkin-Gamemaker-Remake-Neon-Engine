/// @description
global.debug_settig.debug_y = 700
if file_exists(working_directory + string(text_box_path.text)) and path_ok = false{
	if string_pos(".json",string(text_box_path.text)) {
		var file_content = buffer_load(working_directory + string(text_box_path.text))
		test_time = 0
		var json_string = buffer_read(file_content, buffer_string);
		buffer_delete(file_content);
		json_data = json_parse(json_string);
		atlas_sprite = sprite_add(working_directory + json_data.TextureAtlas.imagePath, 1, false, false, 0, 0);
		path_ok = true
	}
}else if (sprite_exists(atlas_sprite)) and !file_exists(working_directory + string(text_box_path.text)){
	try {
		path_ok = false
		sprite_delete(atlas_sprite);
		atlas_sprite = -1; // 设为无效值
	}
}