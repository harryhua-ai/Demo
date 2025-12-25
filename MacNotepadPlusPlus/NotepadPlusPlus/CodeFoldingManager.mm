//
//  CodeFoldingManager.m
//  NotepadPlusPlus
//
//  Created by Assistant on 12/12/2025.
//

#import "CodeFoldingManager.h"
#import "ScintillaCocoa.h"

@interface CodeFoldingManager()
@property (nonatomic, weak) ScintillaView *textView;
@end

@implementation CodeFoldingManager

+ (instancetype)sharedManager {
    static CodeFoldingManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[CodeFoldingManager alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        // 初始化逻辑
    }
    return self;
}

- (void)setTextView:(ScintillaView *)textView {
    _textView = textView;
    if (textView) {
        [self setupCodeFolding];
    }
}

- (void)setupFolding {
    // 修复方法调用问题，使用正确的ScintillaView方法
    [self.textView setProperty:@"fold" toValue:@"1"];
    [self.textView setProperty:@"fold.compact" toValue:@"0"];
    [self.textView setProperty:@"fold.comment" toValue:@"1"];
}

- (void)toggleFoldAtLine:(long)line {
    if (!self.textView) return;
    
    long level = [self.textView sendmessage:SCI_GETFOLDLEVEL sub:line wparam:0];
    
    // Check if the line has the header flag
    if (level & SC_FOLDLEVELHEADERFLAG) {
        // Toggle the fold
        BOOL isExpanded = [self.textView sendmessage:SCI_GETFOLDEXPANDED sub:line wparam:0];
        if (isExpanded) {
            [self.textView sendmessage:SCI_FOLDLINE sub:line wparam:SC_FOLDLEVELCONTRACTED];
        } else {
            [self.textView sendmessage:SCI_FOLDLINE sub:line wparam:SC_FOLDLEVELEXPANDED];
        }
    }
}

- (void)expandAllFolds {
    if (!self.textView) return;
    
    long maxLine = [self.textView sendmessage:SCI_GETLINECOUNT sub:0 wparam:0];
    for (long line = 0; line < maxLine; line++) {
        long level = [self.textView sendmessage:SCI_GETFOLDLEVEL sub:line wparam:0];
        if (level & SC_FOLDLEVELHEADERFLAG) {
            [self.textView sendmessage:SCI_FOLDLINE sub:line wparam:SC_FOLDLEVELEXPANDED];
        }
    }
}

- (void)collapseAllFolds {
    if (!self.textView) return;
    
    long maxLine = [self.textView sendmessage:SCI_GETLINECOUNT sub:0 wparam:0];
    for (long line = 0; line < maxLine; line++) {
        long level = [self.textView sendmessage:SCI_GETFOLDLEVEL sub:line wparam:0];
        if (level & SC_FOLDLEVELHEADERFLAG) {
            [self.textView sendmessage:SCI_FOLDLINE sub:line wparam:SC_FOLDLEVELCONTRACTED];
        }
    }
}

- (void)toggleCurrentFold {
    if (!self.textView) return;
    
    long currentPos = [self.textView sendmessage:SCI_GETCURRENTPOS sub:0 wparam:0];
    long line = [self.textView sendmessage:SCI_LINEFROMPOSITION sub:currentPos wparam:0];
    
    // Find the nearest fold point
    long foldLine = line;
    long level = [self.textView sendmessage:SCI_GETFOLDLEVEL sub:foldLine wparam:0];
    
    // Look up for a header
    while (foldLine >= 0 && !(level & SC_FOLDLEVELHEADERFLAG)) {
        foldLine--;
        if (foldLine >= 0) {
            level = [self.textView sendmessage:SCI_GETFOLDLEVEL sub:foldLine wparam:0];
        }
    }
    
    if (foldLine >= 0 && (level & SC_FOLDLEVELHEADERFLAG)) {
        [self toggleFoldAtLine:foldLine];
    }
}

@end