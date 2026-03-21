import os
import json
import re
import time
import shutil

def deep_scan_project_files(project_dir):
    print("=" * 70)
    print("🔍 GameMaker 项目深度扫描工具")
    print("=" * 70)
    
    # 1. 检查 .yyp 文件
    yyp_files = []
    for root, _, files in os.walk(project_dir):
        for file in files:
            if file.endswith('.yyp'):
                yyp_files.append(os.path.join(root, file))
    
    if not yyp_files:
        print("❌ 没有找到 .yyp 文件！")
        return
    
    print(f"\n📂 找到 {len(yyp_files)} 个 .yyp 文件")
    
    # 2. 扫描所有 .yyp 文件中的 assets 引用
    print("\n🔎 扫描项目文件中的 assets 引用...")
    print("-" * 70)
    
    assets_refs = []
    
    for yyp_file in yyp_files:
        try:
            with open(yyp_file, 'r', encoding='utf-8') as f:
                content = f.read()
            
            # 查找 assets 字符串
            if 'assets' in content.lower():
                # 尝试解析 JSON
                try:
                    data = json.loads(content)
                    # 递归查找所有包含 assets 的值
                    def find_assets(obj, path=""):
                        if isinstance(obj, dict):
                            for key, value in obj.items():
                                new_path = f"{path}.{key}" if path else key
                                find_assets(value, new_path)
                        elif isinstance(obj, list):
                            for i, item in enumerate(obj):
                                find_assets(item, f"{path}[{i}]")
                        elif isinstance(obj, str) and 'assets' in obj.lower():
                            assets_refs.append({
                                'file': os.path.basename(yyp_file),
                                'path': path,
                                'value': obj
                            })
                            print(f"⚠️  {os.path.basename(yyp_file)}:{path} = {obj}")
                except:
                    # 如果不是有效的 JSON，就用正则查找
                    lines = content.split('\n')
                    for i, line in enumerate(lines):
                        if 'assets' in line.lower():
                            assets_refs.append({
                                'file': os.path.basename(yyp_file),
                                'line': i + 1,
                                'content': line.strip()
                            })
                            print(f"⚠️  {os.path.basename(yyp_file)}:行{i+1} -> {line.strip()}")
        except Exception as e:
            print(f"❌ 无法读取 {yyp_file}: {e}")
    
    # 3. 检查所有 .yy 文件（GameMaker 的资源配置文件）
    print("\n🔎 扫描所有 .yy 文件中的 assets 引用...")
    print("-" * 70)
    
    yy_files = []
    for root, _, files in os.walk(project_dir):
        for file in files:
            if file.endswith('.yy'):
                yy_files.append(os.path.join(root, file))
    
    print(f"📂 找到 {len(yy_files)} 个 .yy 文件")
    
    for yy_file in yy_files[:50]:  # 只检查前50个，避免太多
        try:
            with open(yy_file, 'r', encoding='utf-8') as f:
                content = f.read()
            
            if 'assets' in content.lower():
                rel_path = os.path.relpath(yy_file, project_dir)
                print(f"⚠️  {rel_path} 包含 assets 引用")
                
                # 显示具体内容
                lines = content.split('\n')
                for i, line in enumerate(lines):
                    if 'assets' in line.lower():
                        print(f"   行{i+1}: {line.strip()}")
        except:
            pass
    
    # 4. 检查项目选项文件
    print("\n🔎 检查项目选项文件...")
    print("-" * 70)
    
    options_dir = os.path.join(project_dir, "options")
    if os.path.exists(options_dir):
        for root, _, files in os.walk(options_dir):
            for file in files:
                if file.endswith('.yy'):
                    file_path = os.path.join(root, file)
                    try:
                        with open(file_path, 'r', encoding='utf-8') as f:
                            content = f.read()
                        if 'assets' in content.lower():
                            print(f"⚠️  {os.path.join('options', os.path.basename(root), file)} 包含 assets 引用")
                    except:
                        pass
    
    # 5. 检查 Included Files 配置（可能在 .yyp 的 IncludedFiles 部分）
    print("\n🔎 检查 Included Files 配置...")
    print("-" * 70)
    
    for yyp_file in yyp_files:
        try:
            with open(yyp_file, 'r', encoding='utf-8') as f:
                data = json.load(f)
            
            # 查找 IncludedFiles 相关的字段
            if 'IncludedFiles' in str(data):
                print("✅ 找到 IncludedFiles 配置，正在分析...")
                
                def find_included_files(obj):
                    if isinstance(obj, dict):
                        if obj.get('name') == 'assets' or obj.get('folderName') == 'assets':
                            print(f"⚠️  发现 assets 文件夹配置: {obj}")
                            return True
                        for key, value in obj.items():
                            find_included_files(value)
                    elif isinstance(obj, list):
                        for item in obj:
                            find_included_files(item)
                    return False
                
                find_included_files(data)
        except:
            pass
    
    # 6. 提供解决方案
    print("\n" + "=" * 70)
    print("🔧 解决方案")
    print("=" * 70)
    
    if assets_refs:
        print(f"\n⚠️  在项目文件中找到 {len(assets_refs)} 处 assets 引用")
        print("\n📝 解决方法：")
        print("1. 备份你的项目")
        print("2. 在 GameMaker 中执行以下操作：")
        print("   a. 关闭 GameMaker")
        print("   b. 手动编辑 .yyp 文件（用记事本）")
        print("   c. 搜索所有 'assets' 并替换为 'game_assets'")
        print("   d. 重新打开项目")
        print("\n3. 或者使用下面的自动修复脚本")
        
        # 询问是否自动修复
        print("\n⚡ 是否自动修复？(y/n)")
        choice = input().strip().lower()
        if choice == 'y':
            auto_fix_project_files(project_dir, yyp_files, yy_files)
    else:
        print("\n✅ 在项目文件中没有找到 assets 引用！")
        print("\n📝 但问题仍然存在，可能是缓存问题：")
        print("1. 完全关闭 GameMaker")
        print("2. 删除以下文件夹：")
        print(f"   - D:\\GMS2临时缓存\\GMS2TEMP\\")
        print(f"   - C:\\Users\\Administrator\\AppData\\Roaming\\GameMakerStudio2\\Cache\\GMS2CACHE\\")
        print("3. 重新打开 GameMaker")
        print("4. Build -> Clean")
        print("5. 重新打包")

def auto_fix_project_files(project_dir, yyp_files, yy_files):
    """自动修复项目文件中的 assets 引用"""
    print("\n⚡ 开始自动修复...")
    
    # 备份
    backup_dir = os.path.join(project_dir, "backup_" + time.strftime("%Y%m%d_%H%M%S"))
    os.makedirs(backup_dir, exist_ok=True)
    
    modified_count = 0
    
    # 修复 .yyp 文件
    for yyp_file in yyp_files:
        try:
            # 备份
            backup_file = os.path.join(backup_dir, os.path.basename(yyp_file))
            shutil.copy2(yyp_file, backup_file)
            
            # 读取并替换
            with open(yyp_file, 'r', encoding='utf-8') as f:
                content = f.read()
            
            new_content = content.replace('assets', 'game_assets')
            
            if new_content != content:
                with open(yyp_file, 'w', encoding='utf-8') as f:
                    f.write(new_content)
                print(f"✅ 已修复: {os.path.basename(yyp_file)}")
                modified_count += 1
        except Exception as e:
            print(f"❌ 修复失败 {yyp_file}: {e}")
    
    # 修复 .yy 文件（只修复前100个）
    for yy_file in yy_files[:100]:
        try:
            with open(yy_file, 'r', encoding='utf-8') as f:
                content = f.read()
            
            if 'assets' in content:
                # 备份
                rel_path = os.path.relpath(yy_file, project_dir)
                backup_file = os.path.join(backup_dir, rel_path.replace('\\', '_').replace('/', '_'))
                shutil.copy2(yy_file, backup_file)
                
                new_content = content.replace('assets', 'game_assets')
                with open(yy_file, 'w', encoding='utf-8') as f:
                    f.write(new_content)
                print(f"✅ 已修复: {os.path.relpath(yy_file, project_dir)}")
                modified_count += 1
        except Exception as e:
            print(f"❌ 修复失败 {yy_file}: {e}")
    
    print(f"\n✅ 修复完成！共修改了 {modified_count} 个文件")
    print(f"📦 备份保存在: {backup_dir}")
    print("\n📝 下一步：")
    print("1. 关闭 GameMaker")
    print("2. 删除临时缓存文件夹")
    print("3. 重新打开 GameMaker")
    print("4. Build -> Clean")
    print("5. 重新打包")

def nuclear_option(project_dir):
    """终极解决方案：重建 Included Files"""
    print("\n" + "=" * 70)
    print("💣 终极解决方案")
    print("=" * 70)
    
    print("\n这个选项会：")
    print("1. 备份当前的 datafiles 文件夹")
    print("2. 清空 Included Files 配置")
    print("3. 让你重新导入文件")
    
    choice = input("\n是否继续？(y/n): ").strip().lower()
    if choice != 'y':
        return
    
    datafiles_dir = os.path.join(project_dir, "datafiles")
    if os.path.exists(datafiles_dir):
        backup_dir = os.path.join(project_dir, "datafiles_backup_" + time.strftime("%Y%m%d_%H%M%S"))
        shutil.copytree(datafiles_dir, backup_dir)
        print(f"✅ datafiles 已备份到: {backup_dir}")
        
        # 清空 datafiles 但保留 game_assets
        for item in os.listdir(datafiles_dir):
            if item != "game_assets":
                item_path = os.path.join(datafiles_dir, item)
                if os.path.isfile(item_path):
                    os.remove(item_path)
                else:
                    shutil.rmtree(item_path)
                print(f"🗑️ 已删除: {item}")
    
    print("\n✅ 清理完成！")
    print("\n📝 现在请：")
    print("1. 打开 GameMaker")
    print("2. 右键点击 Included Files -> 选择 'Add Existing'")
    print("3. 选择 datafiles/game_assets 文件夹")
    print("4. Build -> Clean")
    print("5. 重新打包")

def main():
    project_dir = r"E:\FNF-NE"
    
    if not os.path.exists(project_dir):
        print(f"❌ 项目目录不存在: {project_dir}")
        time.sleep(10)
        return
    
    # 运行深度扫描
    deep_scan_project_files(project_dir)
    
    # 提供终极选项
    print("\n" + "=" * 70)
    print("💡 如果以上方法都不行，可以使用终极解决方案")
    nuclear_option(project_dir)
    
    print("\n⏱️  30秒后自动关闭...")
    time.sleep(30)

if __name__ == "__main__":
    try:
        main()
    except Exception as e:
        print(f"\n❌ 错误: {e}")
        time.sleep(30)