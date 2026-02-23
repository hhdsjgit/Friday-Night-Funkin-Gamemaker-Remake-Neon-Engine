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

function hex_to_rgb(hex_color) {
    // 1. 去掉#号
    hex_color = string_replace(hex_color, "#", "");
    
    // 2. 读取1,2位 → R
    var r_high = hex_char_to_value(string_char_at(hex_color, 1));
    var r_low = hex_char_to_value(string_char_at(hex_color, 2));
    var r = r_high * 16 + r_low;
    
    // 3. 读取3,4位 → G
    var g_high = hex_char_to_value(string_char_at(hex_color, 3));
    var g_low = hex_char_to_value(string_char_at(hex_color, 4));
    var g = g_high * 16 + g_low;
    
    // 4. 读取5,6位 → B
    var b_high = hex_char_to_value(string_char_at(hex_color, 5));
    var b_low = hex_char_to_value(string_char_at(hex_color, 6));
    var b = b_high * 16 + b_low;
    
    // 5. 返回RGB数组\
	show_debug_message(string([r,g,b]))
    return [r, g, b];
}

/// 单个十六进制字符转数值
function hex_char_to_value(char) {
    char = string_upper(char);
    
    if (char == "0") return 0;
    if (char == "1") return 1;
    if (char == "2") return 2;
    if (char == "3") return 3;
    if (char == "4") return 4;
    if (char == "5") return 5;
    if (char == "6") return 6;
    if (char == "7") return 7;
    if (char == "8") return 8;
    if (char == "9") return 9;
    if (char == "A") return 10;
    if (char == "B") return 11;
    if (char == "C") return 12;
    if (char == "D") return 13;
    if (char == "E") return 14;
    if (char == "F") return 15;
    
    return 0; // 无效字符返回0
}