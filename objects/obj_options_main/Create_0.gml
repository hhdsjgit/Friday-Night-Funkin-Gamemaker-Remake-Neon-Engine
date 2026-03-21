/// @description 设置菜单初始化 - 修复版

// ==================== 基础变量 ====================
choose_setting = 0;
ui_y = 0;
draw_alpha = 1;
In_Controls = false;
choose_controls = [0,0]//x y
choose_controls_draw = [["LEFT",0],["DOWN",0],["UP",0],["RIGHT",0]]
choose_controls_y = 0
// ==================== 菜单选项 ====================
test_need_draw = {
    "options": ["CONTROLS", "GAMEPLAY >", "APPEARANCE >", "MISCELLANEOUS >", "SHARDER >"],
    "options_gameplay": ["DOWNSCROLL", "GHOST TRAPPING", "SONG OFFSET", "NAUGHTYNESS", "CAMERA ZOOM ON BEAT", "BUBBLE SORT"],
    "options_appearance": ["TEST0", "TEST1", "TEST2", "TEST3"]
};

// ==================== 动画变量 ====================
time = 0;
sound_scroll = scroll;
now_need_read = test_need_draw.options;
last_need_read = test_need_draw.options;
buff_x = 50;
last_buff_x = -1000;
buff_time = 0;
fanzhuan = false;

// ==================== 设置项动画数组 ====================
// 只包含有动画的设置项
setting_anims = [
    ["DOWNSCROLL", 0, 0],
    ["GHOST TRAPPING", 0, 0],
    ["BUBBLE SORT", 0, 0],
	["TEST0", 0, 0]
];

// ==================== 判断是否是开关设置 ====================
function is_toggle_setting(name) {
    var _toggles = ["DOWNSCROLL", "GHOST TRAPPING", "BUBBLE SORT", 
                    "NAUGHTYNESS", "CAMERA ZOOM ON BEAT","TEST0"];
    
    for (var i = 0; i < array_length(_toggles); i++) {
        if (_toggles[i] == name) return true;
    }
    return false;
}

// ==================== 获取设置值 ====================
function get_setting(name, value) {
    // 如果不是开关设置，直接返回
    if (!is_toggle_setting(name)) {
        if (name == "SONG OFFSET") {
            return global.setting_game.SONG_OFFSET;
        }
        return false;
    }
    
    // 查找对应的动画数据
    var _anim_index = -1;
    for (var i = 0; i < array_length(setting_anims); i++) {
        if (setting_anims[i][0] == name) {
            _anim_index = i;
            break;
        }
    }
    
    // 处理切换动画
    if (value == 1 && _anim_index >= 0) {
        var _current = global.setting_game[$ name];
        
        if (_current) {
            // 关闭动画
            setting_anims[_anim_index][1] = 11;
            setting_anims[_anim_index][2] = -1;
        } else {
            // 开启动画
            setting_anims[_anim_index][2] = 1;
            setting_anims[_anim_index][1] = 0;
        }
        
        global.setting_game[$ name] = !_current;
    }
    
    return global.setting_game[$ name];
}

// ==================== 获取动画值 ====================
function get_draw_anim(name) {
    // 如果不是开关设置，返回无动画
    if (!is_toggle_setting(name)) {
        return [0, 0];
    }
    
    // 查找动画数据
    for (var i = 0; i < array_length(setting_anims); i++) {
        if (setting_anims[i][0] == name) {
            return [setting_anims[i][1], setting_anims[i][2]];
        }
    }
    
    return [0, 0];
}

// ==================== 获取复选框精灵 ====================
function get_draw_box(value) {
    switch (value) {
        case 0: return Check_Box_unselected;
        case 1: return Check_Box_Selected_Static;
        case -1: return Check_Box_selecting_animation;
    }
    return spr_empty;
}

// ==================== 更新动画帧 ====================
function update_animations() {
    for (var i = 0; i < array_length(setting_anims); i++) {
        var _anim = setting_anims[i];
        
        // 处理关闭动画（递减）
        if (_anim[2] == -1) {
            _anim[1]--;
            if (_anim[1] <= 0) {
                _anim[2] = 0;
                _anim[1] = 0;
            }
        }
        // 处理开启动画（递增）
        else if (_anim[2] == 1) {
            _anim[1]++;
            if (_anim[1] >= 10) {
                _anim[2] = 0;
                _anim[1] = 0;
            }
        }
    }
}


function can_use_options (_bool) {
	if _bool {
		obj_options_main.fanzhuan = true
		obj_options_main.last_buff_x =100
		obj_options_main.buff_x = -1000	
	}else{
		obj_options_main.fanzhuan = false
		obj_options_main.last_buff_x = 100
		obj_options_main.buff_x = 1500
	}
}