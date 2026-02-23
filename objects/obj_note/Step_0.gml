var LEFTARROW_Y = obj_main.obj_left_arrow.y
var DOWNARROW_Y =obj_main.obj_down_arrow.y
var UPARROW_Y =obj_main.obj_up_arrow.y
var RIGHTARROW_Y =obj_main.obj_right_arrow.y

_NOTENOWY = get_note_y(note_arrow,Note_mustHitSection)

// 计算经过的时间（转换为秒）
var _dt = delta_time / 1000000; // 转换为秒


if global.Game_inf.player_die = true {
	instance_destroy(id)	
}
// 检查游戏是否未暂停
if global.game_paused = 0 {
	if Note_mustHitSection {//（玩家段）
	    switch note_arrow {
	        case 0:x=obj_main.obj_left_arrow.x;
			now_y=obj_main.obj_left_arrow.y;break;
	        case 1:x=obj_main.obj_down_arrow.x;
			now_y=obj_main.obj_down_arrow.y;break;
	        case 2:x=obj_main.obj_up_arrow.x;
			now_y=obj_main.obj_up_arrow.y;break;
	        case 3:x=obj_main.obj_right_arrow.x;
			now_y=obj_main.obj_right_arrow.y;break;

	    }
	}else{// 对手段
	    switch note_arrow {
        
	        case 0:x=obj_main.obj_opponent_left_arrow.x;
			now_y=obj_main.obj_opponent_left_arrow.y;break;
	        case 1:x=obj_main.obj_opponent_down_arrow.x;
			now_y=obj_main.obj_opponent_down_arrow.y;break;
	        case 2:x=obj_main.obj_opponent_up_arrow.x;
			now_y=obj_main.obj_opponent_up_arrow.y;break;
	        case 3:x=obj_main.obj_opponent_right_arrow.x;
			now_y=obj_main.obj_opponent_right_arrow.y;break;

	    }   
	}
    // 音符向上移动（每秒20*60像素）
	var speed_move = 20
	speed_move = 22.5
    y = cr_obj_note - move_y - (time_deviation * (speed_move/1000))
    move_y += (speed_move * 60) * _dt 
    // 检查音符是否到达判定线（y=100）且满足自动播放或非玩家音符条件
    if y <= (_NOTENOWY) and (global.Game_inf.BOTPLAY = 1 or Note_mustHitSection = 0) {
        // 如果是第一次检查且是玩家音符段
        if check_note = 0 and Note_mustHitSection and worry_note = "NOONE"{
            // 创建音符特效
            var obj = instance_create_depth(x,_NOTENOWY,-15,obj_noteSplashes)    
            obj.Note_Direction = note_arrow
            
            // 如果是长音符，增加连击
            if Note_length > 0 {
				//global.Game_inf.max_score += 300
				//global.Game_inf.total_score += 300
                global.Game_inf.Combo_note ++
				if worry_note = "NOONE" {
					scrore_ui(global.Game_inf.Combo_note,func_judge_performance_quality(y,_NOTENOWY,note_arrow,false))    
				}else{
					scrore_ui(global.Game_inf.Combo_note,func_judge_performance_quality(y,_NOTENOWY,note_arrow,true))    	
				}
                global.Game_inf.heath += 0.5
            }
            // 设置BF角色动画
            global.player_i._test_time = 0
            global.player_i.Action = note_arrow
            global.player_i.time = 30
        }
		if check_note = 0 and Note_mustHitSection = false{
			global.player_o._test_time = 0
            global.player_o.Action = note_arrow
            global.player_o.time = 30
		}
		if worry_note = "NOONE" {
			check_note = 1  // 标记已检查
		}
        //检查是否为长音
        if Note_length <= Check_note_length and worry_note = "NOONE"{//长度
            // 根据音符所属玩家设置对应的音符状态
            if Note_mustHitSection {//是否必须点击
                switch note_arrow {
                    case 0:global.Game_inf.Note_player2_0=1;break;
                    case 1:global.Game_inf.Note_player2_1=1;break;
                    case 2:global.Game_inf.Note_player2_2=1;break;
                    case 3:global.Game_inf.Note_player2_3=1;break;
                }
                
            
            }else{
                switch note_arrow {
                    case 0:global.Game_inf.Note_player1_0=1;break;
                    case 1:global.Game_inf.Note_player1_1=1;break;
                    case 2:global.Game_inf.Note_player1_2=1;break;
                    case 3:global.Game_inf.Note_player1_3=1;break;
                }    
            
            }
            
            if worry_note = "NOONE" {
				instance_destroy(id)  // 销毁音符实例
			}
            //添加连击（仅对短音符和玩家音符）
            if note_arrow <= 3 and Note_mustHitSection and Note_length <= 0{
                global.Game_inf.Combo_note ++
				//global.Game_inf.total_score += 300
				global.Game_inf.heath += 1
                scrore_ui(global.Game_inf.Combo_note,func_judge_performance_quality(y,_NOTENOWY,note_arrow,false))
            }
            
        }
        // 更新长音符检查长度
        Check_note_length = -(y-_NOTENOWY)//(20 * 60) * _dt
    
    }
}

// 如果音符方向无效（>=4），立即销毁
if  note_arrow >= 4 {
    instance_destroy(id)
}

// 长音符持续判定逻辑（玩家段）
if Note_length > 0 and check_note=true and Note_mustHitSection and global.Game_inf.BOTPLAY = 1 and worry_note = "NOONE"{
    //global.player_i.Action = note_arrow
    global.player_i.time = 30
    
    // 设置玩家音符状态
    switch note_arrow {
        case 0:global.Game_inf.Note_player2_0=1;break;
        case 1:global.Game_inf.Note_player2_1=1;break;
        case 2:global.Game_inf.Note_player2_2=1;break;
        case 3:global.Game_inf.Note_player2_3=1;break;
    }
    
    // 设置对应箭头对象的动画
    switch note_arrow {
        case 0:obj_main.obj_left_arrow.alarm_time = 4;
        obj_main.obj_left_arrow.image_index=0;break;
        case 1:obj_main.obj_down_arrow.alarm_time = 4;
        obj_main.obj_down_arrow.image_index=0;break;
        case 2:obj_main.obj_up_arrow.alarm_time = 4;
        obj_main.obj_up_arrow.image_index=0;break;
        case 3:obj_main.obj_right_arrow.alarm_time = 4;
        obj_main.obj_right_arrow.image_index=0;break;
        
    }
}

// 长音符持续判定逻辑（对手段）
if Note_length > 0 and check_note=true and Note_mustHitSection=false{
    // 设置对手音符状态
	global.player_o.time = 30
    switch note_arrow {
        case 0:global.Game_inf.Note_player1_0=1;break;
        case 1:global.Game_inf.Note_player1_1=1;break;
        case 2:global.Game_inf.Note_player1_2=1;break;
        case 3:global.Game_inf.Note_player1_3=1;break;
    }
    
    // 设置对应对手箭头对象的动画
    switch note_arrow {
        case 0:obj_main.obj_opponent_left_arrow.alarm_time = 4;
        obj_main.obj_opponent_left_arrow.image_index=0;break;
        case 1:obj_main.obj_opponent_down_arrow.alarm_time = 4;
        obj_main.obj_opponent_down_arrow.image_index=0;break;
        case 2:obj_main.obj_opponent_up_arrow.alarm_time = 4;
        obj_main.obj_opponent_up_arrow.image_index=0;break;
        case 3:obj_main.obj_opponent_right_arrow.alarm_time = 4;
        obj_main.obj_opponent_right_arrow.image_index=0;break;
        
    }
}

//同步与obj_arrow的X位置Y位置
if Note_mustHitSection {//是否必须点击（玩家段）
    // 根据音符方向同步到对应玩家箭头位置
    switch note_arrow {
        
        case 0:x=obj_main.obj_left_arrow.x;break;
        case 1:x=obj_main.obj_down_arrow.x;break;
        case 2:x=obj_main.obj_up_arrow.x;break;
        case 3:x=obj_main.obj_right_arrow.x;break;

    }
}else{// 对手段
    // 根据音符方向同步到对应对手箭头位置
    switch note_arrow {
        
        case 0:x=obj_main.obj_opponent_left_arrow.x;break;
        case 1:x=obj_main.obj_opponent_down_arrow.x;break;
        case 2:x=obj_main.obj_opponent_up_arrow.x;break;
        case 3:x=obj_main.obj_opponent_right_arrow.x;break;

    }
    
}

// 错过音符检测（玩家段）
if y <= -200 and Note_mustHitSection = 1 and check_note = 0 and worry_note = "NOONE"{
    if miss_note = 0 {
		miss_note_do()
    }
    miss_note = 1;    
}

//自动销毁
if y <= -240{
    // 短音符在y<=-100时销毁
    if Note_length <= 0 {
		
        instance_destroy(id)    
    }else if y <= -280 - Note_length * 5{
        // 长音符在超出一定范围后销毁
        instance_destroy(id)
    }
}

// Player check
if Note_mustHitSection = 1 and (y >= (-200 +_NOTENOWY) and y <= (200 + _NOTENOWY)) and Note_length <= 10{
	
    my_target_y = _NOTENOWY;
    	
	if can_hit = true {
		switch note_arrow {
			case 0:
			if global.check_map.left_pressed{
				player_check_do()
				instance_destroy(id)
				var obj = instance_create_depth(x,_NOTENOWY,-15,obj_noteSplashes)    
	            obj.Note_Direction = note_arrow
				global.player_i._test_time = 0
		        global.player_i.Action = note_arrow
		        global.player_i.time = 30
				global.Game_inf.Note_player2_0=1;
			
				global.Game_inf.Combo_note ++
	            scrore_ui(global.Game_inf.Combo_note,func_judge_performance_quality(y,_NOTENOWY,0,false))
				//obj_main.obj_left_arrow.sprite_index=left_confirm0000;
			};
			break;
		
			case 1:
			if global.check_map.down_pressed{
				player_check_do()
				instance_destroy(id)
				var obj = instance_create_depth(x,_NOTENOWY,-15,obj_noteSplashes)    
	            obj.Note_Direction = note_arrow
				global.player_i._test_time = 0
		        global.player_i.Action = note_arrow
		        global.player_i.time = 30
				global.Game_inf.Note_player2_1=1;
			
				global.Game_inf.Combo_note ++
	            scrore_ui(global.Game_inf.Combo_note,func_judge_performance_quality(y,_NOTENOWY,1,false))
				//obj_main.obj_down_arrow.sprite_index=down_confirm0000;
			};
			break;
		
			case 2:
			if global.check_map.up_pressed{
				player_check_do()
				instance_destroy(id)
				var obj = instance_create_depth(x,_NOTENOWY,-15,obj_noteSplashes)    
	            obj.Note_Direction = note_arrow
				global.player_i._test_time = 0
		        global.player_i.Action = note_arrow
		        global.player_i.time = 30
				global.Game_inf.Note_player2_2=1;
						
				global.Game_inf.Combo_note ++
	            scrore_ui(global.Game_inf.Combo_note,func_judge_performance_quality(y,_NOTENOWY,2,false))
				//obj_main.obj_up_arrow.sprite_index=up_confirm0000;
			};
			break;
		
			case 3:
			if global.check_map.right_pressed{
				player_check_do()
				instance_destroy(id)
				var obj = instance_create_depth(x,_NOTENOWY,-15,obj_noteSplashes)    
	            obj.Note_Direction = note_arrow
				global.Game_inf.Note_player2_3=1;
				global.player_i._test_time = 0
		        global.player_i.Action = note_arrow
		        global.player_i.time = 30
				global.Game_inf.Combo_note ++
	            scrore_ui(global.Game_inf.Combo_note,func_judge_performance_quality(y,_NOTENOWY,3,false))
				//obj_main.obj_right_arrow.sprite_index=right_confirm0000;
			};
			break;
		}
		
	}
	
}

if Note_mustHitSection = 1 and Note_length > 0{
	
	if check_note = 0 and (y >= (-200 + _NOTENOWY) and y <= (200 + _NOTENOWY)){
		
		if can_hit = true {
			switch note_arrow {
				case 0:
				if global.check_map.left_pressed{
					player_check_do()
					var obj = instance_create_depth(x,_NOTENOWY,-15,obj_noteSplashes)    
					obj.Note_Direction = note_arrow
					global.Game_inf.Note_player2_0=1;
					global.player_i._test_time = 0
		            global.player_i.Action = note_arrow
		            global.player_i.time = 30
					global.Game_inf.Combo_note ++
		            scrore_ui(global.Game_inf.Combo_note,func_judge_performance_quality(y,_NOTENOWY,0,false))
					//obj_main.obj_left_arrow.sprite_index=left_confirm0000;
				};
				break;
		
				case 1:
				if global.check_map.down_pressed{
					player_check_do()
					var obj = instance_create_depth(x,_NOTENOWY,-15,obj_noteSplashes)    
					obj.Note_Direction = note_arrow
					global.Game_inf.Note_player2_1=1;
					global.player_i._test_time = 0
		            global.player_i.Action = note_arrow
		            global.player_i.time = 30
					global.Game_inf.Combo_note ++
		            scrore_ui(global.Game_inf.Combo_note,func_judge_performance_quality(y,_NOTENOWY,1,false))
					//obj_main.obj_down_arrow.sprite_index=down_confirm0000;
				};
				break;
		
				case 2:
				if global.check_map.up_pressed{
					player_check_do()
					var obj = instance_create_depth(x,_NOTENOWY,-15,obj_noteSplashes)    
					obj.Note_Direction = note_arrow
					global.Game_inf.Note_player2_2=1;
					global.player_i._test_time = 0
		            global.player_i.Action = note_arrow
		            global.player_i.time = 30			
					global.Game_inf.Combo_note ++
		            scrore_ui(global.Game_inf.Combo_note,func_judge_performance_quality(y,_NOTENOWY,2,false))
					//obj_main.obj_up_arrow.sprite_index=up_confirm0000;
				};
				break;
		
				case 3:
				if global.check_map.right_pressed{
					player_check_do()
					var obj = instance_create_depth(x,_NOTENOWY,-15,obj_noteSplashes)    
					obj.Note_Direction = note_arrow
					global.Game_inf.Note_player2_3=1;
					global.player_i._test_time = 0
		            global.player_i.Action = note_arrow
		            global.player_i.time = 30		
					global.Game_inf.Combo_note ++
		            scrore_ui(global.Game_inf.Combo_note,func_judge_performance_quality(y,_NOTENOWY,3,false))
					//obj_main.obj_right_arrow.sprite_index=right_confirm0000;
				};
				break;
			}
		
			
		}
	}
	if (y <= _NOTENOWY) and y >= (_NOTENOWY - Note_length * 1 - 20){
		switch note_arrow {
			case 0:
			if global.check_map.left{
				player_check_long_do()
				global.Game_inf.Note_player2_0=1;
				check_note = 1	
				Check_note_length = -(y-_NOTENOWY)
				global.player_i.time = 30
				obj_main.obj_left_arrow.alarm_time = 0;
				obj_main.obj_left_arrow.image_index=0;
				//obj_main.obj_left_arrow.sprite_index=left_confirm0000;
			};
			break;
		
			case 1:
			if global.check_map.down{
				player_check_long_do()
				global.Game_inf.Note_player2_1=1;
				check_note = 1
				Check_note_length = -(y-_NOTENOWY)
				global.player_i.time = 30
				obj_main.obj_down_arrow.alarm_time = 0;
				obj_main.obj_down_arrow.image_index=0;
				//obj_main.obj_down_arrow.sprite_index=down_confirm0000;
			};
			break;
		
			case 2:
			if global.check_map.up{
				player_check_long_do()
				global.Game_inf.Note_player2_2=1;
				check_note = 1		
				Check_note_length = -(y-_NOTENOWY)
				global.player_i.time = 30
				obj_main.obj_up_arrow.alarm_time = 0;
				obj_main.obj_up_arrow.image_index=0;
				//obj_main.obj_up_arrow.sprite_index=up_confirm0000;
			};
			break;
		
			case 3:
			if global.check_map.right{
				player_check_long_do()
				global.Game_inf.Note_player2_3=1;
				check_note = 1		
				Check_note_length = -(y-_NOTENOWY)
				global.player_i.time = 30
				obj_main.obj_right_arrow.alarm_time = 0;
				obj_main.obj_right_arrow.image_index=0;
				//obj_main.obj_right_arrow.sprite_index=right_confirm0000;
			};
			break;
		}
	}
}




