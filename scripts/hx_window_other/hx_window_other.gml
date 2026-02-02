//扩展部分
dll_CreateWindow		=	external_define(__dllhx,"CreateWindow"			,0, 1 , 4 ,	1 , 1 , 1 , 1	)
dll_WindowSetRect		=	external_define(__dllhx,"WindowSetRect"			,0, 0 , 2 ,	1 , 1			)
dll_WindowSetBorder		=	external_define(__dllhx,"SetWindowBorder"		,0, 0 , 2 ,	1 , 0			)
dll_WindowGetRect		=	external_define(__dllhx,"WindowGetRect"			,0, 1 , 1 ,	1				)
//dll_WindowFixed			=	external_define(__dllhx,"WindowFixed"			,0, 0 , 2 ,	1 , 0			)
dll_WindowDrawImage		=	external_define(__dllhx,"WindowDrawImage"		,0, 0 , 3 ,	1 , 1 , 1		)
dll_WindowGetBorderSize	=	external_define(__dllhx,"WindowGetBorderSize"	,0, 1 , 1 , 1				)
dll_WindowSetTOOLWINDOW	=	external_define(__dllhx,"WindowSetTOOLWINDOW"	,0, 0 , 2 ,	1 , 0			)
dll_WindowShowCustom	=	external_define(__dllhx,"WindowShowCustom"		,0, 0 , 2 ,	1 , 0			)
dll_WindowClose			=	external_define(__dllhx,"WindowClose"			,0, 0 , 1 ,	1				)

/**@func window_new_XYWH 创建新窗口
* @arg {string} iconPath 图标 1 默认,0 空,或者填路径,如"test.png"
* @arg {real} controlled 窗口是否接受操作，操作会转移到GM自身窗口，这麻烦而不实用。1是 0否
* @arg {real} border 边框，1有，0无
* 关闭时异步map格式 { ID : 4589764 type : close name : 111 }
* 焦点时异步map{ ID : 4589764 type : hasFocus name : 111 }
* 失焦时异步map区别在于type为lostFocus
* 注意窗口关闭时记得结束函数调用!!!!
*/
/*
iconPath icon 1 By default,0 is left blank, or the path is filled in, such as "test.png".
controlled If the window accepts the operation, the operation will be transferred to the GM's own window, which is cumbersome and not practical. 1 Yes 0 no
border Indicates a border with 1 and 0
* Asynchronous map format when disabled {ID: 4589764 type: close name: 111}
* Asynchronous map{ID: 4589764 type: hasFocus name: 111}
* Out-of-focus asynchronous map is different because type is lostFocus
* Remember to end the function call!!!! when the window closes
*/
function window_new_XYWH(xx=200,yy=200,ww=400,hh=400,title,icon="0",controlled=1,border=1){
	return external_call(gar.dll_CreateWindow,window_handle(),string([xx,yy,ww,hh,controlled,border]),title,icon)
}

//设置窗口位置坐标和大小 x y w h
//@desc Set window position coordinates and size x y w h
function window_Set_XYWH(handle=window_handle(),xx=200,yy=200,ww=400,hh=400){
	return external_call(gar.dll_WindowSetRect,handle,string([xx,yy,ww,hh]))
}

//获取窗口位置坐标和大小 x1 y1 x2 ,y2
/**@func window_Get_Rect(_ptr)
 * @desc Obtain window position coordinates and size x1 y1 x2, y2
*/
function window_Get_Rect(_ptr){
	return json_parse( external_call(gar.dll_WindowGetRect,_ptr))
}
//窗口内绘制传入内容,不需要隐藏边框且不需要半透明时用,效率可能高些
//Draw incoming content within the window without hiding borders or requiring translucency, which may be more efficient
function window_DrawImage(_ptr,buffer,w,h){
	return external_call(gar.dll_WindowDrawImage,_ptr,buffer_get_address(buffer),string([w,h]))
}

//获取标题栏高度,边框宽度,默认应该是31和8,微软给的是32,
//不同方法获取值多种多样,我也不清楚,现在获取的是28和4,计算得出39(31+8)和8(4+4),有1像素偏差
//反正这个不能直接用,以及考虑缩放问题,不知道最终如何
// Get the title bar height, border width, the default should be 31 and 8, Microsoft gives 32,
// Different methods to get a variety of values, I do not know, now get 28 and 4, calculated 39(31+8) and 8(4+4), there is a 1 pixel deviation
// Anyway, this can not be used directly, and consider the scaling problem, I don't know how to end up
function window_Get_BorderSize(_ptr=window_handle()){
	return json_parse(external_call(gar.dll_WindowGetBorderSize,_ptr))
}
//设置为工具窗口
function window_SetTOOLWINDOW(_ptr=window_handle(),show=1){
	return external_call(gar.dll_WindowSetTOOLWINDOW,_ptr,show)
}
//自定义window_Show
function window_ShowCustom(_ptr=window_handle(),show=6){
	return external_call(gar.dll_WindowShowCustom,_ptr,show)
}



//设置窗口边框,尽量不要用，不可靠。
//Set window borders
function window_RemoveBorder(_ptr=window_handle(),remove=1){
	return external_call(gar.dll_WindowSetBorder,_ptr,remove)
}

/**@func window_SetClose(ptr) 关闭子窗口用的到 Useful for closing sub windows
 * @arg {pointer} handle 要关闭的窗口的句柄
 */
function window_SetClose(_ptr){
	return external_call(gar.dll_WindowClose,_ptr)
}


////固定窗口,禁止标题栏移动1禁止移动,2恢复
//function window_Fixed(_ptr=window_handle(),fixed=1){
//	return external_call(gar.dll_WindowFixed,_ptr,fixed)
//}