///// @description
//i = 0
//n = 0
//draw_text(5,50,song_time)
//for (var song_times = 0 + song_time;song_times <= 8000 + song_time;song_times ++){
//	if array_length(global.Song_information.notes_data) > i {
//		var note = 0
//		var note_1 = 0
	
//		note = global.Song_information.notes_data //获取单个内容
//		note_1 = global.Song_information.notes_data[i] //获取单个内容

//		if array_length(note_1.sectionNotes) >= 1 {

//			if note_1.sectionNotes[n][0] <= song_times + song_time{		
//				draw_text(400 + note_1.sectionNotes[n][1] * 30,200-(song_times-song_time)/10,"AX")
//				n++
//				if array_length(note_1.sectionNotes) <= n{
//					i++
//					n = 0	
//				}	
//			}
//		}else{
//			i++	
//		}
//	}
//}



draw_note_i = 0;
draw_note_n = 0;
draw_last_time = song_time;


// 绘制当前时间
draw_text(5, 50, song_time);

// 只绘制未来8秒内的音符（8000毫秒）
var end_time = song_time + 8000;
var temp_i = draw_note_i;
var temp_n = draw_note_n;
var notes_drawn = 0;


//var down_y = floor(song_time)
//for (var j = 0;j <= 500;j++) {
//	for (var k = 0;k < 8;k++){
//		var need_draw_x = 0
//		draw_set_alpha(0.8)
//		if j % 2 {
//			if (k % 2 == 0) {
//				draw_set_color(c_white)
//			}else{
//				draw_set_color(c_gray)
//			}
//			if k > 3 {
//				need_draw_x = 1
//			}
//		}else{
//			if (k % 2 == 0) {
//				draw_set_color(c_gray)
//			}else{
//				draw_set_color(c_white)
//			}	
//			if k > 3 {
//				need_draw_x = 1
//			}
//		}
		
//		draw_rectangle(200 + k * 60 + need_draw_x * 5,200 + j *60-down_y,260 + k * 60 + need_draw_x * 5,260 + j *60-down_y,0)
//	}
//}
//draw_set_alpha(1)

var down_y = floor(song_time);
var visible_rows = 30; // 根据屏幕高度调整，比如800/60≈13，多画几行确保覆盖

draw_set_alpha(0.8);

for (var j = 0; j < visible_rows; j++) {
	draw_set_alpha(0.8)
    for (var k = 0; k < 8; k++) {
		
		
        // 简化的颜色逻辑：根据行列奇偶性决定颜色
        var is_white = ((j % 2) == (k % 2));
        var offset_x = (k > 3) ? 5 : 0;
        
        draw_set_color(is_white ? c_white : c_gray);
        
        // 绘制网格方块
        draw_rectangle(
            200 + k * 60 + offset_x,
            0 + j * 60 - down_y % 720, // 使用取余实现循环滚动
            260 + k * 60 + offset_x,
            60 + j * 60 - down_y % 720,
            false
        );
    }
	if j % 4 = 0 {
		draw_set_alpha(1)
		draw_set_color(c_white)
		draw_line_width(
			200,
            j * 60 - down_y % 720, 
            200 + 60 * 8,
            j * 60 - down_y % 720,5
			)
	}
}

draw_set_alpha(1);


while temp_i < array_length(global.Song_information.notes_data) && notes_drawn < 300 {
    var note_1 = global.Song_information.notes_data[temp_i];
    
    if array_length(note_1.sectionNotes) >= 1 {
        while temp_n < array_length(note_1.sectionNotes) {
            var note_time = note_1.sectionNotes[temp_n][0];
            
            if note_time <= end_time && note_time >= song_time -2000{
                // 绘制音符
				if !(note_time <= end_time && note_time >= song_time) {
					image_alpha = 0.5	
				}else{
					image_alpha = 1
				}
					
                var column = note_1.sectionNotes[temp_n][1];
                var y_pos = (note_time - song_time) + 203;
                
                var draw_image_xscale = 0.33
				var draw_image_yscale = 0.33
				
				var nx_x = note_1.mustHitSection
				if !(note_1.mustHitSection = 1 and note_1.sectionNotes[temp_n][1] <= 3){
					nx_x = 0
				}
				if !(note_1.mustHitSection = 0 and note_1.sectionNotes[temp_n][1] <= 3){
					nx_x = 1
				}
				
				var p_x= (232 + (column mod 4) * 60+ nx_x * 240)
				//if point_in_rectangle(mouse_x, mouse_y,(p_x-127/2) * draw_image_xscale, (y_pos-154/2) * draw_image_yscale,(p_x + 157/2) * draw_image_xscale, (y_pos+154/2) * draw_image_yscale) {
				//	image_alpha = 1
				//} else {
				//	image_alpha = 1
				//}	
				
				draw_set_color(c_white);
				if note_1.mustHitSection = 1 {
					switch note_1.sectionNotes[temp_n][1] {
						case 0:sprite_index=global.sprite_index_note.p_note_arrow_left;break;
						case 1:sprite_index=global.sprite_index_note.p_note_arrow_down;break;
						case 2:sprite_index=global.sprite_index_note.p_note_arrow_up;break;
						case 3:sprite_index=global.sprite_index_note.p_note_arrow_right;break;
		
		
					}
				}else{
					switch note_1.sectionNotes[temp_n][1] {
						case 0:sprite_index=global.sprite_index_note.o_note_arrow_left;break;
						case 1:sprite_index=global.sprite_index_note.o_note_arrow_down;break;
						case 2:sprite_index=global.sprite_index_note.o_note_arrow_up;break;
						case 3:sprite_index=global.sprite_index_note.o_note_arrow_right;break;
		
		
					}
				}
				if !note_1.mustHitSection {
					if column < 4 { // 前4列为玩家/对手音符
	                    switch column {
						
							case 0:sprite_index=global.sprite_index_note.o_note_arrow_left;break;
							case 1:sprite_index=global.sprite_index_note.o_note_arrow_down;break;
							case 2:sprite_index=global.sprite_index_note.o_note_arrow_up;break;
							case 3:sprite_index=global.sprite_index_note.o_note_arrow_right;break;
		
						}
	                } else { // 后4列
	                    switch column-4 {
							case 0:sprite_index=global.sprite_index_note.p_note_arrow_left;break;
							case 1:sprite_index=global.sprite_index_note.p_note_arrow_down;break;
							case 2:sprite_index=global.sprite_index_note.p_note_arrow_up;break;
							case 3:sprite_index=global.sprite_index_note.p_note_arrow_right;break;
						
		
		
						}
	                }
				}else{
					if column < 4 { // 前4列为玩家/对手音符
	                    switch column {
							case 0:sprite_index=global.sprite_index_note.p_note_arrow_left;break;
							case 1:sprite_index=global.sprite_index_note.p_note_arrow_down;break;
							case 2:sprite_index=global.sprite_index_note.p_note_arrow_up;break;
							case 3:sprite_index=global.sprite_index_note.p_note_arrow_right;break;
								
						}
	                } else { // 后4列
	                    switch column-4 {
							case 0:sprite_index=global.sprite_index_note.o_note_arrow_left;break;
							case 1:sprite_index=global.sprite_index_note.o_note_arrow_down;break;
							case 2:sprite_index=global.sprite_index_note.o_note_arrow_up;break;
							case 3:sprite_index=global.sprite_index_note.o_note_arrow_right;break;
						}
	                }
				}
				draw_sprite_ext(sprite_index,0,p_x, y_pos,draw_image_xscale,draw_image_yscale,0,c_white,image_alpha)
				image_alpha = 1
				
                //draw_text(400 + (column mod 4) * 30 + nx_x * 120, y_pos, "XX");
                draw_set_alpha(1)
                
                notes_drawn++;
                
                // 限制每帧绘制数量防止卡顿
                if notes_drawn >= 300 {
                    break;
                }
            }
            
            temp_n++;
            

	        if note_time > end_time{
	            break;
	        }
        }
        
        if temp_n >= array_length(note_1.sectionNotes) {
            temp_i++;
            temp_n = 0;
        }
    } else {
        temp_i++;
        temp_n = 0;
    }
    
    // 如果当前section的音符已经处理完，跳到下一个section
    if temp_n == 0 && temp_i < array_length(global.Song_information.notes_data) {
        // 检查下一个section的第一个音符是否在绘制范围内
        var next_section = global.Song_information.notes_data[temp_i];
        if array_length(next_section.sectionNotes) > 0 {
            if next_section.sectionNotes[0][0] > end_time {
                break;
            }
        }
    }
}

// 更新缓存索引供下一帧使用
draw_note_i = temp_i;
draw_note_n = temp_n;