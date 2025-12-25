//
//  MissionControlManager.m
//  NotepadPlusPlus
//
//  Created by Assistant on 12/12/2025.
//

#import "MissionControlManager.h"
#import <Carbon/Carbon.h>

@implementation MissionControlManager

+ (MissionControlManager *)sharedManager {
    static MissionControlManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[MissionControlManager alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    return self;
}

- (void)moveWindowToSpace:(NSUInteger)spaceIndex {
    // Note: Direct programmatic control of Mission Control spaces is not officially supported by Apple
    // This is a simplified implementation showing the concept
    // In practice, users would use macOS built-in shortcuts (Ctrl+Arrow keys) to navigate spaces
    
    // We can at least bring attention to the space switching capability
    NSAlert *alert = [NSAlert alertWithMessageText:@"Move Window to Space"
                                     defaultButton:@"OK"
                                   alternateButton:nil
                                       otherButton:nil
                         informativeTextWithFormat:@"To move windows between spaces:\n\n1. Use Mission Control (F3 or swipe up with 4 fingers)\n2. Drag windows between spaces\n\nTo navigate between spaces:\n- Ctrl+Right Arrow: Next space\n- Ctrl+Left Arrow: Previous space\n\nAlternatively, you can assign this window to all desktops to access it from any space."];
    [alert runModal];
}

- (void)assignWindowToAllSpaces {
    // Note: Assigning a window to all spaces is not directly programmable
    // This is typically done through the macOS Dock context menu
    
    NSAlert *alert = [NSAlert alertWithMessageText:@"Assign to All Desktops"
                                     defaultButton:@"OK"
                                   alternateButton:nil
                                       otherButton:nil
                         informativeTextWithFormat:@"To assign this window to all desktops:\n\n1. Right-click the Notepad++ icon in the Dock\n2. Select \"Options\" > \"Assign To\" > \"All Desktops\"\n\nThis will make the window available on all virtual desktops."];
    [alert runModal];
}

- (NSArray<NSNumber *> *)getWindowSpaces {
    // Note: Getting window space information is limited due to macOS security restrictions
    // This would require accessibility permissions and is complex to implement
    
    // Return a placeholder array
    return @[@1, @2, @3]; // Example spaces
}

- (void)toggleDesktopSpace {
    // This would simulate the "Show Desktop" functionality (F11 or swipe down with 4 fingers)
    // However, direct programmatic control is not recommended
    
    NSAlert *alert = [NSAlert alertWithMessageText:@"Show Desktop"
                                     defaultButton:@"OK"
                                   alternateButton:nil
                                       otherButton:nil
                         informativeTextWithFormat:@"To show the desktop:\n\n- Press F11\n- Or swipe down with 4 fingers on the trackpad\n\nThis will minimize all windows and show the desktop."];
    [alert runModal];
}

- (void)showMissionControl {
    // Show information about accessing Mission Control
    NSAlert *alert = [NSAlert alertWithMessageText:@"Mission Control"
                                     defaultButton:@"OK"
                                   alternateButton:nil
                                       otherButton:nil
                         informativeTextWithFormat:@"To access Mission Control:\n\n- Press F3\n- Or swipe up with 4 fingers on the trackpad\n\nIn Mission Control, you can:\n- See all open windows\n- Create new desktops\n- Move windows between desktops\n- Close desktops"];
    [alert runModal];
}

- (void)moveWindowToNextSpace {
    // Provide guidance for moving window to next space
    NSAlert *alert = [NSAlert alertWithMessageText:@"Move Window to Next Space"
                                     defaultButton:@"OK"
                                   alternateButton:nil
                                       otherButton:nil
                         informativeTextWithFormat:@"To move the current window to the next space:\n\n1. First, make sure this window is focused\n2. Press Ctrl+Shift+Right Arrow\n\nThis keyboard shortcut moves the active window to the space on the right."];
    [alert runModal];
}

- (void)moveWindowToPreviousSpace {
    // Provide guidance for moving window to previous space
    NSAlert *alert = [NSAlert alertWithMessageText:@"Move Window to Previous Space"
                                     defaultButton:@"OK"
                                   alternateButton:nil
                                       otherButton:nil
                         informativeTextWithFormat:@"To move the current window to the previous space:\n\n1. First, make sure this window is focused\n2. Press Ctrl+Shift+Left Arrow\n\nThis keyboard shortcut moves the active window to the space on the left."];
    [alert runModal];
}

@end