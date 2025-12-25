//
//  SearchHistoryManager.h
//  NotepadPlusPlus
//
//  Created by Assistant on 12/12/2025.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SearchHistoryManager : NSObject

+ (SearchHistoryManager *)sharedManager;

// Search history management
- (void)addSearchTerm:(NSString *)searchTerm;
- (NSArray<NSString *> *)searchHistory;
- (void)clearSearchHistory;

// Replace history management
- (void)addReplaceTerm:(NSString *)replaceTerm;
- (NSArray<NSString *> *)replaceHistory;
- (void)clearReplaceHistory;

@end

NS_ASSUME_NONNULL_END