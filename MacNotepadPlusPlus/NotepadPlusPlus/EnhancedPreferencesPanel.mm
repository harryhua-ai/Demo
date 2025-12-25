//
//  EnhancedPreferencesPanel.m
//  NotepadPlusPlus
//
//  Created by Assistant on 12/12/2025.
//

#import "EnhancedPreferencesPanel.h"
#import "ShortcutPreferencesPanel.h"
#import "LocalizationManager.h"

@interface EnhancedPreferencesPanel() <NSWindowDelegate>
@property (nonatomic, strong) PreferencesManager *preferences;
@property (nonatomic, strong) NSTabView *tabView;
@property (nonatomic, strong) NSButton *okButton;
@property (nonatomic, strong) NSButton *cancelButton;
@property (nonatomic, strong) NSButton *applyButton;

// General tab controls
@property (nonatomic, strong) NSButton *autoSaveCheckbox;
@property (nonatomic, strong) NSButton *restoreSessionCheckbox;

// Editor tab controls
@property (nonatomic, strong) NSTextField *tabWidthField;
@property (nonatomic, strong) NSButton *spacesInsteadOfTabsCheckbox;
@property (nonatomic, strong) NSButton *lineNumbersCheckbox;
@property (nonatomic, strong) NSButton *whiteSpaceCheckbox;
@property (nonatomic, strong) NSTextField *fontSizeField;
@property (nonatomic, strong) NSPopUpButton *fontFamilyPopup;

// View tab controls
@property (nonatomic, strong) NSButton *wrapLinesCheckbox;
@property (nonatomic, strong) NSButton *menuBarCheckbox;
@property (nonatomic, strong) NSButton *toolBarCheckbox;
@property (nonatomic, strong) NSButton *statusBarCheckbox;

// Shortcuts tab
@property (nonatomic, strong) NSTableView *shortcutsTableView;
@property (nonatomic, strong) NSMutableArray *shortcutItems;
@end

@implementation EnhancedPreferencesPanel

- (instancetype)initWithPreferences:(PreferencesManager *)preferences {
    NSRect frame = NSMakeRect(200, 200, 500, 400);
    
    self = [super initWithWindow:[[NSWindow alloc] initWithContentRect:frame
                                                           styleMask:NSWindowStyleMaskTitled |
                                                                     NSWindowStyleMaskClosable |
                                                                     NSWindowStyleMaskResizable
                                                             backing:NSBackingStoreBuffered
                                                               defer:NO]];
    
    if (self) {
        _preferences = preferences;
        [self setUpPreferencesPanel];
    }
    
    return self;
}

- (void)setUpPreferencesPanel {
    [[self window] setTitle:[LocalizationManager.sharedManager localizedStringForKey:@"preferences_title"]];
    [[self window] setDelegate:self];
    [[self window] setMinSize:NSMakeSize(400, 300)];
    
    NSView *contentView = [[NSView alloc] initWithFrame:NSMakeRect(0, 0, 500, 400)];
    [[self window] setContentView:contentView];
    
    // Create tab view
    self.tabView = [[NSTabView alloc] initWithFrame:NSMakeRect(20, 60, 460, 320)];
    
    // General tab
    [self createGeneralTab];
    
    // Editor tab
    [self createEditorTab];
    
    // View tab
    [self createViewTab];
    
    // Shortcuts tab
    [self createShortcutsTab];
    
    [contentView addSubview:self.tabView];
    
    // OK button
    self.okButton = [[NSButton alloc] initWithFrame:NSMakeRect(400, 20, 80, 25)];
    [self.okButton setTitle:[LocalizationManager.sharedManager localizedStringForKey:@"button_ok"]];
    [self.okButton setBezelStyle:NSPushButtonBezelStyle];
    [self.okButton setAction:@selector(okClicked:)];
    [self.okButton setTarget:self];
    [contentView addSubview:self.okButton];
    
    // Cancel button
    self.cancelButton = [[NSButton alloc] initWithFrame:NSMakeRect(310, 20, 80, 25)];
    [self.cancelButton setTitle:[LocalizationManager.sharedManager localizedStringForKey:@"button_cancel"]];
    [self.cancelButton setBezelStyle:NSPushButtonBezelStyle];
    [self.cancelButton setAction:@selector(cancelClicked:)];
    [self.cancelButton setTarget:self];
    [contentView addSubview:self.cancelButton];
    
    // Apply button
    self.applyButton = [[NSButton alloc] initWithFrame:NSMakeRect(220, 20, 80, 25)];
    [self.applyButton setTitle:[LocalizationManager.sharedManager localizedStringForKey:@"button_apply"]];
    [self.applyButton setBezelStyle:NSPushButtonBezelStyle];
    [self.applyButton setAction:@selector(applyClicked:)];
    [self.applyButton setTarget:self];
    [self.applyButton setEnabled:NO];
    [contentView addSubview:self.applyButton];
}

- (void)createGeneralTab {
    NSTabViewItem *generalTab = [[NSTabViewItem alloc] initWithIdentifier:@"General"];
    [generalTab setLabel:[LocalizationManager.sharedManager localizedStringForKey:@"preferences_general"]];
    
    NSView *generalView = [[NSView alloc] initWithFrame:NSMakeRect(0, 0, 460, 320)];
    
    // Auto-save checkbox
    self.autoSaveCheckbox = [[NSButton alloc] initWithFrame:NSMakeRect(20, 280, 200, 20)];
    [self.autoSaveCheckbox setButtonType:NSSwitchButton];
    [self.autoSaveCheckbox setTitle:[LocalizationManager.sharedManager localizedStringForKey:@"preferences_auto_save_documents"]];
    [self.autoSaveCheckbox setState:self.preferences.autoSave ? NSControlStateValueOn : NSControlStateValueOff];
    [generalView addSubview:self.autoSaveCheckbox];
    
    // Restore session checkbox
    self.restoreSessionCheckbox = [[NSButton alloc] initWithFrame:NSMakeRect(20, 250, 200, 20)];
    [self.restoreSessionCheckbox setButtonType:NSSwitchButton];
    [self.restoreSessionCheckbox setTitle:[LocalizationManager.sharedManager localizedStringForKey:@"preferences_restore_last_session"]];
    [self.restoreSessionCheckbox setState:self.preferences.restoreLastSession ? NSControlStateValueOn : NSControlStateValueOff];
    [generalView addSubview:self.restoreSessionCheckbox];
    
    [generalTab setView:generalView];
    [self.tabView addTabViewItem:generalTab];
}

- (void)createEditorTab {
    NSTabViewItem *editorTab = [[NSTabViewItem alloc] initWithIdentifier:@"Editor"];
    [editorTab setLabel:[LocalizationManager.sharedManager localizedStringForKey:@"preferences_editor"]];
    
    NSView *editorView = [[NSView alloc] initWithFrame:NSMakeRect(0, 0, 460, 320)];
    
    // Tab width label and field
    NSTextField *tabWidthLabel = [[NSTextField alloc] initWithFrame:NSMakeRect(20, 280, 100, 20)];
    [tabWidthLabel setStringValue:[LocalizationManager.sharedManager localizedStringForKey:@"preferences_tab_width"]];
    [tabWidthLabel setEditable:NO];
    [tabWidthLabel setBordered:NO];
    [tabWidthLabel setDrawsBackground:NO];
    [editorView addSubview:tabWidthLabel];
    
    self.tabWidthField = [[NSTextField alloc] initWithFrame:NSMakeRect(130, 280, 50, 24)];
    [self.tabWidthField setStringValue:[NSString stringWithFormat:@"%lu", (unsigned long)self.preferences.tabWidth]];
    [self.tabWidthField setAlignment:NSCenterTextAlignment];
    [editorView addSubview:self.tabWidthField];
    
    // Spaces instead of tabs checkbox
    self.spacesInsteadOfTabsCheckbox = [[NSButton alloc] initWithFrame:NSMakeRect(20, 250, 200, 20)];
    [self.spacesInsteadOfTabsCheckbox setButtonType:NSSwitchButton];
    [self.spacesInsteadOfTabsCheckbox setTitle:[LocalizationManager.sharedManager localizedStringForKey:@"preferences_insert_spaces_instead_of_tabs"]];
    [self.spacesInsteadOfTabsCheckbox setState:self.preferences.useSpacesInsteadOfTabs ? NSControlStateValueOn : NSControlStateValueOff];
    [editorView addSubview:self.spacesInsteadOfTabsCheckbox];
    
    // Line numbers checkbox
    self.lineNumbersCheckbox = [[NSButton alloc] initWithFrame:NSMakeRect(20, 220, 200, 20)];
    [self.lineNumbersCheckbox setButtonType:NSSwitchButton];
    [self.lineNumbersCheckbox setTitle:[LocalizationManager.sharedManager localizedStringForKey:@"preferences_show_line_numbers"]];
    [self.lineNumbersCheckbox setState:self.preferences.showLineNumbers ? NSControlStateValueOn : NSControlStateValueOff];
    [editorView addSubview:self.lineNumbersCheckbox];
    
    // White space checkbox
    self.whiteSpaceCheckbox = [[NSButton alloc] initWithFrame:NSMakeRect(20, 190, 200, 20)];
    [self.whiteSpaceCheckbox setButtonType:NSSwitchButton];
    [self.whiteSpaceCheckbox setTitle:[LocalizationManager.sharedManager localizedStringForKey:@"preferences_show_white_space"]];
    [self.whiteSpaceCheckbox setState:self.preferences.showWhiteSpace ? NSControlStateValueOn : NSControlStateValueOff];
    [editorView addSubview:self.whiteSpaceCheckbox];
    
    // Font size label and field
    NSTextField *fontSizeLabel = [[NSTextField alloc] initWithFrame:NSMakeRect(20, 160, 100, 20)];
    [fontSizeLabel setStringValue:[LocalizationManager.sharedManager localizedStringForKey:@"preferences_font_size"]];
    [fontSizeLabel setEditable:NO];
    [fontSizeLabel setBordered:NO];
    [fontSizeLabel setDrawsBackground:NO];
    [editorView addSubview:fontSizeLabel];
    
    self.fontSizeField = [[NSTextField alloc] initWithFrame:NSMakeRect(130, 160, 50, 24)];
    [self.fontSizeField setStringValue:[NSString stringWithFormat:@"%lu", (unsigned long)self.preferences.fontSize]];
    [self.fontSizeField setAlignment:NSCenterTextAlignment];
    [editorView addSubview:self.fontSizeField];
    
    // Font family label and popup
    NSTextField *fontFamilyLabel = [[NSTextField alloc] initWithFrame:NSMakeRect(20, 130, 100, 20)];
    [fontFamilyLabel setStringValue:[LocalizationManager.sharedManager localizedStringForKey:@"preferences_font_family"]];
    [fontFamilyLabel setEditable:NO];
    [fontFamilyLabel setBordered:NO];
    [fontFamilyLabel setDrawsBackground:NO];
    [editorView addSubview:fontFamilyLabel];
    
    self.fontFamilyPopup = [[NSPopUpButton alloc] initWithFrame:NSMakeRect(130, 130, 200, 24)];
    // Add common fonts
    [self.fontFamilyPopup addItemsWithTitles:@[@"Menlo", @"Monaco", @"Courier New", @"Arial", @"Helvetica"]];
    [self.fontFamilyPopup selectItemWithTitle:self.preferences.fontFamily ?: @"Menlo"];
    [editorView addSubview:self.fontFamilyPopup];
    
    [editorTab setView:editorView];
    [self.tabView addTabViewItem:editorTab];
}

- (void)createViewTab {
    NSTabViewItem *viewTab = [[NSTabViewItem alloc] initWithIdentifier:@"View"];
    [viewTab setLabel:[LocalizationManager.sharedManager localizedStringForKey:@"preferences_view"]];
    
    NSView *viewView = [[NSView alloc] initWithFrame:NSMakeRect(0, 0, 460, 320)];
    
    // Wrap lines checkbox
    self.wrapLinesCheckbox = [[NSButton alloc] initWithFrame:NSMakeRect(20, 280, 200, 20)];
    [self.wrapLinesCheckbox setButtonType:NSSwitchButton];
    [self.wrapLinesCheckbox setTitle:[LocalizationManager.sharedManager localizedStringForKey:@"preferences_wrap_lines"]];
    [self.wrapLinesCheckbox setState:self.preferences.wrapLines ? NSControlStateValueOn : NSControlStateValueOff];
    [viewView addSubview:self.wrapLinesCheckbox];
    
    // Menu bar checkbox
    self.menuBarCheckbox = [[NSButton alloc] initWithFrame:NSMakeRect(20, 250, 200, 20)];
    [self.menuBarCheckbox setButtonType:NSSwitchButton];
    [self.menuBarCheckbox setTitle:[LocalizationManager.sharedManager localizedStringForKey:@"preferences_show_menu_bar"]];
    [self.menuBarCheckbox setState:self.preferences.showMenuBar ? NSControlStateValueOn : NSControlStateValueOff];
    [viewView addSubview:self.menuBarCheckbox];
    
    // Tool bar checkbox
    self.toolBarCheckbox = [[NSButton alloc] initWithFrame:NSMakeRect(20, 220, 200, 20)];
    [self.toolBarCheckbox setButtonType:NSSwitchButton];
    [self.toolBarCheckbox setTitle:[LocalizationManager.sharedManager localizedStringForKey:@"preferences_show_tool_bar"]];
    [self.toolBarCheckbox setState:self.preferences.showToolBar ? NSControlStateValueOn : NSControlStateValueOff];
    [viewView addSubview:self.toolBarCheckbox];
    
    // Status bar checkbox
    self.statusBarCheckbox = [[NSButton alloc] initWithFrame:NSMakeRect(20, 190, 200, 20)];
    [self.statusBarCheckbox setButtonType:NSSwitchButton];
    [self.statusBarCheckbox setTitle:[LocalizationManager.sharedManager localizedStringForKey:@"preferences_show_status_bar"]];
    [self.statusBarCheckbox setState:self.preferences.showStatusBar ? NSControlStateValueOn : NSControlStateValueOff];
    [viewView addSubview:self.statusBarCheckbox];
    
    [viewTab setView:viewView];
    [self.tabView addTabViewItem:viewTab];
}

- (void)createShortcutsTab {
    NSTabViewItem *shortcutsTab = [[NSTabViewItem alloc] initWithIdentifier:@"Shortcuts"];
    [shortcutsTab setLabel:[LocalizationManager.sharedManager localizedStringForKey:@"preferences_shortcuts"]];
    
    NSView *shortcutsView = [[NSView alloc] initWithFrame:NSMakeRect(0, 0, 460, 320)];
    
    // Create table view for shortcuts
    NSRect tableFrame = NSMakeRect(20, 20, 420, 280);
    self.shortcutsTableView = [[NSTableView alloc] initWithFrame:tableFrame];
    
    // Create scroll view for table
    NSScrollView *scrollView = [[NSScrollView alloc] initWithFrame:tableFrame];
    scrollView.hasVerticalScroller = YES;
    scrollView.hasHorizontalScroller = NO;
    scrollView.autohidesScrollers = YES;
    scrollView.borderType = NSBezelBorder;
    
    // Setup table columns
    NSTableColumn *actionColumn = [[NSTableColumn alloc] initWithIdentifier:@"Action"];
    [actionColumn setWidth:200];
    [actionColumn.headerCell setTitle:@"Action"];
    [self.shortcutsTableView addTableColumn:actionColumn];
    
    NSTableColumn *shortcutColumn = [[NSTableColumn alloc] initWithIdentifier:@"Shortcut"];
    [shortcutColumn setWidth:200];
    [shortcutColumn.headerCell setTitle:@"Shortcut"];
    [self.shortcutsTableView addTableColumn:shortcutColumn];
    
    // Setup data source and delegate
    self.shortcutItems = [self loadShortcutItems];
    self.shortcutsTableView.dataSource = self;
    self.shortcutsTableView.delegate = self;
    
    scrollView.documentView = self.shortcutsTableView;
    [shortcutsView addSubview:scrollView];
    
    [shortcutsTab setView:shortcutsView];
    [self.tabView addTabViewItem:shortcutsTab];
}

- (NSMutableArray *)loadShortcutItems {
    // This would load actual shortcut data from ShortcutManager
    NSMutableArray *items = [NSMutableArray array];
    
    NSDictionary *newDocItem = @{@"action": @"New Document", @"shortcut": @"Cmd+N"};
    NSDictionary *openDocItem = @{@"action": @"Open Document", @"shortcut": @"Cmd+O"};
    NSDictionary *saveDocItem = @{@"action": @"Save Document", @"shortcut": @"Cmd+S"};
    NSDictionary *closeDocItem = @{@"action": @"Close Document", @"shortcut": @"Cmd+W"};
    NSDictionary *findItem = @{@"action": @"Find", @"shortcut": @"Cmd+F"};
    NSDictionary *replaceItem = @{@"action": @"Replace", @"shortcut": @"Cmd+H"};
    
    [items addObject:newDocItem];
    [items addObject:openDocItem];
    [items addObject:saveDocItem];
    [items addObject:closeDocItem];
    [items addObject:findItem];
    [items addObject:replaceItem];
    
    return items;
}

- (void)showPanel {
    [self updateUIWithPreferences];
    [[self window] makeKeyAndOrderFront:nil];
    [[self window] center];
    [NSApp activateIgnoringOtherApps:YES];
}

- (void)closePanel {
    [[self window] close];
}

- (void)updateUIWithPreferences {
    // General tab
    [self.autoSaveCheckbox setState:self.preferences.autoSave ? NSControlStateValueOn : NSControlStateValueOff];
    [self.restoreSessionCheckbox setState:self.preferences.restoreLastSession ? NSControlStateValueOn : NSControlStateValueOff];
    
    // Editor tab
    [self.tabWidthField setStringValue:[NSString stringWithFormat:@"%lu", (unsigned long)self.preferences.tabWidth]];
    [self.spacesInsteadOfTabsCheckbox setState:self.preferences.useSpacesInsteadOfTabs ? NSControlStateValueOn : NSControlStateValueOff];
    [self.lineNumbersCheckbox setState:self.preferences.showLineNumbers ? NSControlStateValueOn : NSControlStateValueOff];
    [self.whiteSpaceCheckbox setState:self.preferences.showWhiteSpace ? NSControlStateValueOn : NSControlStateValueOff];
    [self.fontSizeField setStringValue:[NSString stringWithFormat:@"%lu", (unsigned long)self.preferences.fontSize]];
    [self.fontFamilyPopup selectItemWithTitle:self.preferences.fontFamily ?: @"Menlo"];
    
    // View tab
    [self.wrapLinesCheckbox setState:self.preferences.wrapLines ? NSControlStateValueOn : NSControlStateValueOff];
    [self.menuBarCheckbox setState:self.preferences.showMenuBar ? NSControlStateValueOn : NSControlStateValueOff];
    [self.toolBarCheckbox setState:self.preferences.showToolBar ? NSControlStateValueOn : NSControlStateValueOff];
    [self.statusBarCheckbox setState:self.preferences.showStatusBar ? NSControlStateValueOn : NSControlStateValueOff];
    
    // Reload shortcuts table
    self.shortcutItems = [self loadShortcutItems];
    [self.shortcutsTableView reloadData];
}

- (void)applyPreferences {
    // General tab
    self.preferences.autoSave = [self.autoSaveCheckbox state] == NSControlStateValueOn;
    self.preferences.restoreLastSession = [self.restoreSessionCheckbox state] == NSControlStateValueOn;
    
    // Editor tab
    NSInteger tabWidth = [self.tabWidthField.stringValue integerValue];
    if (tabWidth > 0) {
        self.preferences.tabWidth = tabWidth;
    }
    
    self.preferences.useSpacesInsteadOfTabs = [self.spacesInsteadOfTabsCheckbox state] == NSControlStateValueOn;
    self.preferences.showLineNumbers = [self.lineNumbersCheckbox state] == NSControlStateValueOn;
    self.preferences.showWhiteSpace = [self.whiteSpaceCheckbox state] == NSControlStateValueOn;
    
    NSInteger fontSize = [self.fontSizeField.stringValue integerValue];
    if (fontSize > 0) {
        self.preferences.fontSize = fontSize;
    }
    
    self.preferences.fontFamily = [self.fontFamilyPopup titleOfSelectedItem];
    
    // View tab
    self.preferences.wrapLines = [self.wrapLinesCheckbox state] == NSControlStateValueOn;
    self.preferences.showMenuBar = [self.menuBarCheckbox state] == NSControlStateValueOn;
    self.preferences.showToolBar = [self.toolBarCheckbox state] == NSControlStateValueOn;
    self.preferences.showStatusBar = [self.statusBarCheckbox state] == NSControlStateValueOn;
    
    // Save preferences
    [self.preferences savePreferences];
    
    // Disable apply button since changes are now saved
    [self.applyButton setEnabled:NO];
}

- (IBAction)okClicked:(id)sender {
    [self applyPreferences];
    [self closePanel];
}

- (IBAction)cancelClicked:(id)sender {
    [self closePanel];
}

- (IBAction)applyClicked:(id)sender {
    [self applyPreferences];
}

#pragma mark - NSTableViewDataSource

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return self.shortcutItems.count;
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    if (row >= self.shortcutItems.count) return nil;
    
    NSDictionary *item = self.shortcutItems[row];
    
    if ([[tableColumn identifier] isEqualToString:@"Action"]) {
        return item[@"action"];
    } else if ([[tableColumn identifier] isEqualToString:@"Shortcut"]) {
        return item[@"shortcut"];
    }
    
    return nil;
}

#pragma mark - NSWindowDelegate

- (void)windowWillClose:(NSNotification *)notification {
    // Clean up if needed
}

@end