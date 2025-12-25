//
//  ToolbarManager.m
//  NotepadPlusPlus
//
//  Created by Assistant on 12/12/2025.
//

#import "ToolbarManager.h"
#import "LocalizationManager.h"

static NSString * const kToolbarIdentifier = @"NotepadToolbar";

// Toolbar item identifiers
static NSString * const kToolbarNewDocumentItemIdentifier = @"NewDocumentToolbarItem";
static NSString * const kToolbarOpenDocumentItemIdentifier = @"OpenDocumentToolbarItem";
static NSString * const kToolbarSaveDocumentItemIdentifier = @"SaveDocumentToolbarItem";
static NSString * const kToolbarFindItemIdentifier = @"FindToolbarItem";
static NSString * const kToolbarReplaceItemIdentifier = @"ReplaceToolbarItem";
static NSString * const kToolbarUndoItemIdentifier = @"UndoToolbarItem";
static NSString * const kToolbarRedoItemIdentifier = @"RedoToolbarItem";
static NSString * const kToolbarLanguagePopupItemIdentifier = @"LanguagePopupToolbarItem";
static NSString * const kToolbarPrintItemIdentifier = @"PrintToolbarItem";
static NSString * const kToolbarBookmarkToggleItemIdentifier = @"BookmarkToggleToolbarItem";
static NSString * const kToolbarNextBookmarkItemIdentifier = @"NextBookmarkToolbarItem";
static NSString * const kToolbarPreviousBookmarkItemIdentifier = @"PreviousBookmarkToolbarItem";
static NSString * const kToolbarCollapseAllItemIdentifier = @"CollapseAllToolbarItem";
static NSString * const kToolbarExpandAllItemIdentifier = @"ExpandAllToolbarItem";
static NSString * const kToolbarGoToLineItemIdentifier = @"GoToLineToolbarItem";
static NSString * const kToolbarMacroRecordItemIdentifier = @"MacroRecordToolbarItem";
static NSString * const kToolbarMacroPlayItemIdentifier = @"MacroPlayToolbarItem";

@interface ToolbarManager()
@property (nonatomic, weak) NotepadDocumentWindowController *windowController;
@end

@implementation ToolbarManager

- (instancetype)initWithWindowController:(NotepadDocumentWindowController *)windowController {
    self = [super init];
    if (self) {
        _windowController = windowController;
    }
    return self;
}

- (NSToolbar *)createToolbar {
    NSToolbar *toolbar = [[NSToolbar alloc] initWithIdentifier:kToolbarIdentifier];
    toolbar.delegate = self;
    toolbar.allowsUserCustomization = YES;
    toolbar.autosavesConfiguration = YES;
    return toolbar;
}

#pragma mark - NSToolbarDelegate

- (NSToolbarItem *)toolbar:(NSToolbar *)toolbar itemForItemIdentifier:(NSString *)itemIdentifier willBeInsertedIntoToolbar:(BOOL)flag {
    NSToolbarItem *toolbarItem = [[NSToolbarItem alloc] initWithItemIdentifier:itemIdentifier];
    
    if ([itemIdentifier isEqualToString:kToolbarNewDocumentItemIdentifier]) {
        toolbarItem.label = [LocalizationManager.sharedManager localizedStringForKey:@"menu_new"];
        toolbarItem.paletteLabel = [LocalizationManager.sharedManager localizedStringForKey:@"menu_new"];
        toolbarItem.toolTip = [LocalizationManager.sharedManager localizedStringForKey:@"menu_new"];
        toolbarItem.target = self.windowController;
        toolbarItem.action = @selector(newDocument:);
        toolbarItem.image = [NSImage imageNamed:NSImageNameAddTemplate];
    } else if ([itemIdentifier isEqualToString:kToolbarOpenDocumentItemIdentifier]) {
        toolbarItem.label = [LocalizationManager.sharedManager localizedStringForKey:@"menu_open"];
        toolbarItem.paletteLabel = [LocalizationManager.sharedManager localizedStringForKey:@"menu_open"];
        toolbarItem.toolTip = [LocalizationManager.sharedManager localizedStringForKey:@"menu_open"];
        toolbarItem.target = self.windowController;
        toolbarItem.action = @selector(openDocument:);
        toolbarItem.image = [NSImage imageNamed:NSImageNameOpenTemplate];
    } else if ([itemIdentifier isEqualToString:kToolbarSaveDocumentItemIdentifier]) {
        toolbarItem.label = [LocalizationManager.sharedManager localizedStringForKey:@"menu_save"];
        toolbarItem.paletteLabel = [LocalizationManager.sharedManager localizedStringForKey:@"menu_save"];
        toolbarItem.toolTip = [LocalizationManager.sharedManager localizedStringForKey:@"menu_save"];
        toolbarItem.target = self.windowController;
        toolbarItem.action = @selector(saveDocument:);
        toolbarItem.image = [NSImage imageNamed:NSImageNameSaveTemplate];
    } else if ([itemIdentifier isEqualToString:kToolbarFindItemIdentifier]) {
        toolbarItem.label = [LocalizationManager.sharedManager localizedStringForKey:@"menu_find"];
        toolbarItem.paletteLabel = [LocalizationManager.sharedManager localizedStringForKey:@"menu_find"];
        toolbarItem.toolTip = [LocalizationManager.sharedManager localizedStringForKey:@"menu_find"];
        toolbarItem.target = self.windowController;
        toolbarItem.action = @selector(showFindPanel:);
        toolbarItem.image = [NSImage imageNamed:NSImageNameFindTemplate];
    } else if ([itemIdentifier isEqualToString:kToolbarReplaceItemIdentifier]) {
        toolbarItem.label = [LocalizationManager.sharedManager localizedStringForKey:@"menu_replace"];
        toolbarItem.paletteLabel = [LocalizationManager.sharedManager localizedStringForKey:@"menu_replace"];
        toolbarItem.toolTip = [LocalizationManager.sharedManager localizedStringForKey:@"menu_replace"];
        toolbarItem.target = self.windowController;
        toolbarItem.action = @selector(showReplacePanel:);
        toolbarItem.image = [NSImage imageNamed:NSImageNameAdvanced];
    } else if ([itemIdentifier isEqualToString:kToolbarUndoItemIdentifier]) {
        toolbarItem.label = [LocalizationManager.sharedManager localizedStringForKey:@"menu_undo"];
        toolbarItem.paletteLabel = [LocalizationManager.sharedManager localizedStringForKey:@"menu_undo"];
        toolbarItem.toolTip = [LocalizationManager.sharedManager localizedStringForKey:@"menu_undo"];
        toolbarItem.target = self.windowController;
        toolbarItem.action = @selector(undo:);
        toolbarItem.image = [NSImage imageNamed:NSImageNameUndoTemplate];
    } else if ([itemIdentifier isEqualToString:kToolbarRedoItemIdentifier]) {
        toolbarItem.label = [LocalizationManager.sharedManager localizedStringForKey:@"menu_redo"];
        toolbarItem.paletteLabel = [LocalizationManager.sharedManager localizedStringForKey:@"menu_redo"];
        toolbarItem.toolTip = [LocalizationManager.sharedManager localizedStringForKey:@"menu_redo"];
        toolbarItem.target = self.windowController;
        toolbarItem.action = @selector(redo:);
        toolbarItem.image = [NSImage imageNamed:NSImageNameRedoTemplate];
    } else if ([itemIdentifier isEqualToString:kToolbarLanguagePopupItemIdentifier]) {
        toolbarItem.label = [LocalizationManager.sharedManager localizedStringForKey:@"menu_language"];
        toolbarItem.paletteLabel = [LocalizationManager.sharedManager localizedStringForKey:@"menu_language"];
        toolbarItem.toolTip = [LocalizationManager.sharedManager localizedStringForKey:@"menu_language"];
        toolbarItem.view = [self createLanguagePopupView];
    } else if ([itemIdentifier isEqualToString:kToolbarPrintItemIdentifier]) {
        toolbarItem.label = [LocalizationManager.sharedManager localizedStringForKey:@"menu_print"];
        toolbarItem.paletteLabel = [LocalizationManager.sharedManager localizedStringForKey:@"menu_print"];
        toolbarItem.toolTip = [LocalizationManager.sharedManager localizedStringForKey:@"menu_print"];
        toolbarItem.target = self.windowController;
        toolbarItem.action = @selector(showEnhancedPrintPanel:);
        toolbarItem.image = [NSImage imageNamed:NSImageNamePrintTemplate];
    } else if ([itemIdentifier isEqualToString:kToolbarBookmarkToggleItemIdentifier]) {
        toolbarItem.label = @"Toggle Bookmark";
        toolbarItem.paletteLabel = @"Toggle Bookmark";
        toolbarItem.toolTip = @"Toggle bookmark at current line";
        toolbarItem.target = self.windowController;
        toolbarItem.action = @selector(toggleBookmark:);
        toolbarItem.image = [NSImage imageNamed:NSImageNameBookmarksTemplate];
    } else if ([itemIdentifier isEqualToString:kToolbarNextBookmarkItemIdentifier]) {
        toolbarItem.label = @"Next Bookmark";
        toolbarItem.paletteLabel = @"Next Bookmark";
        toolbarItem.toolTip = @"Go to next bookmark";
        toolbarItem.target = self.windowController;
        toolbarItem.action = @selector(nextBookmark:);
        toolbarItem.image = [NSImage imageNamed:NSImageNameRightFacingTriangleTemplate];
    } else if ([itemIdentifier isEqualToString:kToolbarPreviousBookmarkItemIdentifier]) {
        toolbarItem.label = @"Previous Bookmark";
        toolbarItem.paletteLabel = @"Previous Bookmark";
        toolbarItem.toolTip = @"Go to previous bookmark";
        toolbarItem.target = self.windowController;
        toolbarItem.action = @selector(previousBookmark:);
        toolbarItem.image = [NSImage imageNamed:NSImageNameLeftFacingTriangleTemplate];
    } else if ([itemIdentifier isEqualToString:kToolbarCollapseAllItemIdentifier]) {
        toolbarItem.label = @"Collapse All";
        toolbarItem.paletteLabel = @"Collapse All";
        toolbarItem.toolTip = @"Collapse all code folds";
        toolbarItem.target = self.windowController;
        toolbarItem.action = @selector(collapseAllFolds:);
        toolbarItem.image = [NSImage imageNamed:NSImageNameIconViewTemplate];
    } else if ([itemIdentifier isEqualToString:kToolbarExpandAllItemIdentifier]) {
        toolbarItem.label = @"Expand All";
        toolbarItem.paletteLabel = @"Expand All";
        toolbarItem.toolTip = @"Expand all code folds";
        toolbarItem.target = self.windowController;
        toolbarItem.action = @selector(expandAllFolds:);
        toolbarItem.image = [NSImage imageNamed:NSImageNameListViewTemplate];
    } else if ([itemIdentifier isEqualToString:kToolbarGoToLineItemIdentifier]) {
        toolbarItem.label = [LocalizationManager.sharedManager localizedStringForKey:@"menu_go_to_line"];
        toolbarItem.paletteLabel = [LocalizationManager.sharedManager localizedStringForKey:@"menu_go_to_line"];
        toolbarItem.toolTip = [LocalizationManager.sharedManager localizedStringForKey:@"menu_go_to_line"];
        toolbarItem.target = self.windowController;
        toolbarItem.action = @selector(goToLine:);
        toolbarItem.image = [NSImage imageNamed:NSImageNameJumpToPageTemplate];
    } else if ([itemIdentifier isEqualToString:kToolbarMacroRecordItemIdentifier]) {
        toolbarItem.label = @"Record Macro";
        toolbarItem.paletteLabel = @"Record Macro";
        toolbarItem.toolTip = @"Start/Stop macro recording";
        toolbarItem.target = self.windowController;
        toolbarItem.action = @selector(startRecording:);
        toolbarItem.image = [NSImage imageNamed:NSImageNameRecordingsFolder];
    } else if ([itemIdentifier isEqualToString:kToolbarMacroPlayItemIdentifier]) {
        toolbarItem.label = @"Play Macro";
        toolbarItem.paletteLabel = @"Play Macro";
        toolbarItem.toolTip = @"Play recorded macro";
        toolbarItem.target = self.windowController;
        toolbarItem.action = @selector(playMacro:);
        toolbarItem.image = [NSImage imageNamed:NSImageNamePlayTemplate];
    }
    
    return toolbarItem;
}

- (NSArray *)toolbarDefaultItemIdentifiers:(NSToolbar *)toolbar {
    return @[
        kToolbarNewDocumentItemIdentifier,
        kToolbarOpenDocumentItemIdentifier,
        kToolbarSaveDocumentItemIdentifier,
        NSToolbarSpaceItemIdentifier,
        kToolbarUndoItemIdentifier,
        kToolbarRedoItemIdentifier,
        NSToolbarSpaceItemIdentifier,
        kToolbarFindItemIdentifier,
        kToolbarReplaceItemIdentifier,
        NSToolbarSpaceItemIdentifier,
        kToolbarPrintItemIdentifier,
        kToolbarGoToLineItemIdentifier,
        NSToolbarSpaceItemIdentifier,
        kToolbarBookmarkToggleItemIdentifier,
        kToolbarNextBookmarkItemIdentifier,
        kToolbarPreviousBookmarkItemIdentifier,
        NSToolbarSpaceItemIdentifier,
        kToolbarCollapseAllItemIdentifier,
        kToolbarExpandAllItemIdentifier,
        NSToolbarSpaceItemIdentifier,
        kToolbarMacroRecordItemIdentifier,
        kToolbarMacroPlayItemIdentifier,
        NSToolbarSpaceItemIdentifier,
        kToolbarLanguagePopupItemIdentifier
    ];
}

- (NSArray *)toolbarAllowedItemIdentifiers:(NSToolbar *)toolbar {
    return @[
        kToolbarNewDocumentItemIdentifier,
        kToolbarOpenDocumentItemIdentifier,
        kToolbarSaveDocumentItemIdentifier,
        kToolbarUndoItemIdentifier,
        kToolbarRedoItemIdentifier,
        kToolbarFindItemIdentifier,
        kToolbarReplaceItemIdentifier,
        kToolbarPrintItemIdentifier,
        kToolbarBookmarkToggleItemIdentifier,
        kToolbarNextBookmarkItemIdentifier,
        kToolbarPreviousBookmarkItemIdentifier,
        kToolbarCollapseAllItemIdentifier,
        kToolbarExpandAllItemIdentifier,
        kToolbarGoToLineItemIdentifier,
        kToolbarMacroRecordItemIdentifier,
        kToolbarMacroPlayItemIdentifier,
        kToolbarLanguagePopupItemIdentifier,
        NSToolbarSpaceItemIdentifier,
        NSToolbarFlexibleSpaceItemIdentifier
    ];
}

- (NSPopUpButton *)createLanguagePopupView {
    NSPopUpButton *popupButton = [[NSPopUpButton alloc] initWithFrame:NSMakeRect(0, 0, 120, 24) pullsDown:NO];
    popupButton.target = self.windowController;
    popupButton.action = @selector(changeLanguage:);
    
    // Add language options
    NSArray *languages = @[@"Plain Text", @"C++", @"Python", @"JavaScript", @"HTML", @"XML"];
    [popupButton addItemsWithTitles:languages];
    
    return popupButton;
}

@end