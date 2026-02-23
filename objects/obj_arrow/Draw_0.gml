/// @description
if !surface_exists(global.ui_surface) {
	global.ui_surface = surface_create(1280,720)
}
surface_set_target(global.ui_surface);
image_alpha = global.Game_inf.Note_arrow_alpha[Note_mustHitSection]
draw_sprite_ext(sprite_index,image_index,x,y,image_xscale,image_yscale,image_angle,image_blend,image_alpha)
image_alpha = 1
surface_reset_target();