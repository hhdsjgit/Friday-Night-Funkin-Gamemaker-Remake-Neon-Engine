/// @description
if song_time >= 356129.032258064 and video_played = false{
	vedio_play("assets\\videos\\nightflaid.mp4")	
	video_played = true;
}
if keyboard_check_pressed(ord("L")) {
    global.input_latency_test = true;
    global.input_timestamp = current_time;
    show_debug_message("开始延迟测试: " + string(current_time));
}
    
if global.input_latency_test {
    // 检测到任意输入时记录时间
    if keyboard_check_pressed(vk_left) or keyboard_check_pressed(vk_down) or 
        keyboard_check_pressed(vk_up) or keyboard_check_pressed(vk_right) {
            
        var latency = current_time - global.input_timestamp;
        show_debug_message("输入延迟: " + string(latency) + "ms");
        global.input_latency_test = false;
    }
}


global.check_map.left_pressed = keyboard_check_pressed(vk_left)
global.check_map.down_pressed = keyboard_check_pressed(vk_down)
global.check_map.up_pressed = keyboard_check_pressed(vk_up)
global.check_map.right_pressed = keyboard_check_pressed(vk_right)