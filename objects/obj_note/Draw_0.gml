/// @description

//if !surface_exists(global.ui_surface) {
//	global.ui_surface = surface_create(1280,720)
//}

//surface_set_target(global.ui_surface);
//if Note_length > 0  {
//    var _y = y
//	var need_draw_sprite = undefined
//    if Note_mustHitSection = 1 {
//        switch note_arrow {
//            case 0: need_draw_sprite=global.sprite_index_note.p_note_arrow_left_hold_piece;break;
//            case 1: need_draw_sprite=global.sprite_index_note.p_note_arrow_down_hold_piece;break;
//            case 2: need_draw_sprite=global.sprite_index_note.p_note_arrow_up_hold_piece;break;   
//            case 3: need_draw_sprite=global.sprite_index_note.p_note_arrow_right_hold_piece;break;
//			default: need_draw_sprite=global.sprite_index_note.p_note_arrow_right_hold_piece;break
//        }
//    }else{
//        switch note_arrow {
//            case 0: need_draw_sprite=global.sprite_index_note.o_note_arrow_left_hold_piece;break;
//            case 1: need_draw_sprite=global.sprite_index_note.o_note_arrow_down_hold_piece;break;
//            case 2: need_draw_sprite=global.sprite_index_note.o_note_arrow_up_hold_piece;break;   
//            case 3: need_draw_sprite=global.sprite_index_note.o_note_arrow_right_hold_piece;break;
//			default: need_draw_sprite=global.sprite_index_note.p_note_arrow_right_hold_piece;break
//        }   
//    }
    
//    // 从头部位置(Check_note_length)开始绘制到尾
//    for (var i = Check_note_length; i < Note_length; i += sprite_get_height(need_draw_sprite)) {
//        y = _y + i
        
//        // 屏幕裁剪
//        if y >= -100 && y <= 920 {
//            draw_sprite_part_ext(
//                need_draw_sprite,
//                0,
//                0, 
//                0,
//                sprite_get_width(need_draw_sprite) * 2,
//                sprite_get_height(need_draw_sprite) * 2,
//                x -  sprite_get_width(need_draw_sprite)/2,
//                y,
//                image_xscale, 
//                image_yscale,
//                c_white,
//                0.7  // 整体透明度0.7
//            );
//        }
//    }
    
//    // 调试文字
//    //draw_set_color(c_red)
//    //draw_text(x+15, _y-20, "剩余:"+string(Note_length - Check_note_length)+"/"+string(Note_length))
//    //draw_set_color(c_white)
    
//    y = _y  // 恢复y坐标
//}


//image_yscale = 0.7
//if worry_note = "NOONE" {
//	if Note_mustHitSection = 1 {
//		switch note_arrow {
//			case 0:sprite_index=global.sprite_index_note.p_note_arrow_left;break;
//			case 1:sprite_index=global.sprite_index_note.p_note_arrow_down;break;
//			case 2:sprite_index=global.sprite_index_note.p_note_arrow_up;break;
//			case 3:sprite_index=global.sprite_index_note.p_note_arrow_right;break;
		
		
//		}
//	}else{
//		switch note_arrow {
//			case 0:sprite_index=global.sprite_index_note.o_note_arrow_left;break;
//			case 1:sprite_index=global.sprite_index_note.o_note_arrow_down;break;
//			case 2:sprite_index=global.sprite_index_note.o_note_arrow_up;break;
//			case 3:sprite_index=global.sprite_index_note.o_note_arrow_right;break;
		
		
//		}
//	}
//}else{
//	if Note_mustHitSection = 1 {
//		switch note_arrow {
//			case 0:sprite_index=global.sprite_index_note.o_note_arrow_left;break;
//			case 1:sprite_index=global.sprite_index_note.o_note_arrow_down;break;
//			case 2:sprite_index=global.sprite_index_note.o_note_arrow_up;break;
//			case 3:sprite_index=global.sprite_index_note.o_note_arrow_right;break;
//		}
//	}else{
//		switch note_arrow {
//			case 0:sprite_index=global.sprite_index_note.o_note_arrow_left;break;
//			case 1:sprite_index=global.sprite_index_note.o_note_arrow_down;break;
//			case 2:sprite_index=global.sprite_index_note.o_note_arrow_up;break;
//			case 3:sprite_index=global.sprite_index_note.o_note_arrow_right;break;
		
		
//		}
//	}	
//}
//if !check_note {
//	draw_self()
//}

//var can_hit = true;


//surface_reset_target();






if !surface_exists(global.ui_surface) {
	global.ui_surface = surface_create(1280,720)
}

surface_set_target(global.ui_surface);
if Note_length > 0  {
	var _y =y
	if Note_mustHitSection = 1 {
		switch note_arrow {
			case 0:sprite_index=global.sprite_index_note.p_note_arrow_left_hold_piece;break;
			case 1:sprite_index=global.sprite_index_note.p_note_arrow_down_hold_piece;break;
			case 2:sprite_index=global.sprite_index_note.p_note_arrow_up_hold_piece;break;	
			case 3:sprite_index=global.sprite_index_note.p_note_arrow_right_hold_piece;break;
			default:sprite_index=global.sprite_index_note.p_note_arrow_right_hold_piece;break;
		}
	}else{
		switch note_arrow {
			case 0:sprite_index=global.sprite_index_note.o_note_arrow_left_hold_piece;break;
			case 1:sprite_index=global.sprite_index_note.o_note_arrow_down_hold_piece;break;
			case 2:sprite_index=global.sprite_index_note.o_note_arrow_up_hold_piece;break;	
			case 3:sprite_index=global.sprite_index_note.o_note_arrow_right_hold_piece;break;
			default:sprite_index=global.sprite_index_note.p_note_arrow_right_hold_piece;break;
		}	
	}
	var k = sprite_index
	if Check_note_length >= Note_length - 20 {
		Check_note_length = Note_length	
	}
	if Note_length >= 10 and Check_note_length <= Note_length - 20{
		for (var i = Check_note_length;i <= Note_length + 100;i += 25) {
			y = _y + i
			if i <= Note_length and (x >= 0 and x <= 1280 and y >= -100 and y <= 920){
				//image_yscale = 2
				draw_self()
				//draw_sprite_part_ext(
                //    sprite_index,
                //    0,
                //    0, 
                //    0,
                //    sprite_width * 2,
				//	sprite_height,
                //    x - sprite_width/2,
                //    y,
                //    image_xscale, 
                //    image_yscale,
                //    c_white,
                //    1
                //);
				//draw_sprite_ext(sprite_index,0,x,y,1,2,0,c_white,1)
				
				//draw_text(x+15,y-0,"LEG "+string(Note_length) + " / " + string(Check_note_length))
				
			}
		
		}
		image_yscale = 1
	}
	y = _y
}


image_yscale = 0.7
if worry_note = "NOONE" {
	if Note_mustHitSection = 1 {
		switch note_arrow {
			case 0:sprite_index=global.sprite_index_note.p_note_arrow_left;break;
			case 1:sprite_index=global.sprite_index_note.p_note_arrow_down;break;
			case 2:sprite_index=global.sprite_index_note.p_note_arrow_up;break;
			case 3:sprite_index=global.sprite_index_note.p_note_arrow_right;break;
		
		
		}
	}else{
		switch note_arrow {
			case 0:sprite_index=global.sprite_index_note.o_note_arrow_left;break;
			case 1:sprite_index=global.sprite_index_note.o_note_arrow_down;break;
			case 2:sprite_index=global.sprite_index_note.o_note_arrow_up;break;
			case 3:sprite_index=global.sprite_index_note.o_note_arrow_right;break;
		
		
		}
	}
}else{
	if Note_mustHitSection = 1 {
		switch note_arrow {
			case 0:sprite_index=global.sprite_index_note.o_note_arrow_left;break;
			case 1:sprite_index=global.sprite_index_note.o_note_arrow_down;break;
			case 2:sprite_index=global.sprite_index_note.o_note_arrow_up;break;
			case 3:sprite_index=global.sprite_index_note.o_note_arrow_right;break;
		}
	}else{
		switch note_arrow {
			case 0:sprite_index=global.sprite_index_note.o_note_arrow_left;break;
			case 1:sprite_index=global.sprite_index_note.o_note_arrow_down;break;
			case 2:sprite_index=global.sprite_index_note.o_note_arrow_up;break;
			case 3:sprite_index=global.sprite_index_note.o_note_arrow_right;break;
		
		
		}
	}	
}
if !check_note {
	draw_self()
}

var can_hit = true;


surface_reset_target();

