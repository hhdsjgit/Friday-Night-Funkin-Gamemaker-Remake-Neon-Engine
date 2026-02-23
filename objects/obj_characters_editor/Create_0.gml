/// @description
//wirit some happy things =>
//exmp json to use array_list?

debug_test = 0

exmp_json = 
{
	"name": "",
	"anim": "",
	"start_anim":0,
	"end_anim": 0,
	"x": 0,
	"y": 0,
	"fps": 24,
	"loop": false
};


buff_char_json = 
{
  "character": {
    "metadata": {
      "doctype": "neon-engine-character",
      "version": "0.0.1"
    },
    "properties": {
      "y": 0,
      "sprite": "",
	  "flipX":false,
	  "flipY": true,
      "isPlayer": true,
      "icon": "bf",
      "color": "#30B0D1",
      "isGF": false,
      "holdTime": 8,
	  "json_path":"",
	  "png_path":""
    },
    "animations": [
      {
        "name": "idle",
        "anim": "A",
		"start_anim":0,
		"end_anim": 12,
        "x": 0,
        "y": 0,
        "fps": 24,
        "loop": false
      },
	   {
        "name": "singUP",
        "anim": "A",
		"start_anim":14,
		"end_anim": 21,
        "x": 0,
        "y": 0,
        "fps": 24,
        "loop": false
      },
	   {
        "name": "singDOWN",
        "anim": "A",
		"start_anim":24,
		"end_anim": 31,
        "x": 0,
        "y": 0,
        "fps": 24,
        "loop": false
      },
	  {
        "name": "singLEFT",
        "anim": "A",
		"start_anim":34,
		"end_anim": 41,
        "x": 0,
        "y": 0,
        "fps": 24,
        "loop": false
      },
	  {
        "name": "singRIGHT",
        "anim": "A",
		"start_anim":44,
		"end_anim": 51,
        "x": 0,
        "y": 0,
        "fps": 24,
        "loop": false
      }
    ]
  }
}
choose_char_json = 0
text_box_path = instance_create_depth(10,50,0,obj_input_box)
text_box_path_png = instance_create_depth(10,140,0,obj_input_box)

text_box_p_start = instance_create_depth(10,260,0,obj_input_box)
text_box_p_start.box_width = 100
text_box_p_start.max_length = 10

text_box_p_end = instance_create_depth(10,320,0,obj_input_box)
text_box_p_end.box_width = 100
text_box_p_end.max_length = 10

text_box_i_name = instance_create_depth(10,360,0,obj_input_box)
text_box_i_name.box_width = 200

text_box_i_fps = instance_create_depth(10,360,0,obj_input_box)
text_box_i_fps.box_width = 100

text_box_i_x = instance_create_depth(10,360,0,obj_input_box)
text_box_i_x.box_width = 100
text_box_i_x.max_length = 7

text_box_i_y = instance_create_depth(10,360,0,obj_input_box)
text_box_i_y.box_width = 100
text_box_i_y.max_length = 7

text_box_i_fps.choose_text = "number"
text_box_p_end.choose_text = "number"
text_box_p_start.choose_text = "number"
text_box_i_x.choose_text = "number"
text_box_i_y.choose_text = "number"
mouse_check_x = 0
mouse_check_y = 0
mouse_move_x = 0
mouse_move_y = 0

all_move_x = 0
all_move_y = 0

characters_scale = 1
draw_lanzi_up =
{
	"File":["Load out json","Save","Save as","Save as pe","Load NE"]

}
draw_inf = 
{
	"l_file_inf_x":100,
	"l_file_inf_y":100,
	"file_inf_x":100,
	"file_inf_y":100,
	"canmovefileing":0,
	"movechar":1,
	"show_file":1,
}
text_box_path_name = instance_create_depth(10,200,0,obj_input_box)
atlas_sprite = -1
path_ok = false
test_time = 0
buff_png_json = []
last_png_name = ""
json_data = {}
//var file_path = get_open_filename("json", "选择文件");

//if (file_path != "") {
//    show_debug_message("完整文件路径: " + file_path);
//	show_debug_message("文件: " + windows_extract_filename(file_path));
//}
show_lan = 0
load_path = "assets\\images\\characters\\"


function string_add_zero (number) {
	var _number = string(number)	
	if number < 10 {
		return "000" + _number
	}else if number < 100 {
		return "00" + _number	
	}else if number < 1000 {
		return "0" + _number	
	}else if number < 10000 {
		return _number	
	}
}


buff_pe_json= 
{
	"animations": [
		
	],
	"vocals_file": "",//对话框音色
	"no_antialiasing": false,
	"image": "characters/",//图像
	"position": [0, 350],//偏移
	"healthicon": "",//血条外
	"flip_x": true,//反转
	"healthbar_colors": [255,255,255],
	"camera_position": [0,0],
	"sing_duration": 4,
	"scale": 1,
	"_editor_isPlayer": true//玩家吗?
}