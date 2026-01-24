/// @function seconds_to_min_sec(seconds)
/// @desc 将秒数转换为分钟:秒格式
/// @param {real} seconds 总秒数
function seconds_to_min_sec(seconds) {
    var mins = seconds div 60;
    var secs = seconds mod 60;
    
    if (secs <= 9) {
        return string(mins) + ":0" + string(ceil(secs));
    } else {
        return string(mins) + ":" + string(ceil(secs));
    }
}
