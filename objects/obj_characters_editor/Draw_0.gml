/// @description 

//////////////////////////////////////////////////
//---------------------警告---------------------//
//-----------------这不是最优的-----------------//
//////////////////////////////////////////////////


if !draw_inf.movechar and !draw_inf.canmovefileing {
    mouse_move_x = 0
    mouse_move_y = 0
}

// 处理鼠标释放事件 - 移动字符
if mouse_check_button_released(1) {
    if draw_inf.movechar and !draw_inf.canmovefileing {
        all_move_x = mouse_move_x + all_move_x
        all_move_y = mouse_move_y + all_move_y
        mouse_move_x = 0
        mouse_move_y = 0
    }
}

var draw_file_x = draw_inf.file_inf_x
var draw_file_y = draw_inf.file_inf_y

// 检查是否点击文件窗口标题栏
var hovering_title_bar = point_in_rectangle(
    mouse_x, mouse_y,
    draw_file_x + mouse_move_x,
    draw_file_y + mouse_move_y,
    draw_file_x + 1000 + mouse_move_x,
    draw_file_y + 25 + mouse_move_y
)

if (hovering_title_bar or draw_inf.canmovefileing) and mouse_check_button(1) {
    draw_inf.movechar = 0
}

// 绘制精灵
if file_exists(working_directory + string(text_box_path.text)) {

    if sprite_exists(atlas_sprite) and array_length(buff_png_json) > 0 {
		if string_replace_all(text_box_i_fps.text, " ", "") != "" {
			test_time += func_frc_main(real(string_replace_all(text_box_i_fps.text, " ", "")))
		}else{
			test_time += func_frc_main(24)
		}
		
		var a_test_time = 0
		if text_box_p_end.text != "" {
	        if string_replace_all(text_box_p_end.text, " ", "") != "" {
				a_test_time = real(string_replace_all(text_box_p_end.text, " ", ""))
				a_test_time = clamp(a_test_time,0,array_length(buff_png_json) - 1)
			}
			if string_replace_all(text_box_p_end.text, " ", "") == "" {
				a_test_time = array_length(buff_png_json) - 1	
			}
		}else{
			a_test_time = array_length(buff_png_json) - 1
		}
        
        if test_time >= array_length(buff_png_json) or test_time >= a_test_time{
            test_time = a_test_time
        }
        
        var _test_time = floor(test_time)
        
        // 计算移动偏移量
        var need_move_x = all_move_x + mouse_move_x
        var need_move_y = all_move_y + mouse_move_y
        
        
        if draw_inf.movechar == 0 {
            need_move_x = all_move_x
            need_move_y = all_move_y
        }
		
        var filpx = 1
		if buff_char_json.character.properties.flipX = 1 {
			filpx = -1	
			need_move_x += buff_png_json[_test_time].frameWidth*characters_scale + buff_png_json[_test_time].frameX*characters_scale*2
		}
		
		// 检查是否存在帧偏移属性
		var has_frame_offset = (variable_struct_exists(buff_png_json[_test_time], "frameX")) 
                and (variable_struct_exists(buff_png_json[_test_time], "frameY"))
				
				
		// 绘制位置计算
        var base_x = 530 + need_move_x
        var base_y = 100 + need_move_y
        
        // 应用帧偏移
        var draw_x = base_x - buff_png_json[_test_time].frameX * characters_scale
        var draw_y = base_y - buff_png_json[_test_time].frameY * characters_scale
		
        // 检查数组索引是否有效
        if _test_time >= 0 and _test_time < array_length(buff_png_json) {
            var rotated = 0
			// 检查是否存在帧偏移属性
            if has_frame_offset {
                if variable_struct_exists(buff_png_json[_test_time], "rotated") {
                    rotated = 90
                }
                draw_sprite_general(
                    atlas_sprite,                          // sprite
                    0,                                     // subimg
                    buff_png_json[_test_time].x,           // left
                    buff_png_json[_test_time].y,           // top
                    buff_png_json[_test_time].width,       // width
                    buff_png_json[_test_time].height,      // height
                    draw_x, // x
                    draw_y, // y
                    characters_scale * filpx,                      // xscale
                    characters_scale,                      // yscale
                    rotated,                               // rotation
                    c_white,                               // c1
                    c_white,                               // c2
                    c_white,                               // c3
                    c_white,                               // c4
                    1                                      // alpha
                );
            } else {
                draw_sprite_part_ext(
                    atlas_sprite,
                    0,
                    buff_png_json[_test_time].x, 
                    buff_png_json[_test_time].y,
                    buff_png_json[_test_time].width, 
                    buff_png_json[_test_time].height,
                    530 + need_move_x,
                    100 + need_move_y,
                    characters_scale * filpx, 
                    characters_scale,
                    c_white,
                    1
                );
            }
        }
    }
}

// 处理鼠标释放事件 - 移动文件窗口
if mouse_check_button_released(1) {
    if draw_inf.canmovefileing {
        draw_inf.file_inf_x = draw_inf.l_file_inf_x + mouse_move_x
        draw_inf.file_inf_y = draw_inf.l_file_inf_y + mouse_move_y
        draw_inf.movechar = 1
        draw_inf.canmovefileing = 0    
        mouse_move_x = 0
        mouse_move_y = 0
    }
}

// 绘制UI元素
draw_set_color(c_orange)
draw_set_alpha(0.6)
draw_roundrect(draw_file_x, draw_file_y, draw_file_x + 1000, draw_file_y + 500, 0)
draw_set_alpha(1)
draw_set_color(c_white)
draw_roundrect(draw_file_x, draw_file_y, draw_file_x + 1000, draw_file_y + 25, 0)

// 设置文本框位置
text_box_path.x = draw_file_x + 5
text_box_path.y = draw_file_y + 50
text_box_path_png.x = draw_file_x + 5
text_box_path_png.y = draw_file_y + 120
text_box_path_name.x = draw_file_x + 5
text_box_path_name.y = draw_file_y + 180
text_box_p_start.x = draw_file_x + 5
text_box_p_start.y = draw_file_y + 240
text_box_p_end.x = draw_file_x + 5
text_box_p_end.y = draw_file_y + 300
text_box_i_name.x = draw_file_x + 110
text_box_i_name.y = draw_file_y + 240//355
text_box_i_fps.x = draw_file_x + 110
text_box_i_fps.y = draw_file_y + 300

text_box_i_x.x = draw_file_x + 370
text_box_i_x.y = draw_file_y + 240
text_box_i_y.x = draw_file_x + 475
text_box_i_y.y = draw_file_y + 240
// 处理文件窗口拖动
if (hovering_title_bar or draw_inf.canmovefileing) and mouse_check_button(1) {
    draw_inf.file_inf_x = draw_inf.l_file_inf_x + mouse_move_x
    draw_inf.file_inf_y = draw_inf.l_file_inf_y + mouse_move_y
    draw_inf.movechar = 0
    draw_inf.canmovefileing = 1
} else {
    draw_inf.l_file_inf_x = draw_inf.file_inf_x
    draw_inf.l_file_inf_y = draw_inf.file_inf_y
}

// 检查文件是否存在并显示状态
if file_exists(working_directory + string(text_box_path.text)) {    
    draw_Outline("OK", text_box_path.x, text_box_path.y + 40, 1, 1, c_black, c_lime, 0, Font_vcr)
} else {
    draw_Outline("ERROR", text_box_path.x, text_box_path.y + 40, 1, 1, c_black, c_red, 0, Font_vcr)
}

draw_Outline("Json path :", text_box_path.x, text_box_path.y - 12, 1, 1, c_black, c_white, 0, Font_vcr)
draw_Outline("Png path :", text_box_path_png.x, text_box_path_png.y - 12, 1, 1, c_black, c_white, 0, Font_vcr)
draw_Outline("Json name (Such as: playeridle):", text_box_path_name.x, text_box_path_name.y - 12, 1, 1, c_black, c_white, 0, Font_vcr)
draw_Outline("Start:", text_box_p_start.x, text_box_p_start.y - 12, 1, 1, c_black, c_white, 0, Font_vcr)
draw_Outline("End:", text_box_p_end.x, text_box_p_end.y - 12, 1, 1, c_black, c_white, 0, Font_vcr)
draw_Outline_s("name", text_box_i_name.x, text_box_i_name.y - 12, 0.9, 0.9, c_black, c_white, 0, Font_vcr)
draw_Outline_s("fps", text_box_i_fps.x, text_box_i_fps.y - 12, 0.9, 0.9, c_black, c_white, 0, Font_vcr)
draw_Outline_s("x", text_box_i_x.x, text_box_i_x.y - 12, 0.9, 0.9, c_black, c_white, 0, Font_vcr)
draw_Outline_s("y", text_box_i_y.x, text_box_i_y.y - 12, 0.9, 0.9, c_black, c_white, 0, Font_vcr)




draw_set_alpha(0.5)
draw_set_color(c_lime)
draw_roundrect(draw_file_x + 630, draw_file_y + 30, draw_file_x + 995, draw_file_y + 490, 0)
draw_set_alpha(0.7)

for (var i=0;i < array_length(buff_char_json.character.animations);i++) {
	var meet_draw = point_in_rectangle(
	    mouse_x, mouse_y,
	    draw_file_x + 635, 
		draw_file_y + 35 + i*30 + 5, 
		draw_file_x + 990, 
		draw_file_y + 65 + i*30
	)

	var need_draw_name = buff_char_json.character.animations[i].name
	
	if meet_draw{
		draw_set_alpha(1)
		if mouse_check_button_pressed(1){
			text_box_p_start.text = buff_char_json.character.animations[i].start_anim;
			text_box_p_end.text = buff_char_json.character.animations[i].end_anim;	
			text_box_path_name.text = buff_char_json.character.animations[i].anim;	
			text_box_i_name.text = buff_char_json.character.animations[i].name;	
			text_box_i_fps.text = buff_char_json.character.animations[i].fps;	
			text_box_i_x.text = buff_char_json.character.animations[i].x;	
			text_box_i_y.text = buff_char_json.character.animations[i].y;	
			
			choose_char_json = i
			last_png_name = ""
			test_time = real(text_box_p_start.text)
		}
	}else{
		draw_set_alpha(0.7)
	}
	if choose_char_json = i {
		draw_set_alpha(1)
	}
	draw_set_color(c_orange)
	draw_roundrect(draw_file_x + 635, draw_file_y + 35 + i*30 + 5, draw_file_x + 990, draw_file_y + 65 + i*30, 0)	
	draw_Outline_s(need_draw_name, draw_file_x + 638, draw_file_y + 50 + i*30, 0.9, 0.9, c_black, c_white, 0, Font_vcr)
}
draw_set_alpha(1)
//draw_Outline_s("List", draw_file_x + 635, draw_file_y + 34, 0.8, 0.8, c_black, c_white, 0, Font_vcr)
if draw_button_ext(draw_file_x + 15, draw_file_y + 390,75,30,"SAVE") and choose_char_json >= 0 and choose_char_json < array_length(buff_char_json.character.animations){
	if text_box_p_start.text != "" and text_box_p_end.text != "" {
		buff_char_json.character.animations[choose_char_json].anim = string(text_box_path_name.text);
		buff_char_json.character.animations[choose_char_json].start_anim = string(text_box_p_start.text)
		buff_char_json.character.animations[choose_char_json].end_anim = string(text_box_p_end.text)
		buff_char_json.character.animations[choose_char_json].name = string(text_box_i_name.text)
		buff_char_json.character.animations[choose_char_json].fps = text_box_i_fps.text; 
		buff_char_json.character.animations[choose_char_json].x = text_box_i_x.text;	
		buff_char_json.character.animations[choose_char_json].y = text_box_i_y.text;
		buff_char_json.character.properties.json_path = text_box_path.text
		buff_char_json.character.properties.png_path = text_box_path_png.text
	}
}

if draw_button_ext(draw_file_x + 620, draw_file_y + 380,25,25,"+") {
	array_push(buff_char_json.character.animations, exmp_json);
	exmp_json = 
	{
		"name": "",
		"anim": "",
		"start_anim":0,
		"end_anim": 0,
		"x": 0,
		"y": 0,
		"fps": 24,
		"loop": false
	};
	//...//
}
if draw_button_ext(draw_file_x + 620, draw_file_y + 410,25,25,"-") or keyboard_check_pressed(vk_delete){
	
	if array_length(buff_char_json.character.animations) >= 0 {
		array_delete(buff_char_json.character.animations,choose_char_json,1)
		if choose_char_json > 0 {
			choose_char_json --
		}
		if choose_char_json <= 0 and array_length(buff_char_json.character.animations) <= 0{
			array_push(buff_char_json.character.animations, exmp_json);
			exmp_json = 
			{
				"name": "",
				"anim": "",
				"start_anim":0,
				"end_anim": 0,
				"x": 0,
				"y": 0,
				"fps": 24,
				"loop": false
			};
		}
	}
}

//if draw_button_ext(draw_file_x + 15, draw_file_y + 420,100,30,"SAVE File") and choose_char_json >= 0 and choose_char_json < array_length(buff_char_json.character.animations){
//	if array_length(buff_char_json) >= 0{
//		var updated_json_string = json_stringify(buff_char_json, true);

//        var save_path = working_directory + "assets\\data\\characters\\" + windows_extract_filename(text_box_path.text);
                    
//        var file_handle = file_text_open_write(save_path);
                    
//        if (file_handle != -1) {
//            file_text_write_string(file_handle, updated_json_string);
//            file_text_close(file_handle);
                        
//            //show_debug_message("JSON 文件成功保存！");
//        } else {
//			show_message("ERROR：无法打开文件写入")
//        }
//	}
//}





//tired! I want to sleep qwq!
//Don,t study me , You can use surface!!! It is very easy and beautiful!
//Hello this is a... , I don't want to say...
//=) =)=)=)=)=)=)=)=)=)=)=)=)
//My English is no vert well!  <---- (?)


draw_box("loop:",draw_file_x + 600, draw_file_y + 300,24,24,buff_char_json.character.animations[choose_char_json].loop,make_color_rgb(200,90,10),c_orange,"i_loop")
draw_box("flipX:",draw_file_x + 315, draw_file_y + 365,24,24,buff_char_json.character.properties.flipX,make_color_rgb(200,90,10),c_orange,"p_flipX")
draw_box("isPlayer:",draw_file_x + 315, draw_file_y + 400,24,24,buff_char_json.character.properties.isPlayer,make_color_rgb(200,90,10),c_orange,"p_isPlayer")
draw_box("isGF:",draw_file_x + 315, draw_file_y + 435,24,24,buff_char_json.character.properties.isGF,make_color_rgb(200,90,10),c_orange,"p_isGF")














