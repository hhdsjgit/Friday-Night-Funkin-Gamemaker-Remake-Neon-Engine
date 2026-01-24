/// @description 初始化事件管理器

// 脉冲系统
pulse_active = false;
pulse_timer = 0;
pulse_duration = 1.25; // 1.25秒

// 节拍检测
last_beat = -1;
last_step = -1;

// 特殊节拍列表
special_cam = [151, 158, 165, 319, 326, 333, 347, 354, 361]
flashy_beats = [79, 143, 171, 199, 279, 311, 339, 367];
zoom_beats = [415, 447, 479, 511, 543, 575, 607, 639, 671];
pulse_steps = [
    50, 53, 56, 
    306, 309, 312, 
    562, 565, 568, 
    980, 984,
    1652, 1656,
    3442, 3445, 3448
];

// 镜头效果 - 修复：确保所有变量都初始化
camera_shake_strength = 0;
camera_shake_timer = 0; // 这里已经初始化了，但确保没有遗漏

// Mod功能开关
modcharts_enabled = true;
toggledShove = false;
trulyBeats = 0;

// 闪光效果
flash_active = false;
next_beat_flash = -1;

// 红色对象列表
red_objects_initialized = false;

// 颜色存储数组
original_player_colors = array_create(4);
original_opponent_colors = array_create(4);

// 闪光灯效果开关（对应Lua的flashingLights）
global.flashing_lights = true; // 默认开启，可以根据需要改为false

// 其他可能需要的全局变量
global.modcharts = true; // Modcharts开关

global.crochet = 0
crochet =0
n = 0
n_color = 0
n_icon = 0
n_red_color = 0