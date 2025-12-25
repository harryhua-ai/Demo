//
//  EnhancedFindReplacePanel.h
//  NotepadPlusPlus
//
//  Created by Assistant on 12/12/2025.
//

#import <Cocoa/Cocoa.h>
#import "ScintillaView.h"
#import "RegexReferencePanel.h"

NS_ASSUME_NONNULL_BEGIN

@interface EnhancedFindReplacePanel : NSWindowController

@property (nonatomic, strong) ScintillaView *textView;

- (instancetype)initWithTextView:(ScintillaView *)textView;

- (void)showFindPanel;
- (void)showReplacePanel;
- (void)closePanel;

- (NSString *)searchText;
- (NSString *)replaceText;
- (BOOL)isRegularExpression;
- (BOOL)isMatchCase;
- (BOOL)isMatchWholeWord;
- (BOOL)isWrapAround;

- (void)findNext;
- (void)findPrevious;

@end

NS_ASSUME_NONNULL_END