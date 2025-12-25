//
//  SessionManager.h
//  NotepadPlusPlus
//
//  Created by Assistant on 12/12/2025.
//

#import <Cocoa/Cocoa.h>
#import "EnhancedSessionManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface SessionManager : NSObject

@property (nonatomic, strong) EnhancedSessionManager *enhancedSessionManager;

+ (SessionManager *)sharedManager;

- (instancetype)init;

- (void)saveSession:(NSString *)sessionName;
- (void)restoreSession:(NSString *)sessionName;
- (void)deleteSession:(NSString *)sessionName;
- (NSArray<NSString *> *)availableSessions;
- (void)renameSession:(NSString *)oldName to:(NSString *)newName;

@end

NS_ASSUME_NONNULL_END