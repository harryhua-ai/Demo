//
// SimpleTextEditor.m
// Simplepad
//
// 极简文本编辑器 - 专注于核心功能
// 避免复杂架构，确保功能稳定可靠
//

#import <Cocoa/Cocoa.h>

@interface SimpleTextEditor : NSObject <NSApplicationDelegate>

@property (nonatomic, strong) NSWindow *window;
@property (nonatomic, strong) NSTextView *textView;
@property (nonatomic, strong) NSString *currentFilePath;
@property (nonatomic, assign) BOOL documentModified;

@end

@implementation SimpleTextEditor

#pragma mark - 应用程序启动

- (void)applicationDidFinishLaunching:(NSNotification *)notification {
    NSLog(@"🔧 SimpleTextEditor: 应用程序启动完成");
    
    // 创建主窗口
    [self createMainWindow];
    
    // 创建文本视图
    [self createTextView];
    
    // 设置菜单
    [self setupMenu];
    
    // 显示窗口
    [self.window makeKeyAndOrderFront:nil];
    [self.window center];
    
    NSLog(@"✅ SimpleTextEditor: 应用程序初始化完成");
}

#pragma mark - 窗口创建

- (void)createMainWindow {
    NSLog(@"🔧 SimpleTextEditor: 创建主窗口");
    
    // 创建窗口
    NSRect frame = NSMakeRect(100, 100, 800, 600);
    self.window = [[NSWindow alloc] initWithContentRect:frame
                                              styleMask:NSWindowStyleMaskTitled | NSWindowStyleMaskClosable | NSWindowStyleMaskMiniaturizable | NSWindowStyleMaskResizable
                                                backing:NSBackingStoreBuffered
                                                  defer:NO];
    
    self.window.title = @"Simplepad";
    self.window.releasedWhenClosed = NO;
    
    NSLog(@"✅ SimpleTextEditor: 主窗口创建完成");
}

#pragma mark - 文本视图创建

- (void)createTextView {
    NSLog(@"🔧 SimpleTextEditor: 创建文本视图");
    
    // 创建滚动视图
    NSScrollView *scrollView = [[NSScrollView alloc] initWithFrame:self.window.contentView.bounds];
    scrollView.hasVerticalScroller = YES;
    scrollView.hasHorizontalScroller = YES;
    scrollView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
    
    // 创建文本视图
    NSRect textFrame = NSMakeRect(0, 0, scrollView.contentSize.width, scrollView.contentSize.height);
    self.textView = [[NSTextView alloc] initWithFrame:textFrame];
    
    // 配置文本视图
    self.textView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
    self.textView.allowsUndo = YES;
    self.textView.richText = NO; // 纯文本模式
    self.textView.font = [NSFont fontWithName:@"Menlo" size:12];
    
    // 设置滚动视图的文档视图
    scrollView.documentView = self.textView;
    
    // 添加到窗口
    [self.window setContentView:scrollView];
    
    // 确保文本视图可以成为第一响应者
    [self.textView setEditable:YES];
    [self.textView setSelectable:YES];
    
    // 添加文本更改监听器
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textDidChange:)
                                                 name:NSTextDidChangeNotification
                                               object:self.textView];
    
    NSLog(@"✅ SimpleTextEditor: 文本视图创建完成");
}

#pragma mark - 菜单设置

- (void)setupMenu {
    NSLog(@"🔧 SimpleTextEditor: 设置菜单");
    
    // 创建主菜单
    NSMenu *mainMenu = [[NSMenu alloc] initWithTitle:@"主菜单"];
    
    // 应用程序菜单
    NSMenuItem *appMenuItem = [[NSMenuItem alloc] initWithTitle:@"应用程序" action:nil keyEquivalent:@""];
    NSMenu *appMenu = [[NSMenu alloc] initWithTitle:@"应用程序"];
    
    // 退出菜单项
    NSMenuItem *quitItem = [[NSMenuItem alloc] initWithTitle:@"退出" action:@selector(terminate:) keyEquivalent:@"q"];
    [appMenu addItem:quitItem];
    
    [mainMenu setSubmenu:appMenu forItem:appMenuItem];
    [mainMenu addItem:appMenuItem];
    
    // 文件菜单
    NSMenuItem *fileMenuItem = [[NSMenuItem alloc] initWithTitle:@"文件" action:nil keyEquivalent:@""];
    NSMenu *fileMenu = [[NSMenu alloc] initWithTitle:@"文件"];
    
    // 新建文件
    NSMenuItem *newItem = [[NSMenuItem alloc] initWithTitle:@"新建" action:@selector(newFile:) keyEquivalent:@"n"];
    [newItem setTarget:self];
    [fileMenu addItem:newItem];
    
    // 打开文件
    NSMenuItem *openItem = [[NSMenuItem alloc] initWithTitle:@"打开..." action:@selector(openFile:) keyEquivalent:@"o"];
    [openItem setTarget:self];
    [fileMenu addItem:openItem];
    
    // 保存文件
    NSMenuItem *saveItem = [[NSMenuItem alloc] initWithTitle:@"保存" action:@selector(saveFile:) keyEquivalent:@"s"];
    [saveItem setTarget:self];
    [fileMenu addItem:saveItem];
    
    [mainMenu setSubmenu:fileMenu forItem:fileMenuItem];
    [mainMenu addItem:fileMenuItem];
    
    // 编辑菜单
    NSMenuItem *editMenuItem = [[NSMenuItem alloc] initWithTitle:@"编辑" action:nil keyEquivalent:@""];
    NSMenu *editMenu = [[NSMenu alloc] initWithTitle:@"编辑"];
    
    // 撤销
    NSMenuItem *undoItem = [[NSMenuItem alloc] initWithTitle:@"撤销" action:@selector(undo:) keyEquivalent:@"z"];
    [undoItem setTarget:self.textView.undoManager];
    [editMenu addItem:undoItem];
    
    // 重做
    NSMenuItem *redoItem = [[NSMenuItem alloc] initWithTitle:@"重做" action:@selector(redo:) keyEquivalent:@"Z"];
    [redoItem setTarget:self.textView.undoManager];
    [editMenu addItem:redoItem];
    
    [editMenu addItem:[NSMenuItem separatorItem]];
    
    // 剪切
    NSMenuItem *cutItem = [[NSMenuItem alloc] initWithTitle:@"剪切" action:@selector(cut:) keyEquivalent:@"x"];
    [cutItem setTarget:self.textView];
    [editMenu addItem:cutItem];
    
    // 复制
    NSMenuItem *copyItem = [[NSMenuItem alloc] initWithTitle:@"复制" action:@selector(copy:) keyEquivalent:@"c"];
    [copyItem setTarget:self.textView];
    [editMenu addItem:copyItem];
    
    // 粘贴
    NSMenuItem *pasteItem = [[NSMenuItem alloc] initWithTitle:@"粘贴" action:@selector(paste:) keyEquivalent:@"v"];
    [pasteItem setTarget:self.textView];
    [editMenu addItem:pasteItem];
    
    [editMenu addItem:[NSMenuItem separatorItem]];
    
    // 全选
    NSMenuItem *selectAllItem = [[NSMenuItem alloc] initWithTitle:@"全选" action:@selector(selectAll:) keyEquivalent:@"a"];
    [selectAllItem setTarget:self.textView];
    [editMenu addItem:selectAllItem];
    
    [mainMenu setSubmenu:editMenu forItem:editMenuItem];
    [mainMenu addItem:editMenuItem];
    
    // 格式菜单
    NSMenuItem *formatMenuItem = [[NSMenuItem alloc] initWithTitle:@"格式" action:nil keyEquivalent:@""];
    NSMenu *formatMenu = [[NSMenu alloc] initWithTitle:@"格式"];
    
    // 字体设置
    NSMenuItem *fontItem = [[NSMenuItem alloc] initWithTitle:@"字体..." action:@selector(showFontPanel:) keyEquivalent:@"t"];
    [fontItem setTarget:self];
    [formatMenu addItem:fontItem];
    
    [mainMenu setSubmenu:formatMenu forItem:formatMenuItem];
    [mainMenu addItem:formatMenuItem];
    
    // 设置应用程序菜单
    [NSApp setMainMenu:mainMenu];
    
    NSLog(@"✅ SimpleTextEditor: 菜单设置完成");
}

#pragma mark - 文件操作

- (void)newFile:(id)sender {
    NSLog(@"🔧 SimpleTextEditor: 新建文件");
    
    // 检查当前文档是否需要保存
    if (self.documentModified) {
        [self promptToSaveBeforeAction:@"新建文件"];
        return;
    }
    
    // 清空文本内容
    self.textView.string = @"";
    self.currentFilePath = nil;
    [self clearDocumentModifiedStatus];
    self.window.title = @"新文档 - Simplepad";
    
    NSLog(@"✅ SimpleTextEditor: 新建文件完成");
}

- (void)openFile:(id)sender {
    NSLog(@"🔧 SimpleTextEditor: 打开文件");
    
    // 检查当前文档是否需要保存
    if (self.documentModified) {
        [self promptToSaveBeforeAction:@"打开文件"];
        return;
    }
    
    // 创建打开文件面板
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    openPanel.allowsMultipleSelection = NO;
    openPanel.canChooseDirectories = NO;
    openPanel.canChooseFiles = YES;
    openPanel.allowedFileTypes = @[@"txt", @"*"];
    
    [openPanel beginSheetModalForWindow:self.window completionHandler:^(NSInteger result) {
        if (result == NSModalResponseOK) {
            NSURL *fileURL = openPanel.URLs.firstObject;
            [self loadFileAtURL:fileURL];
        }
    }];
}

- (void)loadFileAtURL:(NSURL *)fileURL {
    NSLog(@"🔧 SimpleTextEditor: 加载文件: %@", fileURL.path);
    
    NSError *error = nil;
    NSString *fileContent = [NSString stringWithContentsOfURL:fileURL encoding:NSUTF8StringEncoding error:&error];
    
    if (error) {
        NSLog(@"❌ SimpleTextEditor: 文件读取失败: %@", error);
        [self showAlert:@"错误" message:@"无法读取文件"];
        return;
    }
    
    // 设置文本内容
    self.textView.string = fileContent;
    self.currentFilePath = fileURL.path;
    [self clearDocumentModifiedStatus];
    self.window.title = [NSString stringWithFormat:@"%@ - Simplepad", fileURL.lastPathComponent];
    
    NSLog(@"✅ SimpleTextEditor: 文件加载完成");
}

- (void)saveFile:(id)sender {
    NSLog(@"🔧 SimpleTextEditor: 保存文件");
    
    if (self.currentFilePath) {
        // 保存到现有文件
        [self saveToCurrentFile];
    } else {
        // 另存为新文件
        [self saveAsNewFile];
    }
}

- (void)saveToCurrentFile {
    NSError *error = nil;
    BOOL success = [self.textView.string writeToFile:self.currentFilePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
    
    if (success) {
        NSLog(@"✅ SimpleTextEditor: 文件保存成功");
        [self clearDocumentModifiedStatus];
    } else {
        NSLog(@"❌ SimpleTextEditor: 文件保存失败: %@", error);
        [self showAlert:@"错误" message:@"文件保存失败"];
    }
}

- (void)saveAsNewFile {
    NSSavePanel *savePanel = [NSSavePanel savePanel];
    savePanel.allowedFileTypes = @[@"txt"];
    savePanel.nameFieldStringValue = @"新文档.txt";
    
    [savePanel beginSheetModalForWindow:self.window completionHandler:^(NSInteger result) {
        if (result == NSModalResponseOK) {
            NSURL *fileURL = savePanel.URL;
            self.currentFilePath = fileURL.path;
            [self saveToCurrentFile];
            self.window.title = [NSString stringWithFormat:@"%@ - Simplepad", fileURL.lastPathComponent];
        }
    }];
}

#pragma mark - 辅助方法

- (void)showAlert:(NSString *)title message:(NSString *)message {
    NSAlert *alert = [[NSAlert alloc] init];
    alert.messageText = title;
    alert.informativeText = message;
    [alert addButtonWithTitle:@"确定"];
    [alert runModal];
}

#pragma mark - 字体设置

- (void)showFontPanel:(id)sender {
    NSLog(@"🔧 SimpleTextEditor: 显示字体面板");
    
    // 创建字体管理器
    NSFontManager *fontManager = [NSFontManager sharedFontManager];
    
    // 设置字体面板的目标
    [fontManager setTarget:self];
    [fontManager setAction:@selector(changeFont:)];
    
    // 显示字体面板
    NSFontPanel *fontPanel = [fontManager fontPanel:YES];
    [fontPanel makeKeyAndOrderFront:nil];
}

- (void)changeFont:(id)sender {
    NSLog(@"🔧 SimpleTextEditor: 更改字体");
    
    NSFontManager *fontManager = [NSFontManager sharedFontManager];
    NSFont *newFont = [fontManager convertFont:self.textView.font];
    
    if (newFont) {
        self.textView.font = newFont;
        NSLog(@"✅ SimpleTextEditor: 字体已更改为: %@", newFont.fontName);
    }
}

#pragma mark - 文档修改状态管理

- (void)textDidChange:(NSNotification *)notification {
    // 标记文档为已修改
    if (!self.documentModified) {
        self.documentModified = YES;
        [self updateWindowTitleWithModifiedStatus];
    }
}

- (void)updateWindowTitleWithModifiedStatus {
    NSString *baseTitle = self.window.title;
    
    // 移除现有的修改标记
    if ([baseTitle hasSuffix:@"*"] || [baseTitle hasSuffix:@" (已修改)"]) {
        baseTitle = [baseTitle stringByReplacingOccurrencesOfString:@"*" withString:@""];
        baseTitle = [baseTitle stringByReplacingOccurrencesOfString:@" (已修改)" withString:@""];
        baseTitle = [baseTitle stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    }
    
    // 添加修改标记
    if (self.documentModified) {
        self.window.title = [NSString stringWithFormat:@"%@*", baseTitle];
    } else {
        self.window.title = baseTitle;
    }
}

- (void)clearDocumentModifiedStatus {
    self.documentModified = NO;
    [self updateWindowTitleWithModifiedStatus];
}

- (void)promptToSaveBeforeAction:(NSString *)actionName {
    NSLog(@"🔧 SimpleTextEditor: 在执行 %@ 前提示保存", actionName);
    
    NSAlert *alert = [[NSAlert alloc] init];
    alert.messageText = @"文档已修改";
    alert.informativeText = [NSString stringWithFormat:@"文档已修改，是否要在执行 %@ 前保存更改？", actionName];
    
    [alert addButtonWithTitle:@"保存"];
    [alert addButtonWithTitle:@"不保存"];
    [alert addButtonWithTitle:@"取消"];
    
    NSInteger response = [alert runModal];
    
    switch (response) {
        case NSAlertFirstButtonReturn: // 保存
            [self saveFile:nil];
            break;
        case NSAlertSecondButtonReturn: // 不保存
            // 继续执行操作，不保存
            break;
        case NSAlertThirdButtonReturn: // 取消
            // 取消操作
            return;
        default:
            break;
    }
}

#pragma mark - 应用程序代理

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
    return YES;
}

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender {
    NSLog(@"🔧 SimpleTextEditor: 检查应用程序是否应该终止");
    
    // 检查文档是否需要保存
    if (self.documentModified) {
        NSAlert *alert = [[NSAlert alloc] init];
        alert.messageText = @"文档已修改";
        alert.informativeText = @"文档已修改，是否要在退出前保存更改？";
        
        [alert addButtonWithTitle:@"保存"];
        [alert addButtonWithTitle:@"不保存"];
        [alert addButtonWithTitle:@"取消"];
        
        NSInteger response = [alert runModal];
        
        switch (response) {
            case NSAlertFirstButtonReturn: // 保存
                [self saveFile:nil];
                return NSTerminateNow;
            case NSAlertSecondButtonReturn: // 不保存
                return NSTerminateNow;
            case NSAlertThirdButtonReturn: // 取消
                return NSTerminateCancel;
            default:
                return NSTerminateCancel;
        }
    }
    
    return NSTerminateNow;
}

@end

#pragma mark - 主函数

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSLog(@"🔧 SimpleTextEditor: 启动极简文本编辑器");
        
        // 创建应用程序实例
        NSApplication *application = [NSApplication sharedApplication];
        
        // 创建应用程序委托
        SimpleTextEditor *appDelegate = [[SimpleTextEditor alloc] init];
        [application setDelegate:appDelegate];
        
        // 启动应用程序
        [application run];
        
        return 0;
    }
}