import os
import glob
import tkinter as tk
from tkinter import ttk, filedialog, messagebox, scrolledtext

class GMLCounterGUI:
    def __init__(self, root):
        self.root = root
        self.root.title("GML文件行数统计工具")
        self.root.geometry("800x600")
        
        # 设置样式
        self.setup_style()
        
        # 创建界面
        self.create_widgets()
        
    def setup_style(self):
        """设置界面样式"""
        style = ttk.Style()
        style.configure("Title.TLabel", font=("Arial", 16, "bold"))
        style.configure("Subtitle.TLabel", font=("Arial", 12, "bold"))
        style.configure("Success.TLabel", foreground="green")
        style.configure("Error.TLabel", foreground="red")
        
    def create_widgets(self):
        """创建界面组件"""
        # 主框架
        main_frame = ttk.Frame(self.root, padding="10")
        main_frame.grid(row=0, column=0, sticky=(tk.W, tk.E, tk.N, tk.S))
        
        # 标题
        title_label = ttk.Label(main_frame, text="GML文件行数统计工具", style="Title.TLabel")
        title_label.grid(row=0, column=0, columnspan=3, pady=(0, 20))
        
        # 目录选择区域
        dir_frame = ttk.LabelFrame(main_frame, text="目录选择", padding="10")
        dir_frame.grid(row=1, column=0, columnspan=3, sticky=(tk.W, tk.E), pady=(0, 10))
        
        self.dir_var = tk.StringVar(value=os.getcwd())
        
        ttk.Label(dir_frame, text="目标目录:").grid(row=0, column=0, sticky=tk.W)
        dir_entry = ttk.Entry(dir_frame, textvariable=self.dir_var, width=60)
        dir_entry.grid(row=0, column=1, padx=(10, 10), sticky=(tk.W, tk.E))
        
        browse_btn = ttk.Button(dir_frame, text="浏览...", command=self.browse_directory)
        browse_btn.grid(row=0, column=2, padx=(0, 10))
        
        # 统计选项区域
        options_frame = ttk.LabelFrame(main_frame, text="统计选项", padding="10")
        options_frame.grid(row=2, column=0, columnspan=3, sticky=(tk.W, tk.E), pady=(0, 10))
        
        self.recursive_var = tk.BooleanVar(value=True)
        recursive_cb = ttk.Checkbutton(options_frame, text="递归搜索子目录", 
                                      variable=self.recursive_var)
        recursive_cb.grid(row=0, column=0, sticky=tk.W)
        
        self.include_empty_var = tk.BooleanVar(value=False)
        empty_cb = ttk.Checkbutton(options_frame, text="统计空行", 
                                  variable=self.include_empty_var)
        empty_cb.grid(row=0, column=1, sticky=tk.W, padx=(20, 0))
        
        # 按钮区域
        btn_frame = ttk.Frame(main_frame)
        btn_frame.grid(row=3, column=0, columnspan=3, pady=(0, 10))
        
        count_btn = ttk.Button(btn_frame, text="开始统计", command=self.start_counting)
        count_btn.grid(row=0, column=0, padx=(0, 10))
        
        clear_btn = ttk.Button(btn_frame, text="清空结果", command=self.clear_results)
        clear_btn.grid(row=0, column=1, padx=(0, 10))
        
        export_btn = ttk.Button(btn_frame, text="导出结果", command=self.export_results)
        export_btn.grid(row=0, column=2)
        
        # 结果显示区域
        results_frame = ttk.LabelFrame(main_frame, text="统计结果", padding="10")
        results_frame.grid(row=4, column=0, columnspan=3, sticky=(tk.W, tk.E, tk.N, tk.S))
        
        # 创建文本框和滚动条
        self.results_text = scrolledtext.ScrolledText(results_frame, width=80, height=20)
        self.results_text.grid(row=0, column=0, sticky=(tk.W, tk.E, tk.N, tk.S))
        
        # 统计信息区域
        info_frame = ttk.Frame(main_frame)
        info_frame.grid(row=5, column=0, columnspan=3, sticky=(tk.W, tk.E), pady=(10, 0))
        
        self.info_label = ttk.Label(info_frame, text="就绪", style="Subtitle.TLabel")
        self.info_label.grid(row=0, column=0, sticky=tk.W)
        
        # 配置网格权重
        self.root.columnconfigure(0, weight=1)
        self.root.rowconfigure(0, weight=1)
        main_frame.columnconfigure(1, weight=1)
        main_frame.rowconfigure(4, weight=1)
        dir_frame.columnconfigure(1, weight=1)
        results_frame.columnconfigure(0, weight=1)
        results_frame.rowconfigure(0, weight=1)
        info_frame.columnconfigure(0, weight=1)
        
    def browse_directory(self):
        """浏览选择目录"""
        directory = filedialog.askdirectory(initialdir=self.dir_var.get())
        if directory:
            self.dir_var.set(directory)
            
    def count_lines_in_file(self, file_path):
        """统计单个文件的代码行数"""
        try:
            with open(file_path, 'r', encoding='utf-8') as file:
                lines = file.readlines()
                
                if not self.include_empty_var.get():
                    # 过滤空行
                    lines = [line for line in lines if line.strip()]
                    
                return len(lines)
        except UnicodeDecodeError:
            # 尝试其他编码
            try:
                with open(file_path, 'r', encoding='gbk') as file:
                    lines = file.readlines()
                    if not self.include_empty_var.get():
                        lines = [line for line in lines if line.strip()]
                    return len(lines)
            except Exception as e:
                self.results_text.insert(tk.END, f"错误: 无法读取文件 {file_path} - {e}\n")
                return 0
        except Exception as e:
            self.results_text.insert(tk.END, f"错误: 无法读取文件 {file_path} - {e}\n")
            return 0
            
    def start_counting(self):
        """开始统计"""
        directory = self.dir_var.get()
        
        if not os.path.exists(directory):
            messagebox.showerror("错误", "指定的目录不存在！")
            return
            
        # 清空之前的结果
        self.clear_results()
        
        self.results_text.insert(tk.END, "正在搜索GML文件...\n")
        self.root.update()
        
        # 查找gml文件
        if self.recursive_var.get():
            pattern = os.path.join(directory, "**", "*.gml")
        else:
            pattern = os.path.join(directory, "*.gml")
            
        gml_files = glob.glob(pattern, recursive=self.recursive_var.get())
        
        if not gml_files:
            self.results_text.insert(tk.END, "未找到任何.gml文件\n")
            self.info_label.config(text="未找到.gml文件")
            return
            
        self.results_text.delete(1.0, tk.END)
        self.results_text.insert(tk.END, f"找到 {len(gml_files)} 个.gml文件:\n")
        self.results_text.insert(tk.END, "=" * 50 + "\n\n")
        
        total_lines = 0
        file_line_counts = []
        
        # 统计每个文件
        for i, file_path in enumerate(gml_files):
            lines = self.count_lines_in_file(file_path)
            file_line_counts.append((file_path, lines))
            total_lines += lines
            
            # 显示进度
            relative_path = os.path.relpath(file_path, directory)
            self.results_text.insert(tk.END, f"{i+1:3d}. {relative_path}: {lines} 行\n")
            self.root.update()
            
        # 按行数排序
        file_line_counts.sort(key=lambda x: x[1], reverse=True)
        
        # 显示排序后的结果
        self.results_text.insert(tk.END, "\n" + "=" * 50 + "\n")
        self.results_text.insert(tk.END, "按行数排序:\n\n")
        
        for i, (file_path, lines) in enumerate(file_line_counts):
            relative_path = os.path.relpath(file_path, directory)
            self.results_text.insert(tk.END, f"{i+1:3d}. {relative_path}: {lines} 行\n")
            
        # 显示统计信息
        self.results_text.insert(tk.END, "\n" + "=" * 50 + "\n")
        self.results_text.insert(tk.END, f"文件总数: {len(gml_files)} 个\n")
        self.results_text.insert(tk.END, f"代码总行数: {total_lines} 行\n")
        
        if len(gml_files) > 0:
            avg_lines = total_lines / len(gml_files)
            self.results_text.insert(tk.END, f"平均每个文件: {avg_lines:.1f} 行\n")
            
        # 更新信息标签
        self.info_label.config(text=f"统计完成: {len(gml_files)} 个文件, {total_lines} 行代码")
        
    def clear_results(self):
        """清空结果"""
        self.results_text.delete(1.0, tk.END)
        self.info_label.config(text="就绪")
        
    def export_results(self):
        """导出结果到文件"""
        content = self.results_text.get(1.0, tk.END)
        if not content.strip():
            messagebox.showwarning("警告", "没有可导出的内容")
            return
            
        file_path = filedialog.asksaveasfilename(
            defaultextension=".txt",
            filetypes=[("文本文件", "*.txt"), ("所有文件", "*.*")]
        )
        
        if file_path:
            try:
                with open(file_path, 'w', encoding='utf-8') as file:
                    file.write(content)
                messagebox.showinfo("成功", f"结果已导出到: {file_path}")
            except Exception as e:
                messagebox.showerror("错误", f"导出失败: {e}")

def main():
    root = tk.Tk()
    app = GMLCounterGUI(root)
    root.mainloop()

if __name__ == "__main__":
    main()