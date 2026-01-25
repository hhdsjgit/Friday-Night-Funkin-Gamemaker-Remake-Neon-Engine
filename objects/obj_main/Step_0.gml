/// @description



switch Game_start_pos {
	case 1: if Game_start_pos_time >= 0.1 {func_play_sounds("\\assets\\sounds\\minus\\1.ogg",0,0);Game_start_pos ++};break;
	case 2: if Game_start_pos_time >= 0.5 {func_play_sounds("\\assets\\sounds\\minus\\2.ogg",0,0);Game_start_pos ++};break;
	case 3: if Game_start_pos_time >= 1 {func_play_sounds("\\assets\\sounds\\minus\\3.ogg",0,0);Game_start_pos ++};break;
	case 4: if Game_start_pos_time >= 1.5 {func_play_sounds("\\assets\\sounds\\minus\\4.ogg",0,0);Game_start_pos ++};break;
	case 5: audio_resume_sound(obj_main.song_sound1);audio_resume_sound(obj_main.song_sound2);audio_resume_sound(obj_main.song_sound3);global.game_play = 1;Game_start_pos ++;break;
	case 6: break;
}
Game_start_pos_time += 0.013333

var _view_w = 1280 * global.Game_inf.cam_scale
var _view_h = 720 * global.Game_inf.cam_scale
camera_set_view_pos(global._camera,(1280 - _view_w)/2 + global.Game_inf.cam_x + global.Game_inf.cam_shark_shake_x,(720 - _view_h)/2 + global.Game_inf.cam_y + global.Game_inf.cam_shark_shake_y)
camera_set_view_size(global._camera,_view_w,_view_h)
camera_apply(global._camera)

if keyboard_check(ord("D")) {
	global.Game_inf.cam_x += 3
}
if keyboard_check(ord("A")) {
	global.Game_inf.cam_x -= 3
}
if keyboard_check(ord("W")) {
	global.Game_inf.cam_y -= 3
}
if keyboard_check(ord("S")) {
	global.Game_inf.cam_y += 3
}
if keyboard_check(ord("Q")) {
	global.Game_inf.cam_scale -= 0.02
}
if keyboard_check(ord("E")) {
	global.Game_inf.cam_scale += 0.02
}


if !audio_exists(song_sound1) or !audio_exists(song_sound2) {
	if audio_exists(song_sound1) {
		audio_stop_sound(song_sound1)
	}else{
		audio_stop_sound(song_sound2)	
	}
	load_s = audio_create_stream(working_directory + "\\assets\\songs\\test-song\\song\\Inst.ogg")
	load_s1 = audio_create_stream(working_directory + "\\assets\\songs\\test-song\\song\\Voices.ogg")
	song_sound1=audio_play_sound(load_s,0,0)
	song_sound2=audio_play_sound(load_s1,0,0)	
	var audio_time = song_time / 1000
	
	audio_sound_set_track_position(song_sound1, audio_time)	
	audio_sound_set_track_position(song_sound2, audio_time)	
			
	
}


Shooting_duration = 60 / global.Song_information.bpm;
Shooting_time =song_time / 1000 - Shooting_time_last
if Shooting_time > Shooting_duration * 2 {
	//audio_play_sound(click,0,0)
	
	obj_bf_car.can_act = 1
	obj_opponent_player.can_act = 1
	
	Shooting_time_last = song_time / 1000
	image_index = 0
	image_speed = 1
	//Ui_Zoom = 1.05
	if !(audio_sound_get_track_position(song_sound1) >= 19.5 and audio_sound_get_track_position(song_sound1) <= 20.5) {
		
		//global.Game_inf.cam_scale = 1.75
	}
	if song_time >= 23225 {
		//execute_event("Add Camera Zoom",0.05,0.08)	
	}
}	
if sprite_get_number(BF) <= image_index{
	image_speed = 0
}

//读取json进行解析处理
song_time = audio_sound_get_track_position(song_sound1) * 1000//get_timer() / 1000 - song_last_time;

/**
	======NOTE======
	1. i变量用于获取但前读取global.Song_information.notes_data的某个列表[]
	2. n变量用于note_1.sectionNotes[n]用于读取sectionNotes内的数据表
	3. 有进行冒泡整理,但可以优化
	4. song_time为单曲歌曲播放的时间us

*/


if array_length(global.Song_information.notes_data) > i {
	var note = 0
	var note_1 = 0
	
	note = global.Song_information.notes_data //获取单个内容
	note_1 = global.Song_information.notes_data[i] //获取单个内容
	// 检查值是否为undefined
	if (variable_struct_exists(note_1, "changeBPM")) {
		if note_1.changeBPM = true {
			global.Song_information.bpm = note_1.bpm
		}
	}
	if array_length(note_1.sectionNotes) >= 1 {
		song_time = audio_sound_get_track_position(song_sound1) * 1000
		//冒泡排序(会卡死)(整理时间顺序)
		var array_2d = note_1.sectionNotes
		var n1 = array_length(array_2d);
    
		for (var i1 = 0; i1 < n1 - 1; i1++) {
		    for (var j = 0; j < n1 - i1 - 1; j++) {
		        // 比较相邻子数组的第0个元素
		        if (array_2d[j][0] > array_2d[j + 1][0]) {
		            // 交换整个子数组
		            var temp = array_2d[j];
		            array_2d[j] = array_2d[j + 1];
		            array_2d[j + 1] = temp;
		        }
		    }
		}
		//show_debug_message("TIME:" + string(note_1.sectionNotes[n][0]) + " TEST:" + string(song_time + 800))
			
		//排序""""""""
		//for (var t = 0;note_1.sectionNotes[n][0] >= song_time + 800;t ++) {
		var song_time_add = 800
		var notes_to_process = 0;
		for (var check_idx = n; check_idx < array_length(note_1.sectionNotes); check_idx++) {
		    if (note_1.sectionNotes[check_idx][0] <= song_time + song_time_add) {
		        notes_to_process++;
		    } else {
		        break;  // 时间太晚的音符不需要现在处理
		    }
		}
		
		for (var t = 0; t < notes_to_process; t++) {
			if note_1.sectionNotes[n][0] <= song_time + song_time_add{
					
				var load_note_now = 0
				//生成玩家的箭头
				if note_1.mustHitSection = 1 and note_1.sectionNotes[n][1] <= 3{
					var note_obj = instance_create_depth(800 + note_1.sectionNotes[n][1] * 110,800,-15,obj_note)
					note_obj.note_arrow=note_1.sectionNotes[n][1]
					note_obj.Note_length=note_1.sectionNotes[n][2]
					note_obj.Note_mustHitSection=note_1.mustHitSection
					if (array_length(note_1.sectionNotes[n]) >= 4) {
						note_obj.worry_note=note_1.sectionNotes[n][3]
					}
				}else{
					var note_obj = instance_create_depth(100 + (note_1.sectionNotes[n][1] - 3) * 110,800,-15,obj_note)
					note_obj.note_arrow=note_1.sectionNotes[n][1] - 3
					note_obj.Note_length=note_1.sectionNotes[n][2]
					note_obj.Note_mustHitSection=0
					if (array_length(note_1.sectionNotes[n]) >= 4) {
						note_obj.worry_note=note_1.sectionNotes[n][3]
					}
				}
				
				////玩家箭头生成end
			
				//生成对手的箭头
				if note_1.mustHitSection = 0 and note_1.sectionNotes[n][1] <= 3{
					var note_obj = instance_create_depth(100 + note_1.sectionNotes[n][1] * 110,800,-15,obj_note)
					note_obj.note_arrow=note_1.sectionNotes[n][1]
					note_obj.Note_length=note_1.sectionNotes[n][2]
					note_obj.Note_mustHitSection=note_1.mustHitSection
					if (array_length(note_1.sectionNotes[n]) >= 4) {
						note_obj.worry_note=note_1.sectionNotes[n][3]
					}
				}else if note_1.mustHitSection = 0{
					var note_obj = instance_create_depth(800 + (note_1.sectionNotes[n][1] - 3) * 110,800,-15,obj_note)
					note_obj.note_arrow=note_1.sectionNotes[n][1] - 3
					note_obj.Note_length=note_1.sectionNotes[n][2]
					note_obj.Note_mustHitSection=1
					if (array_length(note_1.sectionNotes[n]) >= 4) {
						note_obj.worry_note=note_1.sectionNotes[n][3]
					}
				}
				if note_1.mustHitSection = 0 {
					cam_move_type = obj_opponent_player
				}else{
					cam_move_type = obj_bf_car
				}
				////对手箭头生成end
				//show_debug_message(note_1.sectionNotes[n][1])
				//show_debug_message("DEBUG : " + string(note_1.sectionNotes[n]) + "O : " + string(note_1.mustHitSection))	
				n++
				if array_length(note_1.sectionNotes) <= n{
					i++
					n = 0
					
				}
				
			
			}
				
			
		}
	}else{
		i++	
	}
}

function execute_event(_event_type, param1, param2) {
	switch _event_type {
		
		case "Add Camera Zoom":
            // 执行镜头缩放
            camera_zoom_add(real(param1), real(param2));
            break;
            
        case "Play Animation":
            // 播放动画
            //play_animation(param1, param2);
            break;
            
        case "Change Character":
            // 切换角色
            //change_character(param1, param2);
            break;
            
        case "Wildcard":
            // 自定义事件
            //handle_wildcard(param1, param2);
            break;
            
        case "Midsong Video":
            // 播放视频
            //play_midsong_video(param1);
            break;
            
        // 添加其他事件类型...
            
        default:
            show_debug_message("未知事件类型: " + _event_type);
            break;
		
		
	}
}

if array_length(global.Song_information.events_data) > events_i {

	var note_events = global.Song_information.events_data
	/* 检查值是否为undefined
	if (variable_struct_exists(note_1, "changeBPM")) {
		if note_1.changeBPM = true {
			global.Song_information.bpm = note_1.bpm
		}
	}*/
	if array_length(note_events) >= 1 {
		song_time = audio_sound_get_track_position(song_sound1) * 1000
	

		var song_time_add = 1
		var notes_to_process = 0;
		for (var check_idx = event_n; check_idx < array_length(note_events); check_idx++) {
		    if (note_events[check_idx][0] <= song_time + song_time_add) {
		        notes_to_process++;
		    } else {
		        break;  // 时间太晚的音符不需要现在处理
		    }
		}
		
		for (var t = 0; t < notes_to_process; t++) {
			if note_events[event_n][0] <= song_time + song_time_add{
				
				//show_debug_message(note_events[event_n][1][0])
				execute_event(note_events[event_n][1][0][0],note_events[event_n][1][0][1],note_events[event_n][1][0][2])
				event_n++
				if array_length(note_events) <= n{
					events_i++	
					event_n = 0
					
				}		
			}
				
			
		}
	}else{
		events_i++	
	}
}





















//用于校对音乐,防止过快qwq(其实没啥用)
var audio_time = song_time / 1000

if (audio_is_playing(song_sound1) and audio_is_playing(song_sound2)) {
	if abs((audio_sound_get_track_position(song_sound1) - audio_time)) >= 0.08 {
		audio_sound_set_track_position(song_sound1, audio_time)	
		audio_sound_set_track_position(song_sound2, audio_time)	
		audio_sound_set_track_position(song_sound3, audio_time)	
	}
}

//UI缩放
Ui_Zoom += func_frc((1-Ui_Zoom)/15)


//玩家条件判定按键
if keyboard_check(vk_left){
	if global.Game_inf.Note_player2_0 != 1{
		global.Game_inf.Note_player2_0 = 2
	}else{
		obj_left_arrow.alarm_time = 1
	}
}else{
	global.Game_inf.Note_player2_0 = 0
}

if keyboard_check(vk_down) {
	if global.Game_inf.Note_player2_1 != 1 {
		global.Game_inf.Note_player2_1 = 2
	}else{
		obj_down_arrow.alarm_time = 1
	}
}else{
	global.Game_inf.Note_player2_1 = 0
}

if keyboard_check(vk_up) {
	if global.Game_inf.Note_player2_2 != 1 {
		global.Game_inf.Note_player2_2 = 2
	}else{
		obj_up_arrow.alarm_time = 1
	}
}else{
	global.Game_inf.Note_player2_2 = 0
}

if keyboard_check(vk_right) {
	if global.Game_inf.Note_player2_3 != 1{
		global.Game_inf.Note_player2_3 = 2
	}else{
		obj_right_arrow.alarm_time = 1
	}
}else{
	global.Game_inf.Note_player2_3 = 0
}






