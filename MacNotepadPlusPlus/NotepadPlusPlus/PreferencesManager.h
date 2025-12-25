//
//  PreferencesManager.h
//  NotepadPlusPlus
//
//  Created by Assistant on 12/12/2025.
//

#import <Foundation/Foundation.h>

@interface PreferencesManager : NSObject

+ (instancetype)sharedManager;

// Editor preferences
@property (nonatomic, assign) NSInteger tabWidth;
@property (nonatomic, assign) BOOL useSpacesInsteadOfTabs;
@property (nonatomic, assign) BOOL showLineNumbers;
@property (nonatomic, assign) BOOL showWhiteSpace;
@property (nonatomic, assign) NSInteger fontSize;
@property (nonatomic, strong) NSString *fontFamily;

// View preferences
@property (nonatomic, assign) BOOL wrapLines;
@property (nonatomic, assign) BOOL showMenuBar;
@property (nonatomic, assign) BOOL showToolBar;
@property (nonatomic, assign) BOOL showStatusBar;

// Behavior preferences
@property (nonatomic, assign) BOOL autoSave;
@property (nonatomic, assign) NSInteger autoSaveInterval;
@property (nonatomic, assign) BOOL restoreLastSession;

// Methods
- (void)savePreferences;
- (void)loadPreferences;

@end