buff_pe_json= 
{
	"animations": [
		
	],
	"vocals_file": "",//对话框音色
	"no_antialiasing": false,
	"image": "characters/",//图像
	"position": [0, 350],//偏移
	"healthicon": "",//血条外
	"flip_x": true,//反转
	"healthbar_colors": [255,255,255],
	"camera_position": [0,0],
	"sing_duration": 4,
	"scale": 1,
	"_editor_isPlayer": true//玩家吗?
}
var updated_json_string = -1
var save_path = -1
var file_handle = -1
buff_char_json.character.properties.json_path = text_box_path.text
buff_char_json.character.properties.png_path = text_box_path_png.text   
var png_path = windows_extract_filename(text_box_path_png.text)
var name_length = string_length(png_path);
var base_name = string_copy(png_path, 1, name_length - 4);
var buff_json_pe = buff_pe_json
var anim_buff = 
{
	"offsets": [68, 122],
	"indices": [],
	"fps": 24,
	"anim": "",//动作命名(？反过来)
	"loop": false,
	"name": ""//xml名字
}

if string_replace_all(text_box_path_png.text, " ", "") == "" {
	return false;	
}
for (var i = 0;i < array_length(buff_char_json.character.animations);i ++) {
	anim_buff = 
	{
		"offsets": [68, 122],
		"indices": [],
		"fps": 24,
		"anim": "",//动作命名(？反过来)
		"loop": false,
		"name": ""//xml名字
	}
	anim_buff.offsets[0] = real(buff_char_json.character.animations[i].x)
	anim_buff.offsets[1] = real(buff_char_json.character.animations[i].y)
	anim_buff.fps = real(buff_char_json.character.animations[i].fps)
	anim_buff.loop = buff_char_json.character.animations[i].loop
	anim_buff.anim = buff_char_json.character.animations[i].name
	anim_buff.name = string_lower(string(buff_char_json.character.animations[i].anim))
	var start_frame = round(buff_char_json.character.animations[i].start_anim);
    var end_frame = round(buff_char_json.character.animations[i].end_anim);
    
    for (var frame = start_frame; frame <= end_frame; frame++) {
        array_push(anim_buff.indices, frame);
    }
	array_push(buff_pe_json.animations,anim_buff)
}
buff_json_pe.flip_x = buff_char_json.character.properties.flipX
buff_json_pe.image = "characters" + "\\" + base_name
show_debug_message(buff_json_pe.image)
buff_json_pe._editor_isPlayer = buff_char_json.character.properties.isPlayer

if array_length(buff_char_json) >= 0 and choose_char_json >= 0 and choose_char_json < array_length(buff_char_json.character.animations){
	updated_json_string = json_stringify(buff_json_pe, true);
	save_path = get_save_filename("请选择保存位置","char-pe.json")
    file_handle = file_text_open_write(save_path);
	
	if (file_handle != -1){
	    file_text_write_string(file_handle, updated_json_string);
	    file_text_close(file_handle);
                        
	    show_message(save_path)
	}
}

