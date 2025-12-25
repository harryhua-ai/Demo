//
//  DocumentHistoryManager.h
//  NotepadPlusPlus
//
//  Created by Assistant on 12/12/2025.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DocumentHistoryManager : NSObject

+ (DocumentHistoryManager *)sharedManager;

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