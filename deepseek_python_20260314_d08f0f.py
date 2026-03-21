import os
import time
from pathlib import Path

def get_folder_structure(start_path, prefix="", max_depth=5, current_depth=0, exclude_dirs=None):
    """
    递归获取文件夹结构
    """
    if exclude_dirs is None:
        exclude_dirs = ['.git', '__pycache__', 'node_modules', '.vs', '.vscode']
    
    if current_depth > max_depth:
        return ""
    
    if not os.path.exists(start_path):
        return f"路径不存在: {start_path}"
    
    result = ""
    try:
        items = sorted(os.listdir(start_path))
        dirs = []
        files = []
        
        for item in items:
            item_path = os.path.join(start_path, item)
            if os.path.isdir(item_path):
                if item not in exclude_dirs:
                    dirs.append(item)
            else:
                files.append(item)
        
        # 先显示文件夹
        for i, dir_name in enumerate(dirs):
            is_last = (i == len(dirs) - 1 and len(files) == 0)
            connector = "└── " if is_last else "├── "
            result += f"{prefix}{connector}📁 {dir_name}/\n"
            
            # 递归进入子文件夹
            new_prefix = prefix + ("    " if is_last else "│   ")
            sub_path = os.path.join(start_path, dir_name)
            result += get_folder_structure(sub_path, new_prefix, max_depth, current_depth + 1, exclude_dirs)
        
        # 再显示文件
        for i, file_name in enumerate(files):
            is_last = (i == len(files) - 1)
            connector = "└── " if is_last else "├── "
            
            # 根据文件类型添加图标
            if file_name.endswith(('.json')):
                icon = "📄"
            elif file_name.endswith(('.png', '.jpg', '.jpeg', '.gif', '.bmp')):
                icon = "🖼️"
            elif file_name.endswith(('.ogg', '.mp3', '.wav')):
                icon = "🎵"
            elif file_name.endswith(('.gml', '.yy', '.yyp')):
                icon = "⚙️"
            else:
                icon = "📄"
            
            # 显示文件大小
            file_path = os.path.join(start_path, file_name)
            size = os.path.getsize(file_path)
            if size < 1024:
                size_str = f"{size} B"
            elif size < 1024 * 1024:
                size_str = f"{size/1024:.1f} KB"
            else:
                size_str = f"{size/(1024*1024):.1f} MB"
            
            result += f"{prefix}{connector}{icon} {file_name} ({size_str})\n"
            
    except PermissionError:
        result += f"{prefix}└── ⚠️ 无权限访问\n"
    except Exception as e:
        result += f"{prefix}└── ⚠️ 错误: {e}\n"
    
    return result

def find_assets_folders(root_path):
    """查找所有包含 assets 或 game_assets 的文件夹"""
    print("\n🔍 搜索 assets/game_assets 相关文件夹...")
    print("-" * 50)
    
    assets_folders = []
    game_assets_folders = []
    
    for root, dirs, files in os.walk(root_path):
        for dir_name in dirs:
            full_path = os.path.join(root, dir_name)
            rel_path = os.path.relpath(full_path, root_path)
            
            if dir_name == "assets":
                assets_folders.append(rel_path)
                print(f"⚠️  [assets] {rel_path}")
            elif dir_name == "game_assets":
                game_assets_folders.append(rel_path)
                print(f"✅ [game_assets] {rel_path}")
    
    return assets_folders, game_assets_folders

def check_included_files_structure(project_dir):
    """检查可能对应 Included Files 的文件夹结构"""
    print("\n📁 检查可能对应 Included Files 的文件夹...")
    print("-" * 50)
    
    # 常见的 datafiles 位置
    possible_paths = [
        os.path.join(project_dir, "datafiles"),
        os.path.join(project_dir, "IncludedFiles"),
        os.path.join(project_dir, "included"),
        project_dir  # 也可能直接在项目根目录
    ]
    
    for path in possible_paths:
        if os.path.exists(path):
            print(f"\n📂 检查: {path}")
            
            # 检查 assets 或 game_assets 文件夹
            for item in os.listdir(path):
                item_path = os.path.join(path, item)
                if os.path.isdir(item_path):
                    if item == "assets":
                        print(f"  ⚠️  [assets] {item_path}")
                    elif item == "game_assets":
                        print(f"  ✅ [game_assets] {item_path}")

def main():
    print("=" * 60)
    print("📁 FNF-NE 项目目录结构分析工具")
    print("=" * 60)
    
    # 项目路径
    project_dir = r"E:\FNF-NE"
    
    if not os.path.exists(project_dir):
        print(f"❌ 项目目录不存在: {project_dir}")
        time.sleep(10)
        return
    
    print(f"\n📂 项目根目录: {project_dir}")
    
    # 1. 查找所有 assets/game_assets 文件夹
    assets_folders, game_assets_folders = find_assets_folders(project_dir)
    
    # 2. 检查 datafiles 结构
    check_included_files_structure(project_dir)
    
    # 3. 生成完整的目录结构树
    print("\n🌳 完整的目录结构树:")
    print("-" * 50)
    
    structure = f"""
================================================================================
FNF-NE 项目目录结构
生成时间: {time.strftime('%Y-%m-%d %H:%M:%S')}
================================================================================

{project_dir}/
"""
    structure += get_folder_structure(project_dir, max_depth=4)
    
    # 4. 添加统计信息
    structure += f"""
================================================================================
统计信息:
- assets 文件夹数量: {len(assets_folders)}
- game_assets 文件夹数量: {len(game_assets_folders)}

⚠️ 如果看到任何 assets 文件夹，请在 GameMaker 的 Included Files 中将其重命名
✅ game_assets 文件夹是正确的名称
================================================================================
"""
    
    print(structure)
    
    # 5. 保存到文件
    output_file = os.path.join(project_dir, "folder_structure.txt")
    try:
        with open(output_file, 'w', encoding='utf-8') as f:
            f.write(structure)
        print(f"\n💾 目录结构已保存到: {output_file}")
    except Exception as e:
        print(f"❌ 保存文件失败: {e}")
    
    # 6. 诊断建议
    print("\n🔧 诊断建议:")
    print("-" * 50)
    
    if assets_folders:
        print("⚠️  发现 assets 文件夹！这可能是问题的根源：")
        for folder in assets_folders:
            print(f"   - {folder}")
        print("\n   解决方案：")
        print("   1. 在 GameMaker 中打开 Included Files")
        print("   2. 找到 assets 文件夹，重命名为 game_assets")
        print("   3. 或者修改代码中的路径为新的文件夹名")
    elif not game_assets_folders:
        print("❌ 没有找到 game_assets 文件夹！")
        print("   解决方案：")
        print("   1. 在硬盘上创建 game_assets 文件夹")
        print("   2. 在 GameMaker 的 Included Files 中导入文件")
    else:
        print("✅ 文件夹命名看起来正确")
        print("   如果还是报错，请检查 GameMaker 的 Included Files 配置")
    
    print("\n⏱️  20秒后自动关闭...")
    time.sleep(20)

if __name__ == "__main__":
    try:
        main()
    except Exception as e:
        print(f"\n❌ 错误: {e}")
        time.sleep(20)