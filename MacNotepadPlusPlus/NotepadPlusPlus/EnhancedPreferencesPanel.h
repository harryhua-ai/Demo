//
//  EnhancedPreferencesPanel.h
//  NotepadPlusPlus
//
//  Created by Assistant on 12/12/2025.
//

#import <Cocoa/Cocoa.h>
#import "PreferencesManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface EnhancedPreferencesPanel : NSWindowController

- (instancetype)initWithPreferences:(PreferencesManager *)preferences;

- (void)showPanel;
- (void)closePanel;

@end

NS_ASSUME_NONNULL_END