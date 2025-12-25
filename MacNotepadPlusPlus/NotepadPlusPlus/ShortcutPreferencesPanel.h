//
//  ShortcutPreferencesPanel.h
//  NotepadPlusPlus
//
//  Created by Assistant on 12/12/2025.
//

#import <Cocoa/Cocoa.h>
#import "ShortcutManager.h"

@interface ShortcutPreferencesPanel : NSPanel <NSTableViewDataSource, NSTableViewDelegate>

@property (nonatomic, strong) NSTableView *tableView;
@property (nonatomic, strong) NSArray *shortcutKeys;
@property (nonatomic, strong) NSMutableDictionary *editingShortcuts;
@property (nonatomic, strong) ShortcutManager *shortcutManager;

+ (instancetype)sharedPanel;
- (void)showPanel:(id)sender;

@end