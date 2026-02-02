function events(){

}
function camera_zoom_add (param1,param2) {
	global.Game_inf.cam_scale -= param1 * 2
	obj_main.Ui_Zoom += param2
}
function Flash_Camera(param1, param2) {
	obj_else_events.flash_active = 1
	obj_else_events.flash_time = real(param1)
}