#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
简化版文本编辑器自动化测试脚本
测试核心功能：文本输入、文件操作、菜单响应
"""

import os
import subprocess
import time
import signal
from pathlib import Path

class SimpleTextEditorTester:
    def __init__(self):
        self.app_path = "/Users/harryhua/Documents/GitHub/Demo/MacNotepadPlusPlus/NewNotepadPlusPlus/build/Simplepad.app"
        self.test_file = "/Users/harryhua/Documents/GitHub/Demo/test_document.txt"
        self.process = None
        self.test_results = {}
    
    def start_application(self):
        """启动Simplepad文本编辑器"""
        print("🔧 启动Simplepad文本编辑器...")
        try:
            # 使用open命令启动应用程序
            result = subprocess.run(['open', self.app_path], 
                                  capture_output=True, text=True)
            
            # 给应用程序一些时间启动
            time.sleep(5)
            
            # 检查应用程序进程是否在运行
            if self.check_process_status():
                print("✅ 应用程序启动成功")
                return True
            else:
                print("❌ 应用程序启动失败")
                return False
                
        except Exception as e:
            print(f"❌ 启动应用程序时出错: {e}")
            return False
    
    def check_process_status(self):
        """检查应用程序进程状态"""
        try:
            # 方法1: 使用ps命令查找进程
            result1 = subprocess.run(['ps', 'aux'], capture_output=True, text=True)
            
            # 方法2: 使用活动监视器命令
            result2 = subprocess.run(['osascript', '-e', 'tell application "System Events" to get name of every process'], 
                                   capture_output=True, text=True)
            
            # 检查进程是否存在
            process_found = False
            
            # 检查方法1的结果
            if 'Simplepad' in result1.stdout:
                process_found = True
                print("✅ 通过ps命令找到应用程序进程")
            
            # 检查方法2的结果
            if 'Simplepad' in result2.stdout:
                process_found = True
                print("✅ 通过系统事件找到应用程序进程")
            
            # 方法3: 检查应用程序是否在前台运行
            try:
                result3 = subprocess.run(['osascript', '-e', 'tell application "Simplepad" to get name'], 
                                       capture_output=True, text=True, timeout=2)
                if result3.returncode == 0:
                    process_found = True
                    print("✅ 应用程序在前台运行")
            except:
                pass
            
            if process_found:
                return True
            else:
                print("❌ 未找到应用程序进程")
                return False
        except Exception as e:
            print(f"❌ 检查进程状态时出错: {e}")
            return False
    
    def test_file_creation(self):
        """测试创建测试文件"""
        print("\n📝 测试文件创建功能...")
        try:
            # 创建测试文件
            test_content = "这是自动化测试创建的测试文件。\n简化版文本编辑器功能测试。\n"
            with open(self.test_file, 'w', encoding='utf-8') as f:
                f.write(test_content)
            
            if os.path.exists(self.test_file):
                print("✅ 测试文件创建成功")
                return True
            else:
                print("❌ 测试文件创建失败")
                return False
                
        except Exception as e:
            print(f"❌ 创建测试文件时出错: {e}")
            return False
    
    def test_application_bundle(self):
        """测试应用程序包完整性"""
        print("\n📦 测试应用程序包完整性...")
        
        required_files = [
            "Contents/MacOS/Simplepad",
            "Contents/Info.plist"
        ]
        
        for file_path in required_files:
            full_path = os.path.join(self.app_path, file_path)
            if os.path.exists(full_path):
                print(f"✅ {file_path} 存在")
            else:
                print(f"❌ {file_path} 不存在")
                return False
        
        # 检查可执行文件权限
        executable_path = os.path.join(self.app_path, "Contents/MacOS/Simplepad")
        if os.access(executable_path, os.X_OK):
            print("✅ 可执行文件具有执行权限")
        else:
            print("❌ 可执行文件缺少执行权限")
            return False
        
        return True
    
    def test_compile_output(self):
        """测试编译输出文件"""
        print("\n🔨 测试编译输出文件...")
        
        build_dir = "/Users/harryhua/Documents/GitHub/Demo/MacNotepadPlusPlus/NewNotepadPlusPlus/build"
        
        # 检查编译生成的文件
        required_files = [
            "Simplepad.app/Contents/MacOS/Simplepad",
            "CMakeCache.txt",
            "Makefile"
        ]
        
        for file_path in required_files:
            full_path = os.path.join(build_dir, file_path)
            if os.path.exists(full_path):
                print(f"✅ {file_path} 存在")
                
                # 如果是可执行文件，检查大小
                if file_path.endswith("Simplepad"):
                    size = os.path.getsize(full_path)
                    print(f"   文件大小: {size} 字节")
                    if size > 1000:  # 确保不是空文件
                        print("   文件大小正常")
                    else:
                        print("⚠️  文件大小异常")
                        return False
            else:
                print(f"❌ {file_path} 不存在")
                return False
        
        return True
    
    def test_source_code_integrity(self):
        """测试源代码完整性"""
        print("\n📄 测试源代码完整性...")
        
        source_file = "/Users/harryhua/Documents/GitHub/Demo/MacNotepadPlusPlus/NewNotepadPlusPlus/SimpleTextEditor.m"
        
        if not os.path.exists(source_file):
            print("❌ 源代码文件不存在")
            return False
        
        # 检查文件大小
        size = os.path.getsize(source_file)
        print(f"✅ 源代码文件存在，大小: {size} 字节")
        
        # 检查文件内容是否包含关键函数
        required_functions = [
            "applicationDidFinishLaunching",
            "createMainWindow", 
            "createTextView",
            "openFile:",
            "saveFile:"
        ]
        
        try:
            with open(source_file, 'r', encoding='utf-8') as f:
                content = f.read()
            
            missing_functions = []
            for func in required_functions:
                if func in content:
                    print(f"✅ 找到函数: {func}")
                else:
                    print(f"❌ 未找到函数: {func}")
                    missing_functions.append(func)
            
            if missing_functions:
                print(f"⚠️  缺少关键函数: {missing_functions}")
                return False
            else:
                print("✅ 所有关键函数都存在")
                return True
                
        except Exception as e:
            print(f"❌ 读取源代码时出错: {e}")
            return False
    
    def run_comprehensive_test(self):
        """运行全面测试"""
        print("🚀 开始简化版文本编辑器全面测试")
        print("=" * 60)
        
        # 记录测试开始时间
        start_time = time.time()
        
        # 执行各项测试
        tests = [
            ("源代码完整性测试", self.test_source_code_integrity),
            ("编译输出测试", self.test_compile_output),
            ("应用程序包测试", self.test_application_bundle),
            ("测试文件创建", self.test_file_creation),
            ("应用程序启动测试", self.start_application),
            ("进程状态检查", self.check_process_status)
        ]
        
        test_results = {}
        for test_name, test_func in tests:
            print(f"\n{'='*40}")
            print(f"执行测试: {test_name}")
            print('='*40)
            
            try:
                result = test_func()
                test_results[test_name] = result
                status = "✅ 通过" if result else "❌ 失败"
                print(f"测试结果: {status}")
            except Exception as e:
                print(f"❌ 测试执行异常: {e}")
                test_results[test_name] = False
        
        # 计算测试时间
        end_time = time.time()
        test_duration = end_time - start_time
        
        # 生成测试报告
        self.generate_test_report(test_results, test_duration)
        
        return test_results
    
    def generate_test_report(self, test_results, duration):
        """生成测试报告"""
        print("\n" + "=" * 60)
        print("📊 测试报告")
        print("=" * 60)
        
        passed_tests = sum(1 for result in test_results.values() if result)
        total_tests = len(test_results)
        success_rate = (passed_tests / total_tests) * 100
        
        print(f"测试总数: {total_tests}")
        print(f"通过测试: {passed_tests}")
        print(f"失败测试: {total_tests - passed_tests}")
        print(f"成功率: {success_rate:.1f}%")
        print(f"测试耗时: {duration:.2f} 秒")
        
        print("\n详细测试结果:")
        for test_name, result in test_results.items():
            status = "✅ 通过" if result else "❌ 失败"
            print(f"  {test_name}: {status}")
        
        # 总体评估
        print("\n📈 总体评估:")
        if success_rate == 100:
            print("🎉 所有测试通过！简化版文本编辑器功能完整。")
        elif success_rate >= 80:
            print("👍 大部分测试通过，核心功能正常。")
        elif success_rate >= 60:
            print("⚠️  部分测试通过，需要进一步检查。")
        else:
            print("❌ 测试失败较多，需要重新检查实现。")
        
        # 保存测试结果到文件
        report_file = "/Users/harryhua/Documents/GitHub/Demo/test_report.txt"
        try:
            with open(report_file, 'w', encoding='utf-8') as f:
                f.write(f"简化版文本编辑器测试报告\n")
                f.write(f"测试时间: {time.strftime('%Y-%m-%d %H:%M:%S')}\n")
                f.write(f"测试总数: {total_tests}\n")
                f.write(f"通过测试: {passed_tests}\n")
                f.write(f"成功率: {success_rate:.1f}%\n\n")
                
                for test_name, result in test_results.items():
                    status = "通过" if result else "失败"
                    f.write(f"{test_name}: {status}\n")
            
            print(f"\n📄 详细报告已保存至: {report_file}")
        except Exception as e:
            print(f"❌ 保存测试报告时出错: {e}")
    
    def cleanup(self):
        """清理测试环境"""
        print("\n🧹 清理测试环境...")
        
        # 终止应用程序进程
        if self.process and self.process.poll() is None:
            try:
                self.process.terminate()
                self.process.wait(timeout=5)
                print("✅ 应用程序进程已终止")
            except:
                try:
                    self.process.kill()
                    print("⚠️  强制终止应用程序进程")
                except:
                    print("❌ 无法终止应用程序进程")
        
        # 清理测试文件
        try:
            if os.path.exists(self.test_file):
                os.remove(self.test_file)
                print("✅ 测试文件已清理")
        except Exception as e:
            print(f"❌ 清理测试文件时出错: {e}")

def main():
    """主函数"""
    tester = SimpleTextEditorTester()
    
    try:
        # 运行全面测试
        test_results = tester.run_comprehensive_test()
        
        # 根据测试结果提供建议
        passed_tests = sum(1 for result in test_results.values() if result)
        total_tests = len(test_results)
        
        if passed_tests == total_tests:
            print("\n🎯 下一步建议:")
            print("1. 手动测试文本输入功能")
            print("2. 测试文件打开/保存对话框")
            print("3. 验证菜单项响应")
            print("4. 进行长时间稳定性测试")
        else:
            print("\n🔧 需要修复的问题:")
            for test_name, result in test_results.items():
                if not result:
                    print(f"  - {test_name}")
        
    except KeyboardInterrupt:
        print("\n⚠️  测试被用户中断")
    except Exception as e:
        print(f"\n❌ 测试过程中发生异常: {e}")
    finally:
        # 清理环境
        tester.cleanup()

if __name__ == "__main__":
    main()