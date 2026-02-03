/// @description 
if file_exists(working_directory + string(text_box_path.text)) {
	if sprite_exists(atlas_sprite) {
		test_time ++
		if test_time >= array_length(json_data.TextureAtlas.SubTextures){
			test_time = 0	
		}
		// 直接绘制纹理的一部分
		draw_sprite_part_ext(
		    atlas_sprite,
		    0,
		    json_data.TextureAtlas.SubTextures[test_time].x, json_data.TextureAtlas.SubTextures[test_time].y,
		    json_data.TextureAtlas.SubTextures[test_time].width, json_data.TextureAtlas.SubTextures[test_time].height,
		    530,100,
		    1, 1,
		    c_white,
		    1
		);	
	}
}

if file_exists(working_directory + string(text_box_path.text)) {	
	draw_Outline("OK",text_box_path.x,text_box_path.y + 40,1,1,c_black,c_green,0,Font_vcr)
}else{
	draw_Outline("ERROR",text_box_path.x,text_box_path.y + 40,1,1,c_black,c_red,0,Font_vcr)
}
draw_Outline("Json path :",text_box_path.x,text_box_path.y - 12,1,1,c_black,c_white,0,Font_vcr)


