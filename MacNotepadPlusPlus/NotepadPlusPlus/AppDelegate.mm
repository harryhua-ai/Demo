//
//  AppDelegate.m
//  NotepadPlusPlus
//
//  Created by Assistant on 12/12/2025.
//

#import "AppDelegate.h"
#import "NotepadDocument.h"
#import "PreferencesManager.h"
#import "PreferencesPanel.h"
#import "RecentFilesManager.h"
#import "TouchBarManager.h"
#import "PluginManager.h"
#import "SessionManager.h"
#import "DocumentSettingsManager.h"
#import "HistoryManager.h"
#import "FileDialogManager.h"
#import "LocalizationManager.h"
#import "AboutPanelManager.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Initialize managers
    [PreferencesManager sharedManager];
    [RecentFilesManager sharedManager];
    [PluginManager sharedManager];
    [SessionManager sharedManager];
    [DocumentSettingsManager sharedManager];
    [HistoryManager sharedManager];
    [FileDialogManager sharedManager];
    [LocalizationManager sharedManager];
    [AboutPanelManager sharedManager];
    
    // Create the first document
    NSDocumentController *docController = [NSDocumentController sharedDocumentController];
    [docController newDocument:self];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (void)application:(NSApplication *)application openFiles:(NSArray<NSString *> *)filenames {
    for (NSString *filename in filenames) {
        [[RecentFilesManager sharedManager] addRecentFile:filename];
        NSURL *fileURL = [NSURL fileURLWithPath:filename];
        NSDocumentController *docController = [NSDocumentController sharedDocumentController];
        [docController openDocumentWithContentsOfURL:fileURL display:YES completionHandler:^(NSDocument * _Nullable document, BOOL documentWasAlreadyOpen, NSError * _Nullable error) {
            if (error) {
                NSLog(@"Error opening file: %@", error.localizedDescription);
            }
        }];
    }
}

@end
