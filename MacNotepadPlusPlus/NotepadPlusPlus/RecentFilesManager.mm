//
//  RecentFilesManager.m
//  NotepadPlusPlus
//
//  Created by Assistant on 12/12/2025.
//

#import "RecentFilesManager.h"

static RecentFilesManager *sharedInstance = nil;
static NSString *const RecentFilesKey = @"RecentFiles";
static NSInteger const MaxRecentFiles = 10;

@implementation RecentFilesManager

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[RecentFilesManager alloc] init];
        [sharedInstance loadRecentFiles];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _recentFiles = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)addRecentFile:(NSString *)filePath {
    // Remove if already exists
    [self.recentFiles removeObject:filePath];
    
    // Add to beginning
    [self.recentFiles insertObject:filePath atIndex:0];
    
    // Limit to max recent files
    if (self.recentFiles.count > MaxRecentFiles) {
        [self.recentFiles removeLastObject];
    }
    
    // Save
    [self saveRecentFiles];
}

- (void)removeRecentFile:(NSString *)filePath {
    [self.recentFiles removeObject:filePath];
    [self saveRecentFiles];
}

- (void)clearRecentFiles {
    [self.recentFiles removeAllObjects];
    [self saveRecentFiles];
}

- (NSArray *)recentFilesLimitedTo:(NSInteger)limit {
    if (limit <= 0 || limit >= self.recentFiles.count) {
        return [self.recentFiles copy];
    }
    
    return [[self.recentFiles subarrayWithRange:NSMakeRange(0, limit)] copy];
}

- (void)saveRecentFiles {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.recentFiles forKey:RecentFilesKey];
    [defaults synchronize];
}

- (void)loadRecentFiles {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *files = [defaults objectForKey:RecentFilesKey];
    
    if (files) {
        self.recentFiles = [[NSMutableArray alloc] initWithArray:files];
    } else {
        self.recentFiles = [[NSMutableArray alloc] init];
    }
    
    // Validate files still exist
    NSMutableArray *validFiles = [[NSMutableArray alloc] init];
    for (NSString *filePath in self.recentFiles) {
        if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
            [validFiles addObject:filePath];
        }
    }
    
    self.recentFiles = validFiles;
}

@end