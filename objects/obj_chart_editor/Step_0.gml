song_time = audio_sound_get_track_position(song_sound1) * 1000

if keyboard_check_pressed(vk_down) or mouse_wheel_down(){
	audio_sound_set_track_position(song_sound2, song_time / 1000 + 0.1);	
	audio_sound_set_track_position(song_sound1, song_time / 1000 + 0.1);	
}
if keyboard_check_pressed(vk_up) or mouse_wheel_up(){
	audio_sound_set_track_position(song_sound2, song_time / 1000 - 0.1);	
	audio_sound_set_track_position(song_sound1, song_time / 1000 - 0.1);	
}
