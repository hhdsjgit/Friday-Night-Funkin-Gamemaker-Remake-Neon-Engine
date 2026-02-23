/// @description
if character_json_name = "bf-christmas" {
	character_json_name = "starjump"
}else{
	character_json_name = "bf-christmas"
}
if (sprite_exists(atlas_sprite)){
	sprite_delete(atlas_sprite);
}
Action_skin_left = []
Action_skin_right = []
Action_skin_down = []
Action_skin_up = []
Action_skin_idle = []
Action_skin_0 = []
load_json_0 = false
json_data = {}
atlas_sprite = -1 
draw_x = x
draw_y = y 
Action = 4
characters_scale = 1
time = 0
characters_json_data = {}
event_user(0)
//"starjump"