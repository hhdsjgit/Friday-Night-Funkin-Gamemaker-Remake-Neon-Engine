function draw_button_ext(x,y,width,hight,text) {
	var draw_color = c_lime;
	var b_return = false;
	
	if point_in_rectangle(mouse_x, mouse_y,x,y,x + width,y + hight) {
		if mouse_check_button_released(1){
			b_return = true;
		}
		x += 2
		width -= 2
		y += 2
		hight -= 2
		draw_color = c_green;
	}
	
	draw_set_color(draw_color);
	draw_roundrect(x,y,x + width,y + hight,0);
	
	draw_set_color(c_white);
	draw_set_halign(fa_center);
	draw_set_valign(fa_middle);

	draw_Outline_s(text,(width/2 + x),(hight/2 + y),1,1,c_black,c_white,0,Font_vcr);
	
	draw_set_halign(fa_left);
	
	return b_return;
	
}

function draw_box(text,x,y,width,hight,value,c0,c1,name){
	
	draw_set_color(c0)
	draw_roundrect(x - 2,y - 2,x+width + 2,y+hight + 2,0)
	if point_in_rectangle(mouse_x, mouse_y,x,y,x + width,y + hight) {
		if mouse_check_button_pressed(1) {
			switch name {
				case "i_loop": 
				
					if value = 0 or value = 1 {
						buff_char_json.character.animations[choose_char_json].loop = !value;					
					}
				break;
				
				case "p_flipX": 
					if value = 0 or value = 1 {
						buff_char_json.character.properties.flipX = !value;					
					}
				break;
				
				case "p_isPlayer": 
					if value = 0 or value = 1 {
						buff_char_json.character.properties.isPlayer = !value;					
					}
				break;
				
				case "p_isGF": 
					if value = 0 or value = 1 {
						buff_char_json.character.properties.isGF = !value;					
					}
				break;
				//
				////////////
				
			}
			value = !value	
		}
	}
	if value = 1 {
		draw_set_color(c1)
		draw_roundrect(x + 4,y + 4,x+width - 4,y+hight - 4,0)
	}
	
	draw_set_halign(fa_center);
	draw_set_valign(fa_middle);
	draw_set_halign(fa_right);
	
	draw_Outline_s(text,(x - 4),(hight/2 + y),0.8,0.8,c_black,c_white,0,Font_vcr)
	
	draw_set_halign(fa_left);
	
	draw_set_color(c_white)
}