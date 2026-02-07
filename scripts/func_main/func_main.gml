function func_main(a1,a2,a3,a4,b1,b2,b3,b4){
	obj_main.obj_left_arrow.x = a1
	obj_main.obj_down_arrow.x = a2
	obj_main.obj_up_arrow.x = a3
	obj_main.obj_right_arrow.x = a4
	obj_main.obj_opponent_left_arrow.x = b1
	obj_main.obj_opponent_down_arrow.x = b2
	obj_main.obj_opponent_up_arrow.x = b3
	obj_main.obj_opponent_right_arrow.x = b4
	
}
function Use_Gradient (value) {
	if value = 0 and obj_all_load.suc_gradient{
		obj_all_load.can_show_gradient = 0
		obj_all_load.y_show_gradient = -1280
		obj_all_load.suc_gradient = false
	}
	if value = 1 and obj_all_load.suc_gradient{
		obj_all_load.can_show_gradient = 1
		obj_all_load.y_show_gradient = 0
		obj_all_load.suc_gradient = false
	}
}
function Get_Gradient () {
	return obj_all_load.suc_gradient;
}
function load_image(Path) {

	var full_path = working_directory + string(Path)

	var sprite_id = sprite_add(full_path, 1, false, false, 0, 0);

	return sprite_id; 
	
}

function func_frc(val){
	//return val * (global.fps_time);
	return val * 60 * global.fps_time
}
function func_frc_main(val){
	return val * (global.fps_time);
	//return val * 60 * global.fps_time
}
/// @function func_play_sounds(sounds_dir,priority,loops)
/// @description 读取外部音频文件用=)
/// @param {string} sounds_dir 音频文件路径
function func_play_sounds(sounds_dir,priority,loops){

	var load_sounds = audio_create_stream(working_directory + string(sounds_dir))
	var back_sounds = audio_play_sound(load_sounds,priority,loops)
	return back_sounds;
}
/*
/// @function func_judge_performance_quality(_x,_offset,_note)
/// @description 判定sick good bad shit =<
/// @param {real} _y 按键时箭头的y坐标
/// @param {real} _offset 偏移量
/// @param {real} _note 箭头类型 0 1 2 3玩家 4 5 6 7对手
function func_judge_performance_quality(_y,_offset,_note,worry_note){
	if worry_note = false {
		global.Game_inf.max_score += 300
	}
	if (_y >= 20 + _offset -100 and _y <= 210 + _offset -100) {
		global.Game_inf.total_score += 300
		return 0;
	}
	if (_y >= 15 + _offset -100 and _y <= 230 + _offset -100) {
		global.Game_inf.total_score += 200
		return 1;
	}
	if (_y >= 10 + _offset -100 and _y <= 250 + _offset -100) {
		global.Game_inf.total_score += 100
		return 2;
	}
	if (_y >= 0 + _offset -100 and _y <= 260 + _offset -100) {
		global.Game_inf.total_score += 0
		return 3;
	}
}*/


function pause_game() {
    if (global.game_paused) return;
    
    global.game_paused = true;
    
    // 暂停音效
    audio_pause_sound(obj_main.song_sound1);
    audio_pause_sound(obj_main.song_sound2);
    audio_pause_sound(obj_main.song_sound3);
    
    // 暂停所有其他音效
    audio_pause_all();
       
}

/// 恢复游戏
function resume_game() {
    if (!global.game_paused) return;
    
    global.game_paused = false;
    
    // 恢复音效
    audio_resume_sound(obj_main.song_sound1);
    audio_resume_sound(obj_main.song_sound2);
    audio_resume_sound(obj_main.song_sound3);
    
    // 恢复所有其他音效
    audio_resume_all();
    
}

/// @function func_bet_char(_char)
/// @description 文本查询获取需要的字符动画
/// @param {string} _char 文本,仅支持英文加数字加> !!! 
function func_bet_char(_char){
	switch (_char) {
		// 数字 0-9
        case "0": return 1;
        case "1": return 5;
        case "2": return 9;
        case "3": return 13;
        case "4": return 17;
        case "5": return 21;
        case "6": return 25;
        case "7": return 29;
        case "8": return 33;
        case "9": return 37;        
        case ">": return 41;      
        // 字母 A-Z
        case "A": return 45;
        case "B": return 49;
        case "C": return 53;
        case "D": return 57;
        case "E": return 61;
        case "F": return 65;
        case "G": return 69;
        case "H": return 73;
        case "I": return 77;
        case "J": return 81;
        case "K": return 85;
        case "L": return 89;
        case "M": return 93;
        case "N": return 97;
        case "O": return 101;
        case "P": return 105;
        case "Q": return 109;
        case "R": return 113;
        case "S": return 117;
        case "T": return 121;
        case "U": return 125;
        case "V": return 129;
        case "W": return 133;
        case "X": return 137;
        case "Y": return 141;
        case "Z": return 145;
      
        default: return -1;	
	}
}

function draw_text_bet(text,_x,_y,_image_xscale,_image_yscale,angle,alpha) {	
	for (var i=1;i <= string_length(text);i ++) {
		var _chars = " "		
		_chars = string_upper(string_char_at(text, i));	
		if func_bet_char(_chars) != -1 {
			draw_sprite_ext(spr_alphabet,func_bet_char(_chars) + obj_all_load.anit_time,_x + (sprite_get_width(spr_alphabet) - 37)* i * image_xscale,_y ,_image_xscale,_image_yscale,angle,c_white,alpha)	
		}
	}
}

function vedio_play (_PATH) {
	if !instance_exists(obj_vedio) {
		instance_create_depth(0,0,-1000,obj_vedio)
	}
	var dir = working_directory + _PATH;
	obj_vedio._PATH = _PATH
	obj_vedio._CAN_PLAY_VEDIO = true
	with obj_vedio {
		event_user(0);
	}
}

function ui_arrow_move_buffer_my (ax,bx,cx,dx,ay,by,cy,dy,Target,buffer_speed,need_x,need_y) {	

	var B_F = buffer_speed
	if Target = 0 {
		if need_y {
			obj_main.obj_left_arrow.y += (ay - obj_main.obj_left_arrow.y) / B_F
			obj_main.obj_down_arrow.y += (by - obj_main.obj_down_arrow.y) / B_F
			obj_main.obj_up_arrow.y += (cy - obj_main.obj_up_arrow.y) / B_F
			obj_main.obj_right_arrow.y += (dy - obj_main.obj_right_arrow.y) / B_F
		}
		if need_x {
			obj_main.obj_left_arrow.x += (ax - obj_main.obj_left_arrow.x) / B_F
			obj_main.obj_down_arrow.x += (bx - obj_main.obj_down_arrow.x) / B_F
			obj_main.obj_up_arrow.x += (cx - obj_main.obj_up_arrow.x) / B_F
			obj_main.obj_right_arrow.x += (dx - obj_main.obj_right_arrow.x) / B_F
		}
	}else{
		if need_y {
			obj_main.obj_opponent_left_arrow.y += (ay - obj_main.obj_opponent_left_arrow.y) / B_F
			obj_main.obj_opponent_down_arrow.y += (by - obj_main.obj_opponent_down_arrow.y) / B_F
			obj_main.obj_opponent_up_arrow.y += (cy - obj_main.obj_opponent_up_arrow.y) / B_F
			obj_main.obj_opponent_right_arrow.y += (dy - obj_main.obj_opponent_right_arrow.y) / B_F
		}
		if need_x {
			obj_main.obj_opponent_left_arrow.x += (ax - obj_main.obj_opponent_left_arrow.x) / B_F
			obj_main.obj_opponent_down_arrow.x += (bx - obj_main.obj_opponent_down_arrow.x) / B_F
			obj_main.obj_opponent_up_arrow.x += (cx - obj_main.obj_opponent_up_arrow.x) / B_F
			obj_main.obj_opponent_right_arrow.x += (dx - obj_main.obj_opponent_right_arrow.x) / B_F
		}
	}
}
function ui_arrow_move_buffer (ax,bx,cx,dx,ay,by,cy,dy,Target,buffer_speed,start_time,end_time,need_x,need_y) {	
	
	if start_time < obj_main.song_time and end_time > obj_main.song_time{
		var B_F = buffer_speed
		if Target = 0 {
			if need_y {
				obj_main.obj_left_arrow.y += (ay - obj_main.obj_left_arrow.y) / B_F
				obj_main.obj_down_arrow.y += (by - obj_main.obj_down_arrow.y) / B_F
				obj_main.obj_up_arrow.y += (cy - obj_main.obj_up_arrow.y) / B_F
				obj_main.obj_right_arrow.y += (dy - obj_main.obj_right_arrow.y) / B_F
			}
			if need_x {
				obj_main.obj_left_arrow.x += (ax - obj_main.obj_left_arrow.x) / B_F
				obj_main.obj_down_arrow.x += (bx - obj_main.obj_down_arrow.x) / B_F
				obj_main.obj_up_arrow.x += (cx - obj_main.obj_up_arrow.x) / B_F
				obj_main.obj_right_arrow.x += (dx - obj_main.obj_right_arrow.x) / B_F
			}
		}else{
			if need_y {
				obj_main.obj_opponent_left_arrow.y += (ay - obj_main.obj_opponent_left_arrow.y) / B_F
				obj_main.obj_opponent_down_arrow.y += (by - obj_main.obj_opponent_down_arrow.y) / B_F
				obj_main.obj_opponent_up_arrow.y += (cy - obj_main.obj_opponent_up_arrow.y) / B_F
				obj_main.obj_opponent_right_arrow.y += (dy - obj_main.obj_opponent_right_arrow.y) / B_F
			}
			if need_x {
				obj_main.obj_opponent_left_arrow.x += (ax - obj_main.obj_opponent_left_arrow.x) / B_F
				obj_main.obj_opponent_down_arrow.x += (bx - obj_main.obj_opponent_down_arrow.x) / B_F
				obj_main.obj_opponent_up_arrow.x += (cx - obj_main.obj_opponent_up_arrow.x) / B_F
				obj_main.obj_opponent_right_arrow.x += (dx - obj_main.obj_opponent_right_arrow.x) / B_F
			}
		}
	}
}

function ui_arrow_set_color_my(Target, red, green, blue) {	
	// 设置箭头颜色（RGB格式）
	// 参数说明：
	// Target: 0 = 玩家箭头，1 = 对手箭头
	// red: 红色分量 (0-255)
	// green: 绿色分量 (0-255)
	// blue: 蓝色分量 (0-255)
	
	var color_value = make_color_rgb(red, green, blue)
	
	if Target = 0 {
		// 设置玩家箭头颜色
		obj_main.obj_left_arrow.image_blend = color_value
		obj_main.obj_down_arrow.image_blend = color_value
		obj_main.obj_up_arrow.image_blend = color_value
		obj_main.obj_right_arrow.image_blend = color_value
	} else {
		// 设置对手箭头颜色
		obj_main.obj_opponent_left_arrow.image_blend = color_value
		obj_main.obj_opponent_down_arrow.image_blend = color_value
		obj_main.obj_opponent_up_arrow.image_blend = color_value
		obj_main.obj_opponent_right_arrow.image_blend = color_value
	}
}

//单独设置颜色
function ui_arrow_set_individual_color(Target, arrow_type, red, green, blue) {
	// arrow_type: 0=左, 1=下, 2=上, 3=右
	var color_value = make_color_rgb(red, green, blue)
	
	if Target = 0 {
		switch arrow_type {
			case 0: obj_main.obj_left_arrow.image_blend = color_value; break
			case 1: obj_main.obj_down_arrow.image_blend = color_value; break
			case 2: obj_main.obj_up_arrow.image_blend = color_value; break
			case 3: obj_main.obj_right_arrow.image_blend = color_value; break
		}
	} else {
		switch arrow_type {
			case 0: obj_main.obj_opponent_left_arrow.image_blend = color_value; break
			case 1: obj_main.obj_opponent_down_arrow.image_blend = color_value; break
			case 2: obj_main.obj_opponent_up_arrow.image_blend = color_value; break
			case 3: obj_main.obj_opponent_right_arrow.image_blend = color_value; break
		}
	}
}

function get_song_position_ms() {
	return obj_main.song_time / 10000	
}

function ui_arrow_wave(Target, start_time, end_time) {
	if start_time < obj_main.song_time and end_time > obj_main.song_time{
		var now_time = obj_main.song_time
		var _now_time = now_time / 500
		show_debug_message(sin(_now_time))
		ui_arrow_move_buffer_my (0,0,0,0,sin(_now_time + 0.8) * 80 + 100,sin(_now_time+0.6) * 80 + 100,sin(_now_time+0.4) * 80 + 100,sin(_now_time+0.1) * 80 + 100,Target,1,0,1)
	}
}



function redPulse() {
    //if (!global.modcharts) return;
    
    // 设置玩家箭头颜色
    with (obj_main.obj_left_arrow) { image_blend = make_color_rgb(255, 0, 0); }
    with (obj_main.obj_down_arrow) { image_blend = make_color_rgb(255, 0, 0); }
    with (obj_main.obj_up_arrow) { image_blend = make_color_rgb(255, 0, 0); }
    with (obj_main.obj_right_arrow) { image_blend = make_color_rgb(255, 0, 0); }
    
    // 设置对手箭头颜色
    with (obj_main.obj_opponent_left_arrow) { image_blend = make_color_rgb(255, 0, 0); }
    with (obj_main.obj_opponent_down_arrow) { image_blend = make_color_rgb(255, 0, 0); }
    with (obj_main.obj_opponent_up_arrow) { image_blend = make_color_rgb(255, 0, 0); }
    with (obj_main.obj_opponent_right_arrow) { image_blend = make_color_rgb(255, 0, 0); }
    
}

function unload_texture_group(group_name) {
	texturegroup_unload(group_name);
}



/// @function func_judge_performance_quality(_y,_offset,_note,worry_note)
/// @description 判定sick good bad shit =<
/// @param {real} _y 按键时箭头的y坐标
/// @param {real} _offset 偏移量
/// @param {real} _note 箭头类型 0 1 2 3玩家 4 5 6 7对手
function func_judge_performance_quality(_y,_offset,_note,worry_note){
    // 计算与判定线的实际距离（像素转换为毫秒）
    var distance_pixels = abs(_y - _offset);
    var distance_ms = distance_pixels * (1000 / (22.5 * 60)); // 转换为毫秒
    show_debug_message(distance_ms)
    var judgement = "";
    var rating = 0; // 0=Sick, 1=Good, 2=Bad, 3=Shit
    var base_score = 0;
    
    // 使用ACC时间窗口判断
    if distance_ms <= 45 {
        judgement = "SICK";
        rating = 0; // Sick
        base_score = 300;
    } else if distance_ms <= 90 {
        judgement = "GOOD";
        rating = 1; // Good
        base_score = 200;
    } else if distance_ms <= 135 {
        judgement = "BAD";
        rating = 2; // Bad
        base_score = 100;
    } else if distance_ms <= 160 {
        judgement = "SHIT";
        rating = 3; // Shit
        base_score = 50;
    }
   
    if worry_note = false {
        global.Game_inf.max_score += 300;
    }
    
    if base_score > 0 {
        global.Game_inf.total_score += base_score;
    }
    
    return rating;
}

//e,别问我咋用,我其实不是很知道(^-^)
function load_all_jsons_from_folder(folder_path) {
    var all_jsons = [];
    
    var search_pattern = working_directory + string(folder_path) + "*.json";
    var file = file_find_first(search_pattern, 0);
    
    while (file != "") {
        var full_path = folder_path + file;
		var file_content = buffer_load(working_directory + full_path)

		var json_string = buffer_read(file_content, buffer_string);
		buffer_delete(file_content);
		var json_data = json_parse(json_string);
        
        if (json_data != undefined) {            
            array_push(all_jsons, json_data);
        }
        
        file = file_find_next();
    }
    file_find_close();
    
    return all_jsons; 
}