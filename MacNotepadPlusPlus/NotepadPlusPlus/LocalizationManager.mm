//
//  LocalizationManager.mm
//  NotepadPlusPlus
//
//  Created by Lingma on 12/12/2025.
//

#import "LocalizationManager.h"

@implementation LocalizationManager

+ (LocalizationManager *)sharedManager {
    static LocalizationManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[LocalizationManager alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self loadLocalizedStrings];
    }
    return self;
}

- (void)loadLocalizedStrings {
    NSString *languageCode = [[NSLocale preferredLanguages] firstObject];
    
    if ([languageCode hasPrefix:@"zh"]) {
        _localizedStrings = @{
            // Menu titles
            @"menu_notepad": @"记事本",
            @"menu_file": @"文件",
            @"menu_edit": @"编辑",
            @"menu_search": @"搜索",
            @"menu_view": @"视图",
            @"menu_encoding": @"编码",
            @"menu_language": @"语言",
            @"menu_settings": @"设置",
            @"menu_macro": @"宏",
            @"menu_run": @"运行",
            @"menu_plugins": @"插件",
            @"menu_window": @"窗口",
            @"menu_help": @"帮助",
            
            // File menu items
            @"menu_new": @"新建",
            @"menu_open": @"打开",
            @"menu_save": @"保存",
            @"menu_save_as": @"另存为",
            @"menu_print": @"打印",
            @"menu_close": @"关闭",
            
            // Edit menu items
            @"menu_undo": @"撤销",
            @"menu_redo": @"重做",
            @"menu_cut": @"剪切",
            @"menu_copy": @"复制",
            @"menu_paste": @"粘贴",
            @"menu_delete": @"删除",
            @"menu_select_all": @"全选",
            
            // Search menu items
            @"menu_find": @"查找",
            @"menu_replace": @"替换",
            @"menu_find_next": @"查找下一个",
            @"menu_find_previous": @"查找上一个",
            
            // View menu items
            @"menu_show_toolbar": @"显示工具栏",
            @"menu_show_status_bar": @"显示状态栏",
            @"menu_zoom_in": @"放大",
            @"menu_zoom_out": @"缩小",
            @"menu_reset_zoom": @"重置缩放",
            @"menu_toggle_line_numbers": @"切换行号",
            @"menu_toggle_whitespace": @"切换空白字符",
            @"menu_enter_full_screen": @"进入全屏",
            @"menu_function_list": @"函数列表",
            
            // Settings menu items
            @"menu_preferences": @"偏好设置",
            
            // Window menu items
            @"menu_minimize": @"最小化",
            @"menu_zoom": @"缩放",
            
            // Help menu items
            @"menu_about": @"关于",
            
            // Toolbar items
            @"toolbar_language": @"语言",
            
            // Status bar items
            @"status_bar_length": @"长度",
            @"status_bar_lines": @"行数",
            @"status_bar_selection": @"选择",
            
            // Panels
            @"find_panel_title": @"查找",
            @"replace_panel_title": @"替换",
            @"go_to_line_title": @"转到行",
            @"document_statistics_title": @"文档统计",
            @"print_preview_title": @"打印预览",
            @"encoding_converter_title": @"编码转换器",
            @"line_operations_title": @"行操作",
            @"function_list": @"函数列表",
            
            // Buttons
            @"button_ok": @"确定",
            @"button_cancel": @"取消",
            @"button_close": @"关闭",
            @"button_apply": @"应用",
            
            // Labels
            @"label_find": @"查找:",
            @"label_replace": @"替换:",
            @"label_line": @"行:",
            @"label_characters": @"字符数:",
            @"label_words": @"单词数:",
            @"label_lines": @"行数:",
            
            // Function list panel
            @"search_functions": @"搜索函数",
            @"name": @"名称",
            @"reload": @"重新加载",
            @"sort": @"排序"
        };
    } else {
        _localizedStrings = @{
            // Menu titles
            @"menu_notepad": @"Notepad",
            @"menu_file": @"File",
            @"menu_edit": @"Edit",
            @"menu_search": @"Search",
            @"menu_view": @"View",
            @"menu_encoding": @"Encoding",
            @"menu_language": @"Language",
            @"menu_settings": @"Settings",
            @"menu_macro": @"Macro",
            @"menu_run": @"Run",
            @"menu_plugins": @"Plugins",
            @"menu_window": @"Window",
            @"menu_help": @"Help",
            
            // File menu items
            @"menu_new": @"New",
            @"menu_open": @"Open",
            @"menu_save": @"Save",
            @"menu_save_as": @"Save As",
            @"menu_print": @"Print",
            @"menu_close": @"Close",
            
            // Edit menu items
            @"menu_undo": @"Undo",
            @"menu_redo": @"Redo",
            @"menu_cut": @"Cut",
            @"menu_copy": @"Copy",
            @"menu_paste": @"Paste",
            @"menu_delete": @"Delete",
            @"menu_select_all": @"Select All",
            
            // Search menu items
            @"menu_find": @"Find",
            @"menu_replace": @"Replace",
            @"menu_find_next": @"Find Next",
            @"menu_find_previous": @"Find Previous",
            
            // View menu items
            @"menu_show_toolbar": @"Show Toolbar",
            @"menu_show_status_bar": @"Show Status Bar",
            @"menu_zoom_in": @"Zoom In",
            @"menu_zoom_out": @"Zoom Out",
            @"menu_reset_zoom": @"Reset Zoom",
            @"menu_toggle_line_numbers": @"Toggle Line Numbers",
            @"menu_toggle_whitespace": @"Toggle Whitespace",
            @"menu_enter_full_screen": @"Enter Full Screen",
            @"menu_function_list": @"Function List",
            
            // Settings menu items
            @"menu_preferences": @"Preferences",
            
            // Window menu items
            @"menu_minimize": @"Minimize",
            @"menu_zoom": @"Zoom",
            
            // Help menu items
            @"menu_about": @"About",
            
            // Toolbar items
            @"toolbar_language": @"Language",
            
            // Status bar items
            @"status_bar_length": @"Length",
            @"status_bar_lines": @"Lines",
            @"status_bar_selection": @"Sel",
            
            // Panels
            @"find_panel_title": @"Find",
            @"replace_panel_title": @"Replace",
            @"go_to_line_title": @"Go to Line",
            @"document_statistics_title": @"Document Statistics",
            @"print_preview_title": @"Print Preview",
            @"encoding_converter_title": @"Encoding Converter",
            @"line_operations_title": @"Line Operations",
            @"function_list": @"Function List",
            
            // Buttons
            @"button_ok": @"OK",
            @"button_cancel": @"Cancel",
            @"button_close": @"Close",
            @"button_apply": @"Apply",
            
            // Labels
            @"label_find": @"Find:",
            @"label_replace": @"Replace:",
            @"label_line": @"Line:",
            @"label_characters": @"Characters:",
            @"label_words": @"Words:",
            @"label_lines": @"Lines:",
            
            // Function list panel
            @"search_functions": @"Search Functions",
            @"name": @"Name",
            @"reload": @"Reload",
            @"sort": @"Sort"
        };
    }
}

- (NSString *)localizedStringForKey:(NSString *)key {
    NSString *localizedString = [_localizedStrings objectForKey:key];
    return localizedString ?: key;
}

- (void)setLanguage:(NSString *)language {
    // Implementation for setting language dynamically
    [self loadLocalizedStrings];
}

@end