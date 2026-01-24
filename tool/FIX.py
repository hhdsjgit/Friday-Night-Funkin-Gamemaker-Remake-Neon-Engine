import json
import tkinter as tk
from tkinter import ttk, filedialog, messagebox, scrolledtext
from typing import Dict, List, Any
import os

class ChartSectionNotesFixer:
    def __init__(self, chart_data: Dict[str, Any]):
        self.chart_data = chart_data
    
    def fix_section_notes_order(self) -> Dict[str, Any]:
        """
        仅修复每个section中音符的时间顺序
        按照时间戳（第一个元素）进行排序
        """
        fixed_data = json.loads(json.dumps(self.chart_data))  # 深拷贝
        
        if "song" in fixed_data and "notes" in fixed_data["song"]:
            for section in fixed_data["song"]["notes"]:
                if "sectionNotes" in section and section["sectionNotes"]:
                    # 按照时间戳（第一个元素）排序
                    section["sectionNotes"] = sorted(
                        section["sectionNotes"], 
                        key=lambda x: x[0] if isinstance(x, list) and len(x) > 0 else 0
                    )
        
        return fixed_data

class ChartFixerGUI:
    def __init__(self, root):
        self.root = root
        self.root.title("Chart Section Notes Fixer")
        self.root.geometry("800x600")
        self.setup_ui()
        
        self.current_file = None
        self.original_data = None
        self.fixed_data = None
    
    def setup_ui(self):
        # 主框架
        main_frame = ttk.Frame(self.root, padding="10")
        main_frame.grid(row=0, column=0, sticky=(tk.W, tk.E, tk.N, tk.S))
        
        # 配置网格权重
        self.root.columnconfigure(0, weight=1)
        self.root.rowconfigure(0, weight=1)
        main_frame.columnconfigure(1, weight=1)
        main_frame.rowconfigure(3, weight=1)
        
        # 文件选择区域
        file_frame = ttk.LabelFrame(main_frame, text="文件操作", padding="5")
        file_frame.grid(row=0, column=0, columnspan=2, sticky=(tk.W, tk.E), pady=(0, 10))
        file_frame.columnconfigure(1, weight=1)
        
        ttk.Button(file_frame, text="打开JSON文件", command=self.open_file).grid(row=0, column=0, padx=(0, 10))
        self.file_label = ttk.Label(file_frame, text="未选择文件")
        self.file_label.grid(row=0, column=1, sticky=(tk.W, tk.E))
        
        # 信息显示区域
        info_frame = ttk.LabelFrame(main_frame, text="文件信息", padding="5")
        info_frame.grid(row=1, column=0, columnspan=2, sticky=(tk.W, tk.E), pady=(0, 10))
        
        self.info_text = tk.Text(info_frame, height=3, width=80)
        self.info_text.grid(row=0, column=0, sticky=(tk.W, tk.E))
        info_frame.columnconfigure(0, weight=1)
        
        # 操作按钮区域
        button_frame = ttk.Frame(main_frame)
        button_frame.grid(row=2, column=0, columnspan=2, sticky=(tk.W, tk.E), pady=(0, 10))
        
        ttk.Button(button_frame, text="修复音符顺序", command=self.fix_notes).grid(row=0, column=0, padx=(0, 10))
        ttk.Button(button_frame, text="预览修复结果", command=self.preview_fix).grid(row=0, column=1, padx=(0, 10))
        ttk.Button(button_frame, text="保存修复文件", command=self.save_file).grid(row=0, column=2, padx=(0, 10))
        ttk.Button(button_frame, text="比较前后差异", command=self.compare_changes).grid(row=0, column=3)
        
        # 结果显示区域
        result_frame = ttk.LabelFrame(main_frame, text="修复结果", padding="5")
        result_frame.grid(row=3, column=0, columnspan=2, sticky=(tk.W, tk.E, tk.N, tk.S))
        result_frame.columnconfigure(0, weight=1)
        result_frame.rowconfigure(0, weight=1)
        
        self.result_text = scrolledtext.ScrolledText(result_frame, width=80, height=20)
        self.result_text.grid(row=0, column=0, sticky=(tk.W, tk.E, tk.N, tk.S))
    
    def open_file(self):
        """打开JSON文件"""
        file_path = filedialog.askopenfilename(
            title="选择JSON文件",
            filetypes=[("JSON files", "*.json"), ("All files", "*.*")]
        )
        
        if file_path:
            try:
                with open(file_path, 'r', encoding='utf-8') as f:
                    self.original_data = json.load(f)
                
                self.current_file = file_path
                self.file_label.config(text=os.path.basename(file_path))
                self.fixed_data = None
                self.display_file_info()
                self.result_text.delete(1.0, tk.END)
                self.result_text.insert(tk.END, "文件加载成功！点击'修复音符顺序'开始修复。")
                
            except Exception as e:
                messagebox.showerror("错误", f"文件读取失败: {str(e)}")
    
    def display_file_info(self):
        """显示文件基本信息"""
        if not self.original_data:
            return
            
        info = ""
        if "song" in self.original_data:
            song_info = self.original_data["song"]
            info += f"歌曲: {song_info.get('song', '未知')}\n"
            info += f"BPM: {song_info.get('bpm', '未知')}\n"
            
            if "notes" in song_info:
                section_count = len(song_info["notes"])
                total_notes = sum(len(section.get("sectionNotes", [])) for section in song_info["notes"])
                info += f"段落数: {section_count}, 总音符数: {total_notes}"
        
        self.info_text.delete(1.0, tk.END)
        self.info_text.insert(tk.END, info)
    
    def fix_notes(self):
        """修复音符顺序"""
        if not self.original_data:
            messagebox.showwarning("警告", "请先打开一个JSON文件")
            return
        
        try:
            fixer = ChartSectionNotesFixer(self.original_data)
            self.fixed_data = fixer.fix_section_notes_order()
            
            # 统计修复信息
            original_sections = self.original_data["song"]["notes"]
            fixed_sections = self.fixed_data["song"]["notes"]
            
            fixed_count = 0
            for i, (orig_section, fixed_section) in enumerate(zip(original_sections, fixed_sections)):
                orig_notes = orig_section.get("sectionNotes", [])
                fixed_notes = fixed_section.get("sectionNotes", [])
                
                # 检查顺序是否改变
                if orig_notes != fixed_notes:
                    fixed_count += 1
            
            self.result_text.delete(1.0, tk.END)
            self.result_text.insert(tk.END, f"修复完成！\n")
            self.result_text.insert(tk.END, f"已修复 {fixed_count} 个段落的音符顺序\n")
            self.result_text.insert(tk.END, f"总段落数: {len(original_sections)}\n\n")
            self.result_text.insert(tk.END, "点击'保存修复文件'保存结果，或点击'预览修复结果'查看详情。")
            
        except Exception as e:
            messagebox.showerror("错误", f"修复过程中出错: {str(e)}")
    
    def preview_fix(self):
        """预览修复结果"""
        if not self.fixed_data:
            messagebox.showwarning("警告", "请先执行修复操作")
            return
        
        try:
            self.result_text.delete(1.0, tk.END)
            
            original_sections = self.original_data["song"]["notes"]
            fixed_sections = self.fixed_data["song"]["notes"]
            
            for i, (orig_section, fixed_section) in enumerate(zip(original_sections, fixed_sections)):
                orig_notes = orig_section.get("sectionNotes", [])
                fixed_notes = fixed_section.get("sectionNotes", [])
                
                if orig_notes != fixed_notes:
                    self.result_text.insert(tk.END, f"段落 {i} 已修复:\n")
                    self.result_text.insert(tk.END, f"  原顺序: {[note[0] for note in orig_notes[:5]]}...\n")
                    self.result_text.insert(tk.END, f"  新顺序: {[note[0] for note in fixed_notes[:5]]}...\n\n")
            
            if not any(orig_section.get("sectionNotes", []) != fixed_section.get("sectionNotes", []) 
                      for orig_section, fixed_section in zip(original_sections, fixed_sections)):
                self.result_text.insert(tk.END, "所有段落的音符顺序已经是正确的，无需修复。\n")
                
        except Exception as e:
            messagebox.showerror("错误", f"预览过程中出错: {str(e)}")
    
    def compare_changes(self):
        """比较修复前后的差异"""
        if not self.fixed_data:
            messagebox.showwarning("警告", "请先执行修复操作")
            return
        
        try:
            self.result_text.delete(1.0, tk.END)
            
            original_sections = self.original_data["song"]["notes"]
            fixed_sections = self.fixed_data["song"]["notes"]
            
            changed_sections = 0
            total_notes_moved = 0
            
            for i, (orig_section, fixed_section) in enumerate(zip(original_sections, fixed_sections)):
                orig_notes = orig_section.get("sectionNotes", [])
                fixed_notes = fixed_section.get("sectionNotes", [])
                
                if orig_notes != fixed_notes:
                    changed_sections += 1
                    # 计算移动的音符数量（简单方法）
                    notes_moved = sum(1 for j, (orig, fixed) in enumerate(zip(orig_notes, fixed_notes)) 
                                    if orig != fixed)
                    total_notes_moved += notes_moved
                    
                    self.result_text.insert(tk.END, f"段落 {i}:\n")
                    self.result_text.insert(tk.END, f"  移动了 {notes_moved} 个音符的位置\n")
                    
                    # 显示第一个不同的音符作为示例
                    for j, (orig, fixed) in enumerate(zip(orig_notes, fixed_notes)):
                        if orig != fixed:
                            self.result_text.insert(tk.END, f"  示例 - 位置 {j}: {orig[0]} → {fixed[0]}\n")
                            break
                    self.result_text.insert(tk.END, "\n")
            
            self.result_text.insert(tk.END, f"总结:\n")
            self.result_text.insert(tk.END, f"  改变的段落: {changed_sections}\n")
            self.result_text.insert(tk.END, f"  总共移动的音符: {total_notes_moved}\n")
            
        except Exception as e:
            messagebox.showerror("错误", f"比较过程中出错: {str(e)}")
    
    def save_file(self):
        """保存修复后的文件"""
        if not self.fixed_data:
            messagebox.showwarning("警告", "没有可保存的修复数据")
            return
        
        if not self.current_file:
            messagebox.showwarning("警告", "没有原始文件路径")
            return
        
        try:
            # 生成保存路径
            base_name = os.path.splitext(self.current_file)[0]
            save_path = f"{base_name}_fixed.json"
            
            save_path = filedialog.asksaveasfilename(
                title="保存修复文件",
                initialfile=os.path.basename(save_path),
                defaultextension=".json",
                filetypes=[("JSON files", "*.json"), ("All files", "*.*")]
            )
            
            if save_path:
                with open(save_path, 'w', encoding='utf-8') as f:
                    json.dump(self.fixed_data, f, indent=4, ensure_ascii=False)
                
                messagebox.showinfo("成功", f"文件已保存到: {save_path}")
                self.result_text.insert(tk.END, f"\n\n文件已保存: {save_path}")
                
        except Exception as e:
            messagebox.showerror("错误", f"保存文件失败: {str(e)}")

def main():
    root = tk.Tk()
    app = ChartFixerGUI(root)
    root.mainloop()

if __name__ == "__main__":
    main()