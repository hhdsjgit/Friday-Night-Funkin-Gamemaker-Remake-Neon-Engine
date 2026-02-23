/// @description 
/**
---开发技术文档---


*/
choose_setting = 0
ui_y = 0
draw_alpha = 1
test_need_draw = 
{
	"options":["CONTROLS","GAMEPLAY >","APPEARANCE >","MISCELLANEOUS >","SHARDER >"],
	"options_gameplay":["DOWNSCROLL","GHOST TRAPPING","SONG OFFSET","NAUGHTYNESS","CAMERA ZOOM ON BEAT","BUBBLE SORT"],
	"options_appearance":["TEST0","TEST1","TEST2","TEST3"]
}

time = 0
sound_scroll= scroll
now_need_read = test_need_draw.options
last_need_read = test_need_draw.options
buff_x = 50
last_buff_x = -1000
buff_time = 0
fanzhuan = false

anin_setting =
{
	"DOWNSCROLL_a":[0,0],
	"GHOST_TRAPPING":[0,0],
	"BUBBLE_SORT":[0,0]	
		
}

function get_setting(name,value){
	switch name {
		
		case "DOWNSCROLL": 
			if value = 1 {
			
				if global.setting_game.DOWNSCROLL {	
					anin_setting.DOWNSCROLL_a[0] = 11
					anin_setting.DOWNSCROLL_a[1] = -1
				}else{
					anin_setting.DOWNSCROLL_a[1] = 1
					anin_setting.DOWNSCROLL_a[0] = 0
				}
			
				global.setting_game.DOWNSCROLL = !global.setting_game.DOWNSCROLL;
			}
		return global.setting_game.DOWNSCROLL;
		
		case "GHOST TRAPPING": 
			if value = 1 {
			
				if global.setting_game.GHOST_TRAPPING {	
					anin_setting.GHOST_TRAPPING[0] = 11
					anin_setting.GHOST_TRAPPING[1] = -1
				}else{
					anin_setting.GHOST_TRAPPING[1] = 1
					anin_setting.GHOST_TRAPPING[0] = 0
				}
			
				global.setting_game.GHOST_TRAPPING = !global.setting_game.GHOST_TRAPPING;
			}
		return global.setting_game.GHOST_TRAPPING;
		
		case "BUBBLE SORT": 
			if value = 1 {
			
				if global.setting_game.BUBBLE_SORT {	
					anin_setting.BUBBLE_SORT[0] = 11
					anin_setting.BUBBLE_SORT[1] = -1
				}else{
					anin_setting.BUBBLE_SORT[1] = 1
					anin_setting.BUBBLE_SORT[0] = 0
				}
			
				global.setting_game.BUBBLE_SORT = !global.setting_game.BUBBLE_SORT;
			}
		return global.setting_game.BUBBLE_SORT;
			
	
	}
}

function get_draw_anim (name) {
	switch name {
		
		case "DOWNSCROLL": return anin_setting.DOWNSCROLL_a;
		case "GHOST TRAPPING": return anin_setting.GHOST_TRAPPING;
		case "BUBBLE SORT": return anin_setting.BUBBLE_SORT;

	}
	return [0,0];
}

function get_draw_box (value) {
	switch value {
		
		case 0: return Check_Box_unselected;
		case 1: return Check_Box_Selected_Static;
		case -1: return Check_Box_selecting_animation;	
	}
	return spr_empty
}