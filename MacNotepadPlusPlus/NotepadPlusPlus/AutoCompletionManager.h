//
//  AutoCompletionManager.h
//  NotepadPlusPlus
//
//  Created by Assistant on 12/12/2025.
//

#import <Cocoa/Cocoa.h>
#import "EnhancedAutoCompletionManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface AutoCompletionManager : NSObject

@property (nonatomic, strong) EnhancedAutoCompletionManager *enhancedAutoCompletionManager;

+ (AutoCompletionManager *)sharedManager;

- (instancetype)init;

- (void)setTextView:(ScintillaView *)textView;
- (void)setupAutoCompletionForLanguage:(NSString *)language;
- (void)showAutoCompletion;
- (void)hideAutoCompletion;
- (void)addCustomWord:(NSString *)word;
- (void)removeCustomWord:(NSString *)word;

@end

NS_ASSUME_NONNULL_END