#macro gar global

#region
__dllhx="hx_window_ext.dll"
external_define(__dllhx,"RegisterCallbacks",0,0,4,1,1,1,1) //dll_cdecl 0  ty_real 0  ty_string 1
dll_SyncTest		=	external_define(__dllhx,"SyncTest",	0,0,0);function __hxSyncTest(){return external_call(gar.dll_SyncTest)}//dll_WSetAlpACrkey		=	external_define(__dllhx,"WindowSetAlpACrkey"	,dll_cdecl,ty_real,2,ty_string,ty_real) 
			 															   // ,返回 数量 1	2	3	4
dll_WSetAlpACrkey		=	external_define(__dllhx,"WindowSetAlpACrkey"	,0, 0 , 3 ,	1 , 0 , 0		)
dll_WResetAlpAndCrk		=	external_define(__dllhx,"WindowResetAlpAndCrk"	,0, 0 , 1 ,	1 				)
dll_WindowSetShape		=	external_define(__dllhx,"WindowSetShape"		,0, 0 , 4 ,	1 , 1 , 1 , 0	)
dll_WDwmExtendFrame		=	external_define(__dllhx,"WindowDwmExtend"		,0, 0 , 2 ,	1 , 1 			)

dll_WindowSetTopMost	=	external_define(__dllhx,"WindowSetTopMost"		,0, 0 , 2 ,	1 , 0			)
dll_WindowSetPenetrate	=	external_define(__dllhx,"WindowSetPenetrate"	,0, 0 , 2 ,	1 , 0			)
dll_WindowHide			=	external_define(__dllhx,"WindowHide"			,0, 0 , 1 ,	1 				)
dll_WindowShow			=	external_define(__dllhx,"WindowShow"			,0, 0 , 2 ,	1 , 1			)
dll_WindowMinimize		=	external_define(__dllhx,"WindowMinimize"		,0, 0 , 1 ,	1 				)

dll_WindowCloseConfirm	=	external_define(__dllhx,"WindowCloseConfirm"	,0, 0 , 4 ,	1 , 1 , 1 , 0	)
dll_MenuBottonDelete	=	external_define(__dllhx,"MenuBottonDelete"		,0, 0 , 3 ,	1 , 0 , 0		)
dll_MenuButtonEnable	=	external_define(__dllhx,"MenuButtonEnable"		,0, 0 , 4 ,	1 , 0 , 0 , 0	)

dll_ImeEnable			=	external_define(__dllhx,"IMEEnable"				,0, 0 , 2 ,	1 , 0			)
dll_ImeIsEnable			=	external_define(__dllhx,"IMEGetEnable"			,0, 0 , 1 ,	1 				)
dll_ImeSetPosition		=	external_define(__dllhx,"IMESetPosition"		,0, 0 , 3 ,	1 , 0 , 0		)

dll_ConvertEncoding		=	external_define(__dllhx,"StrConvertEncoding"	,0, 1 , 3 ,	1 , 1 , 1		)
dll_CaptureScreenBuffer	=	external_define(__dllhx,"CaptureScr2Buffer"		,0, 0 , 2 ,	1 , 1			)

dll_FileOpen			=	external_define(__dllhx,"FileOpen"				,0, 0 , 2 ,	1 , 1			)
dll_FileWriteText		=	external_define(__dllhx,"FileWriteText"			,0, 0 , 3 ,	1 , 1 , 1		)
dll_FileBufferToImage	=	external_define(__dllhx,"FileBufferToImage"		,0, 0 , 4 ,	1 , 1 , 0 , 0	)
dll_FileSaveBuffer		=	external_define(__dllhx,"FileSaveBuffer"		,0, 0 , 3 ,	1 , 1 , 0		)
dll_FileGetInfo			=	external_define(__dllhx,"FileGetInfo"			,0, 1 , 1 ,	1				)
dll_ImageGetSize		=	external_define(__dllhx,"ImageGetSize"			,0, 1 , 1 ,	1				)

dll_FileGetIcon			=	external_define(__dllhx,"FileGetIcon"			,0, 0 , 4 ,	1 , 1 , 0 , 0	)
dll_FileCopy			=	external_define(__dllhx,"FileCopy"				,0, 0 , 2 ,	1 , 1			)
dll_FileDelete			=	external_define(__dllhx,"FileDelete"			,0, 0 , 1 ,	1 ,				)

dll_FileDrop			=	external_define(__dllhx,"FileDropEnable"		,0, 0 , 2 ,	1 , 0			)
dll_GetKeyState			=	external_define(__dllhx,"GetKeyState"			,0, 0 , 1 ,	0				)

dll_CmdCreate			=	external_define(__dllhx,"CmdCreateWindow"		,0, 0 , 3,	1 , 1 , 1		)
dll_CmdCommand			=	external_define(__dllhx,"CmdSendCommand"		,0, 1 , 2 ,	0 ,	1			)		
dll_CmdExit				=	external_define(__dllhx,"CmdExit"				,0, 1 , 1 ,	0				)
dll_CmdCommandB			=	external_define(__dllhx,"CmdExecute"			,0, 1 , 4 ,	1 ,	1 , 1 , 1	)		
#endregion

/**@func window_set_AlphaAndCrkey 设置窗口整体透明度和色度键
 * @desc Set the overall transparency and chromaticity keys of the window
 * @arg {real} alpha 0-255 设置颜色值,0透明~255不透明
 * @arg {real} crkey color(BGR) 设置颜色值
 */
function window_set_AlphaAndCrkey(alpha=128,crkey=c_black){
	return external_call(gar.dll_WSetAlpACrkey,window_handle(),alpha,crkey)
}

/**@func window_ExtendFrame 窗口边框扩展 窗口客户区扩展实现窗口透明,需要先设置无边框
 * @desc client area extension to achieve window transparency, need set no borders and clear draw,
 * see "E10 transparent-Expand border"
 * @arg {array} value Border value 边框值，-1透明，当你需要不等宽边框时才需要修改,0是默认值
 * @return {bool} 1 成功,0失败,失败时会打印其它错误码
 */
function window_ExtendFrame(value=[-1,0,0,0]){
	return external_call(gar.dll_WDwmExtendFrame,window_handle(),string(value))
}

/**
 * @func window_set_Shape 设置窗口形状
 * @desc Set window shape,Not recommended to use secondary functions
   buffer_get_surface(buf,application_surface,0) window_set_Shape(buf,500,500,128) draw_clear_alpha(c_black,0)
 * @arg {buffer} buffer 包含形状信息的缓冲区
 * @arg {real} w 形状的宽度
 * @arg {real} h 形状的高度
 * @arg {real} alpha 透明度 0透明 255 不透明
 */
function window_set_Shape(buffer,w,h,alpha){
	return external_call(gar.dll_WindowSetShape,window_handle() ,buffer_get_address(buffer),string([w,h]),alpha)
}

/**@func window_remove_transparency 移除窗口透明度色度键属性
 * @desc Remove window transparency chroma key attribute
 */
function window_remove_transparency(){
	return external_call(gar.dll_WResetAlpAndCrk,window_handle())
}

/**@func window_set_TopMost 设置窗口置顶
 * @desc Set the window to the top
 * @arg {bool}  topMost 0 false 1 true 设置窗口置顶,0不,1是,2 Z顺序的顶部
 */
function window_set_TopMost(topMost=1){
	return external_call(gar.dll_WindowSetTopMost ,window_handle(),topMost)
}

/**@func window_set_Penetrate 设置窗口点击穿透
 * @desc Set window click penetration
 * @arg {real}  pass 0关穿透，1开穿透
 */
function window_set_Penetrate(pass=1){
	return external_call(gar.dll_WindowSetPenetrate,window_handle(),pass)
}


/**@func window_set_Show 设置窗口显示
 * 备用方案  Alternative plan: window_ShowCustom(,9)
 * @arg {string}  title title是不显示时的备用手段 
 */
function window_set_Show(title=""){//window_get_caption()
	return external_call(gar.dll_WindowShow,window_handle(),title)
}
/**@func window_set_Hide 设置窗口隐藏
 */
function window_set_Hide(){
	return external_call(gar.dll_WindowHide,window_handle())
}
/**@func window_set_Minimize 设置窗口最小化
 */
function window_set_Minimize(){
	return external_call(gar.dll_WindowMinimize,window_handle())
}

/**@func window_set_CloseConfirm 关闭确认
 * @arg {string}	text 文本
 * @arg {string}	title 标题
 * @arg {bool}		anync 1 返回异步信息,自己处理关闭,前两个参数无效化
 */
function window_set_CloseConfirm(text,title,anync=0){
	return external_call(gar.dll_WindowCloseConfirm	,window_handle(),text,title,anync)
}

/**
 * @func window_set_MenuBottonDelete 删除菜单按钮 不包括关闭
 * @arg {real} s minimize 最小化
 * @arg {real} m maximize 最大化
 */
function window_set_MenuBottonDelete(s=1,m=1){
	return external_call(gar.dll_MenuBottonDelete	,window_handle(),s,m)
}

/**
 * @func window_set_MenuButtonEnable 启用/禁用窗口按钮 有bug,只对关闭生效
 * @arg {real} s minimize 最小化
 * @arg {real} m maximize 最大化
 * @arg {real} c close 关闭
 */
function window_set_MenuButtonEnable(s=1,m=1,r=1){
	return external_call(gar.dll_MenuButtonEnable	,window_handle(),s,m,r)
}

/**@func Capture_Screen(xx,yy,w,h) 屏幕区域截图
 * @desc Screenshot of Screen Region
		 可以作为正常截图功能使用，也可以用来模拟透明窗口以提高效率。
		 但是你可能需要自己根据需求重写函数来进行优化以提高性能，例如:
		 使用固定buffer,而不是每次重新分配，使用表面，而不是转为精灵。
		 这样减少重新分配资源带来的性能损失
 * @arg {real}  xx x 坐标
 * @arg {real}  yy y 坐标
 * @arg {real}  w w 宽度
 * @arg {real}  h h 高度
 */
function capture_Screen(xx,yy,w,h){
	//核心
	var buf = buffer_create(w*h*4,buffer_fast,1)
	external_call(gar.dll_CaptureScreenBuffer,buffer_get_address(buf),string([xx,yy,w,h]))
	
	var sur = surface_create(w, h)
	var su2 = surface_create(w, h)
	buffer_set_surface(buf,sur,0)
	
	//BGR->RGB转换
	surface_set_target(su2)
		shader_set(hx_BGR2RGB)
			draw_surface(sur,0,0)
		shader_reset()
	surface_reset_target()
	
	//surface -> sprite
	var spr = sprite_create_from_surface(su2,0,0,w,h,0,0,0,0)
	
	surface_free(sur)
	surface_free(su2)
	buffer_delete(buf)
	
	return spr
}

/**@func ime_Enable	 启用/禁用ime
 * @arg {real}  enable 0禁用,1启用
*/
function ime_Enable(enable=0){
	return external_call(gar.dll_ImeEnable,window_handle(),enable)
}
/**@func ime_Is_Enable	 获取ime状态
 * @return {real}  0禁用,1启用
*/
function ime_Is_Enable(){
	return external_call(gar.dll_ImeIsEnable,window_handle())
}
/**@func ime_Set_Position 
 * @desc 设置ime位置,会受窗口位置和大小影响,可能需要依据缩放计算坐标,
 * @arg {real}  xx x坐标
 * @arg {real}  yy y坐标
*/
function ime_Set_Position(xx=mouse_x,yy=mouse_y){
	return external_call(gar.dll_ImeSetPosition,window_handle(),xx,yy)
}


/**@func string_Convert_Encoding	 文本转码
 * @arg {string}  text text 文本
 * @arg {string}  sorEnc source Encoding 原始编码
 * @arg {string}  tarEnc target Encoding 目标编码
 */
function string_Convert_Encoding(text,sorEnc="GBK",tarEnc="UTF-8"){
	return external_call(gar.dll_ConvertEncoding,text,sorEnc,tarEnc)
}


/**@func file_Open 
 * @desc 打开文件 如
		file_Open(@"C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe",
		"--inprivate  --single-argument %1")
		"C:\\Program Files (x86)\\Adobe\\Reader 11.0\\Reader\\AcroRd32.exe", "/A /R example.pdf"
 * @arg {string}  path 路径
 * @arg {string}  arg 参数
 */
function file_Open(path,arg=""){
	return external_call(gar.dll_FileOpen,path,arg)
}

/**@func file_Text_Write 
 * @desc 写入文本文件
	file_Text_Write(@"C:\Users\90952\Desktop\测试.txt" ,"测试","GBK")
 * @arg {string}  path 路径
 * @arg {string}  text 文本
 * @arg {string}  encoding 编码
 */
function file_Text_Write(path,text,encoding="UTF-8"){
	return external_call(gar.dll_FileWriteText,path,text,encoding)
}
/**@func file_BufferToImage 
 * @desc 保存buffer为图像
	surface_set_target(sur)shader_set(hx_BGR2RGB)
		draw_sprite(tmtest,0,111,110)
	shader_reset()surface_reset_target()
	buffer_get_surface(buf,sur,0)
	file_BufferToImage(@"C:\Users\90952\Desktop\测试.png",buf,500,500)
 * @arg {string}  path 路径
 * @arg {buffer}  buffer 缓冲区
 * @arg {real}  w 宽度
 * @arg {real}  h 高度
 */
function file_BufferToImage(path,buffer,w,h){
	return external_call(gar.dll_FileBufferToImage,path,buffer_get_address(buffer),w,h)
}

/**@func file_SaveBuffer 
*@desc 保存buffer
 *	sur=surface_create(500,500)
	buf=buffer_load(@"C:\Users\90952\Desktop\测试a.png")
	buffer_set_surface(buf,sur,0)
 * @arg {string}  path 路径
 * @arg {string}  buffer 缓冲区
 */
function file_SaveBuffer(path,buffer){
	return external_call(gar.dll_FileSaveBuffer,path,buffer_get_address(buffer),buffer_get_size(buffer))
}

/**@func file_CopyEx 
 * @desc Copy file 复制文件
 * @arg {string}  srcPath 原始路径
 * @arg {string}  tarPath 目标路径
*/
function file_CopyEx(srcPath,tarPath){
	return external_call(gar.dll_FileCopy,srcPath,tarPath)
}
/**@func file_DeleteEx 
 * @desc Delete file 删除文件
 * @arg {string}  path 路径
*/
function file_DeleteEx(path){
	return external_call(gar.dll_FileDelete,path)
}

/**@func file_GetInfo 
 * @ desc Retrieve file information 获取文件信息 
	type: CreationTime,LastWriteTime,LastAccessTime,FileSize,IsReadOnly,IsHidden
	(创建时间,修改时间,访问时间,文件大小,只读,隐藏)
 * @arg {string}  path 路径
*/
function file_GetInfo(path){
	return json_parse(external_call(gar.dll_FileGetInfo,path))
}

/**@func file_ImageGetSize 
 * @desc 获取图像大小 
	Return Format:{"w":500,"h":500}
	To use, JSON parsing is required first: (json_parse(info2)).w
 * @arg {string}  path 路径
*/
function file_ImageGetSize(path){
	return json_parse(external_call(gar.dll_ImageGetSize,path))
}

/**@func file_DropDrag 
 * @desc 使窗口支持拖放文件，只需要调用一次!
		返回异步-社交事件map,第一项为:"type","dropFileList"
		后面键为0123… 值为文件路径,使用请参考工程里面"E5 App Drawer"
		Make GM support drag-and-drop files, only need to call once!
		Returns a map of asynchronous - social events with the first item :"type","dropFileList"
		The following key is 0123... The value is the file path. For details, see "E5 App Drawer"
 * @arg {real} enable 1启用 0禁用
 * @desc 拖放文件
*/
function file_DropDrag(enable=1){
	return external_call(gar.dll_FileDrop,window_handle(),enable)
}


/**@func file_GetIcon 获取文件使用的图标,暂不支持文件夹
 * @desc The icon used to retrieve files does not currently support folders 
 * @arg {string}  path 路径
 * @arg {real}  w 宽度
 * @arg {real}  h 高度
*/
function file_GetIcon(path,w,h=w){
	var buf = buffer_create(w*h*4,buffer_fast,1);
	if	(external_call(gar.dll_FileGetIcon,path,buffer_get_address(buf),w,h)){
		var sur = surface_create(w,h)
		var su2 = surface_create(w,h)
		buffer_set_surface(buf,sur,0)

		surface_set_target(su2)
			draw_clear_alpha(c_black,0)
			//draw_rectangle(1,1,40-1,40-1,0)
			shader_set(hx_BGR2RGB)
				draw_surface(sur,0,0)
			shader_reset()
		surface_reset_target()

		var spr=sprite_create_from_surface(su2,0,0,w,h,0,0,0,0)
		buffer_delete(buf)
		surface_free(sur)
		surface_free(su2)
		return spr
	}else{
		buffer_delete(buf)
		return -1;
	}
}


/**@func keyboard_check_KeyState 检查按键情况 Check the condition of the buttons
 * @desc 替代direct,返回值:0没按 1按下(pressed) 2释放(released) 3按住(hold)
 * @arg {real} vk 虚拟按键键码 Virtual Key Code
*/
function keyboard_check_KeyState(vk=1){
	return external_call(gar.dll_GetKeyState,vk)
}

/*
  使用cmd需要异步事件进行接收,这样做是为了避免卡游戏主进程
  如果你想单独开cmd窗口,那么使用file_Open打开CMD，但这样gm端无法接收到执行信息.
  使用下面异步代码获取返回的文本信息，你可以参考例子："test CMD"
  Using cmd requires asynchronous event reception, which is done to prevent the main game process from getting stuck
  If you want to open the cmd window separately, use file_Open to open the CMD window, 
  but the gm side will not receive the execution information.
  Use the following asynchronous code to get the returned text information, 
  you can refer to the example: "test CMD"
  if async_load[? "type"]!="CMDOUTPUT" exit
  print async_load[? "text"]
 */
/**@func cmd_CreateA Create a command line program 创建命令行程序
 * @arg {string} process Program Name 程序名称
 * @arg {string} arg Program parameters 程序参数
 * @arg {string} encoding 编码,中文环境下CMD要设置为GB2312,如果是调用GM则默认UTF-8
 * @return {real} CMD id
 */
function cmd_CreateA(process="cmd.exe",arg="",encoding="UTF-8"){
	return external_call(gar.dll_CmdCreate,process,arg,encoding)
}
/**@func cmd_CommandA Send a command to CMD 向CMD发送命令
 * @arg {real} cmd_id CMD的id,因为支持多个不同的cmd同时运行,所以需要
 * @arg {string} Command 命令
 */
function cmd_CommandA(cmd_id,Command){
	return external_call(gar.dll_CmdCommand,cmd_id,Command)
}
/**@func cmd_ExitA Exit CMD 退出CMD 退出CMD,你可以直接用exit退出cmd,但会留下索引导致少量内存泄漏
 * @arg {real} cmd_id
 */
function cmd_ExitA(cmd_id){
	return external_call(gar.dll_CmdExit,cmd_id)
}

/**@func cmd_Execute Execute CMD text 执行CMD文本
 * @arg {string} process Program Name 程序名称
 * @arg {string} arg Program parameters 程序参数
 * @arg {string} Command 命令行
 * @arg {string} encoding 编码,中文环境下CMD要设置为GB2312,如果是调用GM则默认UTF-8
 */
function cmd_Execute(process="cmd.exe",arg="",command="echo yysb\nping 192.168.1.1",encoding="UTF-8"){
	return external_call(gar.dll_CmdCommandB,process,arg,command,encoding)
}

















