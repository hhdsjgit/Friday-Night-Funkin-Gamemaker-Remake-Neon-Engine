/// @description

if global.Game_inf.player_die == true {
	for (var i0 = 0;i0 < array_length(global.Game_inf.Note_arrow_alpha);i0 ++) {
		global.Game_inf.Note_arrow_alpha[i0] = 0
	}
	for (var char_type_0 = 0; char_type_0 < array_length(global.Game_inf.characters_alpha);char_type_0 ++) {
		global.Game_inf.characters_alpha[char_type_0] = 0	
	}
	global.Game_inf.show_health_bar = false
	audio_pause_sound(obj_main.song_sound1);
	audio_pause_sound(obj_main.song_sound2);
	audio_pause_sound(obj_main.song_sound3);
	show_message("你失败了,对就这么潦草")
	game_end(true)
}

if global.Game_inf.heath <= 0 {
	global.Game_inf.player_die = true;
}
switch Game_start_pos {
	case 1: if Game_start_pos_time >= 0.1 {func_play_sounds("\\assets\\sounds\\minus\\1.ogg",0,0);Game_start_pos ++};break;
	case 2: if Game_start_pos_time >= 0.5 {func_play_sounds("\\assets\\sounds\\minus\\2.ogg",0,0);Game_start_pos ++};break;
	case 3: if Game_start_pos_time >= 1 {func_play_sounds("\\assets\\sounds\\minus\\3.ogg",0,0);Game_start_pos ++};break;
	case 4: if Game_start_pos_time >= 1.5 {func_play_sounds("\\assets\\sounds\\minus\\4.ogg",0,0);Game_start_pos ++};break;
	case 5: audio_resume_sound(obj_main.song_sound1);audio_resume_sound(obj_main.song_sound2);audio_resume_sound(obj_main.song_sound3);global.game_play = 1;Game_start_pos ++;break;
	case 6: break;
}
Game_start_pos_time += 0.013333

var _view_w = 1280 * global.Game_inf.cam_scale * 1.5
var _view_h = 720 * global.Game_inf.cam_scale * 1.5
camera_set_view_pos(global._camera,(1280*1.5 - _view_w)/2 + global.Game_inf.cam_x + global.Game_inf.cam_shark_shake_x,(720*1.5 - _view_h)/2 + global.Game_inf.cam_y + global.Game_inf.cam_shark_shake_y)
camera_set_view_size(global._camera,_view_w,_view_h)
camera_apply(global._camera)

//if keyboard_check(ord("D")) {
//	global.Game_inf.cam_x += 3
//}
//if keyboard_check(ord("A")) {
//	global.Game_inf.cam_x -= 3
//}
//if keyboard_check(ord("W")) {
//	global.Game_inf.cam_y -= 3
//}
//if keyboard_check(ord("S")) {
//	global.Game_inf.cam_y += 3
//}
//if keyboard_check(ord("Q")) {
//	global.Game_inf.cam_scale -= 0.02
//}
//if keyboard_check(ord("E")) {
//	global.Game_inf.cam_scale += 0.02
//}
time_bot += func_frc_main(1)

if !audio_exists(song_sound1) or !audio_exists(song_sound2) {
	if audio_exists(song_sound1) {
		audio_stop_sound(song_sound1)
	}else{
		audio_stop_sound(song_sound2)	
	}
	wimdows_rename()
	audio_stop_all()
	room_goto(room_stroy_mode)
	exit;
}


Shooting_duration = 60 / global.Song_information.bpm;
Shooting_time =song_time / 1000 - Shooting_time_last
if Shooting_time > Shooting_duration * 2 {

	Shooting_time_last = song_time / 1000
	
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



if array_length(global.Song_information.notes_data) > i and global.Game_inf.player_die != true{
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
		if global.setting_game.BUBBLE_SORT {
			var array_2d = note_1.sectionNotes;
			var n1 = array_length(array_2d);
			var swapped;

			for (var i1 = 0; i1 < n1 - 1; i1++) {
			    swapped = false;
    
			    for (var j = 0; j < n1 - i1 - 1; j++) {
			        if (array_2d[j][0] > array_2d[j + 1][0]) {
			            var temp = array_2d[j];
			            array_2d[j] = array_2d[j + 1];
			            array_2d[j + 1] = temp;
			            swapped = true;
			        }
			    }
    
			    // 如果没有交换发生，数组已经有序，提前退出
			    if (!swapped) break;
			}
		}

		//排序""""""""
		//for (var t = 0;note_1.sectionNotes[n][0] >= song_time + 800;t ++) {
		var song_time_add = 815
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
				var worry_note_a = "NOONE"
				if (array_length(note_1.sectionNotes[n]) >= 4) {
					 worry_note_a = note_1.sectionNotes[n][3]
				}
				var note_dir = note_1.sectionNotes[n][1];
				var note_length = note_1.sectionNotes[n][2];
				var note_obj = undefined	
				var load_note_now = 0
				
				//生成玩家的箭头
				if note_1.mustHitSection = 1 {
				    if note_dir <= 3 {
				        // 玩家右侧 (0-3)
				        note_obj =create_note(
				            800 + note_dir * 110,  
				            note_dir,               
				            1,            
				            note_length,
				            worry_note_a
				        )
					}else {
				        // 玩家左侧 (4-7)
				        note_obj = create_note(
				            100 + (note_dir - 4) * 110,  
				            note_dir - 4,                 
				            0,                   
				            note_length,      
				            worry_note_a
				        )
				    }
				}

				// 对手段生成
				if note_1.mustHitSection = 0 {
				    if note_dir <= 3 {
				        // 对手左侧 (0-3)
				        note_obj = create_note(
				            100 + note_dir * 110, 
				            note_dir,              
				            0,            
				            note_length,  
				            worry_note_a
				        )
					}else {
					    // 对手右侧 (4-7)
					    note_obj = create_note(
					        800 + (note_dir - 4) * 110, 
					        note_dir - 4,                  
					        1,               
					        note_length,       
					        worry_note_a
					    )
					}
				}
				note_obj.target_time = note_1.sectionNotes[n][0]  // 从当前处理的音符获取目标时间
				note_obj.spawn_time = song_time
				if note_1.mustHitSection = 0 {
					cam_move_type = global.player_o
				}else{
					cam_move_type = global.player_i
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
            
        case "Flash Camera":
            // 自定义事件
            Flash_Camera(param1, param2);
            break;
            
        case "Midsong Video":
            // 播放视频
            //play_midsong_video(param1);
            break;
			
		case "Change Stage Zoom":
			Change_Stage_Zoom(param1,param2)
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
Ui_Zoom += func_frc((global.Game_inf.Target_ui_scale-Ui_Zoom)/15)


//玩家条件判定按键
if global.check_map.left{
	if global.Game_inf.Note_player2_0 != 1{
		global.Game_inf.Note_player2_0 = 2
	}else{
		obj_left_arrow.alarm_time = 1
	}
}else{
	global.Game_inf.Note_player2_0 = 0
}

if global.check_map.down {
	if global.Game_inf.Note_player2_1 != 1 {
		global.Game_inf.Note_player2_1 = 2
	}else{
		obj_down_arrow.alarm_time = 1
	}
}else{
	global.Game_inf.Note_player2_1 = 0
}

if global.check_map.up {
	if global.Game_inf.Note_player2_2 != 1 {
		global.Game_inf.Note_player2_2 = 2
	}else{
		obj_up_arrow.alarm_time = 1
	}
}else{
	global.Game_inf.Note_player2_2 = 0
}

if global.check_map.right {
	if global.Game_inf.Note_player2_3 != 1{
		global.Game_inf.Note_player2_3 = 2
	}else{
		obj_right_arrow.alarm_time = 1
	}
}else{
	global.Game_inf.Note_player2_3 = 0
}






