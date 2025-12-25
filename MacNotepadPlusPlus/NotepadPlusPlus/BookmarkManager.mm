//
//  BookmarkManager.m
//  NotepadPlusPlus
//
//  Created by Assistant on 12/12/2025.
//

#import "BookmarkManager.h"
#import "ScintillaCocoa.h"

static const int BOOKMARK_MARKER = 1;

@implementation BookmarkManager

+ (BookmarkManager *)sharedManager {
    static BookmarkManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[BookmarkManager alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _bookmarks = [[NSMutableArray alloc] init];
    }
    return self;
}

- (instancetype)initWithTextView:(ScintillaView *)textView {
    self = [self init]; // 调用新的init方法
    if (self) {
        _textView = textView;
        [self setupBookmarkMarker];
    }
    return self;
}

    self = [super init];
    if (self) {
        _textView = textView;
        _bookmarks = [[NSMutableArray alloc] init];
        [self setupBookmarkMarker];
    }
    return self;
}

- (void)setupBookmarkMarker {
    // Define a marker for bookmarks (blue arrow)
    [_textView sendmessage:SCI_MARKERDEFINE sub:BOOKMARK_MARKER wparam:SC_MARK_ARROW];
    [_textView sendmessage:SCI_MARKERSETFORE sub:BOOKMARK_MARKER wparam:0xFFFFFF]; // White arrow
    [_textView sendmessage:SCI_MARKERSETBACK sub:BOOKMARK_MARKER wparam:0x0000FF]; // Blue background
}

- (void)toggleBookmarkAtLine:(NSInteger)lineNumber {
    // Check if there's already a bookmark on this line
    long markerMask = [_textView sendmessage:SCI_MARKERGET sub:lineNumber wparam:0];
    
    if (markerMask & (1 << BOOKMARK_MARKER)) {
        [self removeBookmarkAtLine:lineNumber];
    } else {
        [_textView sendmessage:SCI_MARKERADD sub:lineNumber wparam:BOOKMARK_MARKER];
        if (![_bookmarks containsObject:@(lineNumber)]) {
            [_bookmarks addObject:@(lineNumber)];
            [_bookmarks sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                return [(NSNumber*)obj1 compare:(NSNumber*)obj2];
            }];
        }
    }
}

- (void)toggleBookmarkAtCurrentLine {
    long currentPos = [_textView sendmessage:SCI_GETCURRENTPOS sub:0 wparam:0];
    long line = [_textView sendmessage:SCI_LINEFROMPOSITION sub:currentPos wparam:0];
    [self toggleBookmarkAtLine:line];
}

- (void)removeBookmarkAtLine:(NSInteger)lineNumber {
    [_textView sendmessage:SCI_MARKERDELETE sub:lineNumber wparam:BOOKMARK_MARKER];
    [_bookmarks removeObject:@(lineNumber)];
}

- (NSArray<NSNumber *> *)getAllBookmarks {
    return [_bookmarks copy]; // 返回不可变副本
}

- (void)navigateToNextBookmark {
    if (_bookmarks.count == 0) {
        return; // 或者可以发出通知，而不是弹窗
    }
    
    long currentPos = [_textView sendmessage:SCI_GETCURRENTPOS sub:0 wparam:0];
    long currentLine = [_textView sendmessage:SCI_LINEFROMPOSITION sub:currentPos wparam:0];
    
    // Find the next bookmark
    NSNumber *nextLine = nil;
    for (NSNumber *lineNumber in _bookmarks) {
        if ([lineNumber longValue] > currentLine) {
            nextLine = lineNumber;
            break;
        }
    }
    
    // If no next bookmark found, wrap to the first one
    if (!nextLine) {
        nextLine = _bookmarks.firstObject;
    }
    
    if (nextLine) {
        [self goToLine:[nextLine longValue]];
    }
}

- (void)nextBookmark {
    [self navigateToNextBookmark];
}

- (void)navigateToPreviousBookmark {
    if (_bookmarks.count == 0) {
        return; // 或者可以发出通知，而不是弹窗
    }
    
    long currentPos = [_textView sendmessage:SCI_GETCURRENTPOS sub:0 wparam:0];
    long currentLine = [_textView sendmessage:SCI_LINEFROMPOSITION sub:currentPos wparam:0];
    
    // Find the previous bookmark
    NSNumber *prevLine = nil;
    for (NSInteger i = _bookmarks.count - 1; i >= 0; i--) {
        NSNumber *lineNumber = _bookmarks[i];
        if ([lineNumber longValue] < currentLine) {
            prevLine = lineNumber;
            break;
        }
    }
    
    // If no previous bookmark found, wrap to the last one
    if (!prevLine) {
        prevLine = _bookmarks.lastObject;
    }
    
    if (prevLine) {
        [self goToLine:[prevLine longValue]];
    }
}

- (void)previousBookmark {
    [self navigateToPreviousBookmark];
}

- (void)goToLine:(long)line {
    // Get position of line
    long pos = [_textView sendmessage:SCI_POSITIONFROMLINE sub:line wparam:0];
    
    if (pos >= 0) {
        // Scroll to position
        [_textView sendmessage:SCI_GOTOPOS sub:pos wparam:0];
        
        // Move cursor to the beginning of the line
        [_textView sendmessage:SCI_SETCURRENTPOS sub:pos wparam:0];
    }
}

- (void)clearAllBookmarks {
    [_textView sendmessage:SCI_MARKERDELETEALL sub:BOOKMARK_MARKER wparam:0];
    [_bookmarks removeAllObjects];
}

@end