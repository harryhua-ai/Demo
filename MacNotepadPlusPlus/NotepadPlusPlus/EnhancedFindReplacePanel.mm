//
//  EnhancedFindReplacePanel.m
//  NotepadPlusPlus
//
//  Created by Assistant on 12/12/2025.
//

#import "EnhancedFindReplacePanel.h"
#import "ScintillaCocoa.h"
#import "HistoryManager.h"
#import "LocalizationManager.h"

@interface EnhancedFindReplacePanel() <NSWindowDelegate>
@property (nonatomic, strong) ScintillaView *textView;
@property (nonatomic, strong) NSComboBox *findComboBox;
@property (nonatomic, strong) NSComboBox *replaceComboBox;
@property (nonatomic, strong) NSButton *matchCaseCheckbox;
@property (nonatomic, strong) NSButton *matchWholeWordCheckbox;
@property (nonatomic, strong) NSButton *regularExpressionCheckbox;
@property (nonatomic, strong) NSButton *wrapAroundCheckbox;
@property (nonatomic, strong) NSButton *findNextButton;
@property (nonatomic, strong) NSButton *replaceButton;
@property (nonatomic, strong) NSButton *replaceAllButton;
@property (nonatomic, strong) NSButton *closeButton;
@property (nonatomic, strong) NSButton *helpButton;
@property (nonatomic, strong) RegexReferencePanel *regexReferencePanel;
@property (nonatomic, assign) BOOL isReplacePanel;
@end

@implementation EnhancedFindReplacePanel

- (instancetype)initWithTextView:(ScintillaView *)textView {
    NSRect frame = NSMakeRect(200, 200, 450, 200);
    
    self = [super initWithWindow:[[NSWindow alloc] initWithContentRect:frame
                                                           styleMask:NSWindowStyleMaskTitled |
                                                                     NSWindowStyleMaskClosable |
                                                                     NSWindowStyleMaskResizable
                                                             backing:NSBackingStoreBuffered
                                                               defer:NO]];
    
    if (self) {
        _textView = textView;
        [self setUpPanel];
    }
    
    return self;
}

- (void)setUpPanel {
    [[self window] setTitle:[LocalizationManager.sharedManager localizedStringForKey:@"find_dialog_title"]];
    [[self window] setDelegate:self];
    
    NSView *contentView = [[NSView alloc] initWithFrame:NSMakeRect(0, 0, 450, 200)];
    [[self window] setContentView:contentView];
    
    // Find label and combo box
    NSTextField *findLabel = [[NSTextField alloc] initWithFrame:NSMakeRect(20, 160, 80, 20)];
    [findLabel setStringValue:[LocalizationManager.sharedManager localizedStringForKey:@"label_find"]];
    [findLabel setEditable:NO];
    [findLabel setBordered:NO];
    [findLabel setDrawsBackground:NO];
    [contentView addSubview:findLabel];
    
    self.findComboBox = [[NSComboBox alloc] initWithFrame:NSMakeRect(100, 160, 330, 26)];
    [self.findComboBox setEditable:YES];
    [self.findComboBox setCompletes:YES];
    [self.findComboBox addItemsWithObjectValues:[[HistoryManager sharedManager] searchHistory]];
    [contentView addSubview:self.findComboBox];
    
    // Replace label and combo box (only for replace panel)
    NSTextField *replaceLabel = [[NSTextField alloc] initWithFrame:NSMakeRect(20, 130, 80, 20)];
    [replaceLabel setStringValue:[LocalizationManager.sharedManager localizedStringForKey:@"label_replace_with"]];
    [replaceLabel setEditable:NO];
    [replaceLabel setBordered:NO];
    [replaceLabel setDrawsBackground:NO];
    [replaceLabel setHidden:YES];
    [contentView addSubview:replaceLabel];
    
    self.replaceComboBox = [[NSComboBox alloc] initWithFrame:NSMakeRect(100, 130, 330, 26)];
    [self.replaceComboBox setEditable:YES];
    [self.replaceComboBox setCompletes:YES];
    [self.replaceComboBox addItemsWithObjectValues:[[HistoryManager sharedManager] replaceHistory]];
    [self.replaceComboBox setHidden:YES];
    [contentView addSubview:self.replaceComboBox];
    
    // Checkboxes
    self.matchCaseCheckbox = [[NSButton alloc] initWithFrame:NSMakeRect(20, 100, 120, 20)];
    [self.matchCaseCheckbox setButtonType:NSSwitchButton];
    [self.matchCaseCheckbox setTitle:[LocalizationManager.sharedManager localizedStringForKey:@"label_match_case"]];
    [contentView addSubview:self.matchCaseCheckbox];
    
    self.matchWholeWordCheckbox = [[NSButton alloc] initWithFrame:NSMakeRect(150, 100, 150, 20)];
    [self.matchWholeWordCheckbox setButtonType:NSSwitchButton];
    [self.matchWholeWordCheckbox setTitle:[LocalizationManager.sharedManager localizedStringForKey:@"label_match_whole_word"]];
    [contentView addSubview:self.matchWholeWordCheckbox];
    
    self.regularExpressionCheckbox = [[NSButton alloc] initWithFrame:NSMakeRect(20, 75, 150, 20)];
    [self.regularExpressionCheckbox setButtonType:NSSwitchButton];
    [self.regularExpressionCheckbox setTitle:[LocalizationManager.sharedManager localizedStringForKey:@"label_regular_expression"]];
    [contentView addSubview:self.regularExpressionCheckbox];
    
    self.wrapAroundCheckbox = [[NSButton alloc] initWithFrame:NSMakeRect(150, 75, 120, 20)];
    [self.wrapAroundCheckbox setButtonType:NSSwitchButton];
    [self.wrapAroundCheckbox setTitle:[LocalizationManager.sharedManager localizedStringForKey:@"label_wrap_around"]];
    [self.wrapAroundCheckbox setState:NSControlStateValueOn]; // Enabled by default
    [contentView addSubview:self.wrapAroundCheckbox];
    
    // Help button for regex
    self.helpButton = [[NSButton alloc] initWithFrame:NSMakeRect(300, 75, 20, 20)];
    [self.helpButton setBezelStyle:NSHelpButtonBezelStyle];
    [self.helpButton setAction:@selector(helpButtonClicked:)];
    [self.helpButton setTarget:self];
    [contentView addSubview:self.helpButton];
    
    // Buttons
    self.findNextButton = [[NSButton alloc] initWithFrame:NSMakeRect(350, 20, 80, 25)];
    [self.findNextButton setTitle:[LocalizationManager.sharedManager localizedStringForKey:@"button_find_next"]];
    [self.findNextButton setBezelStyle:NSPushButtonBezelStyle];
    [self.findNextButton setAction:@selector(findNextClicked:)];
    [self.findNextButton setTarget:self];
    [contentView addSubview:self.findNextButton];
    
    self.replaceButton = [[NSButton alloc] initWithFrame:NSMakeRect(260, 20, 80, 25)];
    [self.replaceButton setTitle:[LocalizationManager.sharedManager localizedStringForKey:@"button_replace"]];
    [self.replaceButton setBezelStyle:NSPushButtonBezelStyle];
    [self.replaceButton setAction:@selector(replaceClicked:)];
    [self.replaceButton setTarget:self];
    [self.replaceButton setHidden:YES];
    [contentView addSubview:self.replaceButton];
    
    self.replaceAllButton = [[NSButton alloc] initWithFrame:NSMakeRect(170, 20, 80, 25)];
    [self.replaceAllButton setTitle:[LocalizationManager.sharedManager localizedStringForKey:@"button_replace_all"]];
    [self.replaceAllButton setBezelStyle:NSPushButtonBezelStyle];
    [self.replaceAllButton setAction:@selector(replaceAllClicked:)];
    [self.replaceAllButton setTarget:self];
    [self.replaceAllButton setHidden:YES];
    [contentView addSubview:self.replaceAllButton];
    
    self.closeButton = [[NSButton alloc] initWithFrame:NSMakeRect(20, 20, 80, 25)];
    [self.closeButton setTitle:[LocalizationManager.sharedManager localizedStringForKey:@"button_close"]];
    [self.closeButton setBezelStyle:NSPushButtonBezelStyle];
    [self.closeButton setAction:@selector(closePanel)];
    [self.closeButton setTarget:self];
    [contentView addSubview:self.closeButton];
}

- (void)showFindPanel {
    self.isReplacePanel = NO;
    [[self window] setTitle:[LocalizationManager.sharedManager localizedStringForKey:@"find_dialog_title"]];
    
    // Hide replace-specific controls
    for (NSView *subview in [[self window] contentView].subviews) {
        if ([subview isKindOfClass:[NSTextField class]] && 
            [[subview stringValue] isEqualToString:
             [LocalizationManager.sharedManager localizedStringForKey:@"label_replace_with"]]) {
            [subview setHidden:YES];
        }
        if ([subview isKindOfClass:[NSComboBox class]] && 
            subview != self.findComboBox) {
            [subview setHidden:YES];
        }
        if ([subview isKindOfClass:[NSButton class]]) {
            if (subview == self.replaceButton || subview == self.replaceAllButton) {
                [subview setHidden:YES];
            }
        }
    }
    
    // Resize window
    NSRect frame = [[self window] frame];
    frame.size.height = 150;
    [[self window] setFrame:frame display:YES animate:YES];
    
    [self.window makeKeyAndOrderFront:nil];
    [NSApp activateIgnoringOtherApps:YES];
}

- (void)showReplacePanel {
    self.isReplacePanel = YES;
    [[self window] setTitle:[LocalizationManager.sharedManager localizedStringForKey:@"replace_dialog_title"]];
    
    // Show replace-specific controls
    for (NSView *subview in [[self window] contentView].subviews) {
        if ([subview isKindOfClass:[NSTextField class]] && 
            [[subview stringValue] isEqualToString:
             [LocalizationManager.sharedManager localizedStringForKey:@"label_replace_with"]]) {
            [subview setHidden:NO];
        }
        if ([subview isKindOfClass:[NSComboBox class]] && 
            subview != self.findComboBox) {
            [subview setHidden:NO];
        }
        if ([subview isKindOfClass:[NSButton class]]) {
            if (subview == self.replaceButton || subview == self.replaceAllButton) {
                [subview setHidden:NO];
            }
        }
    }
    
    // Resize window
    NSRect frame = [[self window] frame];
    frame.size.height = 200;
    [[self window] setFrame:frame display:YES animate:YES];
    
    [self.window makeKeyAndOrderFront:nil];
    [NSApp activateIgnoringOtherApps:YES];
}

- (void)closePanel {
    [self.window close];
}

- (NSString *)searchText {
    return [self.findComboBox stringValue];
}

- (NSString *)replaceText {
    return [self.replaceComboBox stringValue];
}

- (BOOL)isRegularExpression {
    return [self.regularExpressionCheckbox state] == NSControlStateValueOn;
}

- (BOOL)isMatchCase {
    return [self.matchCaseCheckbox state] == NSControlStateValueOn;
}

- (BOOL)isMatchWholeWord {
    return [self.matchWholeWordCheckbox state] == NSControlStateValueOn;
}

- (BOOL)isWrapAround {
    return [self.wrapAroundCheckbox state] == NSControlStateValueOn;
}

- (void)findNext {
    NSString *searchText = self.searchText;
    if (searchText.length == 0) return;
    
    // Add to search history
    [[HistoryManager sharedManager] addSearchTerm:searchText];
    
    // Update combo box items
    [self.findComboBox removeAllItems];
    [self.findComboBox addItemsWithObjectValues:[[HistoryManager sharedManager] searchHistory]];
    [self.findComboBox setStringValue:searchText];
    
    // Set search flags
    int flags = 0;
    if (self.isMatchCase) {
        flags |= SCFIND_MATCHCASE;
    }
    if (self.isMatchWholeWord) {
        flags |= SCFIND_WHOLEWORD;
    }
    if (self.isRegularExpression) {
        flags |= SCFIND_REGEXP;
    }
    
    [self.textView sendmessage:SCI_SEARCHANCHOR sub:0 wparam:0];
    long pos = [self.textView sendmessage:SCI_SEARCHNEXT sub:flags wparam:(sptr_t)[searchText UTF8String]];
    
    if (pos != -1) {
        // Found
        [self.textView sendmessage:SCI_SETSEL sub:pos wparam:pos + searchText.length];
    } else if (self.isWrapAround) {
        // Wrap around and try again from the beginning
        [self.textView sendmessage:SCI_SETSELECTIONSTART sub:0 wparam:0];
        [self.textView sendmessage:SCI_SETSELECTIONEND sub:0 wparam:0];
        [self.textView sendmessage:SCI_SEARCHANCHOR sub:0 wparam:0];
        pos = [self.textView sendmessage:SCI_SEARCHNEXT sub:flags wparam:(sptr_t)[searchText UTF8String]];
        
        if (pos != -1) {
            // Found after wrapping
            [self.textView sendmessage:SCI_SETSEL sub:pos wparam:pos + searchText.length];
        } else {
            // Not found anywhere
            NSBeep();
        }
    } else {
        // Not found and not wrapping
        NSBeep();
    }
}

- (void)findPrevious {
    NSString *searchText = self.searchText;
    if (searchText.length == 0) return;
    
    // Add to search history
    [[HistoryManager sharedManager] addSearchTerm:searchText];
    
    // Update combo box items
    [self.findComboBox removeAllItems];
    [self.findComboBox addItemsWithObjectValues:[[HistoryManager sharedManager] searchHistory]];
    [self.findComboBox setStringValue:searchText];
    
    // Set search flags
    int flags = 0;
    if (self.isMatchCase) {
        flags |= SCFIND_MATCHCASE;
    }
    if (self.isMatchWholeWord) {
        flags |= SCFIND_WHOLEWORD;
    }
    if (self.isRegularExpression) {
        flags |= SCFIND_REGEXP;
    }
    
    [self.textView sendmessage:SCI_SEARCHANCHOR sub:0 wparam:0];
    long pos = [self.textView sendmessage:SCI_SEARCHPREV sub:flags wparam:(sptr_t)[searchText UTF8String]];
    
    if (pos != -1) {
        // Found
        [self.textView sendmessage:SCI_SETSEL sub:pos wparam:pos + searchText.length];
    } else if (self.isWrapAround) {
        // Wrap around and try again from the end
        long textLength = [self.textView sendmessage:SCI_GETLENGTH sub:0 wparam:0];
        [self.textView sendmessage:SCI_SETSELECTIONSTART sub:textLength wparam:0];
        [self.textView sendmessage:SCI_SETSELECTIONEND sub:textLength wparam:0];
        [self.textView sendmessage:SCI_SEARCHANCHOR sub:0 wparam:0];
        pos = [self.textView sendmessage:SCI_SEARCHPREV sub:flags wparam:(sptr_t)[searchText UTF8String]];
        
        if (pos != -1) {
            // Found after wrapping
            [self.textView sendmessage:SCI_SETSEL sub:pos wparam:pos + searchText.length];
        } else {
            // Not found anywhere
            NSBeep();
        }
    } else {
        // Not found and not wrapping
        NSBeep();
    }
}

- (IBAction)findNextClicked:(id)sender {
    [self findNext];
}

- (IBAction)replaceClicked:(id)sender {
    NSString *searchText = self.searchText;
    NSString *replaceText = self.replaceText;
    
    if (searchText.length == 0) return;
    
    // Add to search and replace history
    [[HistoryManager sharedManager] addSearchTerm:searchText];
    [[HistoryManager sharedManager] addReplaceTerm:replaceText];
    
    // Update combo box items
    [self.findComboBox removeAllItems];
    [self.findComboBox addItemsWithObjectValues:[[HistoryManager sharedManager] searchHistory]];
    [self.findComboBox setStringValue:searchText];
    
    [self.replaceComboBox removeAllItems];
    [self.replaceComboBox addItemsWithObjectValues:[[HistoryManager sharedManager] replaceHistory]];
    [self.replaceComboBox setStringValue:replaceText];
    
    // Check if current selection matches search text
    long selStart = [self.textView sendmessage:SCI_GETSELECTIONSTART sub:0 wparam:0];
    long selEnd = [self.textView sendmessage:SCI_GETSELECTIONEND sub:0 wparam:0];
    
    if (selEnd - selStart == searchText.length) {
        // Replace current selection
        [self.textView sendmessage:SCI_REPLACESEL sub:0 wparam:(sptr_t)[replaceText UTF8String]];
    }
    
    // Find next occurrence
    [self findNext];
}

- (IBAction)replaceAllClicked:(id)sender {
    NSString *searchText = self.searchText;
    NSString *replaceText = self.replaceText;
    
    if (searchText.length == 0) return;
    
    // Add to search and replace history
    [[HistoryManager sharedManager] addSearchTerm:searchText];
    [[HistoryManager sharedManager] addReplaceTerm:replaceText];
    
    // Update combo box items
    [self.findComboBox removeAllItems];
    [self.findComboBox addItemsWithObjectValues:[[HistoryManager sharedManager] searchHistory]];
    [self.findComboBox setStringValue:searchText];
    
    [self.replaceComboBox removeAllItems];
    [self.replaceComboBox addItemsWithObjectValues:[[HistoryManager sharedManager] replaceHistory]];
    [self.replaceComboBox setStringValue:replaceText];
    
    // Set search flags
    int flags = 0;
    if (self.isMatchCase) {
        flags |= SCFIND_MATCHCASE;
    }
    if (self.isMatchWholeWord) {
        flags |= SCFIND_WHOLEWORD;
    }
    if (self.isRegularExpression) {
        flags |= SCFIND_REGEXP;
    }
    
    // Begin undo action for replace all
    [self.textView sendmessage:SCI_BEGINUNDOACTION sub:0 wparam:0];
    
    // Start from beginning
    [self.textView sendmessage:SCI_SETSELECTIONSTART sub:0 wparam:0];
    [self.textView sendmessage:SCI_SETSELECTIONEND sub:0 wparam:0];
    
    int count = 0;
    long pos;
    do {
        [self.textView sendmessage:SCI_SEARCHANCHOR sub:0 wparam:0];
        pos = [self.textView sendmessage:SCI_SEARCHNEXT sub:flags wparam:(sptr_t)[searchText UTF8String]];
        
        if (pos != -1) {
            // Select and replace
            [self.textView sendmessage:SCI_SETSEL sub:pos wparam:pos + searchText.length];
            [self.textView sendmessage:SCI_REPLACESEL sub:0 wparam:(sptr_t)[replaceText UTF8String]];
            count++;
        }
    } while (pos != -1);
    
    // End undo action
    [self.textView sendmessage:SCI_ENDUNDOACTION sub:0 wparam:0];
    
    // Show result
    NSAlert *alert = [NSAlert alertWithMessageText:@"Replace All Completed"
                                     defaultButton:@"OK"
                                   alternateButton:nil
                                       otherButton:nil
                         informativeTextWithFormat:@"Replaced %d occurrence(s)", count];
    [alert runModal];
}

- (IBAction)helpButtonClicked:(id)sender {
    if (!self.regexReferencePanel) {
        self.regexReferencePanel = [[RegexReferencePanel alloc] init];
    }
    [self.regexReferencePanel showPanel];
}

#pragma mark - NSWindowDelegate

- (void)windowWillClose:(NSNotification *)notification {
    // Clean up if needed
}

@end