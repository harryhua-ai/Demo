//
//  EncodingConverterPanel.m
//  NotepadPlusPlus
//
//  Created by Assistant on 12/12/2025.
//

#import "EncodingConverterPanel.h"
#import "EncodingManager.h"
#import "LocalizationManager.h"

@interface EncodingConverterPanel() {
    NSWindow *_panel;
    NSPopUpButton *_sourceEncodingPopup;
    NSPopUpButton *_targetEncodingPopup;
    NSButton *_convertButton;
    NSButton *_cancelButton;
    NotepadDocumentWindowController *_windowController;
}

@end

@implementation EncodingConverterPanel

+ (EncodingConverterPanel *)sharedPanel {
    static EncodingConverterPanel *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[EncodingConverterPanel alloc] init];
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
    NSRect frame = NSMakeRect(0, 0, 400, 200);
    _panel = [[NSWindow alloc] initWithContentRect:frame
                                         styleMask:NSWindowStyleMaskTitled | NSWindowStyleMaskClosable
                                           backing:NSBackingStoreBuffered
                                             defer:NO];
    [_panel setTitle:@"Convert Encoding"];
    
    // Create main view
    NSView *contentView = [[NSView alloc] initWithFrame:frame];
    [_panel setContentView:contentView];
    
    // Source encoding label
    NSTextField *sourceLabel = [[NSTextField alloc] initWithFrame:NSMakeRect(20, 160, 150, 20)];
    [sourceLabel setStringValue:@"Source Encoding:"];
    [sourceLabel setEditable:NO];
    [sourceLabel setBordered:NO];
    [sourceLabel setDrawsBackground:NO];
    [contentView addSubview:sourceLabel];
    
    // Source encoding popup
    _sourceEncodingPopup = [[NSPopUpButton alloc] initWithFrame:NSMakeRect(180, 155, 200, 26)];
    [self populateEncodingPopup:_sourceEncodingPopup];
    [contentView addSubview:_sourceEncodingPopup];
    
    // Target encoding label
    NSTextField *targetLabel = [[NSTextField alloc] initWithFrame:NSMakeRect(20, 120, 150, 20)];
    [targetLabel setStringValue:@"Target Encoding:"];
    [targetLabel setEditable:NO];
    [targetLabel setBordered:NO];
    [targetLabel setDrawsBackground:NO];
    [contentView addSubview:targetLabel];
    
    // Target encoding popup
    _targetEncodingPopup = [[NSPopUpButton alloc] initWithFrame:NSMakeRect(180, 115, 200, 26)];
    [self populateEncodingPopup:_targetEncodingPopup];
    [contentView addSubview:_targetEncodingPopup];
    
    // Convert button
    _convertButton = [[NSButton alloc] initWithFrame:NSMakeRect(220, 20, 90, 32)];
    [_convertButton setTitle:@"Convert"];
    [_convertButton setBezelStyle:NSBezelStyleRounded];
    [_convertButton setAction:@selector(convert:)];
    [_convertButton setTarget:self];
    [contentView addSubview:_convertButton];
    
    // Cancel button
    _cancelButton = [[NSButton alloc] initWithFrame:NSMakeRect(320, 20, 90, 32)];
    [_cancelButton setTitle:@"Cancel"];
    [_cancelButton setBezelStyle:NSBezelStyleRounded];
    [_cancelButton setAction:@selector(cancel:)];
    [_cancelButton setTarget:self];
    [contentView addSubview:_cancelButton];
}

- (void)populateEncodingPopup:(NSPopUpButton *)popup {
    EncodingManager *encodingManager = [EncodingManager sharedManager];
    NSArray *encodings = [encodingManager getSupportedEncodings];
    
    for (NSString *encoding in encodings) {
        NSString *localizedName = [encodingManager getLocalizedNameForEncoding:encoding];
        [popup addItemWithTitle:localizedName];
        [[popup lastItem] setRepresentedObject:encoding];
    }
}

- (void)showPanelWithWindowController:(NotepadDocumentWindowController *)windowController {
    _windowController = windowController;
    
    // Center panel on screen
    NSRect screenFrame = [[NSScreen mainScreen] visibleFrame];
    NSRect panelFrame = [_panel frame];
    NSPoint center = NSMakePoint(NSMidX(screenFrame) - NSWidth(panelFrame) / 2,
                                NSMidY(screenFrame) - NSHeight(panelFrame) / 2);
    [_panel setFrameOrigin:center];
    
    [_panel makeKeyAndOrderFront:nil];
    [NSApp activateIgnoringOtherApps:YES];
}

- (IBAction)convert:(id)sender {
    // Get selected encodings
    NSMenuItem *sourceItem = [_sourceEncodingPopup selectedItem];
    NSMenuItem *targetItem = [_targetEncodingPopup selectedItem];
    
    NSString *sourceEncoding = [sourceItem representedObject];
    NSString *targetEncoding = [targetItem representedObject];
    
    if ([sourceEncoding isEqualToString:targetEncoding]) {
        NSAlert *alert = [NSAlert alertWithMessageText:@"Same Encodings"
                                         defaultButton:@"OK"
                                       alternateButton:nil
                                           otherButton:nil
                             informativeTextWithFormat:@"Source and target encodings are the same."];
        [alert runModal];
        return;
    }
    
    // In a real implementation, we would convert the document content here
    // For now, we'll just show a confirmation message
    NSAlert *alert = [NSAlert alertWithMessageText:@"Encoding Conversion"
                                     defaultButton:@"OK"
                                   alternateButton:nil
                                       otherButton:nil
                         informativeTextWithFormat:@"Document would be converted from %@ to %@", 
                         [EncodingManager.sharedManager getLocalizedNameForEncoding:sourceEncoding],
                         [EncodingManager.sharedManager getLocalizedNameForEncoding:targetEncoding]];
    [alert runModal];
    
    [_panel orderOut:nil];
}

- (IBAction)cancel:(id)sender {
    [_panel orderOut:nil];
}

@end