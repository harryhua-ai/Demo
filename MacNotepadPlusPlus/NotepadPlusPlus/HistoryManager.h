//
//  HistoryManager.h
//  NotepadPlusPlus
//
//  Created by Assistant on 12/12/2025.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HistoryManager : NSObject

+ (HistoryManager *)sharedManager;

// Search history management
- (void)addSearchTerm:(NSString *)searchTerm;
- (NSArray<NSString *> *)searchHistory;
- (void)clearSearchHistory;

// Replace history management
- (void)addReplaceTerm:(NSString *)replaceTerm;
- (NSArray<NSString *> *)replaceHistory;
- (void)clearReplaceHistory;

// Document history management
- (void)addDocumentToHistory:(NSString *)documentPath;
- (NSArray<NSString *> *)documentHistory;
- (void)removeDocumentFromHistory:(NSString *)documentPath;
- (void)clearDocumentHistory;

// Recently closed documents
- (void)addRecentlyClosedDocument:(NSString *)documentPath;
- (NSArray<NSString *> *)recentlyClosedDocuments;
- (void)clearRecentlyClosedDocuments;

@end

NS_ASSUME_NONNULL_END