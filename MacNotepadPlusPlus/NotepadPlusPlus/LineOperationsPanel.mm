//
//  LineOperationsPanel.m
//  NotepadPlusPlus
//
//  Created by Assistant on 12/12/2025.
//

#import "LineOperationsPanel.h"
#import "ScintillaView.h"

@interface LineOperationsPanel() {
    NSWindow *_panel;
    NSButton *_removeEmptyLinesButton;
    NSButton *_removeDuplicateLinesButton;
    NSButton *_sortLinesAscButton;
    NSButton *_sortLinesDescButton;
    NSButton *_applyButton;
    NSButton *_cancelButton;
    NotepadDocumentWindowController *_windowController;
}

@end

@implementation LineOperationsPanel

+ (LineOperationsPanel *)sharedPanel {
    static LineOperationsPanel *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[LineOperationsPanel alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self createPanel];
    }
    return self;
}

- (void)createPanel {
    // Create panel window
    NSRect frame = NSMakeRect(0, 0, 350, 250);
    _panel = [[NSWindow alloc] initWithContentRect:frame
                                         styleMask:NSWindowStyleMaskTitled | NSWindowStyleMaskClosable
                                           backing:NSBackingStoreBuffered
                                             defer:NO];
    [_panel setTitle:@"Line Operations"];
    
    // Create main view
    NSView *contentView = [[NSView alloc] initWithFrame:frame];
    [_panel setContentView:contentView];
    
    // Title label
    NSTextField *titleLabel = [[NSTextField alloc] initWithFrame:NSMakeRect(20, 210, 300, 20)];
    [titleLabel setStringValue:@"Select line operations to perform:"];
    [titleLabel setEditable:NO];
    [titleLabel setBordered:NO];
    [titleLabel setDrawsBackground:NO];
    [titleLabel setFont:[NSFont boldSystemFontOfSize:[NSFont systemFontSize]]];
    [contentView addSubview:titleLabel];
    
    // Remove empty lines checkbox
    _removeEmptyLinesButton = [[NSButton alloc] initWithFrame:NSMakeRect(20, 180, 300, 20)];
    [_removeEmptyLinesButton setTitle:@"Remove Empty Lines"];
    [_removeEmptyLinesButton setButtonType:NSButtonTypeSwitch];
    [_removeEmptyLinesButton setState:NSControlStateValueOff];
    [contentView addSubview:_removeEmptyLinesButton];
    
    // Remove duplicate lines checkbox
    _removeDuplicateLinesButton = [[NSButton alloc] initWithFrame:NSMakeRect(20, 150, 300, 20)];
    [_removeDuplicateLinesButton setTitle:@"Remove Duplicate Lines"];
    [_removeDuplicateLinesButton setButtonType:NSButtonTypeSwitch];
    [_removeDuplicateLinesButton setState:NSControlStateValueOff];
    [contentView addSubview:_removeDuplicateLinesButton];
    
    // Sort lines ascending checkbox
    _sortLinesAscButton = [[NSButton alloc] initWithFrame:NSMakeRect(20, 120, 300, 20)];
    [_sortLinesAscButton setTitle:@"Sort Lines (Ascending)"];
    [_sortLinesAscButton setButtonType:NSButtonTypeSwitch];
    [_sortLinesAscButton setState:NSControlStateValueOff];
    [contentView addSubview:_sortLinesAscButton];
    
    // Sort lines descending checkbox
    _sortLinesDescButton = [[NSButton alloc] initWithFrame:NSMakeRect(20, 90, 300, 20)];
    [_sortLinesDescButton setTitle:@"Sort Lines (Descending)"];
    [_sortLinesDescButton setButtonType:NSButtonTypeSwitch];
    [_sortLinesDescButton setState:NSControlStateValueOff];
    [contentView addSubview:_sortLinesDescButton];
    
    // Apply button
    _applyButton = [[NSButton alloc] initWithFrame:NSMakeRect(180, 20, 90, 32)];
    [_applyButton setTitle:@"Apply"];
    [_applyButton setBezelStyle:NSBezelStyleRounded];
    [_applyButton setAction:@selector(apply:)];
    [_applyButton setTarget:self];
    [contentView addSubview:_applyButton];
    
    // Cancel button
    _cancelButton = [[NSButton alloc] initWithFrame:NSMakeRect(280, 20, 90, 32)];
    [_cancelButton setTitle:@"Cancel"];
    [_cancelButton setBezelStyle:NSBezelStyleRounded];
    [_cancelButton setAction:@selector(cancel:)];
    [_cancelButton setTarget:self];
    [contentView addSubview:_cancelButton];
}

- (void)showPanelWithWindowController:(NotepadDocumentWindowController *)windowController {
    _windowController = windowController;
    
    // Reset checkboxes
    [_removeEmptyLinesButton setState:NSControlStateValueOff];
    [_removeDuplicateLinesButton setState:NSControlStateValueOff];
    [_sortLinesAscButton setState:NSControlStateValueOff];
    [_sortLinesDescButton setState:NSControlStateValueOff];
    
    // Center panel on screen
    NSRect screenFrame = [[NSScreen mainScreen] visibleFrame];
    NSRect panelFrame = [_panel frame];
    NSPoint center = NSMakePoint(NSMidX(screenFrame) - NSWidth(panelFrame) / 2,
                                NSMidY(screenFrame) - NSHeight(panelFrame) / 2);
    [_panel setFrameOrigin:center];
    
    [_panel makeKeyAndOrderFront:nil];
    [NSApp activateIgnoringOtherApps:YES];
}

- (IBAction)apply:(id)sender {
    BOOL hasOperationSelected = 
        [_removeEmptyLinesButton state] == NSControlStateValueOn ||
        [_removeDuplicateLinesButton state] == NSControlStateValueOn ||
        [_sortLinesAscButton state] == NSControlStateValueOn ||
        [_sortLinesDescButton state] == NSControlStateValueOn;
    
    if (!hasOperationSelected) {
        NSAlert *alert = [NSAlert alertWithMessageText:@"No Operation Selected"
                                         defaultButton:@"OK"
                                       alternateButton:nil
                                           otherButton:nil
                             informativeTextWithFormat:@"Please select at least one line operation."];
        [alert runModal];
        return;
    }
    
    NSMutableString *message = [NSMutableString stringWithString:@"The following operations would be performed:\n\n"];
    
    if ([_removeEmptyLinesButton state] == NSControlStateValueOn) {
        [message appendString:@"• Remove Empty Lines\n"];
    }
    
    if ([_removeDuplicateLinesButton state] == NSControlStateValueOn) {
        [message appendString:@"• Remove Duplicate Lines\n"];
    }
    
    if ([_sortLinesAscButton state] == NSControlStateValueOn) {
        [message appendString:@"• Sort Lines (Ascending)\n"];
    }
    
    if ([_sortLinesDescButton state] == NSControlStateValueOn) {
        [message appendString:@"• Sort Lines (Descending)\n"];
    }
    
    [message appendString:@"\nIn a full implementation, these operations would be applied to the document."];
    
    NSAlert *alert = [NSAlert alertWithMessageText:@"Line Operations"
                                     defaultButton:@"OK"
                                   alternateButton:nil
                                       otherButton:nil
                         informativeTextWithFormat:@"%@", message];
    [alert runModal];
    
    [_panel orderOut:nil];
}

- (IBAction)cancel:(id)sender {
    [_panel orderOut:nil];
}

@end