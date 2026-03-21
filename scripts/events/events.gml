function events(){

}
function camera_zoom_add (param1,param2) {
	global.Game_inf.cam_scale -= param1 * 2
	obj_main.Ui_Zoom += param2
}
function Flash_Camera(param1, param2) {
	obj_else_events.flash_active = 1
	obj_else_events.flash_time = real(param1)
}
function change_character(param1, param2) {
		
}
function Change_Stage_Zoom(param1, param2) {
	global.Game_inf.Target_cam_scale = param2
}
function Change_Character_Offset(param1, param2) {
    // 解析 param1
    var params1 = split_string(param1, ",");
    if (array_length(params1) < 4) return;
    
    var tweenOffset = (params1[0] == "true" || params1[0] == "1");
    var charIndex = real(params1[1]);
    var offsetX = real(params1[2]);
    var offsetY = real(params1[3]);
    
    // 解析 param2
    var params2 = split_string(param2, ",");
    
    var steps = 4;
    var easeType = "linear";
    var easeDir = "In";
    
    if (array_length(params2) >= 1) steps = real(params2[0]);
    if (array_length(params2) >= 2) easeType = params2[1];
    if (array_length(params2) >= 3) easeDir = params2[2];
    
    if (global.debug_modes) {
        show_debug_message("Change_Character_Offset: 角色" + string(charIndex) + 
                          " 偏移: X=" + string(offsetX) + " Y=" + string(offsetY) +
                          " 缓动=" + string(tweenOffset) + 
                          " 步数=" + string(steps) +
                          " " + easeType + "," + easeDir);
    }
    
    // 调用摄像机移动，传入缓动参数
    Cam_Character_Move(offsetX, offsetY, tweenOffset, charIndex, steps, easeType, easeDir);
}

function Screen_Vignette(param1, param2) {
    var params1 = split_string(param1, ",");
    var params2 = split_string(param2, ",");
    
    if (array_length(params1) < 3) return;
    
    var enabled = (params1[0] == "true" || params1[0] == "1");
    var target_intensity = real(params1[1]);
    var target_size = real(params1[2]);
    
    var steps = 4;
    var easeType = "linear";
    var easeDir = "In";
    
    if (array_length(params2) >= 1) steps = real(params2[0]);
    if (array_length(params2) >= 2) easeType = params2[1];
    if (array_length(params2) >= 3) easeDir = params2[2];
    
    if (!enabled) {
        // 禁用暗角，目标为0
        target_intensity = 0;
    }
    
    // 计算持续时间
    var duration_ms = (global.crochet_time / 4) * steps;
    
    if (duration_ms <= 0) {
        // 瞬移
        global.vignette.intensity = target_intensity;
        global.vignette.size = target_size;
        global.vignette.active = enabled;
        global.vignette.tween_active = false;
    } else {
        // 启动缓动
        global.vignette.start_intensity = global.vignette.intensity;
        global.vignette.start_size = global.vignette.size;
        global.vignette.target_intensity = target_intensity;
        global.vignette.target_size = target_size;
        global.vignette.tween_start_time = obj_main.song_time;
        global.vignette.tween_duration = duration_ms;
        global.vignette.tween_active = true;
        global.vignette.tween_ease = easeType;
        global.vignette.tween_dir = easeDir;
        global.vignette.active = true;
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
            
		case "Change Character Offset":
			Change_Character_Offset(param1,param2)
			break;
			
		case "Screen Vignette":
			Screen_Vignette(param1, param2);
	    break;
        // 添加其他事件类型...
            
        default:
            show_debug_message("未知事件类型: " + _event_type);
            break;
		
		
	}
}
