//
//  AppDelegate.h
//  NotepadPlusPlus
//
//  Created by Assistant on 12/12/2025.
//

#import <Cocoa/Cocoa.h>
#import "PreferencesPanel.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (nonatomic, strong) PreferencesPanel *preferencesPanel;

@end