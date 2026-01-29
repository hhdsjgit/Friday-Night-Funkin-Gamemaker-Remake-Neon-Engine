/// @description 在此处插入描述 
// 你可以在此编辑器中写入代码 
//draw_Outline(string(image_number) + " / " + string(image_index),x+100,y,2,2,c_black,c_white,0,Font_vcr)

draw_self()
image_yscale = -1 
image_alpha = 0.5
draw_sprite_ext(sprite_index,image_index,x,y+20,image_xscale,image_yscale,0,c_white,image_alpha)
image_yscale = 1
image_alpha = 1