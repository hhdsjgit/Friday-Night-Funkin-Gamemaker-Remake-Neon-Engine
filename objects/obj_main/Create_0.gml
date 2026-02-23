/// @description 初始化所有游戏组件和变量

// ==================== UI表面 ====================
global.ui_surface = surface_create(1280, 720);

// ==================== 游戏信息结构体 ====================
global.Game_inf = {
    "miss_note": 0,                    // 错过音符数
    "Combo_note": 0,                   // 当前连击数
    "BOTPLAY": 0,                      // 自动模式开关
    "Note_player2_0": false,            // 对手第0列音符状态
    "Note_player2_1": false,
    "Note_player2_2": false,
    "Note_player2_3": false,
    "Note_player1_0": false,            // 玩家第0列音符状态
    "Note_player1_1": false,
    "Note_player1_2": false,
    "Note_player1_3": false,
    "heath": 50,                         // 血量
    "cam_scale": 1,                      // 摄像机缩放
    "cam_last_scale": 1,
    "cam_scale_changed": 1,
    "cam_x": 0,                          // 摄像机X偏移
    "cam_y": 0,                          // 摄像机Y偏移
    "cam_shark_shake_x": 0,              // 摄像机抖动X
    "cam_shark_shake_y": 0,              // 摄像机抖动Y
    "ui_shark_shake_x": 0,               // UI抖动X
    "ui_shark_shake_y": 0,               // UI抖动Y
    "total_score": 0,                    // 总分
    "accuracy": 100,                     // 准确率
    "max_score": 0,                      // 最大可能分数
    "show_health_bar": 1,                // 显示血条
    "show_opponent_alpha": 1,             // 显示对手透明度
    "show_note_Splashes": 1,              // 显示溅墨特效
	"sick_number": 0,
	"good_number": 0,
	"bad_number": 0,
	"shit_number": 0,
	"player_die": false,
	"Note_arrow_alpha":[1,1],
	"characters_alpha":[1,1],
	"Target_ui_scale":1,
	"Target_cam_scale":1,
};
global.Game_inf.Target_cam_scale = 2
// ==================== 全局变量初始化 ====================
global.arrow_draw = []
global.player_i = obj_player;              // 玩家对象
global.player_o = obj_player_opponent;      // 对手对象
global.input_latency_test = false;          // 输入延迟测试开关
global.input_timestamp = 0;                 // 输入时间戳
global.check_map = {                        // 按键状态映射
    "left_pressed": false,
    "down_pressed": false,
    "up_pressed": false,
    "right_pressed": false,
    "left": false,
    "down": false,
    "up": false,
    "right": false
};

// ==================== 游戏核心变量 ====================
depth = -20;                                // 对象深度
video_played = false;                       // 视频播放状态
cam_move_type = global.player_o;            // 摄像机跟随目标
shader = shader_invert;                      // 使用的着色器
uniform_invert = -1;                         // 着色器参数
icon_scale = -1;                             // 图标缩放
Ui_Zoom = 1;                                 // UI缩放
angle = 0;                                   // 旋转角度

// ==================== 游戏状态变量 ====================
Game_start_pos = 1;                          // 游戏起始位置
Game_start_pos_time = 0;                      // 起始位置时间
a_time = 0;                                   // 动画时间
global.game_play = 0;                         // 0:暂停, 1:播放

// ==================== 计时相关变量 ====================
time_bot = 0
Shooting_duration = 0;                        // 射击持续时间
Shooting_time = 0;                            // 当前射击时间
Shooting_time_last = 0;                        // 上一帧射击时间
Read_table_position = 0;                       // 读取表格位置
song_time = 0;                                 // 歌曲当前时间
song_last_time = get_timer() / 1000;           // 上一帧时间（秒）
song_time_show = "";                           // 显示用的时间字符串
show_text = "";                                // 显示文本

// ==================== 循环计数器 ====================
i = 1;                                         // 通用循环变量
n = 0;                                         // 通用循环变量
events_i = 0;                                  // 当前事件索引
event_n = 0;                                   // 事件计数器

// ==================== 系统设置 ====================
// Windows系统下优化键盘响应（Create事件中执行）
if (os_type == os_windows) {
    // 设置键盘重复速度和延迟以提高响应性
    var dll = external_define("user32.dll", "SystemParametersInfoA", dll_cdecl, 
        ty_real, 4, ty_real, ty_real, ty_real, ty_real);
    external_call(dll, 0x000B, 31, 0, 0);  // SPI_SETKEYBOARDSPEED = 31
    external_call(dll, 0x0017, 0, 0, 0);   // SPI_SETKEYBOARDDELAY = 0
}

// ==================== 摄像机设置 ====================
enum RES {
    WIDTH = 1280,
    HEIGHT = 720,
    SCALE = 4
}

// 创建并应用摄像机
global._camera = camera_create_view(0, 0, RES.WIDTH, RES.HEIGHT, 0, noone, -1, -1, RES.WIDTH / 2, RES.HEIGHT / 2);
view_enabled = true;
view_visible[0] = true;
view_set_camera(0, global._camera);

// ==================== 歌曲数据加载 ====================
var Game_engine_type = "NE";

// 构建JSON文件路径
var json_path = working_directory + "assets\\songs\\" + string(global.song_get.song) + 
                "\\charts\\" + string(global.song_get.song) + "-" + 
                string(global.song_get.difficulties) + ".json";

// 检查文件是否存在
if (!file_exists(json_path)) {
    show_message("Error: 找不到JSON文件\n路径: " + json_path);
    game_end(1);
}

// 加载并解析JSON文件
var file_content = buffer_load(json_path);
var json_string = buffer_read(file_content, buffer_string);
buffer_delete(file_content);
global.song_file = json_parse(json_string);

// ==================== 歌曲信息初始化 ====================
global.Song_information = {
    "player1": "null",          // 玩家角色
    "player2": "null",          // 对手角色
    "song": "name",             // 歌曲名称
    "validScore": true,
    "speed": 2,                 // 滚动速度
    "gfVersion": "gf-dozirc",
    "splashSkin": "notes/noteSplashes_quant",      // 溅墨特效皮肤
    "arrowSkinDAD": "notes/Notes_Dozirc",          // 对手箭头皮肤
    "arrowSkinBF": "notes/Notes_Dozirc",           // 玩家箭头皮肤
    "charter": "MaliciousBunny",
    "vocalVol": 1,              // 人声音量
    "instVol": 1,               // 伴奏音量
    "stage": "sloth",
    "sections": 45,
    "needsVoices": true,
    "bpm": 128,                 // BPM
    "notes_data": [],           // 音符数据
    "events_data": []            // 事件数据
};

// 从加载的文件中填充歌曲信息
global.Song_information.player1 = global.song_file.song.player1;
global.Song_information.player2 = global.song_file.song.player2;
global.Song_information.song = global.song_file.song.song;
global.Song_information.notes_data = global.song_file.song.notes;
global.Song_information.bpm = global.song_file.song.bpm;
global.Song_information.events_data = global.song_file.song.events;

// 设置窗口标题
window_set_caption("Friday Night Funkin-Neon Engine - " + string(global.Song_information.song));

// ==================== 音频加载 ====================
// 加载伴奏（Inst）
if (file_exists(working_directory + "assets\\songs\\" + string(global.song_get.song) + "\\song\\Inst.ogg")) {
    load_s = audio_create_stream(working_directory + "assets\\songs\\" + string(global.song_get.song) + "\\song\\Inst.ogg");
    song_sound1 = audio_play_sound(load_s, 0, 0);
} else {
    song_sound1 = audio_play_sound(Voices1_1, 0, 0);  // 默认音效
}

// 加载人声（Voices）
if (file_exists(working_directory + "assets\\songs\\" + string(global.song_get.song) + "\\song\\Voices.ogg")) {
    load_s1 = audio_create_stream(working_directory + "assets\\songs\\" + string(global.song_get.song) + "\\song\\Voices.ogg");
    song_sound2 = audio_play_sound(load_s1, 0, 0);
} else {
    song_sound2 = audio_play_sound(Voices1_1, 0, 0);  // 默认音效
}

song_sound3 = audio_play_sound(Voices1_1, 0, 0);  // 备用音效

// 音频控制（初始暂停）
audio_pause_sound(obj_main.song_sound1);
audio_pause_sound(obj_main.song_sound2);
audio_pause_sound(obj_main.song_sound3);

// ==================== 创建音符接收器（玩家侧） ====================
obj_left_arrow = instance_create_depth(790, 100, -10, obj_arrow);
obj_left_arrow.Note_Direction = 0;
obj_left_arrow.Note_mustHitSection = 1;

obj_down_arrow = instance_create_depth(790 + 115, 100, -10, obj_arrow);
obj_down_arrow.Note_Direction = 1;
obj_down_arrow.Note_mustHitSection = 1;

obj_up_arrow = instance_create_depth(790 + 230, 100, -10, obj_arrow);
obj_up_arrow.Note_Direction = 2;
obj_up_arrow.Note_mustHitSection = 1;

obj_right_arrow = instance_create_depth(790 + 345, 100, -10, obj_arrow);
obj_right_arrow.Note_Direction = 3;
obj_right_arrow.Note_mustHitSection = 1;

// ==================== 创建音符接收器（对手侧） ====================
obj_opponent_left_arrow = instance_create_depth(135, 100, -10, obj_arrow);
obj_opponent_left_arrow.Note_Direction = 0;
obj_opponent_left_arrow.Note_mustHitSection = 0;

obj_opponent_down_arrow = instance_create_depth(135 + 115, 100, -10, obj_arrow);
obj_opponent_down_arrow.Note_Direction = 1;
obj_opponent_down_arrow.Note_mustHitSection = 0;

obj_opponent_up_arrow = instance_create_depth(135 + 230, 100, -10, obj_arrow);
obj_opponent_up_arrow.Note_Direction = 2;
obj_opponent_up_arrow.Note_mustHitSection = 0;

obj_opponent_right_arrow = instance_create_depth(135 + 345, 100, -10, obj_arrow);
obj_opponent_right_arrow.Note_Direction = 3;
obj_opponent_right_arrow.Note_mustHitSection = 0;

// ==================== 创建音符接收器（其它人侧） ====================


// ==================== 创建背景 ====================
instance_create_depth(0, 0, 100, obj_beijin_spr);

// ==================== 调试与测试变量 ====================
show_debug_log(1);                          // 启用调试日志
test_zx = 0;                                 // 测试变量ZX
test_hc_a = 0;                               // 测试变量HC_A
test_time = 0;                               // 测试时间变量