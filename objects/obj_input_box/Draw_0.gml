draw_set_color(c_blue);
draw_rectangle(box_x, box_y, box_x + box_width, box_y + box_height, false);

// 绘制背景
draw_set_color(c_black);
draw_rectangle(box_x + 1, box_y + 1, box_x + box_width - 1, box_y + box_height - 1, true);

// 设置文本属性
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_middle);

// 绘制文本（如果没有输入则显示占位符）
var display_text = text;
if (display_text == "" && !active) {
    draw_set_color(c_gray);
    display_text = placeholder;
} else {
    draw_set_color(c_white);
}

// 绘制文本
draw_text(box_x + 5, box_y + box_height / 2, display_text);

if (active) {
    cursor_blink += 1;
    if (cursor_blink mod 60 < 30) { // 每30帧闪烁一次
        var cursor_x = box_x + 5 + string_width(string_copy(text, 1, cursor_pos));
        draw_set_color(c_white);
        draw_line(cursor_x, box_y + 5, cursor_x, box_y + box_height - 5);
    }
}

if mouse_check_button_pressed(1) {
	

	if point_in_rectangle(mouse_x, mouse_y, box_x, box_y, box_x + box_width, box_y + box_height) {
	    active = true;
	    // 设置光标位置（简单实现，可以改进为精确到字符）
	    cursor_pos = string_length(text);
	} else {
	    active = false;
	}	
}
