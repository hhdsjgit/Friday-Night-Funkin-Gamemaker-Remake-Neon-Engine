/// @description 
with obj_note {
	if id != other.id and note_arrow = other.note_arrow and Note_mustHitSection = other.Note_mustHitSection {
			
		// 计算其他音符的判定线位置
	    var other_target_y = get_note_y(note_arrow, Note_mustHitSection);
            
	    // 如果这个音符更接近判定线，让更近的先处理
	    if abs(y - other_target_y) < abs(other.y - other.my_target_y) {
	        other.can_hit = false;
	        break;
	    }
	}
}