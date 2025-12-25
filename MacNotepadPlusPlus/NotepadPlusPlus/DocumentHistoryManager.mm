//
//  DocumentHistoryManager.m
//  NotepadPlusPlus
//
//  Created by Assistant on 12/12/2025.
//

#import "DocumentHistoryManager.h"

static NSString * const kDocumentHistoryKey = @"DocumentHistory";
static NSString * const kRecentlyClosedDocumentsKey = @"RecentlyClosedDocuments";
static const NSUInteger kMaxHistoryItems = 20;

@implementation DocumentHistoryManager

+ (DocumentHistoryManager *)sharedManager {
    static DocumentHistoryManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[DocumentHistoryManager alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    return self;
}

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