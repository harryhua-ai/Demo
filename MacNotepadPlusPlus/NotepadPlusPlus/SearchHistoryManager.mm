//
//  SearchHistoryManager.m
//  NotepadPlusPlus
//
//  Created by Assistant on 12/12/2025.
//

#import "SearchHistoryManager.h"

static NSString * const kSearchHistoryKey = @"SearchHistory";
static NSString * const kReplaceHistoryKey = @"ReplaceHistory";
static const NSUInteger kMaxHistoryItems = 20;

@implementation SearchHistoryManager

+ (SearchHistoryManager *)sharedManager {
    static SearchHistoryManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[SearchHistoryManager alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    return self;
}

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

@end