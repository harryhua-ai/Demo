//
//  PreferencesPanel.m
//  NotepadPlusPlus
//
//  Created by Assistant on 12/12/2025.
//

#import "PreferencesPanel.h"
#import "ShortcutPreferencesPanel.h"

@interface PreferencesPanel()
@property (nonatomic, strong) NSTabView *tabView;
@property (nonatomic, strong) NSButton *okButton;
@property (nonatomic, strong) NSButton *cancelButton;

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
@end

@implementation PreferencesPanel

- (instancetype)initWithPreferences:(PreferencesManager *)preferences {
    NSRect frame = NSMakeRect(200, 200, 450, 350);
    
    self = [super initWithContentRect:frame
                             styleMask:NSWindowStyleMaskTitled | NSWindowStyleMaskClosable
                               backing:NSBackingStoreBuffered
                                 defer:NO];
    
    if (self) {
        _preferences = preferences;
        [self setUpPreferencesPanel];
        [self setTitle:@"Preferences"];
    }
    
    return self;
}

- (void)setUpPreferencesPanel {
    // Main view
    NSView *contentView = [[NSView alloc] initWithFrame:NSMakeRect(0, 0, 450, 350)];
    [self setContentView:contentView];
    
    // Create tab view
    self.tabView = [[NSTabView alloc] initWithFrame:NSMakeRect(20, 60, 410, 270)];
    
    // General tab
    [self createGeneralTab];
    
    // Editor tab
    [self createEditorTab];
    
    // View tab
    [self createViewTab];
    
    [contentView addSubview:self.tabView];
    
    // OK button
    self.okButton = [[NSButton alloc] initWithFrame:NSMakeRect(340, 20, 80, 25)];
    [self.okButton setTitle:@"OK"];
    [self.okButton setBezelStyle:NSPushButtonBezelStyle];
    [self.okButton setAction:@selector(okClicked:)];
    [self.okButton setTarget:self];
    [contentView addSubview:self.okButton];
    
    // Cancel button
    self.cancelButton = [[NSButton alloc] initWithFrame:NSMakeRect(250, 20, 80, 25)];
    [self.cancelButton setTitle:@"Cancel"];
    [self.cancelButton setBezelStyle:NSPushButtonBezelStyle];
    [self.cancelButton setAction:@selector(cancelClicked:)];
    [self.cancelButton setTarget:self];
    [contentView addSubview:self.cancelButton];
}

- (void)createGeneralTab {
    NSTabViewItem *generalTab = [[NSTabViewItem alloc] initWithIdentifier:@"General"];
    [generalTab setLabel:@"General"];
    
    NSView *generalView = [[NSView alloc] initWithFrame:NSMakeRect(0, 0, 410, 270)];
    
    // Auto-save checkbox
    self.autoSaveCheckbox = [[NSButton alloc] initWithFrame:NSMakeRect(20, 230, 200, 20)];
    [self.autoSaveCheckbox setButtonType:NSSwitchButton];
    [self.autoSaveCheckbox setTitle:@"Auto-save documents"];
    [self.autoSaveCheckbox setState:self.preferences.autoSave ? NSControlStateValueOn : NSControlStateValueOff];
    [generalView addSubview:self.autoSaveCheckbox];
    
    // Restore session checkbox
    self.restoreSessionCheckbox = [[NSButton alloc] initWithFrame:NSMakeRect(20, 200, 200, 20)];
    [self.restoreSessionCheckbox setButtonType:NSSwitchButton];
    [self.restoreSessionCheckbox setTitle:@"Restore last session"];
    [self.restoreSessionCheckbox setState:self.preferences.restoreLastSession ? NSControlStateValueOn : NSControlStateValueOff];
    [generalView addSubview:self.restoreSessionCheckbox];
    
    // Keyboard shortcuts button
    NSButton *shortcutsButton = [[NSButton alloc] initWithFrame:NSMakeRect(20, 170, 150, 25)];
    [shortcutsButton setTitle:@"Keyboard Shortcuts..."];
    [shortcutsButton setBezelStyle:NSPushButtonBezelStyle];
    [shortcutsButton setAction:@selector(showKeyboardShortcuts:)];
    [shortcutsButton setTarget:self];
    [generalView addSubview:shortcutsButton];
    
    [generalTab setView:generalView];
    [self.tabView addTabViewItem:generalTab];
}

- (void)createEditorTab {
    NSTabViewItem *editorTab = [[NSTabViewItem alloc] initWithIdentifier:@"Editor"];
    [editorTab setLabel:@"Editor"];
    
    NSView *editorView = [[NSView alloc] initWithFrame:NSMakeRect(0, 0, 410, 270)];
    
    // Tab width label
    NSTextField *tabWidthLabel = [[NSTextField alloc] initWithFrame:NSMakeRect(20, 230, 100, 20)];
    [tabWidthLabel setStringValue:@"Tab Width:"];
    [tabWidthLabel setBezeled:NO];
    [tabWidthLabel setDrawsBackground:NO];
    [tabWidthLabel setEditable:NO];
    [tabWidthLabel setSelectable:NO];
    [editorView addSubview:tabWidthLabel];
    
    // Tab width field
    self.tabWidthField = [[NSTextField alloc] initWithFrame:NSMakeRect(130, 230, 50, 20)];
    [self.tabWidthField setStringValue:[NSString stringWithFormat:@"%ld", (long)self.preferences.tabWidth]];
    [self.tabWidthField setAlignment:NSTextAlignmentRight];
    [editorView addSubview:self.tabWidthField];
    
    // Spaces instead of tabs checkbox
    self.spacesInsteadOfTabsCheckbox = [[NSButton alloc] initWithFrame:NSMakeRect(20, 200, 200, 20)];
    [self.spacesInsteadOfTabsCheckbox setButtonType:NSSwitchButton];
    [self.spacesInsteadOfTabsCheckbox setTitle:@"Insert spaces instead of tabs"];
    [self.spacesInsteadOfTabsCheckbox setState:self.preferences.useSpacesInsteadOfTabs ? NSControlStateValueOn : NSControlStateValueOff];
    [editorView addSubview:self.spacesInsteadOfTabsCheckbox];
    
    // Line numbers checkbox
    self.lineNumbersCheckbox = [[NSButton alloc] initWithFrame:NSMakeRect(20, 170, 200, 20)];
    [self.lineNumbersCheckbox setButtonType:NSSwitchButton];
    [self.lineNumbersCheckbox setTitle:@"Show line numbers"];
    [self.lineNumbersCheckbox setState:self.preferences.showLineNumbers ? NSControlStateValueOn : NSControlStateValueOff];
    [editorView addSubview:self.lineNumbersCheckbox];
    
    // White space checkbox
    self.whiteSpaceCheckbox = [[NSButton alloc] initWithFrame:NSMakeRect(20, 140, 200, 20)];
    [self.whiteSpaceCheckbox setButtonType:NSSwitchButton];
    [self.whiteSpaceCheckbox setTitle:@"Show white space"];
    [self.whiteSpaceCheckbox setState:self.preferences.showWhiteSpace ? NSControlStateValueOn : NSControlStateValueOff];
    [editorView addSubview:self.whiteSpaceCheckbox];
    
    // Font size label
    NSTextField *fontSizeLabel = [[NSTextField alloc] initWithFrame:NSMakeRect(20, 110, 100, 20)];
    [fontSizeLabel setStringValue:@"Font Size:"];
    [fontSizeLabel setBezeled:NO];
    [fontSizeLabel setDrawsBackground:NO];
    [fontSizeLabel setEditable:NO];
    [fontSizeLabel setSelectable:NO];
    [editorView addSubview:fontSizeLabel];
    
    // Font size field
    self.fontSizeField = [[NSTextField alloc] initWithFrame:NSMakeRect(130, 110, 50, 20)];
    [self.fontSizeField setStringValue:[NSString stringWithFormat:@"%ld", (long)self.preferences.fontSize]];
    [self.fontSizeField setAlignment:NSTextAlignmentRight];
    [editorView addSubview:self.fontSizeField];
    
    // Font family label
    NSTextField *fontFamilyLabel = [[NSTextField alloc] initWithFrame:NSMakeRect(20, 80, 100, 20)];
    [fontFamilyLabel setStringValue:@"Font Family:"];
    [fontFamilyLabel setBezeled:NO];
    [fontFamilyLabel setDrawsBackground:NO];
    [fontFamilyLabel setEditable:NO];
    [fontFamilyLabel setSelectable:NO];
    [editorView addSubview:fontFamilyLabel];
    
    // Font family popup
    self.fontFamilyPopup = [[NSPopUpButton alloc] initWithFrame:NSMakeRect(130, 80, 150, 25) pullsDown:NO];
    [self.fontFamilyPopup addItemWithTitle:@"Menlo"];
    [self.fontFamilyPopup addItemWithTitle:@"Monaco"];
    [self.fontFamilyPopup addItemWithTitle:@"Courier New"];
    [self.fontFamilyPopup addItemWithTitle:@"Andale Mono"];
    [self.fontFamilyPopup selectItemWithTitle:self.preferences.fontFamily];
    [editorView addSubview:self.fontFamilyPopup];
    
    [editorTab setView:editorView];
    [self.tabView addTabViewItem:editorTab];
}

- (void)createViewTab {
    NSTabViewItem *viewTab = [[NSTabViewItem alloc] initWithIdentifier:@"View"];
    [viewTab setLabel:@"View"];
    
    NSView *viewView = [[NSView alloc] initWithFrame:NSMakeRect(0, 0, 410, 270)];
    
    // Wrap lines checkbox
    self.wrapLinesCheckbox = [[NSButton alloc] initWithFrame:NSMakeRect(20, 230, 200, 20)];
    [self.wrapLinesCheckbox setButtonType:NSSwitchButton];
    [self.wrapLinesCheckbox setTitle:@"Wrap lines"];
    [self.wrapLinesCheckbox setState:self.preferences.wrapLines ? NSControlStateValueOn : NSControlStateValueOff];
    [viewView addSubview:self.wrapLinesCheckbox];
    
    // Menu bar checkbox
    self.menuBarCheckbox = [[NSButton alloc] initWithFrame:NSMakeRect(20, 200, 200, 20)];
    [self.menuBarCheckbox setButtonType:NSSwitchButton];
    [self.menuBarCheckbox setTitle:@"Show menu bar"];
    [self.menuBarCheckbox setState:self.preferences.showMenuBar ? NSControlStateValueOn : NSControlStateValueOff];
    [viewView addSubview:self.menuBarCheckbox];
    
    // Tool bar checkbox
    self.toolBarCheckbox = [[NSButton alloc] initWithFrame:NSMakeRect(20, 170, 200, 20)];
    [self.toolBarCheckbox setButtonType:NSSwitchButton];
    [self.toolBarCheckbox setTitle:@"Show tool bar"];
    [self.toolBarCheckbox setState:self.preferences.showToolBar ? NSControlStateValueOn : NSControlStateValueOff];
    [viewView addSubview:self.toolBarCheckbox];
    
    // Status bar checkbox
    self.statusBarCheckbox = [[NSButton alloc] initWithFrame:NSMakeRect(20, 140, 200, 20)];
    [self.statusBarCheckbox setButtonType:NSSwitchButton];
    [self.statusBarCheckbox setTitle:@"Show status bar"];
    [self.statusBarCheckbox setState:self.preferences.showStatusBar ? NSControlStateValueOn : NSControlStateValueOff];
    [viewView addSubview:self.statusBarCheckbox];
    
    [viewTab setView:viewView];
    [self.tabView addTabViewItem:viewTab];
}

- (void)showPanel:(id)sender {
    [self updateUIWithPreferences];
    [self makeKeyAndOrderFront:sender];
}

- (void)updateUIWithPreferences {
    // General tab
    [self.autoSaveCheckbox setState:self.preferences.autoSave ? NSControlStateValueOn : NSControlStateValueOff];
    [self.restoreSessionCheckbox setState:self.preferences.restoreLastSession ? NSControlStateValueOn : NSControlStateValueOff];
    
    // Editor tab
    [self.tabWidthField setStringValue:[NSString stringWithFormat:@"%ld", (long)self.preferences.tabWidth]];
    [self.spacesInsteadOfTabsCheckbox setState:self.preferences.useSpacesInsteadOfTabs ? NSControlStateValueOn : NSControlStateValueOff];
    [self.lineNumbersCheckbox setState:self.preferences.showLineNumbers ? NSControlStateValueOn : NSControlStateValueOff];
    [self.whiteSpaceCheckbox setState:self.preferences.showWhiteSpace ? NSControlStateValueOn : NSControlStateValueOff];
    [self.fontSizeField setStringValue:[NSString stringWithFormat:@"%ld", (long)self.preferences.fontSize]];
    [self.fontFamilyPopup selectItemWithTitle:self.preferences.fontFamily];
    
    // View tab
    [self.wrapLinesCheckbox setState:self.preferences.wrapLines ? NSControlStateValueOn : NSControlStateValueOff];
    [self.menuBarCheckbox setState:self.preferences.showMenuBar ? NSControlStateValueOn : NSControlStateValueOff];
    [self.toolBarCheckbox setState:self.preferences.showToolBar ? NSControlStateValueOn : NSControlStateValueOff];
    [self.statusBarCheckbox setState:self.preferences.showStatusBar ? NSControlStateValueOn : NSControlStateValueOff];
}

- (void)updatePreferencesWithUI {
    // General tab
    self.preferences.autoSave = [self.autoSaveCheckbox state] == NSControlStateValueOn;
    self.preferences.restoreLastSession = [self.restoreSessionCheckbox state] == NSControlStateValueOn;
    
    // Editor tab
    self.preferences.tabWidth = [self.tabWidthField.stringValue integerValue];
    self.preferences.useSpacesInsteadOfTabs = [self.spacesInsteadOfTabsCheckbox state] == NSControlStateValueOn;
    self.preferences.showLineNumbers = [self.lineNumbersCheckbox state] == NSControlStateValueOn;
    self.preferences.showWhiteSpace = [self.whiteSpaceCheckbox state] == NSControlStateValueOn;
    self.preferences.fontSize = [self.fontSizeField.stringValue integerValue];
    self.preferences.fontFamily = [self.fontFamilyPopup titleOfSelectedItem];
    
    // View tab
    self.preferences.wrapLines = [self.wrapLinesCheckbox state] == NSControlStateValueOn;
    self.preferences.showMenuBar = [self.menuBarCheckbox state] == NSControlStateValueOn;
    self.preferences.showToolBar = [self.toolBarCheckbox state] == NSControlStateValueOn;
    self.preferences.showStatusBar = [self.statusBarCheckbox state] == NSControlStateValueOn;
}

- (IBAction)okClicked:(id)sender {
    [self updatePreferencesWithUI];
    [self.preferences savePreferences];
    [self close];
}

- (IBAction)cancelClicked:(id)sender {
    [self close];
}

- (IBAction)showKeyboardShortcuts:(id)sender {
    ShortcutPreferencesPanel *shortcutPanel = [ShortcutPreferencesPanel sharedPanel];
    [shortcutPanel showPanel:sender];
}

@end