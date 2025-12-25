//
//  RegexHelpPanel.m
//  NotepadPlusPlus
//
//  Created by Assistant on 12/12/2025.
//

#import "RegexHelpPanel.h"

static RegexHelpPanel *sharedInstance = nil;

@implementation RegexHelpPanel

+ (instancetype)sharedPanel {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[RegexHelpPanel alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupPanel];
    }
    return self;
}

- (void)setupPanel {
    NSRect frame = NSMakeRect(300, 300, 500, 400);
    self.panel = [[NSPanel alloc] initWithContentRect:frame
                                          styleMask:NSWindowStyleMaskTitled | NSWindowStyleMaskClosable | NSWindowStyleMaskResizable
                                            backing:NSBackingStoreBuffered
                                              defer:NO];
    [self.panel setTitle:@"Regular Expression Help"];
    
    NSView *contentView = [[NSView alloc] initWithFrame:NSMakeRect(0, 0, 500, 400)];
    [self.panel setContentView:contentView];
    
    // Create text view
    NSRect textFrame = NSMakeRect(0, 0, 500, 400);
    NSScrollView *scrollView = [[NSScrollView alloc] initWithFrame:textFrame];
    [scrollView setHasVerticalScroller:YES];
    [scrollView setHasHorizontalScroller:YES];
    [scrollView setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
    
    self.textView = [[NSTextView alloc] initWithFrame:NSMakeRect(0, 0, 500, 400)];
    [self.textView setEditable:NO];
    [self.textView setRichText:NO];
    [self.textView setFont:[NSFont userFixedPitchFontOfSize:12]];
    
    [scrollView setDocumentView:self.textView];
    [contentView addSubview:scrollView];
    
    // Set help text
    NSString *helpText = @"Regular Expression Syntax Help\n"
                         @"============================\n\n"
                         
                         @"Basic Characters:\n"
                         @"  abc            Literal characters\n"
                         @"  .              Any character except newline\n"
                         @"  \\              Escape character\n"
                         @"  \\\\             Backslash\n"
                         @"  \\.             Period\n"
                         @"\n"
                         
                         @"Character Classes:\n"
                         @"  [abc]          Any character in brackets\n"
                         @"  [^abc]         Any character not in brackets\n"
                         @"  [a-z]          Any character in range\n"
                         @"  [^a-z]         Any character not in range\n"
                         @"  \\d             Digit (0-9)\n"
                         @"  \\D             Non-digit\n"
                         @"  \\w             Word character (a-z, A-Z, 0-9, _)\n"
                         @"  \\W             Non-word character\n"
                         @"  \\s             Whitespace (space, tab, newline)\n"
                         @"  \\S             Non-whitespace\n"
                         @"\n"
                         
                         @"Quantifiers:\n"
                         @"  *              Zero or more\n"
                         @"  +              One or more\n"
                         @"  ?              Zero or one\n"
                         @"  {n}            Exactly n times\n"
                         @"  {n,}           At least n times\n"
                         @"  {n,m}          Between n and m times\n"
                         @"\n"
                         
                         @"Anchors:\n"
                         @"  ^              Start of line\n"
                         @"  $              End of line\n"
                         @"  \\b             Word boundary\n"
                         @"  \\B             Non-word boundary\n"
                         @"\n"
                         
                         @"Groups:\n"
                         @"  (abc)          Capturing group\n"
                         @"  (?:abc)        Non-capturing group\n"
                         @"  (?=abc)        Positive lookahead\n"
                         @"  (?!abc)        Negative lookahead\n"
                         @"\n"
                         
                         @"Alternation:\n"
                         @"  a|b            Either a or b\n"
                         @"\n"
                         
                         @"Examples:\n"
                         @"  \\d{3}-\\d{3}-\\d{4}     US phone number\n"
                         @"  [a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}    Email address\n"
                         @"  ^[A-Z].*[.]$           Line starting with uppercase letter and ending with period\n"
                         @"  \\b\\w+ly\\b            Words ending with 'ly'\n"
                         @"  (\\d{4})-(\\d{2})-(\\d{2})   Date in YYYY-MM-DD format (capturing groups)\n";
    
    [self.textView setString:helpText];
}

- (void)showPanel:(id)sender {
    if (!self.panel) {
        [self setupPanel];
    }
    
    [self.panel makeKeyAndOrderFront:sender];
}

@end