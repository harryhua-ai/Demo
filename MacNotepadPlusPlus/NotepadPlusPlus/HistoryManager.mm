//
//  HistoryManager.m
//  NotepadPlusPlus
//
//  Created by Assistant on 12/12/2025.
//

#import "HistoryManager.h"

static NSString * const kSearchHistoryKey = @"SearchHistory";
static NSString * const kReplaceHistoryKey = @"ReplaceHistory";
static NSString * const kDocumentHistoryKey = @"DocumentHistory";
static NSString * const kRecentlyClosedDocumentsKey = @"RecentlyClosedDocuments";
static const NSUInteger kMaxHistoryItems = 20;

@implementation HistoryManager

+ (HistoryManager *)sharedManager {
    static HistoryManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[HistoryManager alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    return self;
}

#pragma mark - Search History

- (void)addSearchTerm:(NSString *)searchTerm {
    if (!searchTerm || [searchTerm isEqualToString:@""]) return;
    
    NSMutableArray *history = [self.searchHistory mutableCopy];
    
    // Remove if already exists
    [history removeObject:searchTerm];
    
    // Insert at beginning
    [history insertObject:searchTerm atIndex:0];
    
    // Limit to max items
    if (history.count > kMaxHistoryItems) {
        [history removeLastObject];
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:history forKey:kSearchHistoryKey];
    [defaults synchronize];
}

- (NSArray<NSString *> *)searchHistory {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults arrayForKey:kSearchHistoryKey] ?: @[];
}

- (void)clearSearchHistory {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:kSearchHistoryKey];
    [defaults synchronize];
}

#pragma mark - Replace History

- (void)addReplaceTerm:(NSString *)replaceTerm {
    if (!replaceTerm || [replaceTerm isEqualToString:@""]) return;
    
    NSMutableArray *history = [self.replaceHistory mutableCopy];
    
    // Remove if already exists
    [history removeObject:replaceTerm];
    
    // Insert at beginning
    [history insertObject:replaceTerm atIndex:0];
    
    // Limit to max items
    if (history.count > kMaxHistoryItems) {
        [history removeLastObject];
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:history forKey:kReplaceHistoryKey];
    [defaults synchronize];
}

- (NSArray<NSString *> *)replaceHistory {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults arrayForKey:kReplaceHistoryKey] ?: @[];
}

- (void)clearReplaceHistory {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:kReplaceHistoryKey];
    [defaults synchronize];
}

#pragma mark - Document History

- (void)addDocumentToHistory:(NSString *)documentPath {
    if (!documentPath) return;
    
    NSMutableArray *history = [self.documentHistory mutableCopy];
    
    // Remove if already exists
    [history removeObject:documentPath];
    
    // Insert at beginning
    [history insertObject:documentPath atIndex:0];
    
    // Limit to max items
    if (history.count > kMaxHistoryItems) {
        [history removeLastObject];
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:history forKey:kDocumentHistoryKey];
    [defaults synchronize];
}

- (NSArray<NSString *> *)documentHistory {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults arrayForKey:kDocumentHistoryKey] ?: @[];
}

- (void)removeDocumentFromHistory:(NSString *)documentPath {
    if (!documentPath) return;
    
    NSMutableArray *history = [self.documentHistory mutableCopy];
    [history removeObject:documentPath];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:history forKey:kDocumentHistoryKey];
    [defaults synchronize];
}

- (void)clearDocumentHistory {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:kDocumentHistoryKey];
    [defaults synchronize];
}

#pragma mark - Recently Closed Documents

- (void)addRecentlyClosedDocument:(NSString *)documentPath {
    if (!documentPath) return;
    
    NSMutableArray *recentlyClosed = [self.recentlyClosedDocuments mutableCopy];
    
    // Remove if already exists
    [recentlyClosed removeObject:documentPath];
    
    // Insert at beginning
    [recentlyClosed insertObject:documentPath atIndex:0];
    
    // Limit to max items
    if (recentlyClosed.count > 5) {  // Keep only last 5 recently closed
        [recentlyClosed removeLastObject];
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:recentlyClosed forKey:kRecentlyClosedDocumentsKey];
    [defaults synchronize];
}

- (NSArray<NSString *> *)recentlyClosedDocuments {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults arrayForKey:kRecentlyClosedDocumentsKey] ?: @[];
}

- (void)clearRecentlyClosedDocuments {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:kRecentlyClosedDocumentsKey];
    [defaults synchronize];
}

@end