//
//  EnhancedSessionManager.h
//  NotepadPlusPlus
//
//  Created by Assistant on 12/12/2025.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface EnhancedSessionManager : NSObject

+ (EnhancedSessionManager *)sharedManager;

- (void)saveSessionWithName:(NSString *)sessionName;
- (void)restoreSessionWithName:(NSString *)sessionName;
- (void)deleteSessionWithName:(NSString *)sessionName;
- (NSArray<NSString *> *)availableSessions;
- (void)renameSessionFrom:(NSString *)oldName to:(NSString *)newName;

@end

NS_ASSUME_NONNULL_END