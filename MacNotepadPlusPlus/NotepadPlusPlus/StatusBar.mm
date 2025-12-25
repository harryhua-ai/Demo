//
//  StatusBar.m
//  NotepadPlusPlus
//
//  Created by Assistant on 12/12/2025.
//

#import "StatusBar.h"
#import "ScintillaCocoa.h"
#import "LocalizationManager.h"

@interface StatusBar()
@property (nonatomic, strong) NSTextField *positionLabel;
@property (nonatomic, strong) NSTextField *languageLabel;
@property (nonatomic, strong) NSTextField *encodingLabel;
@property (nonatomic, strong) NSTextField *lineEndingLabel;
@property (nonatomic, strong) NSTextField *zoomLabel;
@end

@implementation StatusBar

- (instancetype)initWithFrame:(NSRect)frame textView:(ScintillaView *)textView {
    self = [super initWithFrame:frame];
    if (self) {
        _textView = textView;
        [self setUpStatusBar];
    }
    return self;
}

- (void)setUpStatusBar {
    // Use layer for modern appearance
    self.wantsLayer = YES;
    self.layer.backgroundColor = [NSColor.controlBackgroundColor CGColor];
    
    // Add subtle border
    self.layer.borderWidth = 0.5;
    self.layer.borderColor = [NSColor.separatorColor CGColor];
    
    // Common label properties
    CGFloat labelHeight = 20.0;
    CGFloat labelY = (self.frame.size.height - labelHeight) / 2;
    CGFloat xPosition = 10.0;
    CGFloat spacing = 10.0;
    
    // Position label (cursor position)
    self.positionLabel = [[NSTextField alloc] initWithFrame:NSMakeRect(xPosition, labelY, 150, labelHeight)];
    [self.positionLabel setEditable:NO];
    [self.positionLabel setBordered:NO];
    [self.positionLabel setDrawsBackground:NO];
    [self.positionLabel setFont:[NSFont systemFontOfSize:[NSFont systemFontSizeForControlSize:NSControlSizeSmall]]];
    [self.positionLabel setStringValue:@"Line: 1, Col: 1"];
    [self addSubview:self.positionLabel];
    
    // Language label
    xPosition += 160 + spacing;
    self.languageLabel = [[NSTextField alloc] initWithFrame:NSMakeRect(xPosition, labelY, 100, labelHeight)];
    [self.languageLabel setEditable:NO];
    [self.languageLabel setBordered:NO];
    [self.languageLabel setDrawsBackground:NO];
    [self.languageLabel setFont:[NSFont systemFontOfSize:[NSFont systemFontSizeForControlSize:NSControlSizeSmall]]];
    [self.languageLabel setStringValue:[LocalizationManager.sharedManager localizedStringForKey:@"Plain Text"]];
    [self addSubview:self.languageLabel];
    
    // Encoding label
    xPosition += 100 + spacing;
    self.encodingLabel = [[NSTextField alloc] initWithFrame:NSMakeRect(xPosition, labelY, 100, labelHeight)];
    [self.encodingLabel setEditable:NO];
    [self.encodingLabel setBordered:NO];
    [self.encodingLabel setDrawsBackground:NO];
    [self.encodingLabel setFont:[NSFont systemFontOfSize:[NSFont systemFontSizeForControlSize:NSControlSizeSmall]]];
    [self.encodingLabel setStringValue:@"UTF-8"];
    [self addSubview:self.encodingLabel];
    
    // Line ending label
    xPosition += 100 + spacing;
    self.lineEndingLabel = [[NSTextField alloc] initWithFrame:NSMakeRect(xPosition, labelY, 80, labelHeight)];
    [self.lineEndingLabel setEditable:NO];
    [self.lineEndingLabel setBordered:NO];
    [self.lineEndingLabel setDrawsBackground:NO];
    [self.lineEndingLabel setFont:[NSFont systemFontOfSize:[NSFont systemFontSizeForControlSize:NSControlSizeSmall]]];
    [self.lineEndingLabel setStringValue:@"LF"];
    [self addSubview:self.lineEndingLabel];
    
    // Zoom label
    xPosition = self.frame.size.width - 60;
    self.zoomLabel = [[NSTextField alloc] initWithFrame:NSMakeRect(xPosition, labelY, 50, labelHeight)];
    [self.zoomLabel setEditable:NO];
    [self.zoomLabel setBordered:NO];
    [self.zoomLabel setDrawsBackground:NO];
    [self.zoomLabel setFont:[NSFont systemFontOfSize:[NSFont systemFontSizeForControlSize:NSControlSizeSmall]]];
    [self.zoomLabel setStringValue:@"100%"];
    [self addSubview:self.zoomLabel];
    
    // Register for text view notifications to update status
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textChanged:)
                                                 name:@"SCN_UPDATEUI"
                                               object:self.textView];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)updateStatusBar {
    if (!_textView) {
        return;
    }
    
    // Update cursor position
    long currentPos = [self.textView sendmessage:SCI_GETCURRENTPOS sub:0 wparam:0];
    long line = [self.textView sendmessage:SCI_LINEFROMPOSITION sub:currentPos wparam:0];
    long col = [self.textView sendmessage:SCI_GETCOLUMN sub:currentPos wparam:0];
    
    NSString *positionText = [NSString stringWithFormat:@"Line: %ld, Col: %ld", line + 1, col + 1];
    [self.positionLabel setStringValue:positionText];
    
    // Update zoom level
    long zoom = [self.textView sendmessage:SCI_GETZOOM sub:0 wparam:0];
    NSString *zoomText = [NSString stringWithFormat:@"%ld%%", 100 + zoom];
    [self.zoomLabel setStringValue:zoomText];
}

- (void)setLanguage:(NSString *)language {
    [self.languageLabel setStringValue:language];
}

- (void)setEncoding:(NSString *)encoding {
    [self.encodingLabel setStringValue:encoding];
}

- (void)setLineEnding:(NSString *)lineEnding {
    [self.lineEndingLabel setStringValue:lineEnding];
}

- (void)textChanged:(NSNotification *)notification {
    [self updateStatusBar];
}

- (void)resizeSubviewsWithOldSize:(NSSize)oldBoundsSize {
    [super resizeSubviewsWithOldSize:oldBoundsSize];
    
    // Keep all labels properly positioned when resizing
    CGFloat labelHeight = 20.0;
    CGFloat labelY = (self.frame.size.height - labelHeight) / 2;
    CGFloat xPosition = 10.0;
    CGFloat spacing = 10.0;
    
    // Update positions of all labels
    [self.positionLabel setFrameOrigin:NSMakePoint(xPosition, labelY)];
    
    xPosition += 160 + spacing;
    [self.languageLabel setFrameOrigin:NSMakePoint(xPosition, labelY)];
    
    xPosition += 100 + spacing;
    [self.encodingLabel setFrameOrigin:NSMakePoint(xPosition, labelY)];
    
    xPosition += 100 + spacing;
    [self.lineEndingLabel setFrameOrigin:NSMakePoint(xPosition, labelY)];
    
    // Right-align zoom label
    xPosition = self.frame.size.width - 60;
    [self.zoomLabel setFrameOrigin:NSMakePoint(xPosition, labelY)];
}

@end