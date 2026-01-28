/// @description
json = {}
var file_content = buffer_load(working_directory + "\\assets\\songs\\extirpatient\\charts\\extirpatient-hell.json")

var json_string = buffer_read(file_content, buffer_string);
buffer_delete(file_content);
json = json_parse(json_string);
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
global.Song_information.player1 = json.song.player1
global.Song_information.player2 = json.song.player2
global.Song_information.song = json.song.song
global.Song_information.notes_data = json.song.notes
global.Song_information.bpm = json.song.bpm
global.Song_information.events_data = json.song.events

i = 0
n = 0
song_time = 0
draw_note_i = 0;
draw_note_n = 0;
draw_last_time = -1;

load_s = audio_create_stream(working_directory + "\\assets\\songs\\extirpatient\\song\\Inst.ogg")
load_s1 = audio_create_stream(working_directory + "\\assets\\songs\\extirpatient\\song\\Voices.ogg")
//load_s2 = audio_create_stream(working_directory + "\\assets\\songs\\extirpatient\\song\\VoicesInsatian.ogg")


//load_s = audio_create_stream(working_directory + "\\assets\\songs\\test-song\\song\\Inst.ogg")
//load_s1 = audio_create_stream(working_directory + "\\assets\\songs\\test-song\\song\\Voices.ogg")
song_sound1=audio_play_sound(load_s,0,0)
song_sound2=audio_play_sound(load_s1,0,0)



global.sprite_index_note = 
{
	p_note_arrow_left:Notes_Nightflaid_purple,
	p_note_arrow_down:Notes_Nightflaid_blue,
	p_note_arrow_up:Notes_Nightflaid_green,
	p_note_arrow_right:Notes_Nightflaid_red,
	p_note_arrow_left_hold_piece:Notes_Nightflaid_purple_hold_piece,
	p_note_arrow_down_hold_piece:Notes_Nightflaid_blue_hold_piece,
	p_note_arrow_up_hold_piece:Notes_Nightflaid_green_hold_piece,
	p_note_arrow_right_hold_piece:Notes_Nightflaid_red_hold_piece,
	
	o_note_arrow_left:Notes_Nightflaid_Assets_purple_1,
	o_note_arrow_down:Notes_Nightflaid_Assets_blue_1,
	o_note_arrow_up:Notes_Nightflaid_Assets_green_1,
	o_note_arrow_right:Notes_Nightflaid_Assets_red_1,
	o_note_arrow_left_hold_piece:Notes_Nightflaid_Assets_purple_hold_piece_1,
	o_note_arrow_down_hold_piece:Notes_Nightflaid_Assets_blue_hold_piece_1,
	o_note_arrow_up_hold_piece:Notes_Nightflaid_Assets_green_hold_piece_1,
	o_note_arrow_right_hold_piece:Notes_Nightflaid_Assets_red_hold_piece_1,
}
