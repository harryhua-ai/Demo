//
//  DocumentStatisticsPanel.m
//  NotepadPlusPlus
//
//  Created by Assistant on 12/12/2025.
//

#import "DocumentStatisticsPanel.h"
#import "ScintillaCocoa.h"
#import "LocalizationManager.h"

@interface DocumentStatisticsPanel() <NSWindowDelegate>
@property (nonatomic, strong) ScintillaView *textView;
@property (nonatomic, strong) NSTextField *charactersLabel;
@property (nonatomic, strong) NSTextField *charactersNoSpacesLabel;
@property (nonatomic, strong) NSTextField *linesLabel;
@property (nonatomic, strong) NSTextField *wordsLabel;
@property (nonatomic, strong) NSTextField *encodingLabel;
@property (nonatomic, strong) NSTextField *createdLabel;
@property (nonatomic, strong) NSTextField *modifiedLabel;
@end

@implementation DocumentStatisticsPanel

- (instancetype)initWithTextView:(ScintillaView *)textView {
    NSRect frame = NSMakeRect(200, 200, 350, 250);
    
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
    [[self window] setTitle:@"Document Statistics"];
    [[self window] setDelegate:self];
    
    NSView *contentView = [[NSView alloc] initWithFrame:NSMakeRect(0, 0, 350, 250)];
    [[self window] setContentView:contentView];
    
    // Create labels
    CGFloat yPos = 220;
    CGFloat labelHeight = 20;
    CGFloat labelSpacing = 25;
    
    // Characters label
    NSTextField *charactersTitleLabel = [[NSTextField alloc] initWithFrame:NSMakeRect(20, yPos, 150, labelHeight)];
    [charactersTitleLabel setStringValue:@"Characters (with spaces):"];
    [charactersTitleLabel setEditable:NO];
    [charactersTitleLabel setBordered:NO];
    [charactersTitleLabel setDrawsBackground:NO];
    [charactersTitleLabel setFont:[NSFont boldSystemFontOfSize:[NSFont systemFontSize]]];
    [contentView addSubview:charactersTitleLabel];
    
    self.charactersLabel = [[NSTextField alloc] initWithFrame:NSMakeRect(200, yPos, 130, labelHeight)];
    [self.charactersLabel setStringValue:@"0"];
    [self.charactersLabel setEditable:NO];
    [self.charactersLabel setBordered:NO];
    [self.charactersLabel setDrawsBackground:NO];
    [self.charactersLabel setAlignment:NSTextAlignmentRight];
    [contentView addSubview:self.charactersLabel];
    
    yPos -= labelSpacing;
    
    // Characters (no spaces) label
    NSTextField *charactersNoSpacesTitleLabel = [[NSTextField alloc] initWithFrame:NSMakeRect(20, yPos, 150, labelHeight)];
    [charactersNoSpacesTitleLabel setStringValue:@"Characters (no spaces):"];
    [charactersNoSpacesTitleLabel setEditable:NO];
    [charactersNoSpacesTitleLabel setBordered:NO];
    [charactersNoSpacesTitleLabel setDrawsBackground:NO];
    [charactersNoSpacesTitleLabel setFont:[NSFont boldSystemFontOfSize:[NSFont systemFontSize]]];
    [contentView addSubview:charactersNoSpacesTitleLabel];
    
    self.charactersNoSpacesLabel = [[NSTextField alloc] initWithFrame:NSMakeRect(200, yPos, 130, labelHeight)];
    [self.charactersNoSpacesLabel setStringValue:@"0"];
    [self.charactersNoSpacesLabel setEditable:NO];
    [self.charactersNoSpacesLabel setBordered:NO];
    [self.charactersNoSpacesLabel setDrawsBackground:NO];
    [self.charactersNoSpacesLabel setAlignment:NSTextAlignmentRight];
    [contentView addSubview:self.charactersNoSpacesLabel];
    
    yPos -= labelSpacing;
    
    // Lines label
    NSTextField *linesTitleLabel = [[NSTextField alloc] initWithFrame:NSMakeRect(20, yPos, 150, labelHeight)];
    [linesTitleLabel setStringValue:@"Lines:"];
    [linesTitleLabel setEditable:NO];
    [linesTitleLabel setBordered:NO];
    [linesTitleLabel setDrawsBackground:NO];
    [linesTitleLabel setFont:[NSFont boldSystemFontOfSize:[NSFont systemFontSize]]];
    [contentView addSubview:linesTitleLabel];
    
    self.linesLabel = [[NSTextField alloc] initWithFrame:NSMakeRect(200, yPos, 130, labelHeight)];
    [self.linesLabel setStringValue:@"0"];
    [self.linesLabel setEditable:NO];
    [self.linesLabel setBordered:NO];
    [self.linesLabel setDrawsBackground:NO];
    [self.linesLabel setAlignment:NSTextAlignmentRight];
    [contentView addSubview:self.linesLabel];
    
    yPos -= labelSpacing;
    
    // Words label
    NSTextField *wordsTitleLabel = [[NSTextField alloc] initWithFrame:NSMakeRect(20, yPos, 150, labelHeight)];
    [wordsTitleLabel setStringValue:@"Words:"];
    [wordsTitleLabel setEditable:NO];
    [wordsTitleLabel setBordered:NO];
    [wordsTitleLabel setDrawsBackground:NO];
    [wordsTitleLabel setFont:[NSFont boldSystemFontOfSize:[NSFont systemFontSize]]];
    [contentView addSubview:wordsTitleLabel];
    
    self.wordsLabel = [[NSTextField alloc] initWithFrame:NSMakeRect(200, yPos, 130, labelHeight)];
    [self.wordsLabel setStringValue:@"0"];
    [self.wordsLabel setEditable:NO];
    [self.wordsLabel setBordered:NO];
    [self.wordsLabel setDrawsBackground:NO];
    [self.wordsLabel setAlignment:NSTextAlignmentRight];
    [contentView addSubview:self.wordsLabel];
    
    yPos -= labelSpacing;
    
    // Encoding label
    NSTextField *encodingTitleLabel = [[NSTextField alloc] initWithFrame:NSMakeRect(20, yPos, 150, labelHeight)];
    [encodingTitleLabel setStringValue:@"Encoding:"];
    [encodingTitleLabel setEditable:NO];
    [encodingTitleLabel setBordered:NO];
    [encodingTitleLabel setDrawsBackground:NO];
    [encodingTitleLabel setFont:[NSFont boldSystemFontOfSize:[NSFont systemFontSize]]];
    [contentView addSubview:encodingTitleLabel];
    
    self.encodingLabel = [[NSTextField alloc] initWithFrame:NSMakeRect(200, yPos, 130, labelHeight)];
    [self.encodingLabel setStringValue:@"UTF-8"];
    [self.encodingLabel setEditable:NO];
    [self.encodingLabel setBordered:NO];
    [self.encodingLabel setDrawsBackground:NO];
    [self.encodingLabel setAlignment:NSTextAlignmentRight];
    [contentView addSubview:self.encodingLabel];
    
    yPos -= labelSpacing;
    
    // Created label
    NSTextField *createdTitleLabel = [[NSTextField alloc] initWithFrame:NSMakeRect(20, yPos, 150, labelHeight)];
    [createdTitleLabel setStringValue:@"Created:"];
    [createdTitleLabel setEditable:NO];
    [createdTitleLabel setBordered:NO];
    [createdTitleLabel setDrawsBackground:NO];
    [createdTitleLabel setFont:[NSFont boldSystemFontOfSize:[NSFont systemFontSize]]];
    [contentView addSubview:createdTitleLabel];
    
    self.createdLabel = [[NSTextField alloc] initWithFrame:NSMakeRect(200, yPos, 130, labelHeight)];
    [self.createdLabel setStringValue:@"N/A"];
    [self.createdLabel setEditable:NO];
    [self.createdLabel setBordered:NO];
    [self.createdLabel setDrawsBackground:NO];
    [self.createdLabel setAlignment:NSTextAlignmentRight];
    [contentView addSubview:self.createdLabel];
    
    yPos -= labelSpacing;
    
    // Modified label
    NSTextField *modifiedTitleLabel = [[NSTextField alloc] initWithFrame:NSMakeRect(20, yPos, 150, labelHeight)];
    [modifiedTitleLabel setStringValue:@"Modified:"];
    [modifiedTitleLabel setEditable:NO];
    [modifiedTitleLabel setBordered:NO];
    [modifiedTitleLabel setDrawsBackground:NO];
    [modifiedTitleLabel setFont:[NSFont boldSystemFontOfSize:[NSFont systemFontSize]]];
    [contentView addSubview:modifiedTitleLabel];
    
    self.modifiedLabel = [[NSTextField alloc] initWithFrame:NSMakeRect(200, yPos, 130, labelHeight)];
    [self.modifiedLabel setStringValue:@"N/A"];
    [self.modifiedLabel setEditable:NO];
    [self.modifiedLabel setBordered:NO];
    [self.modifiedLabel setDrawsBackground:NO];
    [self.modifiedLabel setAlignment:NSTextAlignmentRight];
    [contentView addSubview:self.modifiedLabel];
    
    // Close button
    NSButton *closeButton = [[NSButton alloc] initWithFrame:NSMakeRect(250, 20, 80, 25)];
    [closeButton setTitle:[LocalizationManager.sharedManager localizedStringForKey:@"button_close"]];
    [closeButton setBezelStyle:NSPushButtonBezelStyle];
    [closeButton setAction:@selector(closePanel)];
    [closeButton setTarget:self];
    [contentView addSubview:closeButton];
}

- (void)showPanel {
    [self updateStatistics];
    [[self window] makeKeyAndOrderFront:nil];
    [[self window] center];
    [NSApp activateIgnoringOtherApps:YES];
}

- (void)closePanel {
    [[self window] close];
}

- (void)updateStatistics {
    if (!self.textView) return;
    
    // Get document statistics
    long length = [self.textView sendmessage:SCI_GETLENGTH sub:0 wparam:0];
    long lines = [self.textView sendmessage:SCI_GETLINECOUNT sub:0 wparam:0];
    
    // Count characters with and without spaces
    long charactersWithSpaces = length;
    long charactersWithoutSpaces = 0;
    long words = 0;
    
    // Simple word counting algorithm
    BOOL inWord = NO;
    for (long i = 0; i < length; i++) {
        char ch = (char)[self.textView sendmessage:SCI_GETCHARAT sub:i wparam:0];
        
        // Count non-space characters
        if (ch != ' ' && ch != '\t' && ch != '\n' && ch != '\r') {
            charactersWithoutSpaces++;
            
            // Word counting
            if (!inWord && ((ch >= 'a' && ch <= 'z') || (ch >= 'A' && ch <= 'Z') || (ch >= '0' && ch <= '9'))) {
                inWord = YES;
                words++;
            } else if (inWord && !(ch >= 'a' && ch <= 'z') && !(ch >= 'A' && ch <= 'Z') && !(ch >= '0' && ch <= '9')) {
                inWord = NO;
            }
        } else {
            inWord = NO;
        }
    }
    
    // Update labels
    [self.charactersLabel setStringValue:[NSString stringWithFormat:@"%ld", charactersWithSpaces]];
    [self.charactersNoSpacesLabel setStringValue:[NSString stringWithFormat:@"%ld", charactersWithoutSpaces]];
    [self.linesLabel setStringValue:[NSString stringWithFormat:@"%ld", lines]];
    [self.wordsLabel setStringValue:[NSString stringWithFormat:@"%ld", words]];
    
    // Update timestamps if available (would come from document)
    NSDate *now = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [self.createdLabel setStringValue:[formatter stringFromDate:now]];
    [self.modifiedLabel setStringValue:[formatter stringFromDate:now]];
}

#pragma mark - NSWindowDelegate

- (void)windowWillClose:(NSNotification *)notification {
    // Clean up if needed
}

@end