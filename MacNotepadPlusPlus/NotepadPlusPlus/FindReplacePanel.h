//
//  FindReplacePanel.mm
//  NotepadPlusPlus
//
//  Created by Assistant on 12/12/2025.
//

#import "FindReplacePanel.h"

@interface FindReplacePanel ()
// Private properties
@property (nonatomic, strong) NSMutableArray<NSString *> *mutableSearchHistory;
@property (nonatomic, strong) NSMutableArray<NSString *> *mutableReplaceHistory;

// UI elements
@property (nonatomic, strong) NSPanel *panel;
@property (nonatomic, strong) NSTextField *findTextField;
@property (nonatomic, strong) NSTextField *replaceTextField;
@property (nonatomic, strong) NSButton *matchCaseCheckbox;
@property (nonatomic, strong) NSButton *matchWholeWordCheckbox;
@property (nonatomic, strong) NSButton *regularExpressionCheckbox;
@property (nonatomic, strong) NSButton *wrapAroundCheckbox;
@property (nonatomic, strong) NSButton *findNextButton;
@property (nonatomic, strong) NSButton *findAllButton;
@property (nonatomic, strong) NSButton *replaceButton;
@property (nonatomic, strong) NSButton *replaceAllButton;

// State
@property (nonatomic, assign) BOOL isReplaceMode;

// Private methods
- (void)createPanel;
- (void)createFindControls;
- (void)createReplaceControls;
- (void)createButtons;
- (void)layoutUI;
- (void)showPanel:(id)sender;
- (BOOL)isVisible;
- (void)performFindWithText:(NSString *)text forward:(BOOL)forward;
- (void)performFindAllWithText:(NSString *)text;
- (void)performReplace:(NSString *)findText withString:(NSString *)replaceText;
- (void)performReplaceAll:(NSString *)findText withString:(NSString *)replaceText;
@end

@implementation FindReplacePanel

- (instancetype)initWithTextView:(ScintillaView *)textView {
    self = [super init];
    if (self) {
        _textView = textView;
        _isReplaceMode = NO;
        _maxHistoryItems = 20;
        _mutableSearchHistory = [[NSMutableArray alloc] init];
        _mutableReplaceHistory = [[NSMutableArray alloc] init];
        [self createPanel];
    }
    return self;
}

// Lazy getters for history arrays
- (NSArray<NSString *> *)searchHistory {
    return [self.mutableSearchHistory copy];
}

- (NSArray<NSString *> *)replaceHistory {
    return [self.mutableReplaceHistory copy];
}

- (void)createPanel {
    // Create the panel
    _panel = [[NSPanel alloc] initWithContentRect:NSMakeRect(100, 100, 400, 200)
                                      styleMask:NSWindowStyleMaskTitled | 
                                               NSWindowStyleMaskClosable |
                                               NSWindowStyleMaskResizable
                                        backing:NSBackingStoreBuffered
                                          defer:NO];
    [_panel setTitle:@"Find and Replace"];
    [_panel setFloatingPanel:YES];
    
    // Create UI elements
    [self createFindControls];
    [self createReplaceControls];
    [self createButtons];
    
    // Layout the UI
    [self layoutUI];
}

- (void)createFindControls {
    _findTextField = [[NSTextField alloc] initWithFrame:NSMakeRect(10, 160, 300, 24)];
    [_findTextField setPlaceholderString:@"Find"];
    
    _matchCaseCheckbox = [[NSButton alloc] initWithFrame:NSMakeRect(10, 130, 100, 20)];
    [_matchCaseCheckbox setTitle:@"Match case"];
    [_matchCaseCheckbox setButtonType:NSSwitchButton];
    
    _matchWholeWordCheckbox = [[NSButton alloc] initWithFrame:NSMakeRect(110, 130, 120, 20)];
    [_matchWholeWordCheckbox setTitle:@"Whole word"];
    [_matchWholeWordCheckbox setButtonType:NSSwitchButton];
    
    _regularExpressionCheckbox = [[NSButton alloc] initWithFrame:NSMakeRect(230, 130, 120, 20)];
    [_regularExpressionCheckbox setTitle:@"Regular expression"];
    [_regularExpressionCheckbox setButtonType:NSSwitchButton];
    
    _wrapAroundCheckbox = [[NSButton alloc] initWithFrame:NSMakeRect(10, 105, 100, 20)];
    [_wrapAroundCheckbox setTitle:@"Wrap around"];
    [_wrapAroundCheckbox setButtonType:NSSwitchButton];
}

- (void)createReplaceControls {
    _replaceTextField = [[NSTextField alloc] initWithFrame:NSMakeRect(10, 75, 300, 24)];
    [_replaceTextField setPlaceholderString:@"Replace with"];
}

- (void)createButtons {
    _findNextButton = [[NSButton alloc] initWithFrame:NSMakeRect(320, 160, 70, 24)];
    [_findNextButton setTitle:@"Find Next"];
    [_findNextButton setTarget:self];
    [_findNextButton setAction:@selector(findNext:)];
    
    _findAllButton = [[NSButton alloc] initWithFrame:NSMakeRect(320, 135, 70, 24)];
    [_findAllButton setTitle:@"Find All"];
    [_findAllButton setTarget:self];
    [_findAllButton setAction:@selector(findAll:)];
    
    _replaceButton = [[NSButton alloc] initWithFrame:NSMakeRect(320, 75, 70, 24)];
    [_replaceButton setTitle:@"Replace"];
    [_replaceButton setTarget:self];
    [_replaceButton setAction:@selector(replace:)];
    
    _replaceAllButton = [[NSButton alloc] initWithFrame:NSMakeRect(320, 45, 70, 24)];
    [_replaceAllButton setTitle:@"Replace All"];
    [_replaceAllButton setTarget:self];
    [_replaceAllButton setAction:@selector(replaceAll:)];
}

- (void)layoutUI {
    NSView *contentView = [_panel contentView];
    
    // Add find controls
    [contentView addSubview:_findTextField];
    [contentView addSubview:_matchCaseCheckbox];
    [contentView addSubview:_matchWholeWordCheckbox];
    [contentView addSubview:_regularExpressionCheckbox];
    [contentView addSubview:_wrapAroundCheckbox];
    
    // Add replace controls (initially hidden in find mode)
    [contentView addSubview:_replaceTextField];
    [contentView addSubview:_replaceButton];
    [contentView addSubview:_replaceAllButton];
    
    // Add buttons
    [contentView addSubview:_findNextButton];
    [contentView addSubview:_findAllButton];
}

- (void)showFindPanel:(id)sender {
    _isReplaceMode = NO;
    [self showPanel:sender];
}

- (void)showReplacePanel:(id)sender {
    _isReplaceMode = YES;
    [self showPanel:sender];
}

- (void)showPanel:(id)sender {
    if (!_panel) {
        [self createPanel];
    }
    
    // Show or hide replace controls based on mode
    [_replaceTextField setHidden:!_isReplaceMode];
    [_replaceButton setHidden:!_isReplaceMode];
    [_replaceAllButton setHidden:!_isReplaceMode];
    
    // Adjust panel size based on mode
    NSRect frame = [_panel frame];
    if (_isReplaceMode) {
        frame.size.height = 200;
    } else {
        frame.size.height = 150;
    }
    [_panel setFrame:frame display:YES animate:YES];
    
    [_panel makeKeyAndOrderFront:sender];
    [_findTextField selectText:nil];
}

- (BOOL)isVisible {
    return [_panel isVisible];
}

- (void)findNext:(id)sender {
    NSString *text = [_findTextField stringValue];
    if (!text || [text length] == 0) {
        return;
    }
    
    // Add to search history
    [self addSearchTermToHistory:text];
    
    [self performFindWithText:text forward:YES];
}

- (void)findAll:(id)sender {
    NSString *text = [_findTextField stringValue];
    if (!text || [text length] == 0) {
        return;
    }
    
    // Add to search history
    [self addSearchTermToHistory:text];
    
    [self performFindAllWithText:text];
}

- (void)findPrevious:(id)sender {
    NSString *text = [_findTextField stringValue];
    if (!text || [text length] == 0) {
        return;
    }
    
    // Add to search history
    [self addSearchTermToHistory:text];
    
    [self performFindWithText:text forward:NO];
}

// Helper methods for finding
- (void)performFindWithText:(NSString *)text forward:(BOOL)forward {
    NSInteger searchFlags = 0;
    if (![self isMatchCase]) {
        searchFlags |= NSCaseInsensitiveSearch;
    }
    if ([self isMatchWholeWord]) {
        searchFlags |= NSLiteralSearch;
    }
    
    BOOL useRegex = [self isRegularExpression];
    
    // Use Scintilla's search functionality
    if (_textView) {
        if (forward) {
            [_textView findNext:text flags:searchFlags useRegex:useRegex];
        } else {
            [_textView findPrevious:text flags:searchFlags useRegex:useRegex];
        }
    }
}

- (void)performFindAllWithText:(NSString *)text {
    NSInteger searchFlags = 0;
    if (![self isMatchCase]) {
        searchFlags |= NSCaseInsensitiveSearch;
    }
    if ([self isMatchWholeWord]) {
        searchFlags |= NSLiteralSearch;
    }
    
    BOOL useRegex = [self isRegularExpression];
    
    if (_textView) {
        [_textView findAll:text flags:searchFlags useRegex:useRegex];
    }
}

- (void)replace:(id)sender {
    if (!_isReplaceMode || !_textView) {
        return;
    }
    
    NSString *findText = [_findTextField stringValue];
    NSString *replaceText = [_replaceTextField stringValue];
    
    if (!findText || [findText length] == 0) {
        return;
    }
    
    // Add to histories
    [self addSearchTermToHistory:findText];
    [self addReplaceTermToHistory:replaceText];
    
    [self performReplace:findText withString:replaceText];
}

- (void)replaceAll:(id)sender {
    if (!_isReplaceMode || !_textView) {
        return;
    }
    
    NSString *findText = [_findTextField stringValue];
    NSString *replaceText = [_replaceTextField stringValue];
    
    if (!findText || [findText length] == 0) {
        return;
    }
    
    // Add to histories
    [self addSearchTermToHistory:findText];
    [self addReplaceTermToHistory:replaceText];
    
    [self performReplaceAll:findText withString:replaceText];
}

// Helper methods for replacing
- (void)performReplace:(NSString *)findText withString:(NSString *)replaceText {
    NSInteger searchFlags = 0;
    if (![self isMatchCase]) {
        searchFlags |= NSCaseInsensitiveSearch;
    }
    if ([self isMatchWholeWord]) {
        searchFlags |= NSLiteralSearch;
    }
    
    BOOL useRegex = [self isRegularExpression];
    
    [_textView replaceCurrent:findText withString:replaceText flags:searchFlags useRegex:useRegex];
}

- (void)performReplaceAll:(NSString *)findText withString:(NSString *)replaceText {
    NSInteger searchFlags = 0;
    if (![self isMatchCase]) {
        searchFlags |= NSCaseInsensitiveSearch;
    }
    if ([self isMatchWholeWord]) {
        searchFlags |= NSLiteralSearch;
    }
    
    BOOL useRegex = [self isRegularExpression];
    
    NSInteger count = [_textView replaceAll:findText withString:replaceText flags:searchFlags useRegex:useRegex];
    NSLog(@"Replaced %ld occurrences", (long)count);
}

// History management
- (void)addSearchTermToHistory:(NSString *)term {
    if (!term || [term length] == 0) {
        return;
    }
    
    // Remove existing instance if present
    [self.mutableSearchHistory removeObject:term];
    
    // Add to front of array
    [self.mutableSearchHistory insertObject:term atIndex:0];
    
    // Trim array to max size
    while ([self.mutableSearchHistory count] > _maxHistoryItems) {
        [self.mutableSearchHistory removeLastObject];
    }
}

- (void)addReplaceTermToHistory:(NSString *)term {
    if (!term || [term length] == 0) {
        return;
    }
    
    // Remove existing instance if present
    [self.mutableReplaceHistory removeObject:term];
    
    // Add to front of array
    [self.mutableReplaceHistory insertObject:term atIndex:0];
    
    // Trim array to max size
    while ([self.mutableReplaceHistory count] > _maxHistoryItems) {
        [self.mutableReplaceHistory removeLastObject];
    }
}

- (void)clearSearchHistory {
    [self.mutableSearchHistory removeAllObjects];
}

- (void)clearReplaceHistory {
    [self.mutableReplaceHistory removeAllObjects];
}

// Accessors
- (NSString *)searchText {
    return [_findTextField stringValue];
}

- (NSString *)replaceText {
    return [_replaceTextField stringValue];
}

- (BOOL)isRegularExpression {
    return [_regularExpressionCheckbox state] == NSControlStateValueOn;
}

- (BOOL)isMatchCase {
    return [_matchCaseCheckbox state] == NSControlStateValueOn;
}

- (BOOL)isMatchWholeWord {
    return [_matchWholeWordCheckbox state] == NSControlStateValueOn;
}

- (BOOL)isWrapAround {
    return [_wrapAroundCheckbox state] == NSControlStateValueOn;
}

- (BOOL)isReplaceMode {
    return _isReplaceMode;
}

- (void)closePanel {
    [_panel close];
}

@end
//
//  FindReplacePanel.h
//  NotepadPlusPlus
//
//  Created by Assistant on 12/12/2025.
//

#import <Cocoa/Cocoa.h>
#import "ScintillaView.h"

NS_ASSUME_NONNULL_BEGIN

@interface FindReplacePanel : NSObject

@property (nonatomic, weak) ScintillaView *textView;
@property (nonatomic, strong, readonly) NSPanel *panel;

// Search history
@property (nonatomic, strong, readonly) NSArray<NSString *> *searchHistory;
@property (nonatomic, strong, readonly) NSArray<NSString *> *replaceHistory;
@property (nonatomic, assign) NSInteger maxHistoryItems;

- (instancetype)initWithTextView:(ScintillaView *)textView;

// Panel control
- (void)showFindPanel:(id)sender;
- (void)showReplacePanel:(id)sender;
- (void)closePanel;

// Find operations
- (void)findNext:(id)sender;
- (void)findPrevious:(id)sender;
- (void)findAll:(id)sender;

// Replace operations
- (void)replace:(id)sender;
- (void)replaceAll:(id)sender;

// Accessors
- (NSString *)searchText;
- (NSString *)replaceText;
- (BOOL)isRegularExpression;
- (BOOL)isMatchCase;
- (BOOL)isMatchWholeWord;
- (BOOL)isWrapAround;
- (BOOL)isReplaceMode;

// History management
- (void)addSearchTermToHistory:(NSString *)term;
- (void)addReplaceTermToHistory:(NSString *)term;
- (void)clearSearchHistory;
- (void)clearReplaceHistory;

@end

NS_ASSUME_NONNULL_END