import os
import xml.etree.ElementTree as ET
from PIL import Image
import glob
import tkinter as tk
from tkinter import ttk, filedialog, messagebox, scrolledtext
import threading
import time
import re

class SpriteSplitterGUI:
    def __init__(self, root):
        self.root = root
        self.root.title("精灵图分割工具")
        self.root.geometry("800x600")
        self.setup_ui()
        
        # 存储处理状态
        self.is_processing = False
        
    def setup_ui(self):
        """设置用户界面"""
        # 主框架
        main_frame = ttk.Frame(self.root, padding="10")
        main_frame.grid(row=0, column=0, sticky=(tk.W, tk.E, tk.N, tk.S))
        
        # 配置网格权重
        self.root.columnconfigure(0, weight=1)
        self.root.rowconfigure(0, weight=1)
        main_frame.columnconfigure(1, weight=1)
        main_frame.rowconfigure(4, weight=1)
        
        # 标题
        title_label = ttk.Label(main_frame, text="精灵图分割工具", 
                               font=("Arial", 16, "bold"))
        title_label.grid(row=0, column=0, columnspan=3, pady=(0, 20))
        
        # 选择目录区域
        dir_frame = ttk.LabelFrame(main_frame, text="目录设置", padding="10")
        dir_frame.grid(row=1, column=0, columnspan=3, sticky=(tk.W, tk.E), pady=(0, 10))
        dir_frame.columnconfigure(1, weight=1)
        
        ttk.Label(dir_frame, text="资源目录:").grid(row=0, column=0, sticky=tk.W, padx=(0, 10))
        
        self.dir_var = tk.StringVar()
        self.dir_entry = ttk.Entry(dir_frame, textvariable=self.dir_var, width=50)
        self.dir_entry.grid(row=0, column=1, sticky=(tk.W, tk.E), padx=(0, 10))
        
        ttk.Button(dir_frame, text="浏览", 
                  command=self.browse_directory).grid(row=0, column=2)
        
        # 处理选项区域
        options_frame = ttk.LabelFrame(main_frame, text="处理选项", padding="10")
        options_frame.grid(row=2, column=0, columnspan=3, sticky=(tk.W, tk.E), pady=(0, 10))
        
        self.process_all_var = tk.BooleanVar(value=True)
        ttk.Checkbutton(options_frame, text="处理所有XML文件", 
                       variable=self.process_all_var).grid(row=0, column=0, sticky=tk.W)
        
        self.recursive_var = tk.BooleanVar(value=False)
        ttk.Checkbutton(options_frame, text="递归搜索子目录", 
                       variable=self.recursive_var).grid(row=0, column=1, sticky=tk.W)
        
        self.group_by_prefix_var = tk.BooleanVar(value=True)
        ttk.Checkbutton(options_frame, text="按前缀分组到子文件夹", 
                       variable=self.group_by_prefix_var).grid(row=1, column=0, sticky=tk.W)
        
        # 文件选择区域（当不处理所有文件时显示）
        self.file_frame = ttk.LabelFrame(main_frame, text="选择XML文件", padding="10")
        self.file_frame.grid(row=3, column=0, columnspan=3, sticky=(tk.W, tk.E), pady=(0, 10))
        self.file_frame.columnconfigure(1, weight=1)
        
        self.file_listbox = tk.Listbox(self.file_frame, height=6)
        self.file_listbox.grid(row=0, column=0, columnspan=3, sticky=(tk.W, tk.E), pady=(0, 10))
        
        file_scrollbar = ttk.Scrollbar(self.file_frame, orient="vertical", 
                                      command=self.file_listbox.yview)
        file_scrollbar.grid(row=0, column=3, sticky=(tk.N, tk.S))
        self.file_listbox.configure(yscrollcommand=file_scrollbar.set)
        
        ttk.Button(self.file_frame, text="刷新文件列表", 
                  command=self.refresh_file_list).grid(row=1, column=0, pady=(0, 5))
        ttk.Button(self.file_frame, text="全选", 
                  command=self.select_all_files).grid(row=1, column=1, pady=(0, 5))
        ttk.Button(self.file_frame, text="清除选择", 
                  command=self.clear_file_selection).grid(row=1, column=2, pady=(0, 5))
        
        # 控制按钮区域
        button_frame = ttk.Frame(main_frame)
        button_frame.grid(row=4, column=0, columnspan=3, sticky=(tk.W, tk.E), pady=(10, 0))
        
        self.process_button = ttk.Button(button_frame, text="开始处理", 
                                        command=self.start_processing)
        self.process_button.grid(row=0, column=0, padx=(0, 10))
        
        self.progress = ttk.Progressbar(button_frame, mode='indeterminate')
        self.progress.grid(row=0, column=1, sticky=(tk.W, tk.E), padx=(0, 10))
        button_frame.columnconfigure(1, weight=1)
        
        ttk.Button(button_frame, text="清空日志", 
                  command=self.clear_log).grid(row=0, column=2, padx=(0, 10))
        
        ttk.Button(button_frame, text="打开输出目录", 
                  command=self.open_output_dir).grid(row=0, column=3)
        
        # 日志区域
        log_frame = ttk.LabelFrame(main_frame, text="处理日志", padding="10")
        log_frame.grid(row=5, column=0, columnspan=3, sticky=(tk.W, tk.E, tk.N, tk.S), pady=(10, 0))
        log_frame.columnconfigure(0, weight=1)
        log_frame.rowconfigure(0, weight=1)
        
        self.log_text = scrolledtext.ScrolledText(log_frame, height=15, width=80)
        self.log_text.grid(row=0, column=0, sticky=(tk.W, tk.E, tk.N, tk.S))
        
        # 初始隐藏文件选择区域
        self.toggle_file_selection()
        self.process_all_var.trace('w', self.toggle_file_selection)
        
        # 初始日志
        self.log("欢迎使用精灵图分割工具！")
        self.log("请选择资源目录并点击'开始处理'")
        
    def toggle_file_selection(self, *args):
        """切换文件选择区域的显示"""
        if self.process_all_var.get():
            self.file_frame.grid_remove()
        else:
            self.file_frame.grid()
            self.refresh_file_list()
    
    def browse_directory(self):
        """浏览选择目录"""
        directory = filedialog.askdirectory(title="选择资源目录")
        if directory:
            self.dir_var.set(directory)
            self.refresh_file_list()
    
    def refresh_file_list(self):
        """刷新文件列表"""
        self.file_listbox.delete(0, tk.END)
        directory = self.dir_var.get()
        
        if directory and os.path.exists(directory):
            pattern = "**/*.xml" if self.recursive_var.get() else "*.xml"
            xml_files = glob.glob(os.path.join(directory, pattern), 
                                recursive=self.recursive_var.get())
            
            for xml_file in xml_files:
                relative_path = os.path.relpath(xml_file, directory)
                self.file_listbox.insert(tk.END, relative_path)
    
    def select_all_files(self):
        """选择所有文件"""
        self.file_listbox.selection_set(0, tk.END)
    
    def clear_file_selection(self):
        """清除文件选择"""
        self.file_listbox.selection_clear(0, tk.END)
    
    def log(self, message):
        """添加日志信息"""
        timestamp = time.strftime("%H:%M:%S")
        log_message = f"[{timestamp}] {message}\n"
        self.log_text.insert(tk.END, log_message)
        self.log_text.see(tk.END)
        self.root.update_idletasks()
    
    def clear_log(self):
        """清空日志"""
        self.log_text.delete(1.0, tk.END)
    
    def open_output_dir(self):
        """打开输出目录"""
        output_dir = "out"
        if os.path.exists(output_dir):
            if os.name == 'nt':
                os.startfile(output_dir)
            elif os.name == 'posix':
                os.system(f'open "{output_dir}"')
            else:
                os.system(f'xdg-open "{output_dir}"')
        else:
            messagebox.showwarning("警告", "输出目录不存在")
    
    def extract_prefix(self, texture_name):
        """
        从纹理名称中提取前缀
        
        Args:
            texture_name (str): 纹理名称，如 "Pico Down Note MISS0000"
            
        Returns:
            str: 前缀，如 "Pico Down Note MISS"
        """
        # 移除数字后缀
        prefix = re.sub(r'\d+$', '', texture_name)
        # 如果以数字结尾的格式，尝试更精确的匹配
        match = re.match(r'(.+?)(\d+)$', texture_name)
        if match:
            return match.group(1)
        return prefix
    
    def split_sprite_sheet(self, xml_file_path):
        """分割精灵图"""
        try:
            tree = ET.parse(xml_file_path)
            root = tree.getroot()
        except Exception as e:
            self.log(f"错误: 解析XML文件失败 - {e}")
            return 0
        
        # 获取图集图片路径
        image_path = root.get('imagePath')
        if not image_path:
            self.log(f"错误: 未找到imagePath属性")
            return 0
        
        # 构建完整的图片路径
        xml_dir = os.path.dirname(xml_file_path)
        image_full_path = os.path.join(xml_dir, image_path)
        
        # 检查图片文件是否存在
        if not os.path.exists(image_full_path):
            self.log(f"错误: 图片文件不存在 - {image_full_path}")
            return 0
        
        # 创建输出目录
        xml_name = os.path.splitext(os.path.basename(xml_file_path))[0]
        output_dir = os.path.join("out", xml_name)
        os.makedirs(output_dir, exist_ok=True)
        
        # 打开精灵图
        try:
            sprite_sheet = Image.open(image_full_path)
        except Exception as e:
            self.log(f"错误: 打开图片失败 - {e}")
            return 0
        
        # 按前缀分组
        texture_groups = {}
        for sub_texture in root.findall('SubTexture'):
            name = sub_texture.get('name')
            if self.group_by_prefix_var.get():
                prefix = self.extract_prefix(name)
                if prefix not in texture_groups:
                    texture_groups[prefix] = []
                texture_groups[prefix].append((name, sub_texture))
            else:
                # 如果不分组，每个纹理都在主目录
                if "ungrouped" not in texture_groups:
                    texture_groups["ungrouped"] = []
                texture_groups["ungrouped"].append((name, sub_texture))
        
        # 处理每个子纹理
        success_count = 0
        total_count = len(root.findall('SubTexture'))
        
        for prefix, textures in texture_groups.items():
            if not self.is_processing:
                break
            
            # 创建子目录（如果不分组，就在主目录）
            if self.group_by_prefix_var.get() and prefix != "ungrouped":
                group_dir = os.path.join(output_dir, prefix.rstrip())
                os.makedirs(group_dir, exist_ok=True)
                self.log(f"创建分组目录: {prefix}")
            else:
                group_dir = output_dir
            
            for name, sub_texture in textures:
                if not self.is_processing:
                    break
                    
                x = int(sub_texture.get('x', 0))
                y = int(sub_texture.get('y', 0))
                width = int(sub_texture.get('width', 0))
                height = int(sub_texture.get('height', 0))
                
                # 检查是否有帧偏移信息
                frame_x = int(sub_texture.get('frameX', 0))
                frame_y = int(sub_texture.get('frameY', 0))
                frame_width = int(sub_texture.get('frameWidth', width))
                frame_height = int(sub_texture.get('frameHeight', height))
                
                # 提取子图像
                if width > 0 and height > 0:
                    try:
                        # 从精灵图中提取区域
                        sub_image = sprite_sheet.crop((x, y, x + width, y + height))
                        
                        # 如果有帧信息，创建带透明度的正确尺寸图像
                        if frame_width != width or frame_height != height or frame_x != 0 or frame_y != 0:
                            # 创建正确尺寸的透明图像
                            final_image = Image.new('RGBA', (frame_width, frame_height), (0, 0, 0, 0))
                            
                            # 计算放置位置（考虑帧偏移）
                            paste_x = -frame_x if frame_x < 0 else 0
                            paste_y = -frame_y if frame_y < 0 else 0
                            
                            # 将子图像粘贴到正确位置
                            final_image.paste(sub_image, (paste_x, paste_y))
                        else:
                            final_image = sub_image
                        
                        # 保存图像
                        output_path = os.path.join(group_dir, f"{name}.png")
                        final_image.save(output_path, 'PNG')
                        success_count += 1
                        
                        if success_count % 10 == 0:  # 每10个文件更新一次日志
                            self.log(f"正在处理: {success_count}/{total_count} - {name}")
                            
                    except Exception as e:
                        self.log(f"错误: 处理子纹理 {name} 失败 - {e}")
        
        sprite_sheet.close()
        return success_count
    
    def process_files(self):
        """处理文件的主函数"""
        directory = self.dir_var.get()
        
        if not directory or not os.path.exists(directory):
            messagebox.showerror("错误", "请选择有效的资源目录")
            return
        
        # 获取要处理的文件列表
        if self.process_all_var.get():
            pattern = "**/*.xml" if self.recursive_var.get() else "*.xml"
            xml_files = glob.glob(os.path.join(directory, pattern), 
                                recursive=self.recursive_var.get())
        else:
            selected_indices = self.file_listbox.curselection()
            if not selected_indices:
                messagebox.showerror("错误", "请选择要处理的XML文件")
                return
            
            xml_files = []
            for index in selected_indices:
                relative_path = self.file_listbox.get(index)
                xml_files.append(os.path.join(directory, relative_path))
        
        if not xml_files:
            messagebox.showwarning("警告", "未找到XML文件")
            return
        
        self.log(f"开始处理 {len(xml_files)} 个文件...")
        
        total_success = 0
        for i, xml_file in enumerate(xml_files):
            if not self.is_processing:
                break
                
            self.log(f"处理文件 ({i+1}/{len(xml_files)}): {os.path.basename(xml_file)}")
            success_count = self.split_sprite_sheet(xml_file)
            total_success += success_count
            self.log(f"完成: {os.path.basename(xml_file)} - 成功分割 {success_count} 个子图像")
        
        self.log(f"处理完成！总共成功分割 {total_success} 个子图像")
        messagebox.showinfo("完成", f"处理完成！\n总共成功分割 {total_success} 个子图像")
    
    def start_processing(self):
        """开始处理"""
        if self.is_processing:
            self.stop_processing()
        else:
            self.is_processing = True
            self.process_button.config(text="停止处理")
            self.progress.start()
            self.log("开始处理...")
            
            # 在新线程中处理文件
            thread = threading.Thread(target=self.process_files)
            thread.daemon = True
            thread.start()
            
            # 检查处理状态
            self.check_processing_status(thread)
    
    def stop_processing(self):
        """停止处理"""
        self.is_processing = False
        self.process_button.config(text="开始处理")
        self.progress.stop()
        self.log("处理已停止")
    
    def check_processing_status(self, thread):
        """检查处理线程状态"""
        if thread.is_alive():
            self.root.after(100, lambda: self.check_processing_status(thread))
        else:
            self.stop_processing()

def main():
    """主函数"""
    root = tk.Tk()
    app = SpriteSplitterGUI(root)
    root.mainloop()

if __name__ == "__main__":
    main()