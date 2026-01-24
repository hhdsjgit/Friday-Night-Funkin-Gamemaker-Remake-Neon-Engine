/// @description 
/// 创建着色器（在创建事件中）





/// 绘制事件中使用

//shader_set(shader_invert);
    
//// 获取uniform位置（如果尚未获取）
//if (uniform_invert == -1) {
//    uniform_invert = shader_get_uniform(shader_invert, "invert");
//}
    
//// 设置反转参数：0=正常，1=反转
//var should_invert = 1;  // 或 1
//shader_set_uniform_f(uniform_invert, should_invert);
    
//// 绘制精灵
//draw_surface(application_surface,0,0)
    
//shader_reset();
//surface_reset_target();




var w = surface_get_width(global.ui_surface);
var h = surface_get_height(global.ui_surface);
var center_x = 640;  // 中心x坐标
var center_y = 360;  // 中心y坐标

// 缩放系数（示例：随时间变化的缩放）
//var scale_x = 1 + 0.05 * cos(test_time);  // 在0.8到1.2之间缩放
//var scale_y = 1 + 0.05 * cos(test_time);  // 不同的缩放节奏
//Ui arrow箭头运动X


//obj_left_arrow.y = sin(test_time + 0.4) * 30 + 100
//obj_down_arrow.y= sin(test_time + 0.5) * 30 + 100
//obj_up_arrow.y = sin(test_time + 0.6) * 30 + 100
//obj_right_arrow.y = sin(test_time + 0.7) * 30 + 100

//obj_opponent_left_arrow.y = sin(test_time) * 30 + 100
//obj_opponent_down_arrow.y = sin(test_time + 0.1) * 30 + 100
//obj_opponent_up_arrow.y = sin(test_time + 0.2) * 30 + 100
//obj_opponent_right_arrow.y = sin(test_time + 0.3) * 30 + 100



//END
var fps_time = global.fps_time
//Ui缩放
var scale_x = Ui_Zoom; 
var scale_y = Ui_Zoom; 
// 角度变化
if global.game_paused = 0 and global.game_play = 1{
	test_time += 2 * fps_time 
	var speed_note_arrow = func_frc((cos(test_time / 10 + 0.5) *100))
	var fun_test = func_frc(cos(test_time / 2) * 5)

	var test_a = sin(test_time) * 20

}




var angle_rad = -angle * pi / 180;

// 考虑缩放后的计算
// 缩放会影响表面的有效尺寸，所以偏移量也要乘以缩放系数
var _x = center_x - (w * scale_x / 2) * cos(angle_rad) + (h * scale_y / 2) * sin(angle_rad);
var _y = center_y - (w * scale_x / 2) * sin(angle_rad) - (h * scale_y / 2) * cos(angle_rad);

// 绘制时传入缩放参数
draw_surface_ext(global.ui_surface, _x + global.Game_inf.ui_shark_shake_x, _y + global.Game_inf.ui_shark_shake_y, scale_x, scale_y, angle, c_white, 1);
//draw_surface_ext(global.ui_surface,0,0,1,1,10,c_white,1)
//draw_surface(global.ui_surface,0,0)

surface_set_target(global.ui_surface);
draw_clear_alpha(c_black, 0);
draw_set_color(c_white)


//draw_sprite_ext(Heathbar_bar,0,640,688,0.4649515,0.4649515,0,c_blue,1)

var _draw_heath_bar_x = 200 ,_draw_heath_bar_y = 620 ;

var spr_w = sprite_get_width(Heathbar_bar);
var spr_h = sprite_get_height(Heathbar_bar);

if keyboard_check(vk_f10) {
	test_zx -= 1	
	show_debug_message(test_zx)
}
if keyboard_check(vk_f11) {
	test_zx += 1	
	show_debug_message(test_zx)
}
// 1. 先绘制空的部分（白色/背景色）
draw_sprite_ext(Heathbar_bar, 0, _draw_heath_bar_x + 40,_draw_heath_bar_y,0.6,0.6, 0, c_blue, 1);
// 从左到右的进度
var fill_width = spr_w * ((100-global.Game_inf.heath) / 100);
global.Game_inf.heath = clamp(global.Game_inf.heath,0,100)

// 使用部分绘制，只绘制进度内的区域
draw_sprite_part_ext(
    Heathbar_bar, 
    0,
    0, 0,                    // 源图的起始位置
    fill_width, spr_h,       // 要绘制的宽度和高度
    _draw_heath_bar_x + 40, _draw_heath_bar_y,                  // 目标位置
    0.6,0.6,                   // 缩放
    c_white,              // 颜色
    1                        // 透明度
);
draw_sprite_ext(Heathbar_overlay,0,_draw_heath_bar_x,_draw_heath_bar_y,0.6,0.6,0,c_white,1)

// 5. 绘制BF图标，跟随血条进度
var icon_x = _draw_heath_bar_x + 40 + fill_width * 0.6; // 考虑0.6缩放
var icon_y = _draw_heath_bar_y; // 垂直居中
// 根据BF的方向决定是否镜像（如果是面向左边）
icon_scale += func_frc((-1-icon_scale) / 6);
icon_x -= sprite_get_width(icon_bf); // 镜像时需要调整位置
draw_sprite_ext(
    icon_bf, 
    0, 
    icon_x+200, 
    icon_y+40, 
    icon_scale, -icon_scale, // 水平和垂直缩放
    0, 
    c_white, 
    1
);
function get_icon_heath (heath) {
	if heath >= 85 {
		return 1	
	}else if heath < 85 and heath > 15{
		return 0
	}else{
		return 2	
	}
}
draw_sprite_ext(
    icon_nightflaid, 
    get_icon_heath(global.Game_inf.heath), 
    icon_x+90, 
    icon_y+40, 
    -icon_scale, -icon_scale, // 水平和垂直缩放
    0, 
    c_white, 
    1
);
// 设置水平和垂直对齐方式
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

//draw_text_transformed(640,700,"Combo_note : " + string(global.Game_inf.Combo_note),1.1,1.1,0)
//draw_Outline("Combo_note : " + string(global.Game_inf.Combo_note),640,700,1,1,c_black,c_white,0,Font_vcr)

// 恢复默认对齐方式
draw_set_halign(fa_left);
draw_set_valign(fa_top);

var _draw_ui_y = 570
var display_time = seconds_to_min_sec(audio_sound_get_track_position(song_sound1)); 
var remaining_time = seconds_to_min_sec(audio_sound_length(song_sound1))
draw_Outline("Game fps : " + string(fps),15,_draw_ui_y - 80,1,1,c_black,c_white,0,Font_vcr)
draw_Outline("Heath : " + string(global.Game_inf.heath),15,_draw_ui_y - 50,1,1,c_black,c_white,0,Font_vcr)

global.Game_inf.accuracy = (global.Game_inf.total_score / global.Game_inf.max_score) * 100
draw_Outline("ACC : " + string(global.Game_inf.accuracy) + "%",15,_draw_ui_y - 20,1,1,c_black,c_white,0,Font_vcr)

draw_Outline("FNF - NE BETA 0.0.1",15,_draw_ui_y,1,1,c_black,c_white,0,Font_vcr)
draw_Outline("TIME: " + string(remaining_time) + " | " + string(display_time),15,_draw_ui_y + 30,1,1,c_black,c_white,0,Font_vcr)
if global.Game_inf.BOTPLAY = 1 {
	draw_set_color(c_grey)
	draw_set_halign(fa_center);
	draw_set_valign(fa_middle);
	
	image_alpha = sin(test_time/10)
	draw_Outline("BOTPLAY",1280/2,100,1.3,1.3,c_black,c_white,0,Font_vcr)
	image_alpha = 1
	draw_set_halign(fa_left);
	draw_set_valign(fa_top);
	draw_set_color(c_white)
	
	//draw_Outline("Now Bot Playing!!!!!",15,_draw_ui_y + 60,1,1,c_black,c_white,0,Font_vcr)
}else{
	//draw_Outline("Now Player Playing!!!!!",15,_draw_ui_y + 60,1,1,c_black,c_white,0,Font_vcr)
}
draw_Outline("noone",15,_draw_ui_y + 60,1,1,c_black,c_white,0,Font_vcr)
draw_Outline("Combo_note : " + string(global.Game_inf.Combo_note),15,_draw_ui_y + 90,1,1,c_black,c_white,0,Font_vcr)
draw_Outline("Miss: " + string(global.Game_inf.miss_note),15,_draw_ui_y + 120,1,1,c_black,c_white,0,Font_vcr)
//draw_Outline("Miss: " + string(global.Game_inf.miss_note),900,300,1,1,c_black,c_white,0,Font_vcr)
/* Cam debug
draw_Outline("Cam_x : " + string(global.Game_inf.cam_x),15,180,1,1,c_black,c_white,0,Font_vcr)
draw_Outline("Cam_y : " + string(global.Game_inf.cam_y),15,210,1,1,c_black,c_white,0,Font_vcr)
draw_Outline("Cam_scale : " + string(global.Game_inf.cam_scale),15,240,1,1,c_black,c_white,0,Font_vcr)
*/
song_time_show = ("TIME: " + string(remaining_time) + " | " + string(display_time))
//draw_Outline(audio_sound_get_track_position(song_sound1),100,200,1,1,c_black,c_white,0,Font_vcr)
surface_reset_target();


events_game(global.Song_information.song)