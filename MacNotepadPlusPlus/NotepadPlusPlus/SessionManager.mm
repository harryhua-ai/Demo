//
//  SessionManager.m
//  NotepadPlusPlus
//
//  Created by Assistant on 12/12/2025.
//

#import "SessionManager.h"

@implementation SessionManager

+ (SessionManager *)sharedManager {
    static SessionManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[SessionManager alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _enhancedSessionManager = [EnhancedSessionManager sharedManager];
    }
    return self;
}

- (void)saveSession:(NSString *)sessionName {
    [self.enhancedSessionManager saveSessionWithName:sessionName];
}

- (void)restoreSession:(NSString *)sessionName {
    [self.enhancedSessionManager restoreSessionWithName:sessionName];
}

- (void)deleteSession:(NSString *)sessionName {
    [self.enhancedSessionManager deleteSessionWithName:sessionName];
}

- (NSArray<NSString *> *)availableSessions {
    return [self.enhancedSessionManager availableSessions];
}

- (void)renameSession:(NSString *)oldName to:(NSString *)newName {
    [self.enhancedSessionManager renameSessionFrom:oldName to:newName];
}

@end