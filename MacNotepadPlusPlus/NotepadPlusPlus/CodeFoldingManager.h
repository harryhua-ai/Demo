//
//  CodeFoldingManager.h
//  NotepadPlusPlus
//
//  Created by Assistant on 12/12/2025.
//

#import <Cocoa/Cocoa.h>
#import "EnhancedCodeFoldingManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface CodeFoldingManager : NSObject

@property (nonatomic, strong) EnhancedCodeFoldingManager *enhancedCodeFoldingManager;

+ (CodeFoldingManager *)sharedManager;

- (instancetype)init;

- (void)setTextView:(ScintillaView *)textView;
- (void)setupCodeFoldingForLanguage:(NSString *)language;
- (void)collapseAllFolds;
- (void)expandAllFolds;
- (void)toggleCurrentFold;

@end

NS_ASSUME_NONNULL_END