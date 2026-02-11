function events_game(song_name){
	if song_name = "Montagem-Miau" {
		global.Game_inf.cam_x -= ( global.Game_inf.cam_x - (global.palyer_i.x)+720) / 20
		global.Game_inf.cam_y -= ( global.Game_inf.cam_y - (global.palyer_i.y) + 100) / 20
		global.Game_inf.cam_scale += func_frc((1.3-global.Game_inf.cam_scale)/15)
		global.Game_inf.show_health_bar = 0
		global.Game_inf.show_opponent_alpha = 0
	}
	
	if song_name = "Extirpatient" {
		global.Game_inf.cam_scale += func_frc((3-global.Game_inf.cam_scale)/15)
		//ui_arrow_wave(0,12000,50000)
		
		if audio_exists(obj_main.song_sound1) {
			if obj_main.song_time >= 100 and obj_main.song_time < 1000{
				ui_arrow_move_buffer_my(0,0,0,0,-60,-60,-60,-60,0,1,0,1)
				ui_arrow_move_buffer_my(0,0,0,0,-60,-60,-60,-60,1,1,0,1)
			}
			if obj_main.song_time >= 6100 and obj_main.song_time < 6200{
				//ui_arrow_set_color_my(0,255,0,0)
				ui_arrow_move_buffer_my(0,0,0,0,-60,-60,-60,100,0,10,0,1)
				ui_arrow_move_buffer_my(0,0,0,0,100,-60,-60,-60,1,10,0,1)
			}
			if obj_main.song_time >= 6200 and obj_main.song_time < 6300{
				ui_arrow_move_buffer_my(0,0,0,0,-60,-60,100,100,0,10,0,1)
				ui_arrow_move_buffer_my(0,0,0,0,100,100,-60,-60,1,10,0,1)
			}
			if obj_main.song_time >= 6300 and obj_main.song_time < 6400{
				ui_arrow_move_buffer_my(0,0,0,0,-60,100,100,100,0,10,0,1)
				ui_arrow_move_buffer_my(0,0,0,0,100,100,100,-60,1,10,0,1)
			}
			if obj_main.song_time >= 6400 and obj_main.song_time < 10000{
				ui_arrow_move_buffer_my(0,0,0,0,100,100,100,100,0,10,0,1)
				ui_arrow_move_buffer_my(0,0,0,0,100,100,100,100,1,10,0,1)
			}
		}
		ui_arrow_move_buffer(790,790+115,790+230,790+345,100,100,100,100,1,30,26000,30000,1,0)
		ui_arrow_move_buffer(135,135+115,135+230,135+345,100,100,100,100,0,30,26000,30000,1,0)
		ui_arrow_move_buffer(790,790+115,790+230,790+345,100,100,100,100,0,30,46000,50000,1,0)
		ui_arrow_move_buffer(135,135+115,135+230,135+345,100,100,100,100,1,30,46000,50000,1,0)
		
		ui_arrow_move_buffer(790+345,790+230,790+115,790,100,100,100,100,0,10,70000,78000,1,0)
		ui_arrow_move_buffer(790,790+115,790+230,790+345,100,100,100,100,0,10,100000,108000,1,0)
		
		ui_arrow_move_buffer(790,790+115,790+230,790+345,100,180,100,180,0,10,120000,140000,1,1)
		ui_arrow_move_buffer(135,135+115,135+230,135+345,180,100,180,100,1,10,120000,148000,1,1)
		
		ui_arrow_move_buffer(790,790+115,790+230,790+345,100,100,100,100,0,10,180000,186000,1,1)
		ui_arrow_move_buffer(135,135+115,135+230,135+345,100,100,100,100,1,10,180000,186000,1,1)
	
		
		//if cam_move_type = obj_opponent_player {
		//	global.Game_inf.cam_x -= ( global.Game_inf.cam_x - (obj_opponent_player.x) +900) / 30
		//	global.Game_inf.cam_y -= ( global.Game_inf.cam_y - (obj_opponent_player.y) + 900) / 30
		//}else{		
		//	global.Game_inf.cam_x -= ( global.Game_inf.cam_x - global.palyer_i.x + 1280/2) / 30	
		//	global.Game_inf.cam_y -= ( global.Game_inf.cam_y - (global.palyer_i.y + 100)+ 760) / 30
		//}
	}
	//#######Satisfracture#######//
	if song_name = "Satisfracture" {
		//#####GUI#####//
		if audio_sound_get_track_position(song_sound1) >= 20.7 {
			angle = cos(test_time) * 3.5
		}
		
		//######GAME######//
		if audio_sound_get_track_position(song_sound1) >= 20.5 {
			
			if obj_opponent_player.Action_skin != "WrathRetroSpecterAngy" {
				obj_opponent_player.can_play_act_else = 1
			}
		
			obj_opponent_player.Action_skin = "WrathRetroSpecterAngy"
		
		}else{
			obj_opponent_player.Action_skin = "WrathRetroSpecter"
		}

		if !(audio_sound_get_track_position(song_sound1) >= 19.5 and audio_sound_get_track_position(song_sound1) <= 20.5){
			global.Game_inf.cam_scale += func_frc((1.8-global.Game_inf.cam_scale)/15)
			if cam_move_type = obj_opponent_player {
				global.Game_inf.cam_x -= ( global.Game_inf.cam_x - (-395)) / 40
			}else{
				global.Game_inf.cam_x -= ( global.Game_inf.cam_x - 460) / 40				
			}
			global.Game_inf.cam_y += func_frc((-150-global.Game_inf.cam_y)/15)
		}else{
	
			global.Game_inf.cam_y += func_frc((-550-global.Game_inf.cam_y)/8)
			global.Game_inf.cam_x += func_frc((-481-global.Game_inf.cam_x)/8)
			global.Game_inf.cam_scale += func_frc((0.36-global.Game_inf.cam_scale)/8)
		}



	}	
}

function game_song_init() {
	
	if song_name = "Satisfracture" {
		
	}
}