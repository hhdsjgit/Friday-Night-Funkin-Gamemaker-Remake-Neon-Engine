function draw_Outline(text,x,y,xscale,yscale,color,color1,angle,font){
	//描边绘制字体
	draw_set_font(Font_vcr)
	//检查字体是否存在
	if font_exists(font){
		draw_set_font(font)
	}
	//字符化
	var text_str = string(text);
	//设置颜色
	draw_set_colour(color);
	draw_text_transformed(x+2, y-2, text_str,xscale, yscale, angle);
	draw_text_transformed(x+2, y, text_str, xscale, yscale, angle);
	draw_text_transformed(x-2, y+2, text_str, xscale, yscale, angle);
	draw_text_transformed(x-2, y, text_str, xscale, yscale, angle);
	draw_text_transformed(x, y+2, text_str, xscale, yscale, angle);
	draw_text_transformed(x, y+2, text_str, xscale, yscale, angle);
	draw_text_transformed(x, y-2, text_str, xscale, yscale, angle);
	draw_text_transformed(x-2, y-2, text_str, xscale, yscale, angle);
	
	draw_set_colour(color1);
	draw_text_transformed(x, y, text_str, xscale, yscale, angle);
}