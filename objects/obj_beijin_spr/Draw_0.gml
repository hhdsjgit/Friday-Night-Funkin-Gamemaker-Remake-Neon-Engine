/// @description 
var _x = -2080
var _y = -1152

draw_sprite_stretched(highlights,0,_x,_y,sprite_width,sprite_height)
// 假设你想绘制高光精灵右半部分，并放在(x,y)位置

/*
draw_sprite_part_ext(highlights, 0,
    2800,    // left: 从精灵宽度一半开始（右半边）
	0,                 // top: 从顶部开始
	sprite_width,    // width: 取右半宽度
    sprite_height,     // height: 全高
    _x, _y,            // 绘制位置
    1, 1,              // 不缩放
    c_white,           // 白色（用于亮度混合）
    1                  // 不透明
);*/
//draw_sprite_pos(highlights,0,0-sprite_width,0-sprite_height,sprite_width,0,sprite_width,sprite_height,0,sprite_height,1)
//draw_sprite_ext(highlights, 0, _x, _y,1,1,0,c_white,1);
draw_sprite(darklayer, 0, _x, _y);
draw_sprite_ext(glowTop,0,-193.6747,-1152,2.522899,2.522899,0,c_white,1)
draw_sprite_ext(glow,0,-2129,-1145,1,1,0,c_white,1)
draw_sprite_ext(redlights,0,-1777.474,-503.2809,2.667193,2.667193,0,c_white,1)