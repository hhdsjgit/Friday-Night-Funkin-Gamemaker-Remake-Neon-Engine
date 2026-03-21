/// @description
//global.Game_inf.cam_buff_crochet = clamp(global.Game_inf.cam_buff_crochet,0,99999)
//global.Game_inf.cam_buff_crochet -= func_frc_main(1)

// 在 obj_main Step 事件中更新摄像机缓动
if (global.Game_inf.cam_move_active) {
    var _current_time = obj_main.song_time;
    var elapsed = _current_time - global.Game_inf.cam_move_start_time;
    
    if (elapsed >= global.Game_inf.cam_move_duration) {
        // 动画完成
        global.Game_inf.cam_x = global.Game_inf.Target_cam_x;
        global.Game_inf.cam_y = global.Game_inf.Target_cam_y;
        global.Game_inf.cam_move_active = false;
        
        if (global.debug_modes) {
            show_debug_message("摄像机缓动完成");
        }
    } else {
        // 计算进度
        var progress = elapsed / global.Game_inf.cam_move_duration;
        
        // 获取缓动函数
        var ease_func = get_ease_function(global.Game_inf.cam_move_ease_type, 
                                          global.Game_inf.cam_move_ease_dir);
        var eased = ease_func(progress);
        
        // 使用缓动函数进行插值
        global.Game_inf.cam_x = global.Game_inf.cam_move_start_x + 
                                 (global.Game_inf.Target_cam_x - global.Game_inf.cam_move_start_x) * eased;
        global.Game_inf.cam_y = global.Game_inf.cam_move_start_y + 
                                 (global.Game_inf.Target_cam_y - global.Game_inf.cam_move_start_y) * eased;
    }
}

if (global.vignette.tween_active) {
    var _current_time = obj_main.song_time;
    var elapsed = _current_time - global.vignette.tween_start_time;
    
    if (elapsed >= global.vignette.tween_duration) {
        // 动画完成
        global.vignette.intensity = global.vignette.target_intensity;
        global.vignette.size = global.vignette.target_size;
        global.vignette.tween_active = false;
    } else {
        var progress = elapsed / global.vignette.tween_duration;
        var eased = get_ease_function(global.vignette.tween_ease, global.vignette.tween_dir)(progress);
        
        global.vignette.intensity = global.vignette.start_intensity + 
            (global.vignette.target_intensity - global.vignette.start_intensity) * eased;
        global.vignette.size = global.vignette.start_size + 
            (global.vignette.target_size - global.vignette.start_size) * eased;
    }
}
//
if global.game_paused == 0 {
	global.check_map.left_pressed = get_key_pressed(global.key_map.main_key_game.game_key_left);
	global.check_map.down_pressed = get_key_pressed(global.key_map.main_key_game.game_key_down);
	global.check_map.up_pressed = get_key_pressed(global.key_map.main_key_game.game_key_up);
	global.check_map.right_pressed = get_key_pressed(global.key_map.main_key_game.game_key_right);

	global.check_map.left = get_key_down(global.key_map.main_key_game.game_key_left);
	global.check_map.down = get_key_down(global.key_map.main_key_game.game_key_down);
	global.check_map.up = get_key_down(global.key_map.main_key_game.game_key_up);
	global.check_map.right = get_key_down(global.key_map.main_key_game.game_key_right);
}