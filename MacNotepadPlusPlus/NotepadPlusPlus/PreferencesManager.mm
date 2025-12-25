//
//  PreferencesManager.m
//  NotepadPlusPlus
//
//  Created by Assistant on 12/12/2025.
//

#import "PreferencesManager.h"

static PreferencesManager *sharedInstance = nil;

@implementation PreferencesManager

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[PreferencesManager alloc] init];
        [sharedInstance loadPreferences];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        // Set default values
        _tabWidth = 4;
        _useSpacesInsteadOfTabs = YES;
        _showLineNumbers = YES;
        _showWhiteSpace = NO;
        _fontSize = 12;
        _fontFamily = @"Menlo";
        _wrapLines = NO;
        _showMenuBar = YES;
        _showToolBar = YES;
        _showStatusBar = YES;
        _autoSave = NO;
        _autoSaveInterval = 5; // minutes
        _restoreLastSession = YES;
    }
    return self;
}

- (void)savePreferences {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    // Editor preferences
    [defaults setInteger:self.tabWidth forKey:@"TabWidth"];
    [defaults setBool:self.useSpacesInsteadOfTabs forKey:@"UseSpacesInsteadOfTabs"];
    [defaults setBool:self.showLineNumbers forKey:@"ShowLineNumbers"];
    [defaults setBool:self.showWhiteSpace forKey:@"ShowWhiteSpace"];
    [defaults setInteger:self.fontSize forKey:@"FontSize"];
    [defaults setObject:self.fontFamily forKey:@"FontFamily"];
    
    // View preferences
    [defaults setBool:self.wrapLines forKey:@"WrapLines"];
    [defaults setBool:self.showMenuBar forKey:@"ShowMenuBar"];
    [defaults setBool:self.showToolBar forKey:@"ShowToolBar"];
    [defaults setBool:self.showStatusBar forKey:@"ShowStatusBar"];
    
    // Behavior preferences
    [defaults setBool:self.autoSave forKey:@"AutoSave"];
    [defaults setInteger:self.autoSaveInterval forKey:@"AutoSaveInterval"];
    [defaults setBool:self.restoreLastSession forKey:@"RestoreLastSession"];
    
    [defaults synchronize];
}

- (void)loadPreferences {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    // Editor preferences
    if ([defaults objectForKey:@"TabWidth"]) {
        self.tabWidth = [defaults integerForKey:@"TabWidth"];
    }
    
    if ([defaults objectForKey:@"UseSpacesInsteadOfTabs"]) {
        self.useSpacesInsteadOfTabs = [defaults boolForKey:@"UseSpacesInsteadOfTabs"];
    }
    
    if ([defaults objectForKey:@"ShowLineNumbers"]) {
        self.showLineNumbers = [defaults boolForKey:@"ShowLineNumbers"];
    }
    
    if ([defaults objectForKey:@"ShowWhiteSpace"]) {
        self.showWhiteSpace = [defaults boolForKey:@"ShowWhiteSpace"];
    }
    
    if ([defaults objectForKey:@"FontSize"]) {
        self.fontSize = [defaults integerForKey:@"FontSize"];
    }
    
    if ([defaults objectForKey:@"FontFamily"]) {
        self.fontFamily = [defaults stringForKey:@"FontFamily"];
    }
    
    // View preferences
    if ([defaults objectForKey:@"WrapLines"]) {
        self.wrapLines = [defaults boolForKey:@"WrapLines"];
    }
    
    if ([defaults objectForKey:@"ShowMenuBar"]) {
        self.showMenuBar = [defaults boolForKey:@"ShowMenuBar"];
    }
    
    if ([defaults objectForKey:@"ShowToolBar"]) {
        self.showToolBar = [defaults boolForKey:@"ShowToolBar"];
    }
    
    if ([defaults objectForKey:@"ShowStatusBar"]) {
        self.showStatusBar = [defaults boolForKey:@"ShowStatusBar"];
    }
    
    // Behavior preferences
    if ([defaults objectForKey:@"AutoSave"]) {
        self.autoSave = [defaults boolForKey:@"AutoSave"];
    }
    
    if ([defaults objectForKey:@"AutoSaveInterval"]) {
        self.autoSaveInterval = [defaults integerForKey:@"AutoSaveInterval"];
    }
    
    if ([defaults objectForKey:@"RestoreLastSession"]) {
        self.restoreLastSession = [defaults boolForKey:@"RestoreLastSession"];
    }
}

@end