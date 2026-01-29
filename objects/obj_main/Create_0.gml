/// @description

global.input_latency_test = false;
global.input_timestamp = 0;
global.check_map = 
{
	"left_pressed":false,
	"down_pressed":false,
	"up_pressed":false,
	"right_pressed":false,
	"left":false,
	"down":false,
	"up":false,
	"right":false
	
}


// 在Create事件中设置键盘重复率（Windows API调用）
if os_type == os_windows {
    // 尝试设置更高的键盘响应率
    var dll = external_define("user32.dll", "SystemParametersInfoA", dll_cdecl, 
        ty_real, 4, ty_real, ty_real, ty_real, ty_real);
    
    // SPI_SETKEYBOARDSPEED (键盘重复速度)
    external_call(dll, 0x000B, 31, 0, 0);
    
    // SPI_SETKEYBOARDDELAY (键盘重复延迟)
    external_call(dll, 0x0017, 0, 0, 0);
}
test_zx = 0
depth = -20
video_played = false;
cam_move_type = obj_opponent_player
shader = shader_invert;
uniform_invert = -1;

Game_start_pos = 1
Game_start_pos_time = 0
a_time = 0

//创建摄像机

enum RES {
	WIDTH = 1280,
	HEIGHT = 720,
	SCALE = 4,
}

global._camera = camera_create_view(0,0, RES.WIDTH,RES.HEIGHT,0,noone,-1,-1,RES.WIDTH / 2,RES.HEIGHT/2);

view_enabled = true
view_visible[0] = true

view_set_camera(0, global._camera)

//TEST
test_hc_a = 0

//TEST END

show_debug_log(1)

//Game main
var Game_engine_type = "NE"
if !file_exists(working_directory + "\\song_test.json") {
	show_message("Error:NO find json file")
	game_end()	
}
//var file_content = buffer_load(working_directory + "\\song_test.json")//lang_en()
//var file_content = buffer_load(working_directory + "\\assets\\songs\\test-song\\charts\\catastrofiend.json")
var file_content = buffer_load(working_directory + "\\assets\\songs\\extirpatient\\charts\\extirpatient-hell.json")

var json_string = buffer_read(file_content, buffer_string);
buffer_delete(file_content);
global.song_file = json_parse(json_string);
global.Song_information = 
{
	"player1": "null", //人物1
	"player2": "null", //人物2
	
	"song": "name", //歌曲名称
	"validScore": true,
	"speed": 2, //输出
	"gfVersion": "gf-dozirc",
	
	"splashSkin": "notes/noteSplashes_quant", //喷溅皮肤
	"arrowSkinDAD": "notes/Notes_Dozirc", //对手箭头皮肤
	"arrowSkinBF": "notes/Notes_Dozirc", //玩家箭头皮肤
	"charter": "MaliciousBunny",
	
	"vocalVol": 1, //需要人声
	"instVol": 1, //需要inst
	"stage": "sloth",
	"sections": 45,
	"needsVoices": true,
	"bpm": 128, //节拍
	
	"notes_data":[],
	"events_data":[],
}
/*
global.Song_information.player1 = global.song_file.song.player1
global.Song_information.player2 = global.song_file.song.player2
global.Song_information.song = global.song_file.song.song
global.Song_information.notes_data = global.song_file.song.notes
global.Song_information.bpm = global.song_file.song.bpm
*/
global.Song_information.player1 = global.song_file.song.player1
global.Song_information.player2 = global.song_file.song.player2
global.Song_information.song = global.song_file.song.song
global.Song_information.notes_data = global.song_file.song.notes
global.Song_information.bpm = global.song_file.song.bpm
global.Song_information.events_data = global.song_file.song.events

window_set_caption("Friday Night Funkin-Neon Engine - " + string(global.Song_information.song))
//主要计算
Shooting_duration = 0
Shooting_time = 0
Shooting_time_last = 0
Read_table_position = 0

i = 1
n = 0

icon_scale = -1
Ui_Zoom = 1
song_time_show = ""
/*
var step_s = audio_create_stream(Path_init("Path_sound","step\\"+ "Run" + string(round(random_range(0,7.5))) + ".ogg"))
audio_play_sound(step_s,0,0)*/
load_s = audio_create_stream(working_directory + "\\assets\\songs\\extirpatient\\song\\Inst.ogg")
load_s1 = audio_create_stream(working_directory + "\\assets\\songs\\extirpatient\\song\\Voices.ogg")
//load_s2 = audio_create_stream(working_directory + "\\assets\\songs\\extirpatient\\song\\VoicesInsatian.ogg")


//load_s = audio_create_stream(working_directory + "\\assets\\songs\\test-song\\song\\Inst.ogg")
//load_s1 = audio_create_stream(working_directory + "\\assets\\songs\\test-song\\song\\Voices.ogg")
song_sound1=audio_play_sound(load_s,0,0)
song_sound2=audio_play_sound(load_s1,0,0)
song_sound3=audio_play_sound(Voices1_1,0,0)

global.game_play = 0
audio_pause_sound(obj_main.song_sound1);
audio_pause_sound(obj_main.song_sound2);
audio_pause_sound(obj_main.song_sound3);
	
song_time = 0
song_last_time = get_timer() / 1000
show_text = ""

angle = 0
test_time = 0

global.ui_surface = surface_create(1280,720)


global.Game_inf = {
	"miss_note":0,
	"Combo_note":0,
	"BOTPLAY":0,
	"Note_player2_0":false,
	"Note_player2_1":false,
	"Note_player2_2":false,
	"Note_player2_3":false,
	"Note_player1_0":false,
	"Note_player1_1":false,
	"Note_player1_2":false,
	"Note_player1_3":false,
	"heath":50,
	"cam_scale":1,
	"cam_last_scale":1,
	"cam_scale_changed":1,
	"cam_x":0,
	"cam_y":0,
	"cam_shark_shake_x":0,
	"cam_shark_shake_y":0,
	"ui_shark_shake_x":0,
	"ui_shark_shake_y":0,
	"total_score":0,
	"accuracy":100,
	"max_score":0,
}


//创建箭头 玩家

obj_left_arrow=instance_create_depth(790,100,-10,obj_arrow)
obj_left_arrow.Note_Direction = 0
obj_left_arrow.Note_mustHitSection=1

obj_down_arrow=instance_create_depth(790 + 115,100,-10,obj_arrow)
obj_down_arrow.Note_Direction = 1
obj_down_arrow.Note_mustHitSection=1

obj_up_arrow=instance_create_depth(790 + 230,100,-10,obj_arrow)
obj_up_arrow.Note_Direction = 2
obj_up_arrow.Note_mustHitSection=1

obj_right_arrow=instance_create_depth(790 + 345,100,-10,obj_arrow)
obj_right_arrow.Note_Direction = 3
obj_right_arrow.Note_mustHitSection=1

//创建箭头 对手
obj_opponent_left_arrow = instance_create_depth(135, 100, -10, obj_arrow)
obj_opponent_left_arrow.Note_Direction = 0
obj_opponent_left_arrow.Note_mustHitSection = 0

obj_opponent_down_arrow = instance_create_depth(135 + 115, 100, -10, obj_arrow)
obj_opponent_down_arrow.Note_Direction = 1
obj_opponent_down_arrow.Note_mustHitSection = 0

obj_opponent_up_arrow = instance_create_depth(135 + 230, 100, -10, obj_arrow)
obj_opponent_up_arrow.Note_Direction = 2
obj_opponent_up_arrow.Note_mustHitSection = 0

obj_opponent_right_arrow = instance_create_depth(135 + 345, 100, -10, obj_arrow)
obj_opponent_right_arrow.Note_Direction = 3
obj_opponent_right_arrow.Note_mustHitSection = 0


instance_create_depth(0,0,100,obj_beijin_spr)



//events_data
events_i = 0
event_n = 0





