//
//  EnhancedCodeFoldingManager.h
//  NotepadPlusPlus
//
//  Created by Assistant on 12/12/2025.
//

#import <Cocoa/Cocoa.h>
#import "ScintillaView.h"

NS_ASSUME_NONNULL_BEGIN

@interface EnhancedCodeFoldingManager : NSObject

@property (nonatomic, weak) ScintillaView *textView;

- (instancetype)initWithTextView:(ScintillaView *)textView;

- (void)setupCodeFoldingForLanguage:(NSString *)language;
- (void)collapseAllFolds;
- (void)expandAllFolds;
- (void)toggleCurrentFold;
- (void)collapseLevel:(int)level;
- (void)expandLevel:(int)level;

@end

NS_ASSUME_NONNULL_END