function Cam(){
	
}

// 增强版 Cam_Character_Move，支持缓动类型
function Cam_Character_Move(x, y, Tween_Offset, characters, duration_steps, ease_type="linear", ease_dir="In") {
    // 获取当前时间
    var _current_time = obj_main.song_time;
    
    // 计算摄像机应该移动到的目标位置
    var cam_xy = Cam_Changed_xy(x, y);
    var move_t_xy = [0, 0];
    
    // 获取角色的当前位置
    switch (characters) {
        case 0:
            if (instance_exists(global.player_i)) {
                move_t_xy[0] = global.player_i.x;
                move_t_xy[1] = global.player_i.y;
            }
            break;
        case 1:
            if (instance_exists(global.player_o)) {
                move_t_xy[0] = global.player_o.x;
                move_t_xy[1] = global.player_o.y;
            }
            break;
		case 2:  // GF
            //if (instance_exists(global.player_gf)) {
                move_t_xy[0] = 1280/2;
                move_t_xy[1] = 720/2;
            //}
            break;
    }
    
    // 计算最终目标位置
    var target_cam_x = cam_xy[0] + move_t_xy[0];
    var target_cam_y = cam_xy[1] + move_t_xy[1];
    
    if (Tween_Offset or 1==1) {
        // 缓动移动
        global.Game_inf.Target_cam_x = target_cam_x;
        global.Game_inf.Target_cam_y = target_cam_y;
        
        // 计算持续时间（毫秒）
        global.Game_inf.cam_move_duration = (global.crochet_time / 4) * duration_steps;
        global.Game_inf.cam_move_start_time = _current_time;
        global.Game_inf.cam_move_start_x = global.Game_inf.cam_x;
        global.Game_inf.cam_move_start_y = global.Game_inf.cam_y;
        global.Game_inf.cam_move_active = true;
        
        // 保存缓动类型
        global.Game_inf.cam_move_ease_type = ease_type;
        global.Game_inf.cam_move_ease_dir = ease_dir;
        
        if (global.debug_modes) {
            show_debug_message("摄像机缓动开始: 目标(" + string(target_cam_x) + "," + string(target_cam_y) + 
                              ") 持续时间:" + string(global.Game_inf.cam_move_duration) + "ms" +
                              " 缓动:" + ease_type + "_" + ease_dir);
        }
    } else {
        // 瞬移
        global.Game_inf.cam_x = target_cam_x;
        global.Game_inf.cam_y = target_cam_y;
        global.Game_inf.cam_move_active = false;
    }
}
function Cam_Changed_xy(x,y){
	var cam_xy = [0,0]
	cam_xy[0] = x - 1280/2
	cam_xy[1] = y - 720/2
	return cam_xy
}