/// @description 
if flash_time > 0 and flash_active > 0{
	draw_set_color(c_white)
	draw_set_alpha(flash_active)
	draw_rectangle(0,0,1280,720,0)
}
draw_set_alpha(1)