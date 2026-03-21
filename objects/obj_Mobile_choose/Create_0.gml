/// @description
mouse_section = -1
touch_just_pressed = false;
touch_just_released = false;
/// @description 初始化触屏变量
part_width = 1280 / 4;
part_height = 720;

// 记录每个触摸点上一帧所在的分区（-1表示未触摸）
touch_last_section = array_create(4, -1);