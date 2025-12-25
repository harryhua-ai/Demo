//
//  EnhancedAutoCompletionManager.h
//  NotepadPlusPlus
//
//  Created by Assistant on 12/12/2025.
//

#import <Cocoa/Cocoa.h>
#import "ScintillaView.h"

NS_ASSUME_NONNULL_BEGIN

@interface EnhancedAutoCompletionManager : NSObject

@property (nonatomic, weak) ScintillaView *textView;
@property (nonatomic, strong) NSDictionary *languageKeywords;
@property (nonatomic, strong) NSArray *customWords;

- (instancetype)initWithTextView:(ScintillaView *)textView;

- (void)setupAutoCompletionForLanguage:(NSString *)language;
- (void)showAutoCompletion;
- (void)hideAutoCompletion;
- (void)addCustomWord:(NSString *)word;
- (void)removeCustomWord:(NSString *)word;
- (NSArray *)getSuggestionsForPrefix:(NSString *)prefix;

@end

NS_ASSUME_NONNULL_END