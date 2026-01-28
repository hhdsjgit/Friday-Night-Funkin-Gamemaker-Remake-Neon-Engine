
if (active) {
	
	if !(keyboard_check_pressed(vk_enter)or(keyboard_check_pressed(vk_backspace))or(keyboard_check_pressed(vk_shift)or(keyboard_check_pressed(vk_alt)or(keyboard_check_pressed(vk_lcontrol)) ))){
		var key = keyboard_lastchar;
    
	    if (string_length(text) < max_length) {
	        // 插入字符到光标位置
	        text = string_insert((key), text, cursor_pos + 1);
	        cursor_pos += 1;
			//show_debug_message(string(text) + "  " + string(cursor_pos))
        
	    }	
	}
    // 处理删除键
    if (keyboard_check_pressed(vk_backspace)) {
        if (string_length(text)> 0) {
            text = string_delete(text, cursor_pos, 1);
			cursor_pos -= 1
        }
    }

    if (keyboard_check_pressed(vk_enter)) {
        active = false;
        // 可以触发一个事件
        event_user(0); // 用户事件0
    }
}