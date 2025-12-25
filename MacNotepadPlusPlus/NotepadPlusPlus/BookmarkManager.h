//
//  BookmarkManager.h
//  NotepadPlusPlus
//
//  Created by Assistant on 12/12/2025.
//

#import <Cocoa/Cocoa.h>
#import "EnhancedBookmarkManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface BookmarkManager : NSObject

@property (nonatomic, strong) EnhancedBookmarkManager *enhancedBookmarkManager;

+ (BookmarkManager *)sharedManager;

- (instancetype)init;

- (void)setTextView:(ScintillaView *)textView;
- (void)toggleBookmarkAtLine:(NSInteger)lineNumber;
- (void)removeBookmarkAtLine:(NSInteger)lineNumber;
- (void)clearAllBookmarks;
- (NSArray<NSNumber *> *)getAllBookmarks;
- (void)navigateToNextBookmark;
- (void)navigateToPreviousBookmark;
- (void)navigateToBookmarkAtLine:(NSInteger)lineNumber;

@end

NS_ASSUME_NONNULL_END