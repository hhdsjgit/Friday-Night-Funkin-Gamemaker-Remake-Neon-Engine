/// @description 
choose_setting = 0
ui_y = 0
draw_alpha = 1
test_need_draw = 
{
	"credits":
	[
		{
			"names": "> CODE BY",
	        "role": "",
	        "path": ""
		},
		{
			"names": "GOODTIMES2",
	        "role": "code",
	        "path": "assets//imagles//credits//credit_icon_hhdsj.png"
		},
		{
			"names": "> ELSE",
	        "role": "",
	        "path": ""
		}
	]
}
if file_exists(working_directory + "assets\\data\\credits.json") {
	var file_content = buffer_load(working_directory + "assets\\data\\credits.json")
	var json_string = buffer_read(file_content, buffer_string);
	buffer_delete(file_content);
	test_need_draw = json_parse(json_string);
}



for (var i = 0;i < array_length(test_need_draw.credits);i++){
	test_need_draw.credits[i].path = load_image(test_need_draw.credits[i].path)
}
time = 0
sound_scroll= scroll