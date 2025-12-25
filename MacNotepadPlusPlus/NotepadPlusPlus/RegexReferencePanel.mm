//
//  RegexReferencePanel.m
//  NotepadPlusPlus
//
//  Created by Assistant on 12/12/2025.
//

#import "RegexReferencePanel.h"
#import "LocalizationManager.h"

@interface RegexReferencePanel() <NSWindowDelegate, NSTableViewDataSource, NSTableViewDelegate>
@property (nonatomic, strong) NSTableView *tableView;
@property (nonatomic, strong) NSArray *regexPatterns;
@property (nonatomic, strong) NSSearchField *searchField;
@end

@implementation RegexReferencePanel

- (instancetype)init {
    NSRect frame = NSMakeRect(200, 200, 600, 400);
    
    self = [super initWithWindow:[[NSWindow alloc] initWithContentRect:frame
                                                           styleMask:NSWindowStyleMaskTitled |
                                                                     NSWindowStyleMaskClosable |
                                                                     NSWindowStyleMaskResizable
                                                             backing:NSBackingStoreBuffered
                                                               defer:NO]];
    
    if (self) {
        [self setUpPanel];
    }
    
    return self;
}

- (void)setUpPanel {
    [[self window] setTitle:@"Regular Expression Reference"];
    [[self window] setDelegate:self];
    [[self window] setMinSize:NSMakeSize(400, 300)];
    
    NSView *contentView = [[NSView alloc] initWithFrame:NSMakeRect(0, 0, 600, 400)];
    [[self window] setContentView:contentView];
    
    // Search field
    self.searchField = [[NSSearchField alloc] initWithFrame:NSMakeRect(20, 360, 560, 24)];
    [self.searchField setPlaceholderString:@"Search patterns..."];
    [self.searchField setTarget:self];
    [self.searchField setAction:@selector(searchFieldChanged:)];
    [contentView addSubview:self.searchField];
    
    // Table view
    NSRect tableFrame = NSMakeRect(20, 20, 560, 330);
    NSScrollView *scrollView = [[NSScrollView alloc] initWithFrame:tableFrame];
    scrollView.hasVerticalScroller = YES;
    scrollView.hasHorizontalScroller = NO;
    scrollView.autohidesScrollers = YES;
    scrollView.borderType = NSBezelBorder;
    
    self.tableView = [[NSTableView alloc] initWithFrame:NSMakeRect(0, 0, 560, 330)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    // Create table columns
    NSTableColumn *patternColumn = [[NSTableColumn alloc] initWithIdentifier:@"Pattern"];
    [patternColumn setWidth:150];
    [patternColumn.headerCell setTitle:@"Pattern"];
    [self.tableView addTableColumn:patternColumn];
    
    NSTableColumn *descriptionColumn = [[NSTableColumn alloc] initWithIdentifier:@"Description"];
    [descriptionColumn setWidth:400];
    [descriptionColumn.headerCell setTitle:@"Description"];
    [self.tableView addTableColumn:descriptionColumn];
    
    scrollView.documentView = self.tableView;
    [contentView addSubview:scrollView];
    
    // Load regex patterns
    [self loadRegexPatterns];
}

- (void)loadRegexPatterns {
    self.regexPatterns = @[
        @{@"pattern": @".", @"description": @"Any character except newline"},
        @{@"pattern": @"a", @"description": @"The character a"},
        @{@"pattern": @"ab", @"description": @"The string ab"},
        @{@"pattern": @"a|b", @"description": @"a or b"},
        @{@"pattern": @"a*", @"description": @"0 or more a's"},
        @{@"pattern": @"a+", @"description": @"1 or more a's"},
        @{@"pattern": @"a?", @"description": @"0 or 1 a's"},
        @{@"pattern": @"a{3}", @"description": @"Exactly 3 a's"},
        @{@"pattern": @"a{3,}", @"description": @"3 or more a's"},
        @{@"pattern": @"a{3,6}", @"description": @"Between 3 and 6 a's"},
        @{@"pattern": @"^", @"description": @"Start of string"},
        @{@"pattern": @"$", @"description": @"End of string"},
        @{@"pattern": @"[abc]", @"description": @"A single character a, b or c"},
        @{@"pattern": @"[^abc]", @"description": @"Any character except a, b, or c"},
        @{@"pattern": @"[a-z]", @"description": @"Any character from a to z"},
        @{@"pattern": @"(expr)", @"description": @"Capture group"},
        @{@"pattern": @"(?:expr)", @"description": @"Non-capturing group"},
        @{@"pattern": @"(?=expr)", @"description": @"Positive lookahead"},
        @{@"pattern": @"(?!expr)", @"description": @"Negative lookahead"},
        @{@"pattern": @"\d", @"description": @"A digit (equivalent to [0-9])"},
        @{@"pattern": @"\D", @"description": @"A non-digit"},
        @{@"pattern": @"\w", @"description": @"A word character ([a-zA-Z0-9_])"},
        @{@"pattern": @"\W", @"description": @"A non-word character"},
        @{@"pattern": @"\s", @"description": @"A whitespace character"},
        @{@"pattern": @"\S", @"description": @"A non-whitespace character"}
    ];
    
    [self.tableView reloadData];
}

- (void)showPanel {
    [[self window] makeKeyAndOrderFront:nil];
    [[self window] center];
    [NSApp activateIgnoringOtherApps:YES];
}

- (void)closePanel {
    [[self window] close];
}

- (void)searchFieldChanged:(id)sender {
    NSString *searchText = [self.searchField stringValue];
    
    if (searchText.length == 0) {
        [self loadRegexPatterns];
        return;
    }
    
    NSMutableArray *filteredPatterns = [NSMutableArray array];
    
    for (NSDictionary *patternDict in self.regexPatterns) {
        NSString *pattern = patternDict[@"pattern"];
        NSString *description = patternDict[@"description"];
        
        if ([pattern rangeOfString:searchText options:NSCaseInsensitiveSearch].location != NSNotFound ||
            [description rangeOfString:searchText options:NSCaseInsensitiveSearch].location != NSNotFound) {
            [filteredPatterns addObject:patternDict];
        }
    }
    
    self.regexPatterns = [filteredPatterns copy];
    [self.tableView reloadData];
}

#pragma mark - NSTableViewDataSource

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return self.regexPatterns.count;
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    if (row >= self.regexPatterns.count) return nil;
    
    NSDictionary *patternDict = self.regexPatterns[row];
    
    if ([[tableColumn identifier] isEqualToString:@"Pattern"]) {
        return patternDict[@"pattern"];
    } else if ([[tableColumn identifier] isEqualToString:@"Description"]) {
        return patternDict[@"description"];
    }
    
    return nil;
}

#pragma mark - NSTableViewDelegate

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    if (row >= self.regexPatterns.count) return nil;
    
    NSString *identifier = [tableColumn identifier];
    NSTableCellView *cellView = [tableView makeViewWithIdentifier:identifier owner:self];
    
    if (cellView == nil) {
        cellView = [[NSTableCellView alloc] initWithFrame:NSZeroRect];
        cellView.identifier = identifier;
        
        NSTextField *textField = [[NSTextField alloc] initWithFrame:NSZeroRect];
        [textField setEditable:NO];
        [textField setBordered:NO];
        [textField setDrawsBackground:NO];
        [textField setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        [cellView addSubview:textField];
        [cellView addConstraint:[NSLayoutConstraint constraintWithItem:textField
                                                            attribute:NSLayoutAttributeLeading
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:cellView
                                                            attribute:NSLayoutAttributeLeading
                                                           multiplier:1.0
                                                             constant:5.0]];
        [cellView addConstraint:[NSLayoutConstraint constraintWithItem:textField
                                                            attribute:NSLayoutAttributeTrailing
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:cellView
                                                            attribute:NSLayoutAttributeTrailing
                                                           multiplier:1.0
                                                             constant:-5.0]];
        [cellView addConstraint:[NSLayoutConstraint constraintWithItem:textField
                                                            attribute:NSLayoutAttributeTop
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:cellView
                                                            attribute:NSLayoutAttributeTop
                                                           multiplier:1.0
                                                             constant:2.0]];
        [cellView addConstraint:[NSLayoutConstraint constraintWithItem:textField
                                                            attribute:NSLayoutAttributeBottom
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:cellView
                                                            attribute:NSLayoutAttributeBottom
                                                           multiplier:1.0
                                                             constant:-2.0]];
        
        cellView.textField = textField;
    }
    
    NSDictionary *patternDict = self.regexPatterns[row];
    cellView.textField.stringValue = patternDict[identifier];
    
    return cellView;
}

#pragma mark - NSWindowDelegate

- (void)windowWillClose:(NSNotification *)notification {
    // Clean up if needed
}

@end