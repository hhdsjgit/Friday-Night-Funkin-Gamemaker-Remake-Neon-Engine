/// @description 在此处插入描述 
// 你可以在此编辑器中写入代码 
var _video_data = video_draw();
var _status = _video_data[0];

if (_status == 0)
{
	
    var _surface = _video_data[1];

    var scale_x = 1280 / surface_get_width(_surface);
	var scale_y = 720 / surface_get_height(_surface);

	// 绘制到1280x720
	draw_surface_ext(_surface, 0, 0, scale_x, scale_y, 0, c_white, 1);
}