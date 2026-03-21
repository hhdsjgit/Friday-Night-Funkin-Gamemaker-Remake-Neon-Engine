/// @description 绘制分区并显示多点触控状态

if !instance_exists(obj_main) {
	exit;	
}
var part_width = 1280 / 4;
var part_height = 720;

// =============================================
// 1. 绘制背景分区（基础颜色）
// =============================================
for (var i = 0; i < 4; i++) {
    var draw_x = i * part_width;
    
    // 基础背景色
    draw_set_color(c_black);
    draw_set_alpha(0.2);
    draw_rectangle(draw_x, 0, draw_x + part_width, part_height, 0);
}

// =============================================
// 2. 绘制被按下的分区（显示按住状态）
// =============================================
// 显示当前按住的按键（global.check_map 的状态）
if (variable_global_exists("check_map")) {
    for (var i = 0; i < 4; i++) {
        var draw_x = i * part_width;
        var is_pressed = false;
        
        // 检查哪个方向被按住
        switch (i) {
            case 0: is_pressed = global.check_map.left; break;
            case 1: is_pressed = global.check_map.down; break;
            case 2: is_pressed = global.check_map.up; break;
            case 3: is_pressed = global.check_map.right; break;
        }
        
        if (is_pressed) {
            draw_set_color(c_lime);  // 按住显示亮绿色
            draw_set_alpha(0.6);
            draw_rectangle(draw_x, 0, draw_x + part_width, part_height, 0);
        }
    }
}

// =============================================
// 3. 绘制触摸点位置（显示实际触摸点）
// =============================================
draw_set_alpha(1);

// 检查最多4个触摸点
for (var t = 0; t < 4; t++) {
    if (device_mouse_check_button(t, mb_left)) {
        var touch_x = device_mouse_x_to_gui(t);
        var touch_y = device_mouse_y_to_gui(t);
        
        // 确定触摸点所在分区
        var section = -1;
        for (var i = 0; i < 4; i++) {
            var left = i * part_width;
            var right = left + part_width;
            if (touch_x >= left && touch_x <= right && 
                touch_y >= 0 && touch_y <= part_height) {
                section = i;
                break;
            }
        }
        
        // 绘制触摸点标记
        if (section != -1) {
            // 不同触摸点用不同颜色
            switch (t) {
                case 0: draw_set_color(c_aqua); break;    // 青色
                case 1: draw_set_color(c_yellow); break;  // 黄色
                case 2: draw_set_color(c_fuchsia); break; // 紫红色
                case 3: draw_set_color(c_orange); break;  // 橙色
            }
            
            // 绘制触摸点圆圈
            draw_circle(touch_x, touch_y, 30, false);  // 空心圆
            draw_circle(touch_x, touch_y, 5, true);    // 实心中心点
            
            // 绘制触摸点信息
            draw_set_halign(fa_center);
            draw_set_valign(fa_bottom);
            draw_text(touch_x, touch_y - 40, 
                     "T" + string(t) + " 分区 " + string(section));
            
            // 如果是刚按下或滑入，显示特殊标记
            if (device_mouse_check_button_pressed(t, mb_left)) {
                draw_set_color(c_lime);
                draw_text(touch_x, touch_y - 70, "按下!");
            } else if (variable_instance_exists(id, "touch_last_section") && 
                       touch_last_section[t] != section && 
                       touch_last_section[t] != -1) {
                draw_set_color(c_yellow);
                draw_text(touch_x, touch_y - 70, "滑入!");
            }
        }
    }
}

// =============================================
// 4. 绘制分区边框和标签
// =============================================
draw_set_alpha(1);
draw_set_color(c_white);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

for (var i = 0; i < 4; i++) {
    var draw_x = i * part_width;
    var center_x = draw_x + part_width/2;
    
    // 绘制分区边框
    draw_set_color(c_white);
    draw_rectangle(draw_x, 0, draw_x + part_width, part_height, 1);
    
    // 绘制方向标签
    var _direction = "";
    switch (i) {
        case 0: _direction = "← LEFT"; break;
        case 1: _direction = "↓ DOWN"; break;
        case 2: _direction = "↑ UP"; break;
        case 3: _direction = "→ RIGHT"; break;
    }
    
    // 主标签
    draw_set_color(c_white);
    draw_text(center_x, 200, _direction);
    
    // 分区编号
    draw_set_color(c_gray);
    draw_text(center_x, 250, "P" + string(i));
    
    // 显示当前按下状态
    if (variable_global_exists("check_map")) {
        var is_active = false;
        switch (i) {
            case 0: is_active = global.check_map.left; break;
            case 1: is_active = global.check_map.down; break;
            case 2: is_active = global.check_map.up; break;
            case 3: is_active = global.check_map.right; break;
        }
        
        if (is_active) {
            draw_set_color(c_lime);
            draw_text(center_x, 300, "按住中");
        }
    }
}

// =============================================
// 5. 绘制状态信息
// =============================================
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
draw_set_alpha(1);

// 显示当前帧的触摸状态统计
var touch_count = 0;
for (var t = 0; t < 4; t++) {
    if (device_mouse_check_button(t, mb_left)) touch_count++;
}

draw_text(10, 10, "触摸点数量: " + string(touch_count));
draw_text(10, 30, "当前按住的键:");
draw_text(10, 50, "LEFT: "  + string(global.check_map.left));
draw_text(10, 70, "DOWN: "  + string(global.check_map.down));
draw_text(10, 90, "UP: "    + string(global.check_map.up));
draw_text(10, 110, "RIGHT: " + string(global.check_map.right));

// 显示每个触摸点的历史记录（如果有）
if (variable_instance_exists(id, "touch_last_section")) {
    draw_text(10, 140, "触摸点历史分区:");
    for (var t = 0; t < 4; t++) {
        var status = (touch_last_section[t] == -1) ? "无" : string(touch_last_section[t]);
        draw_text(10, 160 + t * 20, "T" + string(t) + ": " + status);
    }
}

// 恢复默认对齐
draw_set_halign(fa_left);
draw_set_valign(fa_top);