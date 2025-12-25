//
//  GoToLinePanel.m
//  NotepadPlusPlus
//
//  Created by Assistant on 12/12/2025.
//

#import "GoToLinePanel.h"
#import "ScintillaCocoa.h"
#import "LocalizationManager.h"

@interface GoToLinePanel() <NSWindowDelegate>
@property (nonatomic, strong) ScintillaView *textView;
@property (nonatomic, strong) NSTextField *lineNumberField;
@property (nonatomic, strong) NSTextField *instructionLabel;
@property (nonatomic, strong) NSButton *goButton;
@property (nonatomic, strong) NSButton *cancelButton;
@end

@implementation GoToLinePanel

- (instancetype)initWithTextView:(ScintillaView *)textView {
    NSRect frame = NSMakeRect(200, 200, 300, 150);
    
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
    [[self window] setTitle:[LocalizationManager.sharedManager localizedStringForKey:@"go_to_line_title"]];
    [[self window] setDelegate:self];
    
    NSView *contentView = [[NSView alloc] initWithFrame:NSMakeRect(0, 0, 300, 150)];
    [[self window] setContentView:contentView];
    
    // Instruction label
    self.instructionLabel = [[NSTextField alloc] initWithFrame:NSMakeRect(20, 110, 260, 20)];
    [self.instructionLabel setStringValue:[LocalizationManager.sharedManager localizedStringForKey:@"label_go_to_line"]];
    [self.instructionLabel setEditable:NO];
    [self.instructionLabel setBordered:NO];
    [self.instructionLabel setDrawsBackground:NO];
    [contentView addSubview:self.instructionLabel];
    
    // Line number field
    self.lineNumberField = [[NSTextField alloc] initWithFrame:NSMakeRect(20, 80, 260, 24)];
    [self.lineNumberField setPlaceholderString:[LocalizationManager.sharedManager localizedStringForKey:@"placeholder_line_number"]];
    [contentView addSubview:self.lineNumberField];
    
    // Go button
    self.goButton = [[NSButton alloc] initWithFrame:NSMakeRect(200, 20, 80, 25)];
    [self.goButton setTitle:[LocalizationManager.sharedManager localizedStringForKey:@"button_go"]];
    [self.goButton setBezelStyle:NSPushButtonBezelStyle];
    [self.goButton setAction:@selector(goButtonClicked:)];
    [self.goButton setTarget:self];
    [contentView addSubview:self.goButton];
    
    // Cancel button
    self.cancelButton = [[NSButton alloc] initWithFrame:NSMakeRect(110, 20, 80, 25)];
    [self.cancelButton setTitle:[LocalizationManager.sharedManager localizedStringForKey:@"button_cancel"]];
    [self.cancelButton setBezelStyle:NSPushButtonBezelStyle];
    [self.cancelButton setAction:@selector(cancelButtonClicked:)];
    [self.cancelButton setTarget:self];
    [contentView addSubview:self.cancelButton];
    
    // Update instruction with actual line count
    [self updateInstructionLabel];
}

- (void)updateInstructionLabel {
    long lineCount = [self.textView sendmessage:SCI_GETLINECOUNT sub:0 wparam:0];
    NSString *text = [NSString stringWithFormat:@"Enter line number (1-%ld):", lineCount];
    [self.instructionLabel setStringValue:text];
}

- (void)showPanel {
    [self updateInstructionLabel];
    [self.lineNumberField setStringValue:@""];
    [[self window] makeKeyAndOrderFront:nil];
    [[self window] center];
    [NSApp activateIgnoringOtherApps:YES];
}

- (void)closePanel {
    [[self window] close];
}

- (IBAction)goButtonClicked:(id)sender {
    NSString *lineNumberText = [self.lineNumberField stringValue];
    if (lineNumberText.length == 0) {
        NSBeep();
        return;
    }
    
    NSInteger lineNumber = [lineNumberText integerValue];
    if (lineNumber <= 0) {
        NSAlert *alert = [NSAlert alertWithMessageText:[LocalizationManager.sharedManager localizedStringForKey:@"message_invalid_line_number"]
                                         defaultButton:@"OK"
                                       alternateButton:nil
                                           otherButton:nil
                                 informativeTextWithFormat:@"%@", 
                                 [LocalizationManager.sharedManager localizedStringForKey:@"message_line_number_greater_than_zero"]];
        [alert runModal];
        return;
    }
    
    long lineCount = [self.textView sendmessage:SCI_GETLINECOUNT sub:0 wparam:0];
    if (lineNumber > lineCount) {
        NSAlert *alert = [NSAlert alertWithMessageText:[LocalizationManager.sharedManager localizedStringForKey:@"message_invalid_line_number"]
                                         defaultButton:@"OK"
                                       alternateButton:nil
                                           otherButton:nil
                                 informativeTextWithFormat:@"%@", 
                                 [NSString stringWithFormat:
                                  [LocalizationManager.sharedManager localizedStringForKey:@"message_line_number_less_than_max"], 
                                  lineCount]];
        [alert runModal];
        return;
    }
    
    // Convert to zero-based index
    long zeroBasedLineNumber = lineNumber - 1;
    
    // Get position of the line
    long position = [self.textView sendmessage:SCI_POSITIONFROMLINE sub:zeroBasedLineNumber wparam:0];
    
    // Set cursor to beginning of the line
    [self.textView sendmessage:SCI_GOTOPOS sub:position wparam:0];
    
    // Scroll to make the line visible
    [self.textView sendmessage:SCI_SCROLLCARET sub:0 wparam:0];
    
    [self closePanel];
}

- (IBAction)cancelButtonClicked:(id)sender {
    [self closePanel];
}

#pragma mark - NSWindowDelegate

- (void)windowWillClose:(NSNotification *)notification {
    // Clean up if needed
}

@end