//
//  EnhancedPrintPanel.m
//  NotepadPlusPlus
//
//  Created by Assistant on 12/12/2025.
//

#import "EnhancedPrintPanel.h"
#import "ScintillaCocoa.h"
#import "LocalizationManager.h"

@interface EnhancedPrintPanel() <NSWindowDelegate>
@property (nonatomic, strong) NSPrintInfo *printInfo;
@property (nonatomic, strong) NSButton *printButton;
@property (nonatomic, strong) NSButton *cancelButton;
@property (nonatomic, strong) NSButton *previewButton;
@property (nonatomic, strong) NSButton *headerFooterCheckbox;
@property (nonatomic, strong) NSButton *lineNumbersCheckbox;
@property (nonatomic, strong) NSButton *colorCheckbox;
@property (nonatomic, strong) NSButton *wrapLinesCheckbox;
@property (nonatomic, strong) NSTextField *headerTextField;
@property (nonatomic, strong) NSTextField *footerTextField;
@property (nonatomic, strong) NSPopUpButton *marginsPopup;
@end

@implementation EnhancedPrintPanel

- (instancetype)initWithTextView:(ScintillaView *)textView {
    NSRect frame = NSMakeRect(200, 200, 400, 350);
    
    self = [super initWithWindow:[[NSWindow alloc] initWithContentRect:frame
                                                           styleMask:NSWindowStyleMaskTitled |
                                                                     NSWindowStyleMaskClosable
                                                             backing:NSBackingStoreBuffered
                                                               defer:NO]];
    
    if (self) {
        _textView = textView;
        [self setUpPanel];
    }
    
    return self;
}

- (void)setUpPanel {
    [[self window] setTitle:@"Print"];
    [[self window] setDelegate:self];
    
    NSView *contentView = [[NSView alloc] initWithFrame:NSMakeRect(0, 0, 400, 350)];
    [[self window] setContentView:contentView];
    
    // Print info
    self.printInfo = [NSPrintInfo sharedPrintInfo];
    
    // Header/Footer checkbox
    self.headerFooterCheckbox = [[NSButton alloc] initWithFrame:NSMakeRect(20, 310, 200, 20)];
    [self.headerFooterCheckbox setButtonType:NSSwitchButton];
    [self.headerFooterCheckbox setTitle:@"Header and Footer"];
    [self.headerFooterCheckbox setState:NSControlStateValueOn];
    [contentView addSubview:self.headerFooterCheckbox];
    
    // Line numbers checkbox
    self.lineNumbersCheckbox = [[NSButton alloc] initWithFrame:NSMakeRect(20, 280, 200, 20)];
    [self.lineNumbersCheckbox setButtonType:NSSwitchButton];
    [self.lineNumbersCheckbox setTitle:@"Line Numbers"];
    [self.lineNumbersCheckbox setState:NSControlStateValueOff];
    [contentView addSubview:self.lineNumbersCheckbox];
    
    // Color checkbox
    self.colorCheckbox = [[NSButton alloc] initWithFrame:NSMakeRect(20, 250, 200, 20)];
    [self.colorCheckbox setButtonType:NSSwitchButton];
    [self.colorCheckbox setTitle:@"Print in Color"];
    [self.colorCheckbox setState:NSControlStateValueOn];
    [contentView addSubview:self.colorCheckbox];
    
    // Wrap lines checkbox
    self.wrapLinesCheckbox = [[NSButton alloc] initWithFrame:NSMakeRect(20, 220, 200, 20)];
    [self.wrapLinesCheckbox setButtonType:NSSwitchButton];
    [self.wrapLinesCheckbox setTitle:@"Wrap Lines"];
    [self.wrapLinesCheckbox setState:NSControlStateValueOn];
    [contentView addSubview:self.wrapLinesCheckbox];
    
    // Header text field
    NSTextField *headerLabel = [[NSTextField alloc] initWithFrame:NSMakeRect(20, 190, 80, 20)];
    [headerLabel setStringValue:@"Header:"];
    [headerLabel setEditable:NO];
    [headerLabel setBordered:NO];
    [headerLabel setDrawsBackground:NO];
    [contentView addSubview:headerLabel];
    
    self.headerTextField = [[NSTextField alloc] initWithFrame:NSMakeRect(100, 190, 280, 24)];
    [self.headerTextField setStringValue:@"&f"];
    [contentView addSubview:self.headerTextField];
    
    // Footer text field
    NSTextField *footerLabel = [[NSTextField alloc] initWithFrame:NSMakeRect(20, 160, 80, 20)];
    [footerLabel setStringValue:@"Footer:"];
    [footerLabel setEditable:NO];
    [footerLabel setBordered:NO];
    [footerLabel setDrawsBackground:NO];
    [contentView addSubview:footerLabel];
    
    self.footerTextField = [[NSTextField alloc] initWithFrame:NSMakeRect(100, 160, 280, 24)];
    [self.footerTextField setStringValue:@"Page &p of &P"];
    [contentView addSubview:self.footerTextField];
    
    // Margins popup
    NSTextField *marginsLabel = [[NSTextField alloc] initWithFrame:NSMakeRect(20, 130, 80, 20)];
    [marginsLabel setStringValue:@"Margins:"];
    [marginsLabel setEditable:NO];
    [marginsLabel setBordered:NO];
    [marginsLabel setDrawsBackground:NO];
    [contentView addSubview:marginsLabel];
    
    self.marginsPopup = [[NSPopUpButton alloc] initWithFrame:NSMakeRect(100, 130, 150, 24)];
    [self.marginsPopup addItemsWithTitles:@[@"Default", @"None", @"Minimum", @"Custom"]];
    [self.marginsPopup selectItemAtIndex:0];
    [contentView addSubview:self.marginsPopup];
    
    // Preview button
    self.previewButton = [[NSButton alloc] initWithFrame:NSMakeRect(20, 20, 80, 25)];
    [self.previewButton setTitle:@"Preview"];
    [self.previewButton setBezelStyle:NSPushButtonBezelStyle];
    [self.previewButton setAction:@selector(previewClicked:)];
    [self.previewButton setTarget:self];
    [contentView addSubview:self.previewButton];
    
    // Print button
    self.printButton = [[NSButton alloc] initWithFrame:NSMakeRect(210, 20, 80, 25)];
    [self.printButton setTitle:@"Print"];
    [self.printButton setBezelStyle:NSPushButtonBezelStyle];
    [self.printButton setAction:@selector(printClicked:)];
    [self.printButton setTarget:self];
    [contentView addSubview:self.printButton];
    
    // Cancel button
    self.cancelButton = [[NSButton alloc] initWithFrame:NSMakeRect(300, 20, 80, 25)];
    [self.cancelButton setTitle:@"Cancel"];
    [self.cancelButton setBezelStyle:NSPushButtonBezelStyle];
    [self.cancelButton setAction:@selector(closePanel)];
    [self.cancelButton setTarget:self];
    [contentView addSubview:self.cancelButton];
}

- (void)showPrintPanel {
    [[self window] makeKeyAndOrderFront:nil];
    [[self window] center];
    [NSApp activateIgnoringOtherApps:YES];
}

- (void)closePanel {
    [[self window] close];
}

- (IBAction)printClicked:(id)sender {
    // Configure print settings
    NSPrintInfo *printInfo = [self.printInfo copy];
    printInfo.horizontalPagination = self.wrapLinesCheckbox.state == NSControlStateValueOn ? 
        NSPrintingPaginationModeAutomatic : NSPrintingPaginationModeFit;
    
    // Create print operation
    NSPrintOperation *printOp = [NSPrintOperation printOperationWithView:self.textView printInfo:printInfo];
    printOp.showsProgressPanel = YES;
    
    // Run the print operation
    [printOp runOperation];
    
    [self closePanel];
}

- (IBAction)previewClicked:(id)sender {
    // Configure print settings
    NSPrintInfo *printInfo = [self.printInfo copy];
    printInfo.horizontalPagination = self.wrapLinesCheckbox.state == NSControlStateValueOn ? 
        NSPrintingPaginationModeAutomatic : NSPrintingPaginationModeFit;
    
    // Create print operation
    NSPrintOperation *printOp = [NSPrintOperation printOperationWithView:self.textView printInfo:printInfo];
    printOp.showsProgressPanel = YES;
    
    // Show preview
    [printOp setShowPanels:YES];
    [printOp runOperationModalForWindow:[self window] delegate:nil didRunSelector:nil contextInfo:nil];
}

#pragma mark - NSWindowDelegate

- (void)windowWillClose:(NSNotification *)notification {
    // Clean up if needed
}

@end