#import "NotepadDocumentWindowController.h"
#import "NotepadTextView.h"

@implementation NotepadDocumentWindowController

- (void)bookmarkLines:(id)sender {
    if (self.textView) {
        [self.textView bookmarkLines:sender];
    }
}

- (void)removeBookmarkedLines:(id)sender {
    if (self.textView) {
        [self.textView removeBookmarkedLines:sender];
    }
}

@end
//
//  MenuManager.mm
//  NotepadPlusPlus
//
//  Created by Lingma on 12/12/2025.
//

#import "MenuManager.h"
#import "NotepadDocumentWindowController.h"

@implementation MenuManager

+ (MenuManager *)sharedManager {
    static MenuManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[MenuManager alloc] init];
    });
    return sharedInstance;
}

- (NSMenu *)createMainMenu {
    NSMenu *mainMenu = [[NSMenu alloc] initWithTitle:@"MainMenu"];
    
    [mainMenu addItem:[self createFileMenu]];
    [mainMenu addItem:[self createEditMenu]];
    [mainMenu addItem:[self createSearchMenu]];
    [mainMenu addItem:[self createViewMenu]];
    [mainMenu addItem:[self createEncodingMenu]];
    [mainMenu addItem:[self createLanguageMenu]];
    [mainMenu addItem:[self createSettingsMenu]];
    [mainMenu addItem:[self createMacroMenu]];
    [mainMenu addItem:[self createRunMenu]];
    [mainMenu addItem:[self createPluginsMenu]];
    [mainMenu addItem:[self createWindowMenu]];
    [mainMenu addItem:[self createHelpMenu]];
    
    return mainMenu;
}

- (NSMenuItem *)createFileMenu {
    NSMenuItem *fileMenuItem = [[NSMenuItem alloc] initWithTitle:[LocalizationManager.sharedManager localizedStringForKey:@"menu_file"]
                                                         action:NULL
                                                  keyEquivalent:@""];
    
    NSMenu *fileMenu = [[NSMenu alloc] initWithTitle:[LocalizationManager.sharedManager localizedStringForKey:@"menu_file"]];
    
    // New
    NSMenuItem *newMenuItem = [[NSMenuItem alloc] initWithTitle:[LocalizationManager.sharedManager localizedStringForKey:@"menu_new"]
                                                        action:@selector(newDocument:)
                                                 keyEquivalent:@"n"];
    [fileMenu addItem:newMenuItem];
    
    // Open
    NSMenuItem *openMenuItem = [[NSMenuItem alloc] initWithTitle:[LocalizationManager.sharedManager localizedStringForKey:@"menu_open"]
                                                         action:@selector(openDocument:)
                                                  keyEquivalent:@"o"];
    [fileMenu addItem:openMenuItem];
    
    // Save
    NSMenuItem *saveMenuItem = [[NSMenuItem alloc] initWithTitle:[LocalizationManager.sharedManager localizedStringForKey:@"menu_save"]
                                                         action:@selector(saveDocument:)
                                                  keyEquivalent:@"s"];
    [fileMenu addItem:saveMenuItem];
    
    // Save As
    NSMenuItem *saveAsMenuItem = [[NSMenuItem alloc] initWithTitle:[LocalizationManager.sharedManager localizedStringForKey:@"menu_save_as"]
                                                           action:@selector(saveDocumentAs:)
                                                    keyEquivalent:@"S"];
    [saveAsMenuItem setKeyEquivalentModifierMask:(NSEventModifierFlagShift | NSEventModifierFlagCommand)];
    [fileMenu addItem:saveAsMenuItem];
    
    // Print
    NSMenuItem *printMenuItem = [[NSMenuItem alloc] initWithTitle:[LocalizationManager.sharedManager localizedStringForKey:@"menu_print"]
                                                          action:@selector(printDocument:)
                                                   keyEquivalent:@"p"];
    [fileMenu addItem:printMenuItem];
    
    [fileMenuItem setSubmenu:fileMenu];
    return fileMenuItem;
}

- (NSMenuItem *)createEditMenu {
    NSMenuItem *editMenuItem = [[NSMenuItem alloc] initWithTitle:[LocalizationManager.sharedManager localizedStringForKey:@"menu_edit"]
                                                         action:NULL
                                                  keyEquivalent:@""];
    
    NSMenu *editMenu = [[NSMenu alloc] initWithTitle:[LocalizationManager.sharedManager localizedStringForKey:@"menu_edit"]];
    
    // Undo
    NSMenuItem *undoMenuItem = [[NSMenuItem alloc] initWithTitle:[LocalizationManager.sharedManager localizedStringForKey:@"menu_undo"]
                                                         action:@selector(undo:)
                                                  keyEquivalent:@"z"];
    [editMenu addItem:undoMenuItem];
    
    // Redo
    NSMenuItem *redoMenuItem = [[NSMenuItem alloc] initWithTitle:[LocalizationManager.sharedManager localizedStringForKey:@"menu_redo"]
                                                         action:@selector(redo:)
                                                  keyEquivalent:@"Z"];
    [editMenu addItem:redoMenuItem];
    
    [editMenu addItem:[NSMenuItem separatorItem]];
    
    // Cut
    NSMenuItem *cutMenuItem = [[NSMenuItem alloc] initWithTitle:[LocalizationManager.sharedManager localizedStringForKey:@"menu_cut"]
                                                        action:@selector(cut:)
                                                 keyEquivalent:@"x"];
    [editMenu addItem:cutMenuItem];
    
    // Copy
    NSMenuItem *copyMenuItem = [[NSMenuItem alloc] initWithTitle:[LocalizationManager.sharedManager localizedStringForKey:@"menu_copy"]
                                                         action:@selector(copy:)
                                                  keyEquivalent:@"c"];
    [editMenu addItem:copyMenuItem];
    
    // Paste
    NSMenuItem *pasteMenuItem = [[NSMenuItem alloc] initWithTitle:[LocalizationManager.sharedManager localizedStringForKey:@"menu_paste"]
                                                          action:@selector(paste:)
                                                   keyEquivalent:@"v"];
    [editMenu addItem:pasteMenuItem];
    
    // Delete
    NSMenuItem *deleteMenuItem = [[NSMenuItem alloc] initWithTitle:[LocalizationManager.sharedManager localizedStringForKey:@"menu_delete"]
                                                           action:@selector(delete:)
                                                    keyEquivalent:@"\x7F"]; // Delete key
    [editMenu addItem:deleteMenuItem];
    
    // Select All
    NSMenuItem *selectAllMenuItem = [[NSMenuItem alloc] initWithTitle:[LocalizationManager.sharedManager localizedStringForKey:@"menu_select_all"]
                                                              action:@selector(selectAll:)
                                                       keyEquivalent:@"a"];
    [editMenu addItem:selectAllMenuItem];
    
    [editMenuItem setSubmenu:editMenu];
    return editMenuItem;
}

- (NSMenuItem *)createSearchMenu {
    NSMenuItem *searchMenuItem = [[NSMenuItem alloc] initWithTitle:[LocalizationManager.sharedManager localizedStringForKey:@"menu_search"]
                                                           action:NULL
                                                    keyEquivalent:@""];
    
    NSMenu *searchMenu = [[NSMenu alloc] initWithTitle:[LocalizationManager.sharedManager localizedStringForKey:@"menu_search"]];
    
    // Find
    NSMenuItem *findMenuItem = [[NSMenuItem alloc] initWithTitle:[LocalizationManager.sharedManager localizedStringForKey:@"menu_find"]
                                                         action:@selector(showFindPanel:)
                                                  keyEquivalent:@"f"];
    [searchMenu addItem:findMenuItem];
    
    // Replace
    NSMenuItem *replaceMenuItem = [[NSMenuItem alloc] initWithTitle:[LocalizationManager.sharedManager localizedStringForKey:@"menu_replace"]
                                                            action:@selector(showReplacePanel:)
                                                     keyEquivalent:@"h"];
    [searchMenu addItem:replaceMenuItem];
    
    [searchMenu addItem:[NSMenuItem separatorItem]];
    
    // Find Next
    NSMenuItem *findNextMenuItem = [[NSMenuItem alloc] initWithTitle:[LocalizationManager.sharedManager localizedStringForKey:@"menu_find_next"]
                                                             action:@selector(findNext:)
                                                      keyEquivalent:@"g"];
    [searchMenu addItem:findNextMenuItem];
    
    // Find Previous
    NSMenuItem *findPreviousMenuItem = [[NSMenuItem alloc] initWithTitle:[LocalizationManager.sharedManager localizedStringForKey:@"menu_find_previous"]
                                                               action:@selector(findPrevious:)
                                                        keyEquivalent:@"G"];
    [searchMenu addItem:findPreviousMenuItem];
    
    [searchMenuItem setSubmenu:searchMenu];
    return searchMenuItem;
}

- (NSMenuItem *)createViewMenu {
    NSMenuItem *viewMenuItem = [[NSMenuItem alloc] initWithTitle:[LocalizationManager.sharedManager localizedStringForKey:@"menu_view"]
                                                         action:NULL
                                                  keyEquivalent:@""];
    
    NSMenu *viewMenu = [[NSMenu alloc] initWithTitle:[LocalizationManager.sharedManager localizedStringForKey:@"menu_view"]];
    
    // Function List
    NSMenuItem *functionListMenuItem = [[NSMenuItem alloc] initWithTitle:[LocalizationManager.sharedManager localizedStringForKey:@"menu_function_list"]
                                                                action:@selector(showFunctionListPanel:)
                                                         keyEquivalent:@"F"];
    [functionListMenuItem setKeyEquivalentModifierMask:(NSEventModifierFlagShift | NSEventModifierFlagCommand)];
    [viewMenu addItem:functionListMenuItem];
    
    [viewMenu addItem:[NSMenuItem separatorItem]];
    
    // Enter Full Screen
    NSMenuItem *fullScreenMenuItem = [[NSMenuItem alloc] initWithTitle:[LocalizationManager.sharedManager localizedStringForKey:@"menu_enter_full_screen"]
                                                              action:@selector(toggleFullScreen:)
                                                       keyEquivalent:@"f"];
    [fullScreenMenuItem setKeyEquivalentModifierMask:(NSEventModifierFlagControl | NSEventModifierFlagCommand)];
    [viewMenu addItem:fullScreenMenuItem];
    
    [viewMenuItem setSubmenu:viewMenu];
    return viewMenuItem;
}

- (NSMenuItem *)createEncodingMenu {
    NSMenuItem *encodingMenuItem = [[NSMenuItem alloc] initWithTitle:[LocalizationManager.sharedManager localizedStringForKey:@"menu_encoding"]
                                                             action:NULL
                                                      keyEquivalent:@""];
    
    NSMenu *encodingMenu = [[NSMenu alloc] initWithTitle:[LocalizationManager.sharedManager localizedStringForKey:@"menu_encoding"]];
    
    // Add encoding options here
    
    [encodingMenuItem setSubmenu:encodingMenu];
    return encodingMenuItem;
}

- (NSMenuItem *)createLanguageMenu {
    NSMenuItem *languageMenuItem = [[NSMenuItem alloc] initWithTitle:[LocalizationManager.sharedManager localizedStringForKey:@"menu_language"]
                                                             action:NULL
                                                      keyEquivalent:@""];
    
    NSMenu *languageMenu = [[NSMenu alloc] initWithTitle:[LocalizationManager.sharedManager localizedStringForKey:@"menu_language"]];
    
    // Add language options here
    
    [languageMenuItem setSubmenu:languageMenu];
    return languageMenuItem;
}

- (NSMenuItem *)createSettingsMenu {
    NSMenuItem *settingsMenuItem = [[NSMenuItem alloc] initWithTitle:[LocalizationManager.sharedManager localizedStringForKey:@"menu_settings"]
                                                             action:NULL
                                                      keyEquivalent:@""];
    
    NSMenu *settingsMenu = [[NSMenu alloc] initWithTitle:[LocalizationManager.sharedManager localizedStringForKey:@"menu_settings"]];
    
    // Preferences
    NSMenuItem *preferencesMenuItem = [[NSMenuItem alloc] initWithTitle:[LocalizationManager.sharedManager localizedStringForKey:@"menu_preferences"]
                                                                action:@selector(showPreferencesPanel:)
                                                         keyEquivalent:@","]; // Comma
    [settingsMenu addItem:preferencesMenuItem];
    
    [settingsMenuItem setSubmenu:settingsMenu];
    return settingsMenuItem;
}

- (NSMenuItem *)createMacroMenu {
    NSMenuItem *macroMenuItem = [[NSMenuItem alloc] initWithTitle:[LocalizationManager.sharedManager localizedStringForKey:@"menu_macro"]
                                                           action:NULL
                                                    keyEquivalent:@""];
    
    NSMenu *macroMenu = [[NSMenu alloc] initWithTitle:[LocalizationManager.sharedManager localizedStringForKey:@"menu_macro"]];
    
    // Add macro options here
    
    [macroMenuItem setSubmenu:macroMenu];
    return macroMenuItem;
}

- (NSMenuItem *)createRunMenu {
    NSMenuItem *runMenuItem = [[NSMenuItem alloc] initWithTitle:[LocalizationManager.sharedManager localizedStringForKey:@"menu_run"]
                                                        action:NULL
                                                 keyEquivalent:@""];
    
    NSMenu *runMenu = [[NSMenu alloc] initWithTitle:[LocalizationManager.sharedManager localizedStringForKey:@"menu_run"]];
    
    // Add run options here
    
    [runMenuItem setSubmenu:runMenu];
    return runMenuItem;
}

- (NSMenuItem *)createPluginsMenu {
    NSMenuItem *pluginsMenuItem = [[NSMenuItem alloc] initWithTitle:[LocalizationManager.sharedManager localizedStringForKey:@"menu_plugins"]
                                                            action:NULL
                                                     keyEquivalent:@""];
    
    NSMenu *pluginsMenu = [[NSMenu alloc] initWithTitle:[LocalizationManager.sharedManager localizedStringForKey:@"menu_plugins"]];
    
    // Add plugin options here
    
    [pluginsMenuItem setSubmenu:pluginsMenu];
    return pluginsMenuItem;
}

- (NSMenuItem *)createWindowMenu {
    NSMenuItem *windowMenuItem = [[NSMenuItem alloc] initWithTitle:[LocalizationManager.sharedManager localizedStringForKey:@"menu_window"]
                                                           action:NULL
                                                    keyEquivalent:@""];
    
    NSMenu *windowMenu = [[NSMenu alloc] initWithTitle:[LocalizationManager.sharedManager localizedStringForKey:@"menu_window"]];
    
    // Minimize
    NSMenuItem *minimizeMenuItem = [[NSMenuItem alloc] initWithTitle:[LocalizationManager.sharedManager localizedStringForKey:@"menu_minimize"]
                                                             action:@selector(minimizeWindow:)
                                                      keyEquivalent:@"m"];
    [windowMenu addItem:minimizeMenuItem];
    
    // Zoom
    NSMenuItem *zoomMenuItem = [[NSMenuItem alloc] initWithTitle:[LocalizationManager.sharedManager localizedStringForKey:@"menu_zoom"]
                                                          action:@selector(performZoom:)
                                                   keyEquivalent:@""];
    [windowMenu addItem:zoomMenuItem];
    
    [windowMenuItem setSubmenu:windowMenu];
    return windowMenuItem;
}

- (NSMenuItem *)createHelpMenu {
    NSMenuItem *helpMenuItem = [[NSMenuItem alloc] initWithTitle:[LocalizationManager.sharedManager localizedStringForKey:@"menu_help"]
                                                          action:NULL
                                                   keyEquivalent:@""];
    
    NSMenu *helpMenu = [[NSMenu alloc] initWithTitle:[LocalizationManager.sharedManager localizedStringForKey:@"menu_help"]];
    
    // About
    NSMenuItem *aboutMenuItem = [[NSMenuItem alloc] initWithTitle:[LocalizationManager.sharedManager localizedStringForKey:@"menu_about"]
                                                           action:@selector(showAboutPanel:)
                                                    keyEquivalent:@""];
    [helpMenu addItem:aboutMenuItem];
    
    [helpMenuItem setSubmenu:helpMenu];
    return helpMenuItem;
}

@end
//
//  MenuManager.m
//  NotepadPlusPlus
//
//  Created by Assistant on 12/12/2025.
//

#import "MenuManager.h"
#import "ShortcutManager.h"
#import "RecentFilesManager.h"
#import "SessionManager.h"
#import "PluginManager.h"
#import "CloudDocumentManager.h"
#import "NotepadDocument.h"
#import "HistoryManager.h"
#import "LocalizationManager.h"
#import "AboutPanelManager.h"
#import "RegexReferencePanel.h"
#import "EncodingManager.h"

static RegexReferencePanel *sharedRegexReferencePanel = nil;

@implementation MenuManager

+ (MenuManager *)sharedManager {
    static MenuManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[MenuManager alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    return self;
}

- (void)createMenusForWindowController:(NotepadDocumentWindowController *)windowController {
    NSMenu *mainMenu = [[NSMenu alloc] init];
    
    // Create the application menu (macOS standard)
    NSMenuItem *appMenuItem = [mainMenu addItemWithTitle:@"Application" action:nil keyEquivalent:@""];
    NSMenu *appMenu = [[NSMenu alloc] initWithTitle:@"Application"];
    [mainMenu setSubmenu:appMenu forItem:appMenuItem];
    
    // About panel
    NSMenuItem *aboutItem = [appMenu addItemWithTitle:@"About Notepad++" action:@selector(showAboutPanel:) keyEquivalent:@""];
    aboutItem.target = [NSApp delegate];
    
    [appMenu addItem:[NSMenuItem separatorItem]];
    
    // Preferences
    NSMenuItem *preferencesItem = [appMenu addItemWithTitle:@"Preferences…" action:@selector(editPreferences:) keyEquivalent:@","];
    preferencesItem.target = [PreferencesManager sharedManager];
    
    [appMenu addItem:[NSMenuItem separatorItem]];
    
    // Services
    NSMenuItem *servicesItem = [appMenu addItemWithTitle:@"Services" action:nil keyEquivalent:@""];
    NSMenu *servicesMenu = [[NSMenu alloc] initWithTitle:@"Services"];
    [appMenu setSubmenu:servicesMenu forItem:servicesItem];
    [NSApp setServicesMenu:servicesMenu];
    
    [appMenu addItem:[NSMenuItem separatorItem]];
    
    // Hide/Quit items
    NSMenuItem *hideItem = [appMenu addItemWithTitle:@"Hide Notepad++" action:@selector(hide:) keyEquivalent:@"h"];
    hideItem.target = NSApp;
    
    NSMenuItem *hideOthersItem = [appMenu addItemWithTitle:@"Hide Others" action:@selector(hideOtherApplications:) keyEquivalent:@"h"];
    hideOthersItem.keyEquivalentModifierMask = NSEventModifierFlagCommand | NSEventModifierFlagOption;
    hideOthersItem.target = NSApp;
    
    NSMenuItem *showAllItem = [appMenu addItemWithTitle:@"Show All" action:@selector(unhideAllApplications:) keyEquivalent:@""];
    showAllItem.target = NSApp;
    
    [appMenu addItem:[NSMenuItem separatorItem]];
    
    NSMenuItem *quitItem = [appMenu addItemWithTitle:@"Quit Notepad++" action:@selector(terminate:) keyEquivalent:@"q"];
    quitItem.target = NSApp;
    
    // Create shortcut manager
    ShortcutManager *shortcutManager = [ShortcutManager sharedManager];
    NSString *newKeyEquivalent;
    NSUInteger newModifier;
    
    // File menu
    NSMenuItem *fileMenuItem = [mainMenu addItemWithTitle:[LocalizationManager.sharedManager localizedStringForKey:@"menu_file"] 
                                                  action:nil 
                                           keyEquivalent:@""];
    NSMenu *fileMenu = [[NSMenu alloc] initWithTitle:[LocalizationManager.sharedManager localizedStringForKey:@"menu_file"]];
    [mainMenu setSubmenu:fileMenu forItem:fileMenuItem];
    
    [shortcutManager getShortcutForKey:@"newDocument" keyEquivalent:&newKeyEquivalent modifier:&newModifier];
    NSMenuItem *newItem = [shortcutManager createMenuItemWithTitle:[LocalizationManager.sharedManager localizedStringForKey:@"menu_new"]
                                                           action:@selector(newDocument:) 
                                                    keyEquivalent:newKeyEquivalent
                                                         modifier:newModifier
                                                           target:windowController];
    [fileMenu addItem:newItem];
    
    [shortcutManager getShortcutForKey:@"openDocument" keyEquivalent:&newKeyEquivalent modifier:&newModifier];
    NSMenuItem *openItem = [shortcutManager createMenuItemWithTitle:[LocalizationManager.sharedManager localizedStringForKey:@"menu_open"]
                                                           action:@selector(openDocument:) 
                                                    keyEquivalent:newKeyEquivalent
                                                         modifier:newModifier
                                                           target:windowController];
    [fileMenu addItem:openItem];
    
    // Add recent files submenu
    NSMenuItem *recentFilesMenuItem = [fileMenu addItemWithTitle:@"Open Recent" action:nil keyEquivalent:@""];
    NSMenu *recentFilesMenu = [[NSMenu alloc] initWithTitle:@"Open Recent"];
    [recentFilesMenu setAutoenablesItems:NO];
    [fileMenu setSubmenu:recentFilesMenu forItem:recentFilesMenuItem];
    [self updateRecentFilesMenu:recentFilesMenu];
    
    // Add document history submenu
    NSMenuItem *documentHistoryMenuItem = [fileMenu addItemWithTitle:@"Document History" action:nil keyEquivalent:@""];
    NSMenu *documentHistoryMenu = [[NSMenu alloc] initWithTitle:@"Document History"];
    [documentHistoryMenu setAutoenablesItems:NO];
    [fileMenu setSubmenu:documentHistoryMenu forItem:documentHistoryMenuItem];
    [self updateDocumentHistoryMenu:documentHistoryMenu];
    
    // Add recently closed documents submenu
    NSMenuItem *recentlyClosedMenuItem = [fileMenu addItemWithTitle:@"Recently Closed" action:nil keyEquivalent:@""];
    NSMenu *recentlyClosedMenu = [[NSMenu alloc] initWithTitle:@"Recently Closed"];
    [recentlyClosedMenu setAutoenablesItems:NO];
    [fileMenu setSubmenu:recentlyClosedMenu forItem:recentlyClosedMenuItem];
    [self updateRecentlyClosedMenu:recentlyClosedMenu];
    
    [fileMenu addItem:[NSMenuItem separatorItem]];
    
    // iCloud menu items
    if ([[CloudDocumentManager sharedManager] isCloudAvailable]) {
        NSMenuItem *moveToICloudItem = [fileMenu addItemWithTitle:@"Move to iCloud" action:@selector(moveToICloud:) keyEquivalent:@""];
        moveToICloudItem.target = windowController;
        
        NSMenuItem *moveFromICloudItem = [fileMenu addItemWithTitle:@"Move from iCloud" action:@selector(moveFromICloud:) keyEquivalent:@""];
        moveFromICloudItem.target = windowController;
        
        [fileMenu addItem:[NSMenuItem separatorItem]];
    }
    
    [shortcutManager getShortcutForKey:@"closeDocument" keyEquivalent:&newKeyEquivalent modifier:&newModifier];
    NSMenuItem *closeItem = [shortcutManager createMenuItemWithTitle:[LocalizationManager.sharedManager localizedStringForKey:@"menu_close"]
                                                            action:@selector(closeDocument:) 
                                                     keyEquivalent:newKeyEquivalent
                                                          modifier:newModifier
                                                            target:windowController];
    [fileMenu addItem:closeItem];
    
    [shortcutManager getShortcutForKey:@"saveDocument" keyEquivalent:&newKeyEquivalent modifier:&newModifier];
    NSMenuItem *saveItem = [shortcutManager createMenuItemWithTitle:[LocalizationManager.sharedManager localizedStringForKey:@"menu_save"]
                                                           action:@selector(saveDocument:) 
                                                    keyEquivalent:newKeyEquivalent
                                                         modifier:newModifier
                                                           target:windowController];
    [fileMenu addItem:saveItem];
    
    [shortcutManager getShortcutForKey:@"saveDocumentAs" keyEquivalent:&newKeyEquivalent modifier:&newModifier];
    NSMenuItem *saveAsItem = [shortcutManager createMenuItemWithTitle:[LocalizationManager.sharedManager localizedStringForKey:@"menu_save_as"]
                                                              action:@selector(saveDocumentAs:) 
                                                       keyEquivalent:newKeyEquivalent
                                                            modifier:newModifier
                                                              target:windowController];
    [fileMenu addItem:saveAsItem];
    
    // Sessions menu items
    NSMenuItem *sessionsMenuItem = [fileMenu addItemWithTitle:@"Sessions" action:nil keyEquivalent:@""];
    NSMenu *sessionsMenu = [[NSMenu alloc] initWithTitle:@"Sessions"];
    [fileMenu setSubmenu:sessionsMenu forItem:sessionsMenuItem];
    
    NSMenuItem *saveSessionItem = [sessionsMenu addItemWithTitle:@"Save Session..." action:@selector(saveSession:) keyEquivalent:@""];
    saveSessionItem.target = windowController;
    
    NSMenuItem *restoreSessionItem = [sessionsMenu addItemWithTitle:@"Restore Session..." action:@selector(restoreSession:) keyEquivalent:@""];
    restoreSessionItem.target = windowController;
    
    // Add saved sessions submenu
    NSMenuItem *savedSessionsMenuItem = [sessionsMenu addItemWithTitle:@"Saved Sessions" action:nil keyEquivalent:@""];
    NSMenu *savedSessionsMenu = [[NSMenu alloc] initWithTitle:@"Saved Sessions"];
    [sessionsMenu setSubmenu:savedSessionsMenu forItem:savedSessionsMenuItem];
    [self updateSessionsMenu:savedSessionsMenu];
    
    NSMenuItem *manageSessionsItem = [sessionsMenu addItemWithTitle:@"Manage Sessions..." action:@selector(manageSessions:) keyEquivalent:@""];
    manageSessionsItem.target = windowController;
    
    [fileMenu addItem:[NSMenuItem separatorItem]];
    
    [shortcutManager getShortcutForKey:@"printDocument" keyEquivalent:&newKeyEquivalent modifier:&newModifier];
    NSMenuItem *printItem = [shortcutManager createMenuItemWithTitle:[LocalizationManager.sharedManager localizedStringForKey:@"menu_print"]
                                                            action:@selector(showEnhancedPrintPanel:) 
                                                     keyEquivalent:newKeyEquivalent
                                                          modifier:newModifier
                                                            target:windowController];
    [fileMenu addItem:printItem];
    
    printItem = [shortcutManager createMenuItemWithTitle:[LocalizationManager.sharedManager localizedStringForKey:@"menu_page_setup"]
                                               action:@selector(runPageLayout:) 
                                        keyEquivalent:newKeyEquivalent
                                             modifier:newModifier
                                               target:windowController];
    [fileMenu addItem:printItem];
    
    // Edit menu
    NSMenuItem *editMenuItem = [mainMenu addItemWithTitle:[LocalizationManager.sharedManager localizedStringForKey:@"menu_edit"] 
                                                 action:nil 
                                          keyEquivalent:@""];
    NSMenu *editMenu = [[NSMenu alloc] initWithTitle:[LocalizationManager.sharedManager localizedStringForKey:@"menu_edit"]];
    [mainMenu setSubmenu:editMenu forItem:editMenuItem];
    
    [shortcutManager getShortcutForKey:@"undo" keyEquivalent:&newKeyEquivalent modifier:&newModifier];
    NSMenuItem *undoItem = [shortcutManager createMenuItemWithTitle:[LocalizationManager.sharedManager localizedStringForKey:@"menu_undo"]
                                                      action:@selector(undo:) 
                                               keyEquivalent:newKeyEquivalent
                                                    modifier:newModifier
                                                      target:windowController];
    [editMenu addItem:undoItem];
    
    [shortcutManager getShortcutForKey:@"redo" keyEquivalent:&newKeyEquivalent modifier:&newModifier];
    NSMenuItem *redoItem = [shortcutManager createMenuItemWithTitle:[LocalizationManager.sharedManager localizedStringForKey:@"menu_redo"]
                                                     action:@selector(redo:) 
                                              keyEquivalent:newKeyEquivalent
                                                   modifier:newModifier
                                                     target:windowController];
    [editMenu addItem:redoItem];
    
    [editMenu addItem:[NSMenuItem separatorItem]];
    
    [shortcutManager getShortcutForKey:@"cut" keyEquivalent:&newKeyEquivalent modifier:&newModifier];
    NSMenuItem *cutItem = [shortcutManager createMenuItemWithTitle:[LocalizationManager.sharedManager localizedStringForKey:@"menu_cut"]
                                                           action:@selector(cut:) 
                                                    keyEquivalent:newKeyEquivalent
                                                         modifier:newModifier
                                                           target:windowController];
    [editMenu addItem:cutItem];
    
    [shortcutManager getShortcutForKey:@"copy" keyEquivalent:&newKeyEquivalent modifier:&newModifier];
    NSMenuItem *copyItem = [shortcutManager createMenuItemWithTitle:[LocalizationManager.sharedManager localizedStringForKey:@"menu_copy"]
                                                            action:@selector(copy:) 
                                                     keyEquivalent:newKeyEquivalent
                                                          modifier:newModifier
                                                            target:windowController];
    [editMenu addItem:copyItem];
    
    [shortcutManager getShortcutForKey:@"paste" keyEquivalent:&newKeyEquivalent modifier:&newModifier];
    NSMenuItem *pasteItem = [shortcutManager createMenuItemWithTitle:[LocalizationManager.sharedManager localizedStringForKey:@"menu_paste"]
                                                             action:@selector(paste:) 
                                                      keyEquivalent:newKeyEquivalent
                                                           modifier:newModifier
                                                             target:windowController];
    [editMenu addItem:pasteItem];
    
    NSMenuItem *deleteItem = [shortcutManager createMenuItemWithTitle:[LocalizationManager.sharedManager localizedStringForKey:@"menu_delete"]
                                                              action:@selector(delete:) 
                                                       keyEquivalent:@"\x08"
                                                            modifier:0
                                                              target:windowController];
    [editMenu addItem:deleteItem];
    
    [shortcutManager getShortcutForKey:@"selectAll" keyEquivalent:&newKeyEquivalent modifier:&newModifier];
    NSMenuItem *selectAllItem = [shortcutManager createMenuItemWithTitle:[LocalizationManager.sharedManager localizedStringForKey:@"menu_select_all"]
                                                                 action:@selector(selectAll:) 
                                                          keyEquivalent:newKeyEquivalent
                                                               modifier:newModifier
                                                                 target:windowController];
    [editMenu addItem:selectAllItem];
    
    // Line operations submenu
    NSMenuItem *lineOperationsMenuItem = [editMenu addItemWithTitle:@"Line Operations" action:nil keyEquivalent:@""];
    NSMenu *lineOperationsMenu = [[NSMenu alloc] initWithTitle:@"Line Operations"];
    [editMenu setSubmenu:lineOperationsMenu forItem:lineOperationsMenuItem];
    
    NSMenuItem *removeEmptyLinesItem = [lineOperationsMenu addItemWithTitle:@"Remove Empty Lines" action:@selector(showLineOperations:) keyEquivalent:@""];
    removeEmptyLinesItem.target = windowController;
    
    NSMenuItem *removeDuplicateLinesItem = [lineOperationsMenu addItemWithTitle:@"Remove Duplicate Lines" action:@selector(showLineOperations:) keyEquivalent:@""];
    removeDuplicateLinesItem.target = windowController;
    
    [lineOperationsMenu addItem:[NSMenuItem separatorItem]];
    
    NSMenuItem *sortLinesAscItem = [lineOperationsMenu addItemWithTitle:@"Sort Lines Ascending" action:@selector(showLineOperations:) keyEquivalent:@""];
    sortLinesAscItem.target = windowController;
    
    NSMenuItem *sortLinesDescItem = [lineOperationsMenu addItemWithTitle:@"Sort Lines Descending" action:@selector(showLineOperations:) keyEquivalent:@""];
    sortLinesDescItem.target = windowController;
    
    [editMenu addItem:[NSMenuItem separatorItem]];
    
    [shortcutManager getShortcutForKey:@"find" keyEquivalent:&newKeyEquivalent modifier:&newModifier];
    NSMenuItem *findItem = [shortcutManager createMenuItemWithTitle:[LocalizationManager.sharedManager localizedStringForKey:@"menu_find"]
                                                            action:@selector(showFindPanel:) 
                                                     keyEquivalent:newKeyEquivalent
                                                          modifier:newModifier
                                                            target:windowController];
    [editMenu addItem:findItem];
    
    [shortcutManager getShortcutForKey:@"findNext" keyEquivalent:&newKeyEquivalent modifier:&newModifier];
    NSMenuItem *findNextItem = [shortcutManager createMenuItemWithTitle:@"Find Next" 
                                                                action:@selector(findNext:) 
                                                         keyEquivalent:newKeyEquivalent
                                                              modifier:newModifier
                                                                target:windowController];
    [editMenu addItem:findNextItem];
    
    [shortcutManager getShortcutForKey:@"findPrevious" keyEquivalent:&newKeyEquivalent modifier:&newModifier];
    NSMenuItem *findPrevItem = [shortcutManager createMenuItemWithTitle:@"Find Previous" 
                                                                action:@selector(findPrevious:) 
                                                         keyEquivalent:newKeyEquivalent
                                                              modifier:newModifier
                                                                target:windowController];
    [editMenu addItem:findPrevItem];
    
    [shortcutManager getShortcutForKey:@"replace" keyEquivalent:&newKeyEquivalent modifier:&newModifier];
    NSMenuItem *replaceItem = [shortcutManager createMenuItemWithTitle:[LocalizationManager.sharedManager localizedStringForKey:@"menu_replace"]
                                                               action:@selector(showReplacePanel:) 
                                                        keyEquivalent:newKeyEquivalent
                                                             modifier:newModifier
                                                               target:windowController];
    [editMenu addItem:replaceItem];
    
    // Regex help item
    NSMenuItem *regexHelpItem = [editMenu addItemWithTitle:@"Regular Expression Help" action:@selector(showRegexHelp:) keyEquivalent:@""];
    regexHelpItem.target = self;
    
    [editMenu addItem:[NSMenuItem separatorItem]];
    
    // Encoding conversion item
    NSMenuItem *encodingConversionItem = [editMenu addItemWithTitle:@"Convert Encoding" action:@selector(showEncodingConverter:) keyEquivalent:@""];
    encodingConversionItem.target = windowController;
    
    [editMenu addItem:[NSMenuItem separatorItem]];
    
    [shortcutManager getShortcutForKey:@"toggleBookmark" keyEquivalent:&newKeyEquivalent modifier:&newModifier];
    NSMenuItem *toggleBookmarkItem = [shortcutManager createMenuItemWithTitle:@"Toggle Bookmark" 
                                                                     action:@selector(toggleBookmark:) 
                                                              keyEquivalent:newKeyEquivalent
                                                                   modifier:newModifier
                                                                     target:windowController];
    [editMenu addItem:toggleBookmarkItem];
    
    [shortcutManager getShortcutForKey:@"nextBookmark" keyEquivalent:&newKeyEquivalent modifier:&newModifier];
    NSMenuItem *nextBookmarkItem = [shortcutManager createMenuItemWithTitle:@"Next Bookmark" 
                                                                    action:@selector(nextBookmark:) 
                                                             keyEquivalent:newKeyEquivalent
                                                                  modifier:newModifier
                                                                    target:windowController];
    [editMenu addItem:nextBookmarkItem];
    
    [shortcutManager getShortcutForKey:@"previousBookmark" keyEquivalent:&newKeyEquivalent modifier:&newModifier];
    NSMenuItem *prevBookmarkItem = [shortcutManager createMenuItemWithTitle:@"Previous Bookmark" 
                                                                    action:@selector(previousBookmark:) 
                                                             keyEquivalent:newKeyEquivalent
                                                                  modifier:newModifier
                                                                    target:windowController];
    [editMenu addItem:prevBookmarkItem];
    
    NSMenuItem *clearBookmarksItem = [shortcutManager createMenuItemWithTitle:@"Clear All Bookmarks" 
                                                                      action:@selector(clearAllBookmarks:) 
                                                               keyEquivalent:@""
                                                                    modifier:0
                                                                      target:windowController];
    [editMenu addItem:clearBookmarksItem];
    
    [editMenu addItem:[NSMenuItem separatorItem]];
    
    [shortcutManager getShortcutForKey:@"startRecording" keyEquivalent:&newKeyEquivalent modifier:&newModifier];
    NSMenuItem *startRecordingItem = [shortcutManager createMenuItemWithTitle:@"Start Recording" 
                                                                     action:@selector(startRecording:) 
                                                              keyEquivalent:newKeyEquivalent
                                                                   modifier:newModifier
                                                                     target:windowController];
    [editMenu addItem:startRecordingItem];
    
    NSMenuItem *stopRecordingItem = [shortcutManager createMenuItemWithTitle:@"Stop Recording" 
                                                                     action:@selector(stopRecording:) 
                                                              keyEquivalent:@""
                                                                   modifier:0
                                                                     target:windowController];
    [editMenu addItem:stopRecordingItem];
    
    [shortcutManager getShortcutForKey:@"playMacro" keyEquivalent:&newKeyEquivalent modifier:&newModifier];
    NSMenuItem *playMacroItem = [shortcutManager createMenuItemWithTitle:@"Play Macro" 
                                                                 action:@selector(playMacro:) 
                                                          keyEquivalent:newKeyEquivalent
                                                               modifier:newModifier
                                                                 target:windowController];
    [editMenu addItem:playMacroItem];
    
    NSMenuItem *saveMacroItem = [shortcutManager createMenuItemWithTitle:@"Save Current Macro" 
                                                                 action:@selector(saveMacro:) 
                                                          keyEquivalent:@""
                                                               modifier:0
                                                                 target:windowController];
    [editMenu addItem:saveMacroItem];
    
    // Enhanced auto completion item
    [shortcutManager getShortcutForKey:@"autoComplete" keyEquivalent:&newKeyEquivalent modifier:&newModifier];
    NSMenuItem *autoCompleteItem = [shortcutManager createMenuItemWithTitle:@"Auto Completion" 
                                                                   action:@selector(showAutoCompletion:) 
                                                            keyEquivalent:newKeyEquivalent
                                                                 modifier:newModifier
                                                                   target:windowController];
    [editMenu addItem:autoCompleteItem];
    
    NSMenuItem *manageMacrosItem = [shortcutManager createMenuItemWithTitle:@"Manage Macros..." 
                                                                  action:@selector(manageMacros:) 
                                                           keyEquivalent:@""
                                                                modifier:0
                                                                  target:windowController];
    [editMenu addItem:manageMacrosItem];
    
    NSMenuItem *loadMacroItem = [shortcutManager createMenuItemWithTitle:@"Run Saved Macro" 
                                                                 action:@selector(runSavedMacro:) 
                                                          keyEquivalent:@""
                                                               modifier:0
                                                                 target:windowController];
    [editMenu addItem:loadMacroItem];
    
    [editMenu addItem:[NSMenuItem separatorItem]];
    
    [shortcutManager getShortcutForKey:@"goToLine" keyEquivalent:&newKeyEquivalent modifier:&newModifier];
    NSMenuItem *goToLineItem = [shortcutManager createMenuItemWithTitle:[LocalizationManager.sharedManager localizedStringForKey:@"menu_go_to_line"]
                                                                action:@selector(goToLine:) 
                                                         keyEquivalent:newKeyEquivalent
                                                              modifier:newModifier
                                                                target:windowController];
    [editMenu addItem:goToLineItem];
    
    // View menu
    NSMenuItem *viewMenuItem = [self createViewMenu];
    [mainMenu addItem:viewMenuItem];
    
    // Document Statistics item
    NSMenuItem *documentStatsItem = [viewMenu addItemWithTitle:@"Document Statistics" action:@selector(showDocumentStatistics:) keyEquivalent:@""];
    documentStatsItem.target = windowController;
    
    // Language menu
    NSMenuItem *languageMenuItem = [mainMenu addItemWithTitle:[LocalizationManager.sharedManager localizedStringForKey:@"menu_language"] 
                                                    action:nil 
                                             keyEquivalent:@""];
    NSMenu *languageMenu = [[NSMenu alloc] initWithTitle:[LocalizationManager.sharedManager localizedStringForKey:@"menu_language"]];
    [mainMenu setSubmenu:languageMenu forItem:languageMenuItem];
    
    NSArray *languages = @[@"Plain Text", @"C++", @"Python", @"JavaScript", @"HTML", @"XML", @"Java", @"PHP", @"Ruby", @"CSS", @"SQL", @"JSON", @"YAML", @"Markdown", @"Bash", @"Go", @"Rust", @"TypeScript", @"Swift", @"Kotlin"];
    for (NSString *language in languages) {
        NSMenuItem *item = [languageMenu addItemWithTitle:language action:@selector(changeLanguage:) keyEquivalent:@""];
        item.representedObject = language;
        item.target = windowController;
    }
    
    // Encoding menu
    NSMenuItem *encodingMenuItem = [mainMenu addItemWithTitle:[LocalizationManager.sharedManager localizedStringForKey:@"menu_encoding"] 
                                                   action:nil 
                                            keyEquivalent:@""];
    NSMenu *encodingMenu = [[NSMenu alloc] initWithTitle:[LocalizationManager.sharedManager localizedStringForKey:@"menu_encoding"]];
    [mainMenu setSubmenu:encodingMenu forItem:encodingMenuItem];
    
    // Add encoding items
    EncodingManager *encodingManager = [EncodingManager sharedManager];
    NSArray *encodings = [encodingManager getSupportedEncodings];
    for (NSString *encoding in encodings) {
        NSString *localizedName = [encodingManager getLocalizedNameForEncoding:encoding];
        NSMenuItem *item = [encodingMenu addItemWithTitle:localizedName action:@selector(changeEncoding:) keyEquivalent:@""];
        item.representedObject = encoding;
        item.target = windowController;
    }
    
    // Plugins menu
    NSMenuItem *pluginsMenuItem = [mainMenu addItemWithTitle:[LocalizationManager.sharedManager localizedStringForKey:@"menu_plugins"] 
                                                  action:nil 
                                           keyEquivalent:@""];
    NSMenu *topLevelPluginsMenu = [[NSMenu alloc] initWithTitle:[LocalizationManager.sharedManager localizedStringForKey:@"menu_plugins"]];
    [self updatePluginsMenu:topLevelPluginsMenu forWindowController:windowController];
    [mainMenu setSubmenu:topLevelPluginsMenu forItem:pluginsMenuItem];
    
    [NSApp setMainMenu:mainMenu];
}

- (NSMenuItem *)createViewMenu {
    NSMenuItem *viewMenuItem = [[NSMenuItem alloc] initWithTitle:[LocalizationManager.sharedManager localizedStringForKey:@"menu_view"]
                                                          action:NULL
                                                   keyEquivalent:@""];
    
    NSMenu *viewMenu = [[NSMenu alloc] initWithTitle:[LocalizationManager.sharedManager localizedStringForKey:@"menu_view"]];
    
    // Show Toolbar
    NSMenuItem *showToolbarMenuItem = [[NSMenuItem alloc] initWithTitle:[LocalizationManager.sharedManager localizedStringForKey:@"menu_show_toolbar"]
                                                                action:@selector(toggleToolbarShown:)
                                                         keyEquivalent:@"t"];
    [showToolbarMenuItem setKeyEquivalentModifierMask:(NSEventModifierFlagOption | NSEventModifierFlagCommand)];
    [viewMenu addItem:showToolbarMenuItem];
    
    // Show Status Bar
    NSMenuItem *showStatusBarMenuItem = [[NSMenuItem alloc] initWithTitle:[LocalizationManager.sharedManager localizedStringForKey:@"menu_show_status_bar"]
                                                                  action:@selector(toggleStatusBar:)
                                                           keyEquivalent:@""];
    [viewMenu addItem:showStatusBarMenuItem];
    
    [viewMenu addItem:[NSMenuItem separatorItem]];
    
    // Zoom In
    NSMenuItem *zoomInMenuItem = [[NSMenuItem alloc] initWithTitle:[LocalizationManager.sharedManager localizedStringForKey:@"menu_zoom_in"]
                                                            action:@selector(zoomIn:)
                                                     keyEquivalent:@"+"];
    [viewMenu addItem:zoomInMenuItem];
    
    // Zoom Out
    NSMenuItem *zoomOutMenuItem = [[NSMenuItem alloc] initWithTitle:[LocalizationManager.sharedManager localizedStringForKey:@"menu_zoom_out"]
                                                             action:@selector(zoomOut:)
                                                      keyEquivalent:@"-"];
    [viewMenu addItem:zoomOutMenuItem];
    
    // Reset Zoom
    NSMenuItem *resetZoomMenuItem = [[NSMenuItem alloc] initWithTitle:[LocalizationManager.sharedManager localizedStringForKey:@"menu_reset_zoom"]
                                                               action:@selector(resetZoom:)
                                                        keyEquivalent:@"0"];
    [resetZoomMenuItem setKeyEquivalentModifierMask:NSEventModifierFlagCommand];
    [viewMenu addItem:resetZoomMenuItem];
    
    [viewMenu addItem:[NSMenuItem separatorItem]];
    
    // Toggle Line Numbers
    NSMenuItem *toggleLineNumbersMenuItem = [[NSMenuItem alloc] initWithTitle:[LocalizationManager.sharedManager localizedStringForKey:@"menu_toggle_line_numbers"]
                                                                       action:@selector(toggleLineNumbers:)
                                                                keyEquivalent:@"L"];
    [toggleLineNumbersMenuItem setKeyEquivalentModifierMask:(NSEventModifierFlagShift | NSEventModifierFlagCommand)];
    [viewMenu addItem:toggleLineNumbersMenuItem];
    
    // Toggle Whitespace
    NSMenuItem *toggleWhitespaceMenuItem = [[NSMenuItem alloc] initWithTitle:[LocalizationManager.sharedManager localizedStringForKey:@"menu_toggle_whitespace"]
                                                                      action:@selector(toggleWhitespace:)
                                                               keyEquivalent:@"W"];
    [toggleWhitespaceMenuItem setKeyEquivalentModifierMask:(NSEventModifierFlagShift | NSEventModifierFlagCommand)];
    [viewMenu addItem:toggleWhitespaceMenuItem];
    
    [viewMenu addItem:[NSMenuItem separatorItem]];
    
    // Enter Full Screen
    NSMenuItem *enterFullScreenMenuItem = [[NSMenuItem alloc] initWithTitle:[LocalizationManager.sharedManager localizedStringForKey:@"menu_enter_full_screen"]
                                                                    action:@selector(toggleFullScreen:)
                                                             keyEquivalent:@"f"];
    [enterFullScreenMenuItem setKeyEquivalentModifierMask:(NSEventModifierFlagControl | NSEventModifierFlagCommand)];
    [viewMenu addItem:enterFullScreenMenuItem];
    
    // Function List
    NSMenuItem *functionListMenuItem = [[NSMenuItem alloc] initWithTitle:[LocalizationManager.sharedManager localizedStringForKey:@"menu_function_list"]
                                                                 action:@selector(showFunctionList:)
                                                          keyEquivalent:@"F"];
    [functionListMenuItem setKeyEquivalentModifierMask:(NSEventModifierFlagShift | NSEventModifierFlagCommand)];
    [viewMenu addItem:functionListMenuItem];
    
    [viewMenuItem setSubmenu:viewMenu];
    return viewMenuItem;
}

- (void)updateSessionsMenu:(NSMenu *)menu {
    SessionManager *sessionManager = [SessionManager sharedManager];
    NSArray *sessions = [sessionManager availableSessions];
    
    [menu removeAllItems];
    
    if (sessions.count > 0) {
        for (NSString *sessionName in sessions) {
            NSMenuItem *item = [menu addItemWithTitle:sessionName action:@selector(restoreSessionFromMenu:) keyEquivalent:@""];
            item.representedObject = sessionName;
        }
    } else {
        NSMenuItem *emptyItem = [menu addItemWithTitle:@"No saved sessions" action:nil keyEquivalent:@""];
        emptyItem.enabled = NO;
    }
}

- (IBAction)showRegexHelp:(id)sender {
    if (!sharedRegexReferencePanel) {
        sharedRegexReferencePanel = [[RegexReferencePanel alloc] init];
    }
    [sharedRegexReferencePanel showPanel];
}

@end