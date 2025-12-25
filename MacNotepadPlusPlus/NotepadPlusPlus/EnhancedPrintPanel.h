//
//  EnhancedPrintPanel.h
//  NotepadPlusPlus
//
//  Created by Assistant on 12/12/2025.
//

#import <Cocoa/Cocoa.h>
#import "ScintillaView.h"

NS_ASSUME_NONNULL_BEGIN

@interface EnhancedPrintPanel : NSWindowController

@property (nonatomic, strong) ScintillaView *textView;

- (instancetype)initWithTextView:(ScintillaView *)textView;

- (void)showPrintPanel;
- (void)closePanel;

@end

NS_ASSUME_NONNULL_END