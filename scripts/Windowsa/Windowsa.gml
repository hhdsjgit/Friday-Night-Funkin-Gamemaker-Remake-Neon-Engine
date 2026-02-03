function Windowsa(){

}
function wimdows_rename() {
	window_set_caption("Neon Engine")
}

function windows_extract_filename(file_path) {
    if (file_path == "") return "";
    
    var normalized_path = string_replace_all(file_path, "\\", "/");
    
    var last_slash = string_last_pos("/",normalized_path);
    
    if (last_slash == -1) {
        // 没有路径，直接返回
        return normalized_path;
    } else {
        // 提取文件名
        return string_copy(normalized_path, last_slash + 1, 
                          string_length(normalized_path) - last_slash);
    }
}