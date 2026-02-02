/// @description 
choose_setting -= 1
audio_play_sound(sound_scroll,0,0)

if choose_setting < 0 {
	choose_setting = array_length(test_need_draw)-1
}