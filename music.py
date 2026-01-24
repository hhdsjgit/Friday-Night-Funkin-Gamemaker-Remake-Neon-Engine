import tkinter as tk
from tkinter import filedialog, ttk
import pygame
import os
from pathlib import Path
import threading
import time

class SimpleAudioPlayer:
    def __init__(self, root):
        self.root = root
        self.root.title("轻量级音频播放器")
        self.root.geometry("500x450")
        
        # 初始化pygame mixer
        pygame.mixer.init(frequency=44100, size=-16, channels=2, buffer=4096)
        
        # 播放列表
        self.playlist = []
        self.current_index = -1
        self.is_playing = False
        self.is_paused = False
        
        # 创建UI
        self.create_widgets()
        
        # 绑定关闭事件
        self.root.protocol("WM_DELETE_WINDOW", self.on_closing)
    
    def create_widgets(self):
        # 主框架
        main_frame = ttk.Frame(self.root, padding="10")
        main_frame.grid(row=0, column=0, sticky=(tk.W, tk.E, tk.N, tk.S))
        
        # 按钮框架
        button_frame = ttk.Frame(main_frame)
        button_frame.grid(row=0, column=0, columnspan=3, pady=5)
        
        # 控制按钮
        self.play_btn = ttk.Button(button_frame, text="播放", command=self.play, width=10)
        self.play_btn.grid(row=0, column=0, padx=2)
        
        self.pause_btn = ttk.Button(button_frame, text="暂停", command=self.pause, width=10)
        self.pause_btn.grid(row=0, column=1, padx=2)
        
        self.stop_btn = ttk.Button(button_frame, text="停止", command=self.stop, width=10)
        self.stop_btn.grid(row=0, column=2, padx=2)
        
        ttk.Button(button_frame, text="前一首", command=self.previous, width=10).grid(row=0, column=3, padx=2)
        ttk.Button(button_frame, text="下一首", command=self.next, width=10).grid(row=0, column=4, padx=2)
        
        # 进度条
        self.progress_var = tk.DoubleVar()
        self.progress_bar = ttk.Scale(main_frame, from_=0, to=100, 
                                     orient=tk.HORIZONTAL, variable=self.progress_var,
                                     command=self.seek_audio, length=400)
        self.progress_bar.grid(row=1, column=0, columnspan=3, pady=10)
        
        # 时间标签
        self.time_label = ttk.Label(main_frame, text="00:00 / 00:00")
        self.time_label.grid(row=2, column=0, columnspan=3, pady=5)
        
        # 音量控制
        volume_frame = ttk.Frame(main_frame)
        volume_frame.grid(row=3, column=0, columnspan=3, pady=10)
        
        ttk.Label(volume_frame, text="音量:").grid(row=0, column=0)
        
        self.volume_var = tk.DoubleVar(value=0.7)
        self.volume_scale = ttk.Scale(volume_frame, from_=0, to=1, 
                                     orient=tk.HORIZONTAL, variable=self.volume_var,
                                     command=self.set_volume, length=150)
        self.volume_scale.grid(row=0, column=1, padx=10)
        
        # 当前播放标签
        self.current_track_label = ttk.Label(main_frame, text="当前播放: 无", 
                                            font=('Arial', 10, 'bold'))
        self.current_track_label.grid(row=4, column=0, columnspan=3, pady=10)
        
        # 播放列表框架
        list_frame = ttk.LabelFrame(main_frame, text="播放列表", padding="5")
        list_frame.grid(row=5, column=0, columnspan=3, pady=10, sticky=(tk.W, tk.E, tk.N, tk.S))
        
        # 播放列表控件
        self.playlist_box = tk.Listbox(list_frame, height=8, selectmode=tk.SINGLE)
        self.playlist_box.grid(row=0, column=0, sticky=(tk.W, tk.E, tk.N, tk.S))
        
        scrollbar = ttk.Scrollbar(list_frame, orient=tk.VERTICAL, command=self.playlist_box.yview)
        scrollbar.grid(row=0, column=1, sticky=(tk.N, tk.S))
        self.playlist_box.config(yscrollcommand=scrollbar.set)
        
        # 播放列表按钮
        list_btn_frame = ttk.Frame(list_frame)
        list_btn_frame.grid(row=0, column=2, padx=5, sticky=(tk.N,))
        
        ttk.Button(list_btn_frame, text="添加文件", 
                  command=self.add_files, width=12).grid(row=0, column=0, pady=2)
        ttk.Button(list_btn_frame, text="添加文件夹", 
                  command=self.add_folder, width=12).grid(row=1, column=0, pady=2)
        ttk.Button(list_btn_frame, text="移除选中", 
                  command=self.remove_selected, width=12).grid(row=2, column=0, pady=2)
        ttk.Button(list_btn_frame, text="清空列表", 
                  command=self.clear_playlist, width=12).grid(row=3, column=0, pady=2)
        
        # 状态栏
        self.status_bar = ttk.Label(main_frame, text="就绪", relief=tk.SUNKEN, anchor=tk.W)
        self.status_bar.grid(row=6, column=0, columnspan=3, sticky=(tk.W, tk.E), pady=5)
        
        # 绑定列表选择事件
        self.playlist_box.bind('<<ListboxSelect>>', self.on_listbox_select)
        
        # 配置网格权重
        self.root.columnconfigure(0, weight=1)
        self.root.rowconfigure(0, weight=1)
        main_frame.columnconfigure(0, weight=1)
        list_frame.columnconfigure(0, weight=1)
        list_frame.rowconfigure(0, weight=1)
        
        # 启动进度更新线程
        self.update_thread = threading.Thread(target=self.update_progress, daemon=True)
        self.update_thread.start()
    
    def add_files(self):
        """添加音频文件到播放列表"""
        filetypes = [
            ('音频文件', '*.mp3 *.wav *.ogg *.m4a *.flac'),
            ('M4A文件', '*.m4a'),
            ('所有文件', '*.*')
        ]
        
        files = filedialog.askopenfilenames(title="选择音频文件", filetypes=filetypes)
        if files:
            for file in files:
                self.add_to_playlist(file)
    
    def add_folder(self):
        """添加文件夹中的所有音频文件"""
        folder = filedialog.askdirectory(title="选择文件夹")
        if folder:
            audio_extensions = {'.mp3', '.wav', '.ogg', '.m4a', '.flac'}
            for file in Path(folder).rglob('*'):
                if file.suffix.lower() in audio_extensions:
                    self.add_to_playlist(str(file))
    
    def add_to_playlist(self, file_path):
        """添加单个文件到播放列表"""
        if file_path not in [item[0] for item in self.playlist]:
            file_name = os.path.basename(file_path)
            self.playlist.append((file_path, file_name))
            self.playlist_box.insert(tk.END, file_name)
            self.update_status(f"已添加: {file_name}")
    
    def remove_selected(self):
        """移除选中的播放列表项"""
        selection = self.playlist_box.curselection()
        if selection:
            index = selection[0]
            self.playlist_box.delete(index)
            removed_file = self.playlist.pop(index)
            self.update_status(f"已移除: {removed_file[1]}")
            
            # 如果移除的是当前播放的曲目
            if index == self.current_index:
                self.stop()
                self.current_index = -1
    
    def clear_playlist(self):
        """清空播放列表"""
        self.playlist_box.delete(0, tk.END)
        self.playlist.clear()
        self.stop()
        self.current_index = -1
        self.update_status("播放列表已清空")
    
    def play(self):
        """播放音频"""
        if self.is_paused:
            pygame.mixer.music.unpause()
            self.is_paused = False
            self.is_playing = True
            self.update_status("继续播放")
            return
        
        selection = self.playlist_box.curselection()
        if selection:
            index = selection[0]
        elif self.current_index >= 0:
            index = self.current_index
        else:
            if self.playlist:
                index = 0
                self.playlist_box.selection_set(0)
            else:
                self.update_status("播放列表为空")
                return
        
        if 0 <= index < len(self.playlist):
            file_path, file_name = self.playlist[index]
            self.current_index = index
            
            try:
                pygame.mixer.music.load(file_path)
                pygame.mixer.music.play()
                self.is_playing = True
                self.is_paused = False
                
                # 设置音量
                self.set_volume(self.volume_var.get())
                
                self.current_track_label.config(text=f"当前播放: {file_name}")
                self.update_status(f"正在播放: {file_name}")
                
                # 播放完成后自动下一首
                self.root.after(100, self.check_playback)
                
            except Exception as e:
                self.update_status(f"播放错误: {str(e)}")
    
    def pause(self):
        """暂停播放"""
        if self.is_playing and not self.is_paused:
            pygame.mixer.music.pause()
            self.is_paused = True
            self.update_status("已暂停")
    
    def stop(self):
        """停止播放"""
        pygame.mixer.music.stop()
        self.is_playing = False
        self.is_paused = False
        self.progress_var.set(0)
        self.time_label.config(text="00:00 / 00:00")
        self.update_status("已停止")
    
    def previous(self):
        """播放上一首"""
        if self.playlist:
            self.stop()
            if self.current_index > 0:
                self.current_index -= 1
            else:
                self.current_index = len(self.playlist) - 1
            
            self.playlist_box.selection_clear(0, tk.END)
            self.playlist_box.selection_set(self.current_index)
            self.playlist_box.see(self.current_index)
            self.root.after(100, self.play)
    
    def next(self):
        """播放下一首"""
        if self.playlist:
            self.stop()
            if self.current_index < len(self.playlist) - 1:
                self.current_index += 1
            else:
                self.current_index = 0
            
            self.playlist_box.selection_clear(0, tk.END)
            self.playlist_box.selection_set(self.current_index)
            self.playlist_box.see(self.current_index)
            self.root.after(100, self.play)
    
    def set_volume(self, value):
        """设置音量"""
        if hasattr(self, 'volume_var'):
            volume = float(value)
            pygame.mixer.music.set_volume(volume)
    
    def seek_audio(self, value):
        """跳转到指定位置（简化版，实际需要更复杂的实现）"""
        if self.is_playing and not self.is_paused:
            pass  # 实际音频跳转需要更复杂的实现
    
    def update_progress(self):
        """更新播放进度"""
        while True:
            if self.is_playing and not self.is_paused:
                try:
                    # 获取当前播放位置和总长度
                    if pygame.mixer.music.get_busy():
                        # 这里简化处理，实际需要获取音频长度
                        pass
                except:
                    pass
            time.sleep(0.1)
    
    def check_playback(self):
        """检查播放是否结束"""
        if self.is_playing and not pygame.mixer.music.get_busy() and not self.is_paused:
            self.next()
        else:
            self.root.after(100, self.check_playback)
    
    def on_listbox_select(self, event):
        """处理列表选择事件"""
        selection = self.playlist_box.curselection()
        if selection and selection[0] != self.current_index:
            self.stop()
    
    def update_status(self, message):
        """更新状态栏"""
        self.status_bar.config(text=message)
    
    def on_closing(self):
        """关闭窗口时的清理工作"""
        pygame.mixer.quit()
        self.root.destroy()

def main():
    root = tk.Tk()
    
    # 设置窗口图标和样式
    try:
        root.iconbitmap(default='audio_icon.ico')
    except:
        pass
    
    style = ttk.Style()
    style.theme_use('clam')  # 使用轻量级主题
    
    app = SimpleAudioPlayer(root)
    root.mainloop()

if __name__ == "__main__":
    main()