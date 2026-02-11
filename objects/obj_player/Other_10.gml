/// @description 

//---各种临时变量的初始化---//
var need_read_characters = []
var need_read_json_path = -1
var need_read_png_path = -1
var file_content = -1
var json_string = -1
var can_read = false
var json_data = {}

//---读取json文件---//
file_content = buffer_load(working_directory + "assets\\data\\characters\\" +string(character_json_name) + ".json")
json_string = buffer_read(file_content, buffer_string);
buffer_delete(file_content);
characters_json_data = json_parse(json_string);

//---检查json文件是否正确---//
if (variable_struct_exists(characters_json_data, "character")) {
	if (variable_struct_exists(characters_json_data.character, "metadata")) {
		can_read = true
	}
}

//---预读取各类文件位置,方便调用---//
if can_read = true {
	need_read_characters = characters_json_data.character.animations;
	need_read_json_path = working_directory + characters_json_data.character.properties.json_path;
	need_read_png_path = working_directory + characters_json_data.character.properties.png_path;
}else{
	return;	
}

//---读取贴图到变量atlas_sprite中---//
if need_read_png_path != -1 and file_exists(need_read_png_path){
	atlas_sprite = sprite_add(need_read_png_path, 1, false, false, 0, 0);
}else{
	return;	
}

//---检查json文件是否存在---//
if !file_exists(need_read_json_path) {
	return;	
}

//---读取json文件---//
file_content = buffer_load(need_read_json_path)
json_string = buffer_read(file_content, buffer_string);
buffer_delete(file_content);
json_data = json_parse(json_string);

//---处理json文件---//
try {
	var choose_anim = -1
	for (var n = 0;n < array_length(need_read_characters);n++) {

		for (var i = 0; i < array_length(json_data.TextureAtlas.SubTextures); i++) {
		    var full_name = json_data.TextureAtlas.SubTextures[i].name;
		    var name_length = string_length(full_name);
			//放错误空值A0000
		    if (name_length >= 4) {
		        var base_name = string_copy(full_name, 1, name_length - 4);
				if base_name == need_read_characters[n].anim {
					if i >= need_read_characters[n].start_anim and i <= need_read_characters[n].end_anim {
						switch need_read_characters[n].name {
							case "idle":
								array_push(Action_skin_idle, json_data.TextureAtlas.SubTextures[i]);
							break;
							case "singLEFT":
								array_push(Action_skin_left, json_data.TextureAtlas.SubTextures[i]);
							break;
							case "singDOWN":
								array_push(Action_skin_down, json_data.TextureAtlas.SubTextures[i]);
							break;
							case "singUP":
								array_push(Action_skin_up,json_data.TextureAtlas.SubTextures[i]);
							break;
							case "singRIGHT":
								array_push(Action_skin_right,json_data.TextureAtlas.SubTextures[i]);
							break;
							
						
						}
					}				
				}
		    }
		}
	}
}catch(e) {
	show_message("***发生错误!***\n错误信息:\n" + string(e))	
	return;
}
load_json_0 = true