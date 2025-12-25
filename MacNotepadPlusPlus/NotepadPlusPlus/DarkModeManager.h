//
//  DarkModeManager.h
//  NotepadPlusPlus
//
//  Created by Assistant on 12/12/2025.
//

#import <Cocoa/Cocoa.h>
#import "ScintillaView.h"

@interface DarkModeManager : NSObject

+ (void)applyDarkModeToTextView:(ScintillaView *)textView;
+ (void)applyLightModeToTextView:(ScintillaView *)textView;
+ (BOOL)isDarkMode;

@end