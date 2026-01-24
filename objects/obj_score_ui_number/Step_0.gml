/// @description
// 根据chose_number选择不同的精灵显示模式
if chose_number = 1 {
    // 数字模式：显示0-9的数字
    switch number {
        case 0:sprite_index=num0;break;    
        case 1:sprite_index=num1;break;    
        case 2:sprite_index=num2;break;    
        case 3:sprite_index=num3;break;    
        case 4:sprite_index=num4;break;    
        case 5:sprite_index=num5;break;    
        case 6:sprite_index=num6;break;    
        case 7:sprite_index=num7;break;    
        case 8:sprite_index=num8;break;    
        case 9:sprite_index=num9;break;    
    }
}else{
    // 评级模式：显示"sick"或"good"评级
    switch number {
        case 0:sprite_index=sick;break;    
        case 1:sprite_index=good;break;    
		case 2:sprite_index=bad;break;  
		case 3:sprite_index=shit;break;  
    }
}

// 垂直移动：应用下落速度和加速度
y += func_frc(down_y)
// 计算下落加速度，使用缓动效果
down_y += func_frc(((4 + down_y_r) - down_y) / 12)

// 计时器递增
time += func_frc(1)

// 淡出效果：30帧后开始淡出
if time >= 30 {
    image_alpha -= func_frc(0.08)  // 每帧减少透明度
    // 当完全透明时销毁实例
    if image_alpha <= 0 {
        instance_destroy(id)    
    }
}

// 连击数更新时调整深度
if global.Game_inf.Combo_note > combo_note{
    depth = -11    
}