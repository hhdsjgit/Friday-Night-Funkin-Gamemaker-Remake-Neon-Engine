/// @description 优化的音符接收器Step逻辑

// ==================== 玩家侧逻辑 ====================
if Note_mustHitSection = 1 {
    
    // 使用switch处理不同方向的状态1（确认）
    switch Note_Direction {
        case 0:
            if global.Game_inf.Note_player2_0 = 1 {
                sprite_index = skin_left_pass_ok;
                alarm_time = 3;
            }
            break;
        case 1:
            if global.Game_inf.Note_player2_1 = 1 {
                sprite_index = skin_down_pass_ok;
                alarm_time = 3;
            }
            break;
        case 2:
            if global.Game_inf.Note_player2_2 = 1 {
                sprite_index = skin_up_pass_ok;
                alarm_time = 3;
            }
            break;
        case 3:
            if global.Game_inf.Note_player2_3 = 1 {
                sprite_index = skin_right_pass_ok;
                alarm_time = 3;
            }
            break;
    }
    
    // 使用switch处理不同方向的状态2（按下）
    switch Note_Direction {
        case 0:
            if global.Game_inf.Note_player2_0 = 2 {
                sprite_index = skin_left_pass;
                alarm_time = 3;
            }
            break;
        case 1:
            if global.Game_inf.Note_player2_1 = 2 {
                sprite_index = skin_down_pass;
                alarm_time = 3;
            }
            break;
        case 2:
            if global.Game_inf.Note_player2_2 = 2 {
                sprite_index = skin_up_pass;
                alarm_time = 3;
            }
            break;
        case 3:
            if global.Game_inf.Note_player2_3 = 2 {
                sprite_index = skin_right_pass;
                alarm_time = 3;
            }
            break;
    }
    
    // 计时器结束，重置状态
    if alarm_time <= 0 {
        switch Note_Direction {
            case 0:
                sprite_index = skin_left;
                global.Game_inf.Note_player2_0 = 0;
                break;
            case 1:
                sprite_index = skin_down;
                global.Game_inf.Note_player2_1 = 0;
                break;
            case 2:
                sprite_index = skin_up;
                global.Game_inf.Note_player2_2 = 0;
                break;
            case 3:
                sprite_index = skin_right;
                global.Game_inf.Note_player2_3 = 0;
                break;
        }   
    }
}

// ==================== 对手侧逻辑 ====================
if Note_mustHitSection = 0 {
    
    // 对手侧：只在普通状态时响应确认
    switch Note_Direction {
        case 0:
            if sprite_index = skin_left and global.Game_inf.Note_player1_0 = 1 {
                sprite_index = skin_left_pass_ok;
                alarm_time = 4;
            }
            break;
        case 1:
            if sprite_index = skin_down and global.Game_inf.Note_player1_1 = 1 {
                sprite_index = skin_down_pass_ok;
                alarm_time = 4;
            }
            break;
        case 2:
            if sprite_index = skin_up and global.Game_inf.Note_player1_2 = 1 {
                sprite_index = skin_up_pass_ok;
                alarm_time = 4;
            }
            break;
        case 3:
            if sprite_index = skin_right and global.Game_inf.Note_player1_3 = 1 {
                sprite_index = skin_right_pass_ok;
                alarm_time = 4;
            }
            break;
    }
    
    // 计时器结束，重置状态
    if alarm_time <= 0 {
        switch Note_Direction {
            case 0:
                sprite_index = skin_left;
                global.Game_inf.Note_player1_0 = 0;
                break;
            case 1:
                sprite_index = skin_down;
                global.Game_inf.Note_player1_1 = 0;
                break;
            case 2:
                sprite_index = skin_up;
                global.Game_inf.Note_player1_2 = 0;
                break;
            case 3:
                sprite_index = skin_right;
                global.Game_inf.Note_player1_3 = 0;
                break;
        }   
    }
}

// ==================== 统一计时器处理 ====================
if alarm_time > 0 {
    alarm_time -= func_frc_main(60);
    
    // 限制动画帧
    if image_index >= 3 {
        image_index = 3;
    }
}

// ==================== 玩家侧动画帧限制 ====================
if Note_mustHitSection = 1 {
    // 按下状态限制
    if image_index >= 3 and 
       (sprite_index = skin_left_pass or 
        sprite_index = skin_down_pass or 
        sprite_index = skin_up_pass or 
        sprite_index = skin_right_pass) {
        image_index = 3;
    }
    
    // 确认状态限制
    if image_index >= 3 and 
       (sprite_index = skin_left_pass_ok or 
        sprite_index = skin_down_pass_ok or 
        sprite_index = skin_up_pass_ok or 
        sprite_index = skin_right_pass_ok) {
        image_index = 3;
    }
}