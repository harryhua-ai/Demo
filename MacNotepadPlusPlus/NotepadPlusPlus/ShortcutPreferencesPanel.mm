//
//  ShortcutPreferencesPanel.m
//  NotepadPlusPlus
//
//  Created by Assistant on 12/12/2025.
//

#import "ShortcutPreferencesPanel.h"

static ShortcutPreferencesPanel *sharedInstance = nil;

@implementation ShortcutPreferencesPanel

+ (instancetype)sharedPanel {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[ShortcutPreferencesPanel alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    NSRect frame = NSMakeRect(300, 300, 500, 400);
    self = [super initWithContentRect:frame
                            styleMask:NSWindowStyleMaskTitled | NSWindowStyleMaskClosable | NSWindowStyleMaskResizable
                              backing:NSBackingStoreBuffered
                                defer:NO];
    
    if (self) {
        [self setupPanel];
    }
    return self;
}

- (void)setupPanel {
    [self setTitle:@"Keyboard Shortcuts"];
    
    self.shortcutManager = [ShortcutManager sharedManager];
    self.editingShortcuts = [self.shortcutManager.shortcuts mutableCopy];
    
    NSView *contentView = [[NSView alloc] initWithFrame:NSMakeRect(0, 0, 500, 400)];
    [self setContentView:contentView];
    
    // Create table view
    NSRect tableFrame = NSMakeRect(20, 60, 460, 320);
    NSScrollView *scrollView = [[NSScrollView alloc] initWithFrame:tableFrame];
    [scrollView setHasVerticalScroller:YES];
    [scrollView setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
    
    self.tableView = [[NSTableView alloc] initWithFrame:NSMakeRect(0, 0, 460, 320)];
    [self.tableView setDataSource:self];
    [self.tableView setDelegate:self];
    
    // Create columns
    NSTableColumn *actionColumn = [[NSTableColumn alloc] initWithIdentifier:@"Action"];
    [actionColumn setWidth:200];
    [[actionColumn headerCell] setStringValue:@"Action"];
    [self.tableView addTableColumn:actionColumn];
    
    NSTableColumn *shortcutColumn = [[NSTableColumn alloc] initWithIdentifier:@"Shortcut"];
    [shortcutColumn setWidth:250];
    [[shortcutColumn headerCell] setStringValue:@"Shortcut"];
    [self.tableView addTableColumn:shortcutColumn];
    
    [self.tableView setHeaderView:nil];
    [scrollView setDocumentView:self.tableView];
    [contentView addSubview:scrollView];
    
    // Create buttons
    NSButton *resetButton = [[NSButton alloc] initWithFrame:NSMakeRect(20, 20, 80, 25)];
    [resetButton setTitle:@"Reset"];
    [resetButton setBezelStyle:NSPushButtonBezelStyle];
    [resetButton setAction:@selector(resetToDefaults:)];
    [resetButton setTarget:self];
    [contentView addSubview:resetButton];
    
    NSButton *okButton = [[NSButton alloc] initWithFrame:NSMakeRect(400, 20, 80, 25)];
    [okButton setTitle:@"OK"];
    [okButton setBezelStyle:NSPushButtonBezelStyle];
    [okButton setAction:@selector(okClicked:)];
    [okButton setTarget:self];
    [contentView addSubview:okButton];
    
    NSButton *cancelButton = [[NSButton alloc] initWithFrame:NSMakeRect(310, 20, 80, 25)];
    [cancelButton setTitle:@"Cancel"];
    [cancelButton setBezelStyle:NSPushButtonBezelStyle];
    [cancelButton setAction:@selector(cancelClicked:)];
    [cancelButton setTarget:self];
    [contentView addSubview:cancelButton];
    
    // Define shortcut keys with user-friendly names
    self.shortcutKeys = @[
        @{@"key": @"newDocument", @"name": @"New Document"},
        @{@"key": @"openDocument", @"name": @"Open Document"},
        @{@"key": @"closeDocument", @"name": @"Close Document"},
        @{@"key": @"saveDocument", @"name": @"Save Document"},
        @{@"key": @"saveDocumentAs", @"name": @"Save Document As"},
        @{@"key": @"printDocument", @"name": @"Print Document"},
        @{@"key": @"undo", @"name": @"Undo"},
        @{@"key": @"redo", @"name": @"Redo"},
        @{@"key": @"cut", @"name": @"Cut"},
        @{@"key": @"copy", @"name": @"Copy"},
        @{@"key": @"paste", @"name": @"Paste"},
        @{@"key": @"selectAll", @"name": @"Select All"},
        @{@"key": @"find", @"name": @"Find"},
        @{@"key": @"findNext", @"name": @"Find Next"},
        @{@"key": @"findPrevious", @"name": @"Find Previous"},
        @{@"key": @"replace", @"name": @"Replace"},
        @{@"key": @"zoomIn", @"name": @"Zoom In"},
        @{@"key": @"zoomOut", @"name": @"Zoom Out"},
        @{@"key": @"resetZoom", @"name": @"Reset Zoom"},
        @{@"key": @"toggleBookmark", @"name": @"Toggle Bookmark"},
        @{@"key": @"nextBookmark", @"name": @"Next Bookmark"},
        @{@"key": @"previousBookmark", @"name": @"Previous Bookmark"},
        @{@"key": @"startRecording", @"name": @"Start Recording"},
        @{@"key": @"playMacro", @"name": @"Play Macro"},
        @{@"key": @"goToLine", @"name": @"Go to Line"},
        @{@"key": @"collapseAllFolds", @"name": @"Collapse All Folds"},
        @{@"key": @"toggleCurrentFold", @"name": @"Toggle Current Fold"}
    ];
}

- (void)showPanel:(id)sender {
    if (!self.shortcutManager) {
        self.shortcutManager = [ShortcutManager sharedManager];
    }
    
    self.editingShortcuts = [self.shortcutManager.shortcuts mutableCopy];
    [self.tableView reloadData];
    [self makeKeyAndOrderFront:sender];
}

#pragma mark - NSTableViewDataSource

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return self.shortcutKeys.count;
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    NSDictionary *shortcutInfo = self.shortcutKeys[row];
    NSString *key = shortcutInfo[@"key"];
    NSString *name = shortcutInfo[@"name"];
    
    if ([[tableColumn identifier] isEqualToString:@"Action"]) {
        return name;
    } else if ([[tableColumn identifier] isEqualToString:@"Shortcut"]) {
        NSDictionary *shortcut = self.editingShortcuts[key];
        if (shortcut) {
            NSString *keyEquivalent = shortcut[@"keyEquivalent"];
            NSEventModifierFlags modifier = [shortcut[@"modifier"] unsignedLongValue];
            return [self stringFromKeyEquivalent:keyEquivalent modifier:modifier];
        }
        return @"None";
    }
    
    return @"";
}

#pragma mark - NSTableViewDelegate

- (void)tableView:(NSTableView *)tableView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    if ([[tableColumn identifier] isEqualToString:@"Shortcut"]) {
        [(NSCell *)cell setEditable:YES];
    } else {
        [(NSCell *)cell setEditable:NO];
    }
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification {
    // Handle selection change if needed
}

#pragma mark - Helper Methods

- (NSString *)stringFromKeyEquivalent:(NSString *)keyEquivalent modifier:(NSEventModifierFlags)modifier {
    NSMutableString *result = [[NSMutableString alloc] init];
    
    if (modifier & NSEventModifierFlagCommand) {
        [result appendString:@"⌘"];
    }
    if (modifier & NSEventModifierFlagShift) {
        [result appendString:@"⇧"];
    }
    if (modifier & NSEventModifierFlagOption) {
        [result appendString:@"⌥"];
    }
    if (modifier & NSEventModifierFlagControl) {
        [result appendString:@"⌃"];
    }
    
    if (keyEquivalent.length > 0) {
        if ([keyEquivalent isEqualToString:@" "]) {
            [result appendString:@"Space"];
        } else {
            [result appendString:keyEquivalent];
        }
    }
    
    return result;
}

#pragma mark - Actions

- (void)resetToDefaults:(id)sender {
    self.editingShortcuts = [[NSMutableDictionary alloc] init];
    [[ShortcutManager sharedManager] registerDefaultShortcuts];
    [self.editingShortcuts addEntriesFromDictionary:[[ShortcutManager sharedManager] shortcuts]];
    [self.tableView reloadData];
}

- (void)okClicked:(id)sender {
    // Apply changes
    self.shortcutManager.shortcuts = self.editingShortcuts;
    [self.shortcutManager saveCustomShortcuts];
    [self close];
}

- (void)cancelClicked:(id)sender {
    [self close];
}

@end