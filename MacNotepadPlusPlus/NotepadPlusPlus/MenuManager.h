//
//  MenuManager.h
//  NotepadPlusPlus
//
//  Created by Lingma on 12/12/2025.
//

#import <Cocoa/Cocoa.h>
#import "LocalizationManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface MenuManager : NSObject

+ (MenuManager *)sharedManager;
- (NSMenu *)createMainMenu;
- (NSMenuItem *)createFileMenu;
- (NSMenuItem *)createEditMenu;
- (NSMenuItem *)createSearchMenu;
- (NSMenuItem *)createViewMenu;
- (NSMenuItem *)createEncodingMenu;
- (NSMenuItem *)createLanguageMenu;
- (NSMenuItem *)createSettingsMenu;
- (NSMenuItem *)createMacroMenu;
- (NSMenuItem *)createRunMenu;
- (NSMenuItem *)createPluginsMenu;
- (NSMenuItem *)createWindowMenu;
- (NSMenuItem *)createHelpMenu;

@end

NS_ASSUME_NONNULL_END