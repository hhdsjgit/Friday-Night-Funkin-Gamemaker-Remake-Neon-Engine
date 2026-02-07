// 创建对象 obj_textbox
// 创建事件
depth = -1
active = 1
is_active = false;          // 是否激活输入
text = "";              // 存储的文本
cursor_pos = 0;         // 光标位置
cursor_blink = 0;       // 光标闪烁计时器
max_length = 200;        // 最大字符数
placeholder = "text..."; // 占位符
input_ok = false
// 定义输入框外观
box_x = 100;
box_y = 100;
box_width = 600;
box_height = 30;
buff_time = 10
choose_text = "NONE"
if clipboard_has_text()
{
    str = clipboard_get_text();
    clipboard_set_text("");
}