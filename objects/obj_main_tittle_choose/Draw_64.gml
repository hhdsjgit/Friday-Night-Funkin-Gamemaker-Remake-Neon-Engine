function draw_gradient(_x1, _y1, _x2, _y2, _col1, _col2, _vertical = true) {
    if (_vertical) {
        draw_rectangle_color(_x1, _y1, _x2, _y2, _col1, _col1, _col2, _col2, false);
    } else {
        draw_rectangle_color(_x1, _y1, _x2, _y2, _col1, _col2, _col1, _col2, false);
    }
}


//draw_gradient(100, 100, 300, 200, c_red, c_blue, true); // 垂直渐变
//draw_gradient(100, 250, 300, 350, c_red, c_blue, false); // 水平渐变

test_time ++
if test_time >= array_length(sub.TextureAtlas.SubTextures){
	test_time = 0	
}
// 直接绘制纹理的一部分
draw_sprite_part_ext(
    atlas_sprite,
    0,
    sub.TextureAtlas.SubTextures[test_time].x, sub.TextureAtlas.SubTextures[test_time].y,
    sub.TextureAtlas.SubTextures[test_time].width, sub.TextureAtlas.SubTextures[test_time].height,
    20,20,
    1, 1,
    c_white,
    1
);
