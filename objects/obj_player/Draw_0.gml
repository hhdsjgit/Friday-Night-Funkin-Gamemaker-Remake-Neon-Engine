var need_sing = ""
var filpx = 1

switch Action {
	case 0:	need_sing = Action_skin_left;break;
	case 1:	need_sing = Action_skin_down;break;
	case 2:	need_sing = Action_skin_up;break;
	case 3:	need_sing = Action_skin_right;break;
	case 4:	need_sing = Action_skin_idle;break;
	default: need_sing = Action_skin_idle;break;
}	

if characters_json_data.character.properties.flipX = 1 {
	switch Action {
		case 3:	need_sing = Action_skin_left;break;
		case 1:	need_sing = Action_skin_down;break;
		case 2:	need_sing = Action_skin_up;break;
		case 0:	need_sing = Action_skin_right;break;
		case 4:	need_sing = Action_skin_idle;break;
		default: need_sing = Action_skin_idle;break;
	}
}

if _test_time >= array_length(need_sing) {
	_test_time = array_length(need_sing) - 1
}	

if characters_json_data.character.properties.flipX = 1 {
	filpx = -1	
	draw_x += need_sing[_test_time].frameWidth*characters_scale + need_sing[_test_time].frameX*characters_scale*2
}





draw_x -= need_sing[_test_time].frameX * characters_scale
draw_y -= need_sing[_test_time].frameY * characters_scale



draw_sprite_general(
    atlas_sprite,                          // sprite
    0,                                     // subimg
    need_sing[_test_time].x,           // left
    need_sing[_test_time].y,           // top
    need_sing[_test_time].width,       // width
    need_sing[_test_time].height,      // height
    draw_x, // x
    draw_y, // y
    characters_scale * filpx,                      // xscale
    characters_scale,                      // yscale
    0,                               // rotation
    c_white,                               // c1
    c_white,                               // c2
    c_white,                               // c3
    c_white,                               // c4
    1                                      // alpha
);