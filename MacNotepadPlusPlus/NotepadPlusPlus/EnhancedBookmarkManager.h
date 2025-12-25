//
//  EnhancedBookmarkManager.h
//  NotepadPlusPlus
//
//  Created by Assistant on 12/12/2025.
//

#import <Cocoa/Cocoa.h>
#import "ScintillaView.h"

NS_ASSUME_NONNULL_BEGIN

@interface EnhancedBookmarkManager : NSObject

@property (nonatomic, weak) ScintillaView *textView;

- (instancetype)initWithTextView:(ScintillaView *)textView;

- (void)toggleBookmarkAtLine:(NSInteger)lineNumber;
- (void)removeBookmarkAtLine:(NSInteger)lineNumber;
- (void)clearAllBookmarks;
- (NSArray<NSNumber *> *)getAllBookmarks;
- (void)navigateToNextBookmark;
- (void)navigateToPreviousBookmark;
- (void)navigateToBookmarkAtLine:(NSInteger)lineNumber;

@end

NS_ASSUME_NONNULL_END