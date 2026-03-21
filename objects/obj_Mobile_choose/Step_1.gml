/// @description 多点触控 - 支持滑动触发单击

if (instance_exists(obj_main)) {
    
    // 重置所有按键状态
    global.check_map.left = false;
    global.check_map.down = false;
    global.check_map.up = false;
    global.check_map.right = false;
    
    // ----- 新增：记录每个触摸点上一帧所在的分区 -----
    // 需要在 Create 事件中初始化：touch_last_section = array_create(4, -1);
    
    // 检查最多4个触摸点
    for (var t = 0; t < 4; t++) {
        if (device_mouse_check_button(t, mb_left)) {
            var touch_x = device_mouse_x_to_gui(t);
            var touch_y = device_mouse_y_to_gui(t);
            var current_section = -1;
            
            // 检测这个触摸点在哪个分区
            for (var i = 0; i < 4; i++) {
                var left = i * part_width;
                var right = left + part_width;
                
                if (touch_x >= left && touch_x <= right && 
                    touch_y >= 0 && touch_y <= 720) {
                    current_section = i;
                    break;
                }
            }
            
            // 如果触摸点在有效分区内
            if (current_section != -1) {
                // 根据分区设置对应的按键为true
                switch (current_section) {
                    case 0: global.check_map.left = true; break;
                    case 1: global.check_map.down = true; break;
                    case 2: global.check_map.up = true; break;
                    case 3: global.check_map.right = true; break;
                }
                
                // ===== 关键修改：检测滑动到新区块 =====
                // 两种情况触发 pressed：
                // 1. 刚按下时 (pressed)
                // 2. 从其他分区滑动进入时 (上一帧的分区 != 当前分区)
                
                var touch_just_pressed = device_mouse_check_button_pressed(t, mb_left);
                var touch_moved_to_new = (touch_last_section[t] != -1 && 
                                          touch_last_section[t] != current_section);
                
                if (touch_just_pressed || touch_moved_to_new) {
                    switch (current_section) {
                        case 0: 
                            global.check_map.left_pressed = true; 
                            show_debug_message("触摸点 " + string(t) + " 触发左 - " + 
                                              (touch_just_pressed ? "按下" : "滑入"));
                            break;
                        case 1: 
                            global.check_map.down_pressed = true; 
                            show_debug_message("触摸点 " + string(t) + " 触发下 - " + 
                                              (touch_just_pressed ? "按下" : "滑入"));
                            break;
                        case 2: 
                            global.check_map.up_pressed = true; 
                            show_debug_message("触摸点 " + string(t) + " 触发上 - " + 
                                              (touch_just_pressed ? "按下" : "滑入"));
                            break;
                        case 3: 
                            global.check_map.right_pressed = true; 
                            show_debug_message("触摸点 " + string(t) + " 触发右 - " + 
                                              (touch_just_pressed ? "按下" : "滑入"));
                            break;
                    }
                }
            }
            
            // 更新这一帧的分区记录（供下一帧使用）
            touch_last_section[t] = current_section;
            
        } else {
            // 手指已离开，重置记录
            touch_last_section[t] = -1;
        }
    }
}