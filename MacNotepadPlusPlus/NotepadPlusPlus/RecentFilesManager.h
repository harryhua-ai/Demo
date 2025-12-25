//
//  RecentFilesManager.h
//  NotepadPlusPlus
//
//  Created by Assistant on 12/12/2025.
//

#import <Foundation/Foundation.h>

@interface RecentFilesManager : NSObject

@property (nonatomic, strong) NSMutableArray *recentFiles;

+ (instancetype)sharedManager;
- (void)addRecentFile:(NSString *)filePath;
- (void)removeRecentFile:(NSString *)filePath;
- (void)clearRecentFiles;
- (NSArray *)recentFilesLimitedTo:(NSInteger)limit;
- (void)saveRecentFiles;
- (void)loadRecentFiles;

@end