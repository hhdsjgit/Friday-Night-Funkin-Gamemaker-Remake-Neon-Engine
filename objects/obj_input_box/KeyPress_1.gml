
if (active) {
	
	if !(keyboard_check(vk_control) or keyboard_check(vk_enter)or(keyboard_check(vk_backspace))
	or(keyboard_check_pressed(vk_shift))
	or(keyboard_check(vk_alt))
	or(keyboard_check(vk_lcontrol)) ){
		var can_use = 0
		var key = keyboard_lastchar;
		if choose_text = "number" {
			var buff_a = ["0","1","2","3","4","5","6","7","8","9"]
			for (var i = 0;i < array_length(buff_a);i++ ) {
				if key == buff_a[i] {
					can_use = 1	
				}
			}
		}else{
			can_use = 1		
		}
	    if (string_length(text) < max_length) and can_use = 1{
	        // 插入字符到光标位置
	        text = string_insert((key), text, cursor_pos + 1);
	        cursor_pos += 1;
			//show_debug_message(string(text) + "  " + string(cursor_pos))
        
	    }	
	}
	if keyboard_check(vk_control) and keyboard_check_pressed(ord("V")) and choose_text = "NONE"{
		var get_text = clipboard_get_text();
		var get_text_length = string_length(get_text)
		if get_text_length > 0 {
			text = string_insert(get_text, text, cursor_pos + 1);
			cursor_pos += get_text_length
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