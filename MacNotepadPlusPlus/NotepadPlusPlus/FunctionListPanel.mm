//
//  FunctionListPanel.mm
//  NotepadPlusPlus
//
//  Created by Lingma on 12/12/2025.
//

#import "FunctionListPanel.h"
#import "LocalizationManager.h"

@interface FunctionListPanel() <NSSearchFieldDelegate> {
    NotepadDocumentWindowController *_windowController;
    NSOutlineView *_outlineView;
    NSScrollView *_scrollView;
    NSSearchField *_searchField;
    NSButton *_sortButton;
    NSButton *_reloadButton;
    NSMutableArray *_functionItems;
    NSMutableArray *_filteredFunctionItems;
    BOOL _isSorted;
}

@end

@implementation FunctionListPanel

+ (FunctionListPanel *)sharedPanel {
    static FunctionListPanel *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[FunctionListPanel alloc] initWithContentRect:NSMakeRect(100, 100, 400, 300)
                                                              styleMask:NSTitledWindowMask | NSClosableWindowMask | NSResizableWindowMask
                                                                backing:NSBackingStoreBuffered
                                                                  defer:NO];
    });
    return sharedInstance;
}

- (instancetype)initWithContentRect:(NSRect)contentRect styleMask:(NSWindowStyleMask)style backing:(NSBackingStoreType)backingStoreType defer:(BOOL)flag {
    self = [super initWithContentRect:contentRect styleMask:style backing:backingStoreType defer:flag];
    if (self) {
        [self setupUI];
        [self loadSampleFunctions];
    }
    return self;
}

- (void)setupUI {
    // 设置窗口属性
    [self setTitle:[[LocalizationManager sharedManager] localizedStringForKey:@"function_list"]];
    [self setCollectionBehavior:NSWindowCollectionBehaviorManaged];
    
    // 初始化变量
    _functionItems = [[NSMutableArray alloc] init];
    _filteredFunctionItems = [[NSMutableArray alloc] init];
    _isSorted = NO;
    
    // 创建主视图
    NSView *contentView = [[NSView alloc] initWithFrame:NSMakeRect(0, 0, 400, 300)];
    [self setContentView:contentView];
    
    // 创建搜索框
    _searchField = [[NSSearchField alloc] initWithFrame:NSMakeRect(10, 260, 250, 24)];
    [_searchField setDelegate:self];
    [_searchField setPlaceholderString:[[LocalizationManager sharedManager] localizedStringForKey:@"search_functions"]];
    [contentView addSubview:_searchField];
    
    // 创建重新加载按钮
    _reloadButton = [[NSButton alloc] initWithFrame:NSMakeRect(270, 260, 60, 24)];
    [_reloadButton setTitle:[[LocalizationManager sharedManager] localizedStringForKey:@"reload"]];
    [_reloadButton setBezelStyle:NSPushButtonBezelStyle];
    [_reloadButton setTarget:self];
    [_reloadButton setAction:@selector(reloadFunctionList)];
    [contentView addSubview:_reloadButton];
    
    // 创建排序按钮
    _sortButton = [[NSButton alloc] initWithFrame:NSMakeRect(340, 260, 50, 24)];
    [_sortButton setTitle:[[LocalizationManager sharedManager] localizedStringForKey:@"sort"]];
    [_sortButton setBezelStyle:NSPushButtonBezelStyle];
    [_sortButton setTarget:self];
    [_sortButton setAction:@selector(sortFunctionList)];
    [contentView addSubview:_sortButton];
    
    // 创建滚动视图和大纲视图
    _scrollView = [[NSScrollView alloc] initWithFrame:NSMakeRect(10, 10, 380, 240)];
    [_scrollView setHasVerticalScroller:YES];
    [_scrollView setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
    
    _outlineView = [[NSOutlineView alloc] initWithFrame:NSMakeRect(0, 0, 380, 240)];
    [_outlineView setDataSource:self];
    [_outlineView setDelegate:self];
    [_outlineView setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
    
    NSTableColumn *nameColumn = [[NSTableColumn alloc] initWithIdentifier:@"name"];
    [nameColumn setWidth:378];
    [[nameColumn headerCell] setStringValue:[[LocalizationManager sharedManager] localizedStringForKey:@"name"]];
    [_outlineView addTableColumn:nameColumn];
    [_outlineView setOutlineTableColumn:nameColumn];
    
    [_scrollView setDocumentView:_outlineView];
    [contentView addSubview:_scrollView];
    
    // 设置自动调整大小的掩码
    [_searchField setAutoresizingMask:NSViewWidthSizable];
    [_scrollView setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
}

- (void)loadSampleFunctions {
    // 清空现有数据
    [_functionItems removeAllObjects];
    
    // 添加示例 C++ 函数
    NSMutableDictionary *cppClass = [NSMutableDictionary dictionary];
    [cppClass setObject:@"MyClass" forKey:@"name"];
    NSMutableArray *cppMethods = [NSMutableArray array];
    [cppMethods addObject:@{@"name": @"MyClass()", @"type": @"constructor"}];
    [cppMethods addObject:@{@"name": @"~MyClass()", @"type": @"destructor"}];
    [cppMethods addObject:@{@"name": @"getValue()", @"type": @"method"}];
    [cppMethods addObject:@{@"name": @"setValue(int)", @"type": @"method"}];
    [cppClass setObject:cppMethods forKey:@"children"];
    [_functionItems addObject:cppClass];
    
    // 添加示例 Python 函数
    NSMutableDictionary *pythonClass = [NSMutableDictionary dictionary];
    [pythonClass setObject:@"Person" forKey:@"name"];
    NSMutableArray *pythonMethods = [NSMutableArray array];
    [pythonMethods addObject:@{@"name": @"__init__(self)", @"type": @"method"}];
    [pythonMethods addObject:@{@"name": @"get_name(self)", @"type": @"method"}];
    [pythonMethods addObject:@{@"name": @"set_name(self, name)", @"type": @"method"}];
    [pythonClass setObject:pythonMethods forKey:@"children"];
    [_functionItems addObject:pythonClass];
    
    // 添加示例全局函数
    [_functionItems addObject:@{@"name": @"main()", @"type": @"function"}];
    [_functionItems addObject:@{@"name": @"calculateSum(int, int)", @"type": @"function"}];
    [_functionItems addObject:@{@"name": @"printMessage(string)", @"type": @"function"}];
    
    // 复制到过滤列表
    [_filteredFunctionItems setArray:_functionItems];
    
    // 刷新大纲视图
    [_outlineView reloadData];
}

- (void)showPanel {
    [self makeKeyAndOrderFront:nil];
}

- (void)hidePanel {
    [self orderOut:nil];
}

- (void)togglePanel {
    if ([self isVisible]) {
        [self hidePanel];
    } else {
        [self showPanel];
    }
}

- (void)showPanelWithWindowController:(NotepadDocumentWindowController *)windowController {
    _windowController = windowController;
    [self reloadFunctionList];
    [self togglePanel];
}

- (void)reloadFunctionList {
    [self loadSampleFunctions];
}

- (void)sortFunctionList {
    _isSorted = !_isSorted;
    if (_isSorted) {
        [_sortButton setTitle:@"Unsort"];
    } else {
        [_sortButton setTitle:@"Sort"];
    }
    // 在实际实现中这里会对函数列表进行排序
    NSLog(@"Function list sorting is now %@", _isSorted ? @"enabled" : @"disabled");
}

#pragma mark - NSOutlineViewDataSource

- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item {
    if (item == nil) {
        return [_filteredFunctionItems count];
    }
    
    if ([item isKindOfClass:[NSDictionary class]] && [item objectForKey:@"children"]) {
        NSArray *children = [item objectForKey:@"children"];
        return [children count];
    }
    
    return 0;
}

- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item {
    if (item == nil) {
        return [_filteredFunctionItems objectAtIndex:index];
    }
    
    if ([item isKindOfClass:[NSDictionary class]] && [item objectForKey:@"children"]) {
        NSArray *children = [item objectForKey:@"children"];
        return [children objectAtIndex:index];
    }
    
    return nil;
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item {
    if ([item isKindOfClass:[NSDictionary class]]) {
        return [item objectForKey:@"children"] ? YES : NO;
    }
    return NO;
}

- (id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(id)item {
    if ([item isKindOfClass:[NSDictionary class]]) {
        return [item objectForKey:@"name"];
    }
    
    return @"";
}

#pragma mark - NSOutlineViewDelegate

- (BOOL)outlineView:(NSOutlineView *)outlineView shouldSelectItem:(id)item {
    return YES;
}

- (void)outlineViewSelectionDidChange:(NSNotification *)notification {
    NSOutlineView *outlineView = [notification object];
    NSInteger selectedIndex = [outlineView selectedRow];
    if (selectedIndex >= 0) {
        id selectedItem = [outlineView itemAtRow:selectedIndex];
        if (selectedItem && [selectedItem isKindOfClass:[NSDictionary class]]) {
            NSLog(@"Selected function: %@", [selectedItem objectForKey:@"name"]);
            // 在实际实现中，这里会跳转到相应的函数位置
        }
    }
}

#pragma mark - Actions

- (void)filterFunctionListWithString:(NSString *)searchText {
    [_filteredFunctionItems removeAllObjects];
    
    if (searchText.length == 0) {
        [_filteredFunctionItems setArray:_functionItems];
    } else {
        for (NSDictionary *item in _functionItems) {
            NSString *itemName = [item objectForKey:@"name"];
            if ([itemName rangeOfString:searchText options:NSCaseInsensitiveSearch].location != NSNotFound) {
                [_filteredFunctionItems addObject:item];
            } else if ([item objectForKey:@"children"]) {
                // 检查子项
                NSArray *children = [item objectForKey:@"children"];
                NSMutableArray *matchingChildren = [NSMutableArray array];
                for (NSDictionary *child in children) {
                    NSString *childName = [child objectForKey:@"name"];
                    if ([childName rangeOfString:searchText options:NSCaseInsensitiveSearch].location != NSNotFound) {
                        [matchingChildren addObject:child];
                    }
                }
                if ([matchingChildren count] > 0) {
                    NSMutableDictionary *parentCopy = [item mutableCopy];
                    [parentCopy setObject:matchingChildren forKey:@"children"];
                    [_filteredFunctionItems addObject:parentCopy];
                }
            }
        }
    }
    
    [_outlineView reloadData];
}

- (void)reloadButtonClicked:(NSButton *)sender {
    [self reloadFunctionList];
}

- (void)controlTextDidChange:(NSNotification *)obj {
    if ([obj object] == _searchField) {
        [self filterFunctionListWithString:[_searchField stringValue]];
    }
}

@end