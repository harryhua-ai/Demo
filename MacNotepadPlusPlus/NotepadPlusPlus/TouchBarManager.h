//
//  TouchBarManager.h
//  NotepadPlusPlus
//
//  Created by Assistant on 12/12/2025.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface TouchBarManager : NSObject <NSTouchBarProvider>

@property (nonatomic, strong) NSTouchBar *touchBar;
@property (nonatomic, weak) id<NSTouchBarDelegate> touchBarDelegate;

+ (instancetype)sharedManager;
- (NSTouchBar *)makeTouchBar;

@end

NS_ASSUME_NONNULL_END