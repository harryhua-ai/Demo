//
//  EnhancedBookmarkManager.m
//  NotepadPlusPlus
//
//  Created by Assistant on 12/12/2025.
//

#import "EnhancedBookmarkManager.h"
#import "ScintillaCocoa.h"

static const int BOOKMARK_MARKER = 1;
static const int BOOKMARK_MASK = 1 << BOOKMARK_MARKER;

@implementation EnhancedBookmarkManager

- (instancetype)initWithTextView:(ScintillaView *)textView {
    self = [super init];
    if (self) {
        _textView = textView;
        
        // Define bookmark marker
        [self setupBookmarkMarker];
    }
    return self;
}

- (void)setupBookmarkMarker {
    // Set up the bookmark marker with a circle symbol
    [self.textView sendmessage:SCI_MARKERDEFINE sub:BOOKMARK_MARKER wparam:SC_MARK_CIRCLE];
    [self.textView sendmessage:SCI_MARKERSETFORE sub:BOOKMARK_MARKER wparam:0xFF0000]; // Red foreground
    [self.textView sendmessage:SCI_MARKERSETBACK sub:BOOKMARK_MARKER wparam:0xFFFF00]; // Yellow background
}

- (void)toggleBookmarkAtLine:(NSInteger)lineNumber {
    // Check if there's already a bookmark at this line
    long markerMask = [self.textView sendmessage:SCI_MARKERGET sub:lineNumber wparam:0];
    
    if (markerMask & BOOKMARK_MASK) {
        // Bookmark exists, remove it
        [self removeBookmarkAtLine:lineNumber];
    } else {
        // No bookmark, add one
        [self.textView sendmessage:SCI_MARKERADD sub:lineNumber wparam:BOOKMARK_MARKER];
    }
}

- (void)removeBookmarkAtLine:(NSInteger)lineNumber {
    [self.textView sendmessage:SCI_MARKERDELETE sub:lineNumber wparam:BOOKMARK_MARKER];
}

- (void)clearAllBookmarks {
    [self.textView sendmessage:SCI_MARKERDELETEALL sub:BOOKMARK_MARKER wparam:0];
}

- (NSArray<NSNumber *> *)getAllBookmarks {
    NSMutableArray *bookmarks = [NSMutableArray array];
    long line = 0;
    
    while (line >= 0) {
        line = [self.textView sendmessage:SCI_MARKERNEXT sub:line wparam:BOOKMARK_MASK];
        if (line >= 0) {
            [bookmarks addObject:@(line)];
            line++; // Move to next line
        }
    }
    
    return [bookmarks copy];
}

- (void)navigateToNextBookmark {
    // Get current line
    long currentPos = [self.textView sendmessage:SCI_GETCURRENTPOS sub:0 wparam:0];
    long currentLine = [self.textView sendmessage:SCI_LINEFROMPOSITION sub:currentPos wparam:0];
    
    // Find next bookmark
    long nextLine = [self.textView sendmessage:SCI_MARKERNEXT sub:currentLine + 1 wparam:BOOKMARK_MASK];
    
    if (nextLine < 0) {
        // Wrap around to first bookmark
        nextLine = [self.textView sendmessage:SCI_MARKERNEXT sub:0 wparam:BOOKMARK_MASK];
    }
    
    if (nextLine >= 0) {
        [self navigateToBookmarkAtLine:nextLine];
    }
}

- (void)navigateToPreviousBookmark {
    // Get current line
    long currentPos = [self.textView sendmessage:SCI_GETCURRENTPOS sub:0 wparam:0];
    long currentLine = [self.textView sendmessage:SCI_LINEFROMPOSITION sub:currentPos wparam:0];
    
    // Find previous bookmark
    long prevLine = [self.textView sendmessage:SCI_MARKERPREVIOUS sub:currentLine - 1 wparam:BOOKMARK_MASK];
    
    if (prevLine < 0) {
        // Wrap around to last bookmark
        long lineCount = [self.textView sendmessage:SCI_GETLINECOUNT sub:0 wparam:0];
        prevLine = [self.textView sendmessage:SCI_MARKERPREVIOUS sub:lineCount - 1 wparam:BOOKMARK_MASK];
    }
    
    if (prevLine >= 0) {
        [self navigateToBookmarkAtLine:prevLine];
    }
}

- (void)navigateToBookmarkAtLine:(NSInteger)lineNumber {
    // Go to the line
    long pos = [self.textView sendmessage:SCI_POSITIONFROMLINE sub:lineNumber wparam:0];
    [self.textView sendmessage:SCI_GOTOPOS sub:pos wparam:0];
    
    // Ensure the line is visible
    [self.textView sendmessage:SCI_ENSUREVISIBLE sub:lineNumber wparam:0];
    
    // Scroll to center the line
    [self.textView sendmessage:SCI_SCROLLCARET sub:0 wparam:0];
}

@end