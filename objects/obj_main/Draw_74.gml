/// @description 主UI绘制脚本 - 处理游戏界面渲染

//==============================================================================
// 基础变量初始化
//==============================================================================
// 获取UI表面的宽高
var w = surface_get_width(global.ui_surface);
var h = surface_get_height(global.ui_surface);

// 屏幕中心坐标 (基于1280x720分辨率)
var center_x = 640;  
var center_y = 360;  

// 获取帧时间用于动画同步
var fps_time = global.fps_time;

//==============================================================================
// UI缩放与旋转动画
//==============================================================================
// UI缩放系数
var scale_x = Ui_Zoom; 
var scale_y = Ui_Zoom; 

// 游戏运行时更新动画参数
if global.game_paused = 0 and global.game_play = 1 {
    // 累积时间用于动画
    test_time += 2 * fps_time;
    
    // 音符速度波动效果 (未使用)
    var speed_note_arrow = func_frc((cos(test_time / 10 + 0.5) * 100));
    // 测试变量 (未使用)
    var fun_test = func_frc(cos(test_time / 2) * 5);
    // 正弦波动 (未使用)
    var test_a = sin(test_time) * 20;
}

// 角度转弧度
var angle_rad = -angle * pi / 180;

//==============================================================================
// 计算旋转后的UI位置
//==============================================================================
// 考虑缩放后的位置计算
// 公式说明: 以中心点为基准，计算旋转缩放后的表面左上角位置
var _x = center_x - (w * scale_x / 2) * cos(angle_rad) + (h * scale_y / 2) * sin(angle_rad);
var _y = center_y - (w * scale_x / 2) * sin(angle_rad) - (h * scale_y / 2) * cos(angle_rad);

// 绘制UI表面 (带缩放、旋转和抖动效果)
draw_surface_ext(
    global.ui_surface, 
    _x + global.Game_inf.ui_shark_shake_x,  // X坐标 + 水平抖动
    _y + global.Game_inf.ui_shark_shake_y,  // Y坐标 + 垂直抖动
    scale_x, scale_y,   // 缩放系数
    angle,              // 旋转角度
    c_white,            // 混合颜色
    1                   // 透明度
);

//==============================================================================
// 设置UI表面渲染目标
//==============================================================================
surface_set_target(global.ui_surface);
draw_clear_alpha(c_black, 0);  // 清除表面为全透明
draw_set_color(c_white);

//==============================================================================
// 血条绘制
//==============================================================================
// 血条位置
var _draw_heath_bar_x = 200;
var _draw_heath_bar_y = 620;

// 获取血条精灵尺寸
var spr_w = sprite_get_width(Heathbar_bar);
var spr_h = sprite_get_height(Heathbar_bar);

//==============================================================================
// 绘制血条
//==============================================================================
var draw_color_i = #FFFFFF;  // 玩家颜色
var draw_color_o = #FFFFFF;  // 对手颜色

if global.Game_inf.show_health_bar {
    // 设置颜色 (从角色对象获取)
    draw_color_o = global.player_o.color;
    draw_color_i = global.player_i.color;
    
    // 绘制血条背景 (空血条部分)
    draw_sprite_ext(
        Heathbar_bar, 0, 
        _draw_heath_bar_x + 40, _draw_heath_bar_y,  // 位置
        0.6, 0.6,  // 缩放
        0,         // 角度
        draw_color_i,  // 颜色 (对手方)
        1          // 透明度
    );
    
    // 计算血条填充宽度 (基于当前血量)
    // 注意: 血量越低，填充宽度越大 (对手血条是从左到右填充)
    var fill_width = spr_w * ((100 - global.Game_inf.heath) / 100);
    
    // 绘制血条填充部分 (动态宽度)
    draw_sprite_part_ext(
        Heathbar_bar, 
        0,
        0, 0,                    // 源图起始位置
        fill_width, spr_h,       // 要绘制的宽度和高度
        _draw_heath_bar_x + 40, _draw_heath_bar_y,  // 目标位置
        0.6, 0.6,                // 缩放
        draw_color_o,             // 颜色 (玩家方)
        1                         // 透明度
    );
    
    // 绘制血条边框覆盖层
    draw_sprite_ext(
        Heathbar_overlay, 0,
        _draw_heath_bar_x, _draw_heath_bar_y,
        0.6, 0.6, 0, c_white, 1
    );

    //==============================================================================
    // 绘制角色图标 (跟随血条进度)
    //==============================================================================
    // 计算图标X位置 (基于血条填充宽度)
    var icon_x = _draw_heath_bar_x + 40 + fill_width * 0.6; // 考虑0.6缩放
    var icon_y = _draw_heath_bar_y; // 垂直居中
    
    // 图标缩放动画
    icon_scale += func_frc((-1 - icon_scale) / 6);
    
    // 调整图标位置 (镜像时需要偏移)
    icon_x -= 150;
    
    // 绘制BF图标 (镜像效果: 负缩放值)
    //draw_sprite_ext(
    //    icon_bf, 
    //    0, 
    //    icon_x + 200, 
    //    icon_y + 40, 
    //    icon_scale, -icon_scale,  // 水平正常，垂直镜像
    //    0, 
    //    c_white, 
    //    1
    //);
	draw_sprite_general(
        obj_player.character_icon, 0,
        0,
        0,
        150*get_icon_heath(global.Game_inf.heath),
        150,
        icon_x + 200 + 75, 
        icon_y + 40 - 75, 
        icon_scale, 
		-icon_scale,
        0,
        c_white, c_white, c_white, c_white,
        1
	);
    // 绘制对手图标
	draw_sprite_general(
        obj_player_opponent.character_icon, 0,
        0,
        0,
        150*get_icon_heath(global.Game_inf.heath),
        150,
        icon_x, 
        icon_y + 40 - 75, 
        -icon_scale, 
		-icon_scale,
        0,
        c_white, c_white, c_white, c_white,
        1
	);
    //draw_sprite_ext(
    //    icon_nightflaid, 
    //    get_icon_heath(global.Game_inf.heath), 
    //    icon_x + 90, 
    //    icon_y + 40, 
    //    -icon_scale, -icon_scale,  // 水平镜像，垂直镜像
    //    0, 
    //    c_white, 
    //    1
    //);
}

//==============================================================================
// 文本信息绘制
//==============================================================================
// UI文本起始Y坐标
var _draw_ui_y = 570;

// 获取当前播放时间和总时长
var display_time = seconds_to_min_sec(audio_sound_get_track_position(song_sound1)); 
var remaining_time = seconds_to_min_sec(audio_sound_length(song_sound1));

if global.Game_inf.player_die != true {
	/**
	 * 带描边的文本绘制函数
	 * @param {string} text - 要绘制的文本
	 * @param {real} x - X坐标
	 * @param {real} y - Y坐标
	 * @param {real} scale_x - 水平缩放
	 * @param {real} scale_y - 垂直缩放
	 * @param {color} outline_color - 描边颜色
	 * @param {color} text_color - 文字颜色
	 * @param {real} angle - 旋转角度
	 * @param {sprite} font - 字体精灵
	 */
	draw_Outline("Game fps : " + string(fps), 15, _draw_ui_y - 80, 1, 1, c_black, c_white, 0, Font_vcr);
	draw_Outline("Heath : " + string(global.Game_inf.heath), 15, _draw_ui_y - 50, 1, 1, c_black, c_white, 0, Font_vcr);

	// 计算准确率 (总分/最大分 * 100)
	global.Game_inf.accuracy = (global.Game_inf.total_score / global.Game_inf.max_score) * 100;
	draw_Outline("ACC : " + string(global.Game_inf.accuracy) + "%", 15, _draw_ui_y - 20, 1, 1, c_black, c_white, 0, Font_vcr);

	// 游戏版本信息
	draw_Outline("FNF - NE BETA 0.0.1", 15, _draw_ui_y, 1, 1, c_black, c_white, 0, Font_vcr);

	// 时间显示 (剩余时间/当前时间)
	draw_Outline("TIME: " + string(remaining_time) + " | " + string(display_time), 15, _draw_ui_y + 30, 1, 1, c_black, c_white, 0, Font_vcr);

	//==============================================================================
	// 自动播放模式(BOTPLAY)提示
	//==============================================================================
	if global.Game_inf.BOTPLAY = 1{
	    draw_set_color(c_grey);
	    draw_set_halign(fa_center);
	    draw_set_valign(fa_middle);
    
	    // 闪烁效果
	    draw_set_alpha(abs(sin(time_bot)));
	    draw_Outline("BOTPLAY", 1280 / 2, 100, 1.3, 1.3, c_black, c_white, 0, Font_vcr);
    
	    // 恢复设置
	    draw_set_alpha(1);
	    draw_set_halign(fa_left);
	    draw_set_valign(fa_top);
	    draw_set_color(c_white);
	}

	// 绘制其他游戏信息
	draw_Outline("noone", 15, _draw_ui_y + 60, 1, 1, c_black, c_white, 0, Font_vcr);
	draw_Outline("Combo_note : " + string(global.Game_inf.Combo_note), 15, _draw_ui_y + 90, 1, 1, c_black, c_white, 0, Font_vcr);
	draw_Outline("Miss: " + string(global.Game_inf.miss_note), 15, _draw_ui_y + 120, 1, 1, c_black, c_white, 0, Font_vcr);

	// 保存时间字符串供其他地方使用
	song_time_show = ("TIME: " + string(remaining_time) + " | " + string(display_time));

	//==============================================================================
	// 执行歌曲事件
	//==============================================================================
	events_game(global.Song_information.song);

}

//==============================================================================
// 结束UI表面渲染
//==============================================================================
surface_reset_target();























