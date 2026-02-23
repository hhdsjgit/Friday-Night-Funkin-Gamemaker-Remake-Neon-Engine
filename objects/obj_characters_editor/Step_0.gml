/// @description

if keyboard_check(vk_f3) {
	debug_test -= 1
}
if keyboard_check(vk_f4) {
	debug_test += 1	
}




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
//if text_box_path_name.text != "" {
//	//show_debug_message(text_box_path_name.text)
//	for (var i = 0;i < array_length(json_data.TextureAtlas.SubTextures);i++) {
//		//show_debug_message(string_delete(json_data.TextureAtlas.SubTextures[i].name,string_length(json_data.TextureAtlas.SubTextures[i].name)-3,4))
//		if string(text_box_path_name.text)=string(string_delete(json_data.TextureAtlas.SubTextures[i].name,string_length(json_data.TextureAtlas.SubTextures[i].name)-4,4)) {
//			show_debug_message(json_data.TextureAtlas.SubTextures[i].name)	
//			show_debug_message("AA")
//		}
//	}
//}
if text_box_path_name.text != "" and string_length(last_png_name) != string_length(text_box_path_name.text) and last_png_name != text_box_path_name.text and file_exists(working_directory + string(text_box_path.text)) and string_pos(".json",string(text_box_path.text)){
	buff_png_json = []
    for (var i = 0; i < array_length(json_data.TextureAtlas.SubTextures); i++) {
        var full_name = json_data.TextureAtlas.SubTextures[i].name;
        var name_length = string_length(full_name);

        if (name_length >= 4) {
            var base_name = string_copy(full_name, 1, name_length - 4);
            
            if (string(text_box_path_name.text) == base_name) {
				last_png_name = base_name
				array_push(buff_png_json, json_data.TextureAtlas.SubTextures[i]);
            }
        }
    }
	
	//show_debug_message(buff_png_json)
}

if mouse_check_button_pressed(1) {
	mouse_check_x = mouse_x
	mouse_check_y = mouse_y

}


if mouse_check_button(1) {
	mouse_move_x = mouse_x - mouse_check_x 
	mouse_move_y = mouse_y - mouse_check_y
}
var speed_scale = 0.5
if keyboard_check(vk_control) {
	speed_scale = 0.1		
}
if mouse_wheel_down() {
	
	characters_scale -= speed_scale
}
if mouse_wheel_up() {
	characters_scale += speed_scale
}
if keyboard_check_pressed(vk_f2) {
	mouse_check_x = 0
	mouse_check_y = 0
	mouse_move_x = 0
	mouse_move_y = 0

	all_move_x = 0
	all_move_y = 0
	test_time = 0
	characters_scale = 1	
	last_png_name = ""
}

//characters_scale = clamp(characters_scale,0.5,20)

if keyboard_check_pressed(vk_space) {
	if string_replace_all(text_box_p_start.text, " ", "") != "" and string_replace_all(text_box_p_end.text, " ", "") != ""{
		text_box_p_start.text = string(clamp(real(text_box_p_start.text),0,real(text_box_p_end.text)))
		test_time = real(text_box_p_start.text)
		
	}else{
		test_time = 0
	}
}	

draw_inf.file_inf_x = clamp(draw_inf.file_inf_x,-700,1260)
draw_inf.file_inf_y = clamp(draw_inf.file_inf_y,0,700)
var speed_move = 10
if keyboard_check(vk_control) {
	speed_move = 1	
}

if keyboard_check_pressed(vk_left) {
	text_box_i_x.text = real(text_box_i_x.text) - speed_move	
}
if keyboard_check_pressed(vk_right) {
	text_box_i_x.text = real(text_box_i_x.text) + speed_move	
}
if keyboard_check_pressed(vk_up) {
	text_box_i_y.text = real(text_box_i_y.text) - speed_move	
}
if keyboard_check_pressed(vk_down) {
	text_box_i_y.text = real(text_box_i_y.text) + speed_move	
}
if string_replace_all(text_box_i_x.text, " ", "") == "" {
	text_box_i_x.text = "0"	
}
if string_replace_all(text_box_i_y.text, " ", "") == "" {
	text_box_i_y.text = "0"	
}