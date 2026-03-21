function main_game(){

}

function create_note(x_pos, note_arrow, mustHitSection, length, worry) {
    var note_obj = instance_create_depth(x_pos, 800, -15, obj_note)
    note_obj.note_arrow = note_arrow
    note_obj.Note_length = length
    note_obj.Note_mustHitSection = mustHitSection
    note_obj.worry_note = worry
    return note_obj
}

/// @description 检测按键(单次按下)
/// @param {array} key_array - 示例:global.key_map.main_key_game.xxxx
function get_key_pressed(key_array) {
    var _cache = key_array;
    for (var i = 0; i < array_length(_cache); i++) {
        if keyboard_check_pressed(_cache[i]) {
            return true;
        }
    }
    return false;  
}

/// @description 检测按键)(持续按住)
/// @param {array} key_array - 示例:global.key_map.main_key_game.xxxx
function get_key_down(key_array) {
    var _cache = key_array;
    for (var i = 0; i < array_length(_cache); i++) {
        if keyboard_check(_cache[i]) {
            return true;
        }
    }
    return false;
}

/// @description 预处理歌曲数据，在游戏开始前完成所有整理工作
/// @param {struct} _song_file - 原始歌曲JSON数据
/// @return {struct} 处理后的歌曲数据

function scr_preprocess_song_data(_song_file) {
    if !global.setting_game.BUBBLE_SORT {
		return _song_file
	}
	
	var _processed_data = _song_file;
	var song_json = _processed_data.song;
	var note_sectionNotes = song_json.notes;
	var note_events = song_json.events;
	
	for (var i=0;i<array_length(note_sectionNotes);i++){
		var array_2d = note_sectionNotes[i].sectionNotes;
		var n1 = array_length(array_2d);
		var swapped;

		for (var i1 = 0; i1 < n1 - 1; i1++) {
			swapped = false;
    
			for (var j = 0; j < n1 - i1 - 1; j++) {
			    if (array_2d[j][0] > array_2d[j + 1][0]) {
			        var temp = array_2d[j];
			        array_2d[j] = array_2d[j + 1];
			        array_2d[j + 1] = temp;
			        swapped = true;

			    }
			}
    
			// 如果没有交换发生，数组已经有序，提前退出
			if (!swapped) break;
		}	
		
	}
    _processed_data.song.notes = note_sectionNotes
	show_debug_message(_processed_data)
    return _processed_data;
}











