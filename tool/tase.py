import pygame
import json
import os
import sys
import time

# 初始化 Pygame
pygame.init()
pygame.mixer.init()

# 屏幕设置
WIDTH, HEIGHT = 800, 600
screen = pygame.display.set_mode((WIDTH, HEIGHT))
pygame.display.set_caption("FNF - Rotten Family")

# 颜色定义
WHITE = (255, 255, 255)
BLACK = (0, 0, 0)
RED = (255, 0, 0)
GREEN = (0, 255, 0)
BLUE = (0, 0, 255)
YELLOW = (255, 255, 0)
PURPLE = (128, 0, 128)
GRAY = (128, 128, 128)

# 箭头设置
ARROW_SIZE = 80
ARROW_SPEED = 5

# 判定线位置
TARGET_Y = HEIGHT - 150

# 箭头类型
ARROW_TYPES = ["left", "down", "up", "right"]
ARROW_COLORS = {
    "left": RED,
    "down": GREEN,
    "up": BLUE,
    "right": YELLOW
}

# 判定区域
PERFECT_RANGE = 15
GOOD_RANGE = 30
BAD_RANGE = 50

# 字体
font = pygame.font.SysFont(None, 36)
small_font = pygame.font.SysFont(None, 24)

class Arrow:
    def __init__(self, arrow_type, strum_time, sustain_length=0):
        self.type = arrow_type
        self.color = ARROW_COLORS[arrow_type]
        self.x = self.get_x_position()
        self.y = -ARROW_SIZE
        self.strum_time = strum_time  # 音符应该被击中的时间
        self.sustain_length = sustain_length  # 长按音符长度
        self.active = True
        self.is_sustain = sustain_length > 0
        
    def get_x_position(self):
        if self.type == "left":
            return WIDTH // 2 - ARROW_SIZE * 2
        elif self.type == "down":
            return WIDTH // 2 - ARROW_SIZE
        elif self.type == "up":
            return WIDTH // 2
        elif self.type == "right":
            return WIDTH // 2 + ARROW_SIZE
    
    def update(self, song_position):
        # 根据歌曲位置和音符出现时间计算位置
        time_until_hit = self.strum_time - song_position
        scroll_speed = 5
        
        # 计算Y位置（音符从顶部移动到判定线）
        self.y = TARGET_Y - (time_until_hit * scroll_speed)
        
        # 检查是否错过
        if time_until_hit < -BAD_RANGE / scroll_speed and self.active:
            self.active = False
            return "miss"
        return None
    
    def draw(self):
        if self.active:
            # 绘制箭头主体
            pygame.draw.rect(screen, self.color, (self.x, self.y, ARROW_SIZE, ARROW_SIZE))
            
            # 绘制长按部分（如果有）
            if self.is_sustain and self.sustain_length > 0:
                sustain_height = min(self.sustain_length * 0.1, 200)
                pygame.draw.rect(screen, self.color, 
                               (self.x, self.y + ARROW_SIZE, ARROW_SIZE, sustain_height))
            
            # 绘制箭头方向指示
            self.draw_arrow_direction()
    
    def draw_arrow_direction(self):
        """绘制箭头方向图标"""
        center_x = self.x + ARROW_SIZE // 2
        center_y = self.y + ARROW_SIZE // 2
        size = ARROW_SIZE // 3
        
        if self.type == "left":
            points = [
                (center_x + size, center_y - size),
                (center_x - size, center_y),
                (center_x + size, center_y + size)
            ]
        elif self.type == "down":
            points = [
                (center_x - size, center_y - size),
                (center_x, center_y + size),
                (center_x + size, center_y - size)
            ]
        elif self.type == "up":
            points = [
                (center_x - size, center_y + size),
                (center_x, center_y - size),
                (center_x + size, center_y + size)
            ]
        elif self.type == "right":
            points = [
                (center_x - size, center_y - size),
                (center_x + size, center_y),
                (center_x - size, center_y + size)
            ]
        
        pygame.draw.polygon(screen, WHITE, points)

class FNFGame:
    def __init__(self, json_file):
        self.load_song_data(json_file)
        self.arrows = []
        self.score = 0
        self.combo = 0
        self.max_combo = 0
        self.accuracy = 0
        self.total_notes = 0
        self.hit_notes = 0
        self.last_hit_result = None
        self.last_hit_time = 0
        self.song_position = 0
        self.song_start_time = 0
        self.playing = False
        self.load_audio()
        
    def load_song_data(self, json_file):
        """加载歌曲数据"""
        try:
            with open(json_file, 'r', encoding='utf-8') as f:
                self.song_data = json.load(f)
            
            self.song_info = self.song_data['song']
            self.bpm = self.song_info['bpm']
            self.speed = self.song_info.get('speed', 2.7)
            self.song_name = self.song_info['song']
            
            # 解析所有音符
            self.all_notes = []
            for section in self.song_info['notes']:
                for note in section['sectionNotes']:
                    strum_time = note[0]
                    arrow_type = note[1]
                    sustain_length = note[2] if len(note) > 2 else 0
                    
                    # 将数字转换为箭头类型
                    if arrow_type in [0, 1, 2, 3]:
                        arrow_type_str = ARROW_TYPES[arrow_type]
                        self.all_notes.append({
                            'strum_time': strum_time,
                            'arrow_type': arrow_type_str,
                            'sustain_length': sustain_length
                        })
                        self.total_notes += 1
            
            # 按时间排序
            self.all_notes.sort(key=lambda x: x['strum_time'])
            print(f"加载歌曲: {self.song_name}, BPM: {self.bpm}, 音符数量: {len(self.all_notes)}")
            
        except Exception as e:
            print(f"加载歌曲数据错误: {e}")
            self.song_data = None
    
    def load_audio(self):
        """加载音频文件"""
        self.inst = None
        self.voices = None
        
        # 尝试加载音频文件
        audio_files = ['son1.ogg', 'son2.ogg', 'song.ogg', 'instrumental.ogg', 'voices.ogg']
        
        for file in audio_files:
            if os.path.exists(file):
                try:
                    if file in ['son1.ogg', 'song.ogg', 'instrumental.ogg']:
                        self.inst = pygame.mixer.Sound(file)
                        print(f"加载背景音乐: {file}")
                    elif file in ['son2.ogg', 'voices.ogg']:
                        self.voices = pygame.mixer.Sound(file)
                        print(f"加载人声: {file}")
                except Exception as e:
                    print(f"加载音频文件 {file} 错误: {e}")
    
    def start_song(self):
        """开始播放歌曲"""
        if self.inst:
            self.inst.play()
        if self.voices:
            self.voices.play()
        
        self.song_start_time = time.time()
        self.playing = True
        self.next_note_index = 0
    
    def update(self):
        """更新游戏状态"""
        if not self.playing:
            return
        
        # 更新歌曲位置（毫秒）
        self.song_position = (time.time() - self.song_start_time) * 1000
        
        # 生成新音符
        while (self.next_note_index < len(self.all_notes) and 
               self.all_notes[self.next_note_index]['strum_time'] <= self.song_position + 2000):
            
            note_data = self.all_notes[self.next_note_index]
            arrow = Arrow(note_data['arrow_type'], 
                         note_data['strum_time'],
                         note_data['sustain_length'])
            self.arrows.append(arrow)
            self.next_note_index += 1
        
        # 更新箭头位置并检查错过
        for arrow in self.arrows[:]:
            result = arrow.update(self.song_position)
            if result == "miss":
                self.arrows.remove(arrow)
                self.combo = 0
                self.last_hit_result = "miss"
                self.last_hit_time = time.time()
    
    def check_hit(self, arrow, key_pressed):
        """检查是否击中箭头"""
        if arrow.type == key_pressed:
            time_diff = abs(arrow.strum_time - self.song_position)
            
            # 根据时间差判定
            if time_diff <= PERFECT_RANGE:
                return "perfect"
            elif time_diff <= GOOD_RANGE:
                return "good"
            elif time_diff <= BAD_RANGE:
                return "bad"
        return None
    
    def handle_input(self, key_pressed):
        """处理按键输入"""
        if not self.playing:
            return
        
        hit_arrow = None
        for arrow in self.arrows:
            if arrow.active:
                result = self.check_hit(arrow, key_pressed)
                if result:
                    hit_arrow = arrow
                    self.last_hit_result = result
                    self.last_hit_time = time.time()
                    
                    # 根据判定结果加分
                    if result == "perfect":
                        self.score += 100
                        self.combo += 1
                    elif result == "good":
                        self.score += 50
                        self.combo += 1
                    elif result == "bad":
                        self.score += 10
                        self.combo = 0
                    
                    self.hit_notes += 1
                    self.accuracy = (self.hit_notes / self.total_notes) * 100 if self.total_notes > 0 else 0
                    
                    if self.combo > self.max_combo:
                        self.max_combo = self.combo
                    
                    break
        
        if hit_arrow:
            self.arrows.remove(hit_arrow)
    
    def draw(self):
        """绘制游戏界面"""
        screen.fill(BLACK)
        
        # 绘制背景网格
        self.draw_background()
        
        # 绘制判定区域
        self.draw_target_area()
        
        # 绘制所有箭头
        for arrow in self.arrows:
            arrow.draw()
        
        # 绘制UI
        self.draw_ui()
        
        # 显示判定结果
        if self.last_hit_result and time.time() - self.last_hit_time < 1.0:
            self.draw_hit_result()
        
        pygame.display.flip()
    
    def draw_background(self):
        """绘制背景网格"""
        for i in range(0, WIDTH, 50):
            pygame.draw.line(screen, GRAY, (i, 0), (i, HEIGHT), 1)
        for i in range(0, HEIGHT, 50):
            pygame.draw.line(screen, GRAY, (0, i), (WIDTH, i), 1)
    
    def draw_target_area(self):
        """绘制判定区域"""
        # 绘制判定线
        pygame.draw.line(screen, WHITE, (WIDTH//2 - ARROW_SIZE*2, TARGET_Y), 
                        (WIDTH//2 + ARROW_SIZE*2, TARGET_Y), 3)
        
        # 绘制判定区域
        for i, arrow_type in enumerate(ARROW_TYPES):
            x = WIDTH // 2 - ARROW_SIZE * 2 + i * ARROW_SIZE
            color = ARROW_COLORS[arrow_type]
            
            # 绘制静态箭头
            pygame.draw.rect(screen, color, (x, TARGET_Y, ARROW_SIZE, ARROW_SIZE))
            
            # 绘制方向指示
            center_x = x + ARROW_SIZE // 2
            center_y = TARGET_Y + ARROW_SIZE // 2
            size = ARROW_SIZE // 3
            
            if arrow_type == "left":
                points = [
                    (center_x + size, center_y - size),
                    (center_x - size, center_y),
                    (center_x + size, center_y + size)
                ]
            elif arrow_type == "down":
                points = [
                    (center_x - size, center_y - size),
                    (center_x, center_y + size),
                    (center_x + size, center_y - size)
                ]
            elif arrow_type == "up":
                points = [
                    (center_x - size, center_y + size),
                    (center_x, center_y - size),
                    (center_x + size, center_y + size)
                ]
            elif arrow_type == "right":
                points = [
                    (center_x - size, center_y - size),
                    (center_x + size, center_y),
                    (center_x - size, center_y + size)
                ]
            
            pygame.draw.polygon(screen, WHITE, points)
    
    def draw_hit_result(self):
        """绘制判定结果"""
        result_colors = {
            "perfect": GREEN,
            "good": BLUE,
            "bad": YELLOW,
            "miss": RED
        }
        
        color = result_colors.get(self.last_hit_result, WHITE)
        result_text = font.render(self.last_hit_result.upper(), True, color)
        text_rect = result_text.get_rect(center=(WIDTH//2, HEIGHT//2))
        screen.blit(result_text, text_rect)
    
    def draw_ui(self):
        """绘制用户界面"""
        # 绘制分数
        score_text = font.render(f"Score: {self.score}", True, WHITE)
        screen.blit(score_text, (20, 20))
        
        # 绘制连击
        combo_color = GREEN if self.combo >= 10 else WHITE
        combo_text = font.render(f"Combo: {self.combo}", True, combo_color)
        screen.blit(combo_text, (20, 60))
        
        # 绘制最大连击
        max_combo_text = font.render(f"Max Combo: {self.max_combo}", True, WHITE)
        screen.blit(max_combo_text, (20, 100))
        
        # 绘制准确率
        accuracy_color = GREEN if self.accuracy >= 90 else YELLOW if self.accuracy >= 70 else RED
        accuracy_text = font.render(f"Accuracy: {self.accuracy:.1f}%", True, accuracy_color)
        screen.blit(accuracy_text, (20, 140))
        
        # 绘制歌曲信息
        song_text = small_font.render(f"Song: {self.song_name} | BPM: {self.bpm}", True, WHITE)
        screen.blit(song_text, (WIDTH - 300, 20))
        
        # 绘制按键提示
        keys_text = small_font.render("Controls: A S W D  for  ← ↓ ↑ →", True, WHITE)
        screen.blit(keys_text, (WIDTH - 300, 50))
        
        # 绘制歌曲进度
        if self.total_notes > 0:
            progress = min(self.next_note_index / self.total_notes, 1.0)
            pygame.draw.rect(screen, WHITE, (WIDTH//2 - 100, HEIGHT - 30, 200, 10))
            pygame.draw.rect(screen, GREEN, (WIDTH//2 - 100, HEIGHT - 30, 200 * progress, 10))

def main():
    # 创建游戏实例
    game = FNFGame('E:\\FNF-NE\\tool\\rotten-family-hard.json')
    
    if game.song_data is None:
        print("无法加载歌曲数据！")
        return
    
    clock = pygame.time.Clock()
    running = True
    
    # 显示开始界面
    screen.fill(BLACK)
    title_text = font.render("FNF - Rotten Family", True, WHITE)
    subtitle_text = small_font.render("Arrow Rhythm Game", True, WHITE)
    start_text = font.render("Press SPACE to Start", True, GREEN)
    controls_text = small_font.render("Controls: A S W D  for  ← ↓ ↑ →", True, WHITE)
    
    screen.blit(title_text, (WIDTH//2 - title_text.get_width()//2, HEIGHT//2 - 80))
    screen.blit(subtitle_text, (WIDTH//2 - subtitle_text.get_width()//2, HEIGHT//2 - 40))
    screen.blit(start_text, (WIDTH//2 - start_text.get_width()//2, HEIGHT//2 + 20))
    screen.blit(controls_text, (WIDTH//2 - controls_text.get_width()//2, HEIGHT//2 + 70))
    pygame.display.flip()
    
    waiting_for_start = True
    while waiting_for_start and running:
        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                running = False
                waiting_for_start = False
            elif event.type == pygame.KEYDOWN:
                if event.key == pygame.K_SPACE:
                    waiting_for_start = False
                    game.start_song()
                elif event.key == pygame.K_ESCAPE:
                    running = False
                    waiting_for_start = False
        
        clock.tick(60)
    
    # 主游戏循环
    while running:
        # 事件处理
        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                running = False
            elif event.type == pygame.KEYDOWN:
                if event.key == pygame.K_ESCAPE:
                    running = False
                
                # 检查按键对应的箭头
                key_pressed = None
                if event.key == pygame.K_a:
                    key_pressed = "left"
                elif event.key == pygame.K_s:
                    key_pressed = "down"
                elif event.key == pygame.K_w:
                    key_pressed = "up"
                elif event.key == pygame.K_d:
                    key_pressed = "right"
                
                if key_pressed:
                    game.handle_input(key_pressed)
        
        # 更新游戏状态
        game.update()
        
        # 绘制
        game.draw()
        
        # 检查歌曲是否结束
        if (game.playing and game.next_note_index >= len(game.all_notes) and 
            len(game.arrows) == 0 and game.song_position > game.all_notes[-1]['strum_time'] + 2000):
            
            # 显示结束画面
            screen.fill(BLACK)
            end_text = font.render("Song Finished!", True, WHITE)
            score_text = font.render(f"Final Score: {game.score}", True, WHITE)
            accuracy_text = font.render(f"Accuracy: {game.accuracy:.1f}%", True, WHITE)
            max_combo_text = font.render(f"Max Combo: {game.max_combo}", True, WHITE)
            restart_text = font.render("Press R to Restart or ESC to Quit", True, GREEN)
            
            screen.blit(end_text, (WIDTH//2 - end_text.get_width()//2, HEIGHT//2 - 100))
            screen.blit(score_text, (WIDTH//2 - score_text.get_width()//2, HEIGHT//2 - 50))
            screen.blit(accuracy_text, (WIDTH//2 - accuracy_text.get_width()//2, HEIGHT//2))
            screen.blit(max_combo_text, (WIDTH//2 - max_combo_text.get_width()//2, HEIGHT//2 + 50))
            screen.blit(restart_text, (WIDTH//2 - restart_text.get_width()//2, HEIGHT//2 + 100))
            pygame.display.flip()
            
            # 等待重新开始或退出
            waiting_for_restart = True
            while waiting_for_restart and running:
                for event in pygame.event.get():
                    if event.type == pygame.QUIT:
                        running = False
                        waiting_for_restart = False
                    elif event.type == pygame.KEYDOWN:
                        if event.key == pygame.K_r:
                            # 重新开始游戏
                            game = FNFGame('rotten-family-hard.json')
                            game.start_song()
                            waiting_for_restart = False
                        elif event.key == pygame.K_ESCAPE:
                            running = False
                            waiting_for_restart = False
                
                clock.tick(60)
        
        clock.tick(60)
    
    pygame.quit()
    sys.exit()

if __name__ == "__main__":
    main()