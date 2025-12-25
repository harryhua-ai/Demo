//
//  PreferencesPanel.h
//  NotepadPlusPlus
//
//  Created by Assistant on 12/12/2025.
//

#import <Cocoa/Cocoa.h>
#import "PreferencesManager.h"

@interface PreferencesPanel : NSPanel

@property (nonatomic, strong) PreferencesManager *preferences;

- (instancetype)initWithPreferences:(PreferencesManager *)preferences;
- (void)showPanel:(id)sender;

@end