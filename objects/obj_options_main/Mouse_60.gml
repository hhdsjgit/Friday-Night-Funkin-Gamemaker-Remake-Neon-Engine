/// @description 
audio_play_sound(sound_scroll,0,0)
choose_setting -= 1
if choose_setting < 0 {
	choose_setting = array_length(now_need_read)-1
}