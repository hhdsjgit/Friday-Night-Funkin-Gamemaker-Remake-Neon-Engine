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

// 在Draw Event中（修复后的绘制代码）
//if song_time != draw_last_time {
    // 时间变化时重置索引
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

while temp_i < array_length(global.Song_information.notes_data) && notes_drawn < 300 {
    var note_1 = global.Song_information.notes_data[temp_i];
    
    if array_length(note_1.sectionNotes) >= 1 {
        while temp_n < array_length(note_1.sectionNotes) {
            var note_time = note_1.sectionNotes[temp_n][0];
            
            if note_time <= end_time && note_time >= song_time {
                // 绘制音符
                var column = note_1.sectionNotes[temp_n][1];
                var y_pos = (note_time - song_time) / 10 + 100;
                
                // 根据音符类型绘制不同颜色
                if column < 4 { // 前4列为玩家/对手音符
                    draw_set_color(c_blue);
                } else { // 后4列
                    draw_set_color(c_red);
                }
                var nx_x = note_1.mustHitSection
				if note_1.mustHitSection = 1 and note_1.sectionNotes[temp_n][1] <= 3{
					 draw_set_color(c_blue);
				}else{
					draw_set_color(c_red);
					nx_x = 0
				}
				
				////玩家箭头生成end
			
				//生成对手的箭头
				if note_1.mustHitSection = 0 and note_1.sectionNotes[temp_n][1] <= 3{
					draw_set_color(c_red);
				}else if note_1.mustHitSection = 0{
					 draw_set_color(c_blue);
					 nx_x = 1
				}
				
				if point_in_rectangle(mouse_x, mouse_y, (400 + (column mod 4) * 30 + nx_x * 120), y_pos, (400 + (column mod 4) * 30 + nx_x * 120) + 30, y_pos+20) {
					draw_set_alpha(1)
				} else {
					draw_set_alpha(0.5)
				}	
				draw_set_color(c_white);
                draw_text(400 + (column mod 4) * 30 + nx_x * 120, y_pos, "XX");
                
                
                notes_drawn++;
                
                // 限制每帧绘制数量防止卡顿
                if notes_drawn >= 500 {
                    break;
                }
            }
            
            temp_n++;
            
            // 如果音符时间超过绘制范围，跳出
            if note_time > end_time {
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