//
//  StatusBar.h
//  NotepadPlusPlus
//
//  Created by Assistant on 12/12/2025.
//

#import <Cocoa/Cocoa.h>
#import "ScintillaView.h"

NS_ASSUME_NONNULL_BEGIN

@interface StatusBar : NSView

@property (nonatomic, strong) ScintillaView *textView;

- (instancetype)initWithFrame:(NSRect)frame textView:(ScintillaView *)textView;

- (void)updateStatusBar;
- (void)setLanguage:(NSString *)language;
- (void)setEncoding:(NSString *)encoding;
- (void)setLineEnding:(NSString *)lineEnding;

@end

NS_ASSUME_NONNULL_END