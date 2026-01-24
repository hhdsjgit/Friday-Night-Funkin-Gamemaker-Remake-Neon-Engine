import tkinter as tk
from tkinter import ttk, filedialog, messagebox, scrolledtext
import re
import os
import json

class LuaToGMLConverter:
    def __init__(self):
        self.setup_conversion_maps()
        
    def setup_conversion_maps(self):
        """设置完整的转换映射"""
        # 关键字映射
        self.keyword_map = {
            'function': 'function',
            'end': '}',
            'if': 'if',
            'then': '',
            'elseif': 'else if',
            'else': 'else',
            'for': 'for',
            'while': 'while',
            'do': '{',
            'repeat': 'do {',
            'until': '} until',
            'local': 'var',
            'nil': 'undefined',
            'true': 'true',
            'false': 'false',
            'and': '&&',
            'or': '||',
            'not': '!',
            'break': 'break',
            'return': 'return',
            'in': 'in'
        }
        
        # 数学函数映射
        self.math_functions = {
            'math.abs': 'abs',
            'math.acos': 'arccos',
            'math.asin': 'arcsin',
            'math.atan': 'arctan',
            'math.atan2': 'arctan2',
            'math.ceil': 'ceil',
            'math.cos': 'cos',
            'math.deg': 'radtodeg',
            'math.exp': 'exp',
            'math.floor': 'floor',
            'math.fmod': 'mod',
            'math.log': 'ln',
            'math.max': 'max',
            'math.min': 'min',
            'math.pow': 'power',
            'math.rad': 'degtorad',
            'math.random': 'irandom_range',
            'math.randomseed': 'randomize',
            'math.sin': 'sin',
            'math.sqrt': 'sqrt',
            'math.tan': 'tan'
        }
        
        # 字符串函数映射
        self.string_functions = {
            'string.byte': 'ord',
            'string.char': 'chr',
            'string.find': 'string_pos',
            'string.format': 'string_format',
            'string.gmatch': 'string_match_all',
            'string.gsub': 'string_replace_all',
            'string.len': 'string_length',
            'string.lower': 'string_lower',
            'string.upper': 'string_upper',
            'string.reverse': 'string_reverse',
            'string.sub': 'string_copy',
            'string.rep': 'string_repeat',
            'string.match': 'string_match'
        }
        
        # 表函数映射
        self.table_functions = {
            'table.concat': 'array_join',
            'table.insert': 'array_push',
            'table.remove': 'array_delete',
            'table.sort': 'array_sort',
            'table.pack': 'array_create',
            'table.unpack': 'array_unpack'
        }
        
        # 其他函数映射
        self.other_functions = {
            'print': 'show_debug_message',
            'io.write': 'show_debug_message',
            'io.read': 'keyboard_string',
            'os.clock': 'get_timer',
            'os.date': 'date_current_datetime',
            'os.time': 'date_current_time',
            'os.difftime': 'date_time_difference',
            'tostring': 'string',
            'tonumber': 'real',
            'type': 'typeof',
            'pairs': 'ds_map_find_value',
            'ipairs': 'array_foreach',
            'next': 'ds_map_find_next',
            'getmetatable': 'undefined',  # GML 无对应
            'setmetatable': 'undefined',  # GML 无对应
            'rawget': 'undefined',
            'rawset': 'undefined'
        }
        
        # 合并所有函数映射
        self.function_map = {}
        self.function_map.update(self.math_functions)
        self.function_map.update(self.string_functions)
        self.function_map.update(self.table_functions)
        self.function_map.update(self.other_functions)
        
        # GML 内置变量映射
        self.variable_map = {
            'self': 'self',
            'this': 'self',
            '_G': 'global'
        }
        
        # 操作符映射
        self.operator_map = {
            '~=': '!=',
            '..': '+',
            '#': 'array_length',
            '^': '^'
        }

    def convert_file(self, lua_file_path, gml_file_path):
        """转换整个 Lua 文件到 GML 文件"""
        try:
            with open(lua_file_path, 'r', encoding='utf-8') as lua_file:
                lua_code = lua_file.read()
            
            gml_code = self.convert_code(lua_code)
            
            with open(gml_file_path, 'w', encoding='utf-8') as gml_file:
                gml_file.write("// Converted from Lua to GML\n")
                gml_file.write("// Some manual adjustments may be needed\n\n")
                gml_file.write(gml_code)
                
            return True, f"转换完成: {lua_file_path} -> {gml_file_path}"
            
        except Exception as e:
            return False, f"转换错误: {e}"

    def convert_code(self, lua_code):
        """转换 Lua 代码字符串为 GML 代码"""
        # 预处理
        lua_code = self.preprocess_code(lua_code)
        
        # 分割为行
        lines = lua_code.split('\n')
        converted_lines = []
        
        # 用于跟踪代码块深度
        indent_level = 0
        in_function = False
        in_comment_block = False
        
        for i, line in enumerate(lines):
            original_line = line
            line = line.rstrip()
            
            if not line.strip():
                converted_lines.append('')
                continue
                
            # 处理多行注释
            line, in_comment_block = self.handle_multiline_comments(line, in_comment_block)
            if in_comment_block:
                converted_lines.append(line)
                continue
                
            # 转换当前行
            converted_line, indent_change = self.convert_line(line, indent_level, i, lines)
            
            # 更新缩进级别
            indent_level += indent_change
            
            # 添加适当的缩进
            indent = '    ' * max(0, indent_level)
            final_line = indent + converted_line
            
            converted_lines.append(final_line)
        
        return '\n'.join(converted_lines)

    def preprocess_code(self, code):
        """代码预处理"""
        # 标准化行结束符
        code = code.replace('\r\n', '\n').replace('\r', '\n')
        
        # 移除尾随空格
        code = '\n'.join(line.rstrip() for line in code.split('\n'))
        
        return code

    def handle_multiline_comments(self, line, in_comment_block):
        """处理多行注释"""
        if '--[[' in line and ']]' in line:
            # 单行内的完整多行注释
            return '/* ' + line.split('--[[', 1)[1].rsplit(']]', 1)[0] + ' */', in_comment_block
        elif '--[[' in line:
            # 多行注释开始
            comment_content = line.split('--[[', 1)[1]
            return '/* ' + comment_content, True
        elif in_comment_block and ']]' in line:
            # 多行注释结束
            comment_content = line.rsplit(']]', 1)[0]
            return comment_content + ' */', False
        elif in_comment_block:
            # 在多行注释中
            return line, True
        
        return line, in_comment_block

    def convert_line(self, line, indent_level, line_num, all_lines):
        """转换单行 Lua 代码为 GML"""
        original_line = line
        
        # 处理单行注释
        if '--' in line and not line.strip().startswith('--[['):
            parts = line.split('--', 1)
            code_part = parts[0]
            comment_part = parts[1] if len(parts) > 1 else ''
            converted_code = self.convert_code_part(code_part.rstrip())
            if comment_part:
                return converted_code + ' // ' + comment_part, 0
            else:
                return converted_code, 0
        
        # 转换代码部分
        converted_line = self.convert_code_part(line)
        
        # 计算缩进变化
        indent_change = self.calculate_indent_change(original_line, converted_line, line_num, all_lines)
        
        return converted_line, indent_change

    def convert_code_part(self, code):
        """转换代码部分（不含注释）"""
        if not code.strip():
            return code
        
        # 保存字符串字面量
        code, string_literals = self.extract_string_literals(code)
        
        # 处理函数定义
        code = self.convert_function_definitions(code)
        
        # 处理控制结构
        code = self.convert_control_structures(code)
        
        # 处理变量声明
        code = self.convert_variable_declarations(code)
        
        # 处理表构造
        code = self.convert_table_constructors(code)
        
        # 替换关键字
        code = self.replace_keywords(code)
        
        # 替换函数调用
        code = self.replace_function_calls(code)
        
        # 替换变量
        code = self.replace_variables(code)
        
        # 替换操作符
        code = self.replace_operators(code)
        
        # 恢复字符串字面量
        code = self.restore_string_literals(code, string_literals)
        
        # 添加分号（如果还没有）
        code = self.add_semicolons(code)
        
        return code

    def extract_string_literals(self, code):
        """提取字符串字面量以避免误转换"""
        string_literals = []
        pattern = r'(".*?"|\'.*?\')'
        
        def replace_match(match):
            string_literals.append(match.group(0))
            return f'__STRING_{len(string_literals)-1}__'
        
        code = re.sub(pattern, replace_match, code)
        return code, string_literals

    def restore_string_literals(self, code, string_literals):
        """恢复字符串字面量"""
        for i, literal in enumerate(string_literals):
            code = code.replace(f'__STRING_{i}__', literal)
        return code

    def convert_function_definitions(self, code):
        """转换函数定义"""
        # 普通函数 function name(args)
        code = re.sub(r'function\s+([a-zA-Z_][a-zA-Z0-9_]*)\s*\((.*?)\)', 
                     r'function \1(\2) {', code)
        
        # 对象方法 function obj:method(args)
        code = re.sub(r'function\s+([a-zA-Z_][a-zA-Z0-9_]*)\.([a-zA-Z_][a-zA-Z0-9_]*)\s*\((.*?)\)', 
                     r'function \1_\2(\3) {', code)
        code = re.sub(r'function\s+([a-zA-Z_][a-zA-Z0-9_]*):([a-zA-Z_][a-zA-Z0-9_]*)\s*\((.*?)\)', 
                     r'function \1_\2(\3) {', code)
        
        # 匿名函数
        code = re.sub(r'function\s*\((.*?)\)', r'function(\1) {', code)
        
        return code

    def convert_control_structures(self, code):
        """转换控制结构"""
        # if-then
        code = re.sub(r'if\s*(.*?)\s+then', r'if (\1) {', code)
        
        # elseif
        code = re.sub(r'elseif\s*(.*?)\s+then', r'} else if (\1) {', code)
        
        # for 循环
        code = re.sub(r'for\s+([a-zA-Z_][a-zA-Z0-9_]*)\s*=\s*(\d+)\s*,\s*(\d+)(?:\s*,\s*(-?\d+))?', 
                     r'for (var \1 = \2; \1 <= \3; \1 += \4)', code)
        
        # while 循环
        code = re.sub(r'while\s*(.*?)\s+do', r'while (\1) {', code)
        
        # repeat until
        if 'repeat' in code:
            code = code.replace('repeat', 'do {')
        if 'until' in code:
            code = code.replace('until', '} until')
        
        return code

    def convert_variable_declarations(self, code):
        """转换变量声明"""
        # local 声明
        if re.match(r'^\s*local\s+', code):
            code = re.sub(r'local\s+', 'var ', code)
            # 只有在不是控制结构的情况下才添加分号
            if not any(keyword in code for keyword in ['if', 'for', 'while', 'function']):
                if not code.rstrip().endswith('{') and not code.rstrip().endswith('}'):
                    code = code.rstrip() + ';'
        
        return code

    def convert_table_constructors(self, code):
        """转换表构造器"""
        # 简单数组 {1, 2, 3}
        code = re.sub(r'\{\s*([^}]*?)\s*\}', r'[\1]', code)
        
        # 带键的表 {key = value}
        code = re.sub(r'\{\s*([a-zA-Z_][a-zA-Z0-9_]*)\s*=\s*([^,}]+)\s*\}', 
                     r'{ \1: \2 }', code)
        
        return code

    def replace_keywords(self, code):
        """替换关键字"""
        for lua_keyword, gml_keyword in self.keyword_map.items():
            # 使用单词边界来避免替换变量名中的部分
            code = re.sub(r'\b' + re.escape(lua_keyword) + r'\b', gml_keyword, code)
        return code

    def replace_function_calls(self, code):
        """替换函数调用"""
        for lua_func, gml_func in self.function_map.items():
            # 转义函数名中的特殊字符
            escaped_lua_func = re.escape(lua_func)
            code = re.sub(r'\b' + escaped_lua_func + r'\b', gml_func, code)
        return code

    def replace_variables(self, code):
        """替换变量名"""
        for lua_var, gml_var in self.variable_map.items():
            code = re.sub(r'\b' + re.escape(lua_var) + r'\b', gml_var, code)
        return code

    def replace_operators(self, code):
        """替换操作符"""
        for lua_op, gml_op in self.operator_map.items():
            code = code.replace(lua_op, gml_op)
        return code

    def add_semicolons(self, code):
        """在适当位置添加分号"""
        code = code.strip()
        if not code:
            return code
            
        # 如果行不以这些字符结尾，添加分号
        if not code.endswith(('{', '}', ';', '//')) and not code.startswith(('//', '/*')):
            # 检查是否是控制结构
            control_structures = ['if', 'for', 'while', 'function']
            if not any(code.strip().startswith(cs) for cs in control_structures):
                code += ';'
        
        return code

    def calculate_indent_change(self, original_line, converted_line, line_num, all_lines):
        """计算缩进级别变化"""
        indent_change = 0
        
        line = original_line.strip()
        converted = converted_line.strip()
        
        # 增加缩进的情况
        increase_keywords = ['function', 'if', 'for', 'while', 'do', 'repeat']
        if any(line.startswith(keyword) for keyword in increase_keywords) or '{' in converted:
            indent_change += 1
        
        # 减少缩进的情况
        decrease_keywords = ['end', 'until']
        if any(keyword in line for keyword in decrease_keywords) or '}' in converted:
            indent_change -= 1
        
        # 特殊处理
        if line.startswith('elseif') or line == 'else':
            indent_change = 0  # 这些会同时结束前一个块并开始新块
        
        return indent_change


class LuaToGMLGUI:
    def __init__(self, root):
        self.root = root
        self.root.title("Lua 到 GML 转换器 v2.0")
        self.root.geometry("1000x700")
        
        self.converter = LuaToGMLConverter()
        self.setup_ui()
        
    def setup_ui(self):
        """设置用户界面"""
        # 创建主框架
        main_frame = ttk.Frame(self.root, padding="10")
        main_frame.grid(row=0, column=0, sticky=(tk.W, tk.E, tk.N, tk.S))
        
        # 配置网格权重
        self.root.columnconfigure(0, weight=1)
        self.root.rowconfigure(0, weight=1)
        main_frame.columnconfigure(1, weight=1)
        main_frame.rowconfigure(1, weight=1)
        
        # 标题
        title_label = ttk.Label(main_frame, text="Lua 到 GML 转换器", 
                               font=("Arial", 16, "bold"))
        title_label.grid(row=0, column=0, columnspan=3, pady=(0, 20))
        
        # 文件选择区域
        file_frame = ttk.LabelFrame(main_frame, text="文件操作", padding="10")
        file_frame.grid(row=1, column=0, columnspan=3, sticky=(tk.W, tk.E), pady=(0, 10))
        file_frame.columnconfigure(1, weight=1)
        
        ttk.Label(file_frame, text="Lua 文件:").grid(row=0, column=0, sticky=tk.W, padx=(0, 5))
        
        self.lua_file_var = tk.StringVar()
        lua_file_entry = ttk.Entry(file_frame, textvariable=self.lua_file_var)
        lua_file_entry.grid(row=0, column=1, sticky=(tk.W, tk.E), padx=(0, 5))
        
        ttk.Button(file_frame, text="浏览", 
                  command=self.browse_lua_file).grid(row=0, column=2, padx=(0, 5))
        
        ttk.Label(file_frame, text="GML 文件:").grid(row=1, column=0, sticky=tk.W, padx=(0, 5))
        
        self.gml_file_var = tk.StringVar()
        gml_file_entry = ttk.Entry(file_frame, textvariable=self.gml_file_var)
        gml_file_entry.grid(row=1, column=1, sticky=(tk.W, tk.E), padx=(0, 5))
        
        ttk.Button(file_frame, text="浏览", 
                  command=self.browse_gml_file).grid(row=1, column=2, padx=(0, 5))
        
        # 转换按钮
        button_frame = ttk.Frame(main_frame)
        button_frame.grid(row=2, column=0, columnspan=3, pady=10)
        
        ttk.Button(button_frame, text="转换文件", 
                  command=self.convert_file).pack(side=tk.LEFT, padx=(0, 10))
        
        ttk.Button(button_frame, text="清空", 
                  command=self.clear_all).pack(side=tk.LEFT, padx=(0, 10))
        
        ttk.Button(button_frame, text="退出", 
                  command=self.root.quit).pack(side=tk.LEFT)
        
        # 代码编辑区域
        editor_frame = ttk.Frame(main_frame)
        editor_frame.grid(row=3, column=0, columnspan=3, sticky=(tk.W, tk.E, tk.N, tk.S), pady=(10, 0))
        editor_frame.columnconfigure(0, weight=1)
        editor_frame.columnconfigure(1, weight=1)
        editor_frame.rowconfigure(0, weight=1)
        
        # Lua 代码编辑器
        lua_frame = ttk.LabelFrame(editor_frame, text="Lua 代码", padding="5")
        lua_frame.grid(row=0, column=0, sticky=(tk.W, tk.E, tk.N, tk.S), padx=(0, 5))
        lua_frame.columnconfigure(0, weight=1)
        lua_frame.rowconfigure(0, weight=1)
        
        self.lua_text = scrolledtext.ScrolledText(lua_frame, width=50, height=20, 
                                                 font=("Consolas", 10))
        self.lua_text.grid(row=0, column=0, sticky=(tk.W, tk.E, tk.N, tk.S))
        
        # GML 代码编辑器
        gml_frame = ttk.LabelFrame(editor_frame, text="GML 代码", padding="5")
        gml_frame.grid(row=0, column=1, sticky=(tk.W, tk.E, tk.N, tk.S), padx=(5, 0))
        gml_frame.columnconfigure(0, weight=1)
        gml_frame.rowconfigure(0, weight=1)
        
        self.gml_text = scrolledtext.ScrolledText(gml_frame, width=50, height=20, 
                                                 font=("Consolas", 10))
        self.gml_text.grid(row=0, column=0, sticky=(tk.W, tk.E, tk.N, tk.S))
        
        # 状态栏
        self.status_var = tk.StringVar(value="就绪")
        status_bar = ttk.Label(main_frame, textvariable=self.status_var, relief=tk.SUNKEN)
        status_bar.grid(row=4, column=0, columnspan=3, sticky=(tk.W, tk.E), pady=(10, 0))
        
        # 绑定事件
        self.lua_text.bind('<KeyRelease>', self.on_lua_code_change)
        
    def browse_lua_file(self):
        """浏览 Lua 文件"""
        filename = filedialog.askopenfilename(
            title="选择 Lua 文件",
            filetypes=[("Lua files", "*.lua"), ("All files", "*.*")]
        )
        if filename:
            self.lua_file_var.set(filename)
            self.load_lua_file(filename)
    
    def browse_gml_file(self):
        """浏览 GML 文件保存位置"""
        filename = filedialog.asksaveasfilename(
            title="保存 GML 文件",
            defaultextension=".gml",
            filetypes=[("GML files", "*.gml"), ("All files", "*.*")]
        )
        if filename:
            self.gml_file_var.set(filename)
    
    def load_lua_file(self, filename):
        """加载 Lua 文件到编辑器"""
        try:
            with open(filename, 'r', encoding='utf-8') as f:
                content = f.read()
            self.lua_text.delete(1.0, tk.END)
            self.lua_text.insert(1.0, content)
            self.status_var.set(f"已加载文件: {filename}")
        except Exception as e:
            messagebox.showerror("错误", f"无法加载文件: {e}")
    
    def convert_file(self):
        """转换文件"""
        lua_file = self.lua_file_var.get()
        gml_file = self.gml_file_var.get()
        
        if not lua_file or not gml_file:
            messagebox.showwarning("警告", "请选择输入和输出文件")
            return
        
        success, message = self.converter.convert_file(lua_file, gml_file)
        
        if success:
            messagebox.showinfo("成功", message)
            self.status_var.set("转换完成")
            # 加载转换后的文件到 GML 编辑器
            try:
                with open(gml_file, 'r', encoding='utf-8') as f:
                    content = f.read()
                self.gml_text.delete(1.0, tk.END)
                self.gml_text.insert(1.0, content)
            except Exception as e:
                messagebox.showerror("错误", f"无法加载转换后的文件: {e}")
        else:
            messagebox.showerror("错误", message)
            self.status_var.set("转换失败")
    
    def on_lua_code_change(self, event=None):
        """当 Lua 代码改变时实时转换"""
        lua_code = self.lua_text.get(1.0, tk.END)
        if lua_code.strip():
            try:
                gml_code = self.converter.convert_code(lua_code)
                self.gml_text.delete(1.0, tk.END)
                self.gml_text.insert(1.0, gml_code)
                self.status_var.set("实时转换完成")
            except Exception as e:
                self.status_var.set(f"转换错误: {e}")
    
    def clear_all(self):
        """清空所有内容"""
        self.lua_text.delete(1.0, tk.END)
        self.gml_text.delete(1.0, tk.END)
        self.lua_file_var.set("")
        self.gml_file_var.set("")
        self.status_var.set("已清空")

def main():
    root = tk.Tk()
    app = LuaToGMLGUI(root)
    root.mainloop()

if __name__ == "__main__":
    main()