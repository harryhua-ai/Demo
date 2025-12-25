//
//  AboutPanelManager.h
//  NotepadPlusPlus
//
//  Created by Assistant on 12/12/2025.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface AboutPanelManager : NSObject

+ (AboutPanelManager *)sharedManager;

- (void)showAboutPanel;

@end

NS_ASSUME_NONNULL_END