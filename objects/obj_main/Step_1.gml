/// @description
global.check_map.left_pressed = keyboard_check_pressed(vk_left) or keyboard_check_pressed(ord("A"));
global.check_map.down_pressed = keyboard_check_pressed(vk_down) or keyboard_check_pressed(ord("S"));
global.check_map.up_pressed = keyboard_check_pressed(vk_up) or keyboard_check_pressed(ord("W"));
global.check_map.right_pressed = keyboard_check_pressed(vk_right) or keyboard_check_pressed(ord("D"));

global.check_map.left = keyboard_check(vk_left) or keyboard_check(ord("A"));
global.check_map.down = keyboard_check(vk_down) or keyboard_check(ord("S"));
global.check_map.up = keyboard_check(vk_up) or keyboard_check(ord("W"));  
global.check_map.right = keyboard_check(vk_right) or keyboard_check(ord("D"));