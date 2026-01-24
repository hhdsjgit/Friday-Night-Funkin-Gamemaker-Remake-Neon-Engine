/// @description
if global.game_paused = 1{
	draw_alpha += (3 - draw_alpha) / 40
}else{
	draw_alpha = 0	
	if audio_is_playing(break_music) = true{
		audio_stop_sound(break_music)
	}
}

time += 0.1
//window_set_position(1600/2-1280/2 + cos(time) * 50,100 + sin(time) * 20)