/// @description 在此处插入描述 
// 你可以在此编辑器中写入代码 

if global.Game_inf.show_note_Splashes {
	if !surface_exists(global.ui_surface) {
		global.ui_surface = surface_create(1280,720)
	}
	surface_set_target(global.ui_surface);
	draw_self()
	surface_reset_target();
}