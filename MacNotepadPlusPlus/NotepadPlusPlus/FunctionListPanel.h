//
//  FunctionListPanel.h
//  NotepadPlusPlus
//
//  Created by Lingma on 12/12/2025.
//

#ifndef FunctionListPanel_h
#define FunctionListPanel_h

#import <Cocoa/Cocoa.h>
#import "LocalizationManager.h"

@interface FunctionListPanel : NSPanel <NSOutlineViewDataSource, NSOutlineViewDelegate, NSSearchFieldDelegate> {
@private
    NSOutlineView *_outlineView;
    NSSearchField *_searchField;
    NSButton *_reloadButton;
    NSButton *_sortButton;
    NSScrollView *_scrollView;
    
    NSMutableArray *_functionItems;
    NSMutableArray *_filteredFunctionItems;
    BOOL _isSorted;
    
    // 模拟函数数据结构
    NSArray *_sampleCppFunctions;
    NSArray *_samplePythonFunctions;
    NSArray *_sampleJavaFunctions;
}

@property (nonatomic, strong) NSOutlineView *outlineView;
@property (nonatomic, strong) NSSearchField *searchField;
@property (nonatomic, strong) NSButton *reloadButton;
@property (nonatomic, strong) NSButton *sortButton;

+ (FunctionListPanel *)sharedPanel;
- (void)showPanel;
- (void)hidePanel;
- (void)togglePanel;

// 函数列表相关方法
- (void)reloadFunctionList;
- (void)sortFunctionList;
- (void)filterFunctionListWithString:(NSString *)searchText;
- (void)loadSampleFunctions;

@end

#endif /* FunctionListPanel_h */