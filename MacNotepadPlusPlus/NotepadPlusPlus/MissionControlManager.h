//
//  MissionControlManager.h
//  NotepadPlusPlus
//
//  Created by Assistant on 12/12/2025.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface MissionControlManager : NSObject

+ (MissionControlManager *)sharedManager;

- (void)moveWindowToSpace:(NSUInteger)spaceIndex;
- (void)assignWindowToAllSpaces;
- (NSArray<NSNumber *> *)getWindowSpaces;
- (void)toggleDesktopSpace;
- (void)showMissionControl;
- (void)moveWindowToNextSpace;
- (void)moveWindowToPreviousSpace;

@end

NS_ASSUME_NONNULL_END