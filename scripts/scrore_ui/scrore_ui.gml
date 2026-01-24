function scrore_ui(number,denji){
	var text = number
	var _x = 300
	var _y = 380
	var char_x = 0
	var char_y = 0
	if text < 100 {
		ins_char = instance_create_depth(char_x + _x,char_y + _y,-12,obj_score_ui_number)
		ins_char.number= 0
		ins_char.image_xscale = 0.58
		ins_char.image_yscale = 0.58
		ins_char.chose_number=1
		ins_char.down_y = random_range(-7,-10.0)
		char_x += 50	
			
		if text < 10 {
			ins_char = instance_create_depth(char_x + _x,char_y + _y,-12,obj_score_ui_number)
			ins_char.number = 0	
			ins_char.image_xscale = 0.58
			ins_char.image_yscale = 0.58
			ins_char.chose_number=1
			ins_char.down_y = random_range(-7,-10.0)
			char_x += 50	
		}
	}
	for (var i = 1; i <= string_length(text); i++){	
	    var char = string_char_at(text, i);
	    ins_char = instance_create_depth(char_x + _x,char_y + _y,-12,obj_score_ui_number)
		ins_char.number=char
		ins_char.image_xscale = 0.58
		ins_char.image_yscale = 0.58
		ins_char.chose_number=1
		ins_char.down_y = random_range(-7,-10.0)
		char_x += 50
	}
	ins_char = instance_create_depth(char_x + _x - 80,char_y + _y - 120,-14,obj_score_ui_number)
	ins_char.number=denji
	ins_char.chose_number=0
	ins_char.down_y = random_range(-7,-10.0)
	
}