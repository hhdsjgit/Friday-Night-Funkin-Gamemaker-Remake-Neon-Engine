/// @description
//全局游戏设置!
global.setting_game = 
{	
	"Volume":10,
	"DOWNSCROLL":0,
	"GHOST_TRAPPING":0,
	"SONG_OFFSET":39,
	"NAUGHTYNESS":0,
	"CAMERA ZOOM ON BEAT":15,
	"BUBBLE_SORT":1
}

global.key_map =
{
    "main_key_game":
    {
        "ui_key_left": [vk_left, ord("A")],      // 示例：左箭头或A键
        "ui_key_down": [vk_down, ord("S")],      // 下箭头或S键
        "ui_key_up": [vk_up, ord("W")],           // 上箭头或W键
        "ui_key_right": [vk_right, ord("D")],     // 右箭头或D键
        "game_key_left": [vk_left, ord("A")],     // 可以复用或设置不同键位
        "game_key_down": [vk_down, ord("S")],
        "game_key_up": [vk_up, ord("W")],
        "game_key_right": [vk_right, ord("D")],
        "enter": [vk_enter],
        "back": [vk_escape, vk_backspace]         // ESC或退格键
    }
}


