//
//  EnhancedCodeFoldingManager.m
//  NotepadPlusPlus
//
//  Created by Assistant on 12/12/2025.
//

#import "EnhancedCodeFoldingManager.h"
#import "ScintillaCocoa.h"

@implementation EnhancedCodeFoldingManager

- (instancetype)initWithTextView:(ScintillaView *)textView {
    self = [super init];
    if (self) {
        _textView = textView;
        [self setupFoldingStyles];
    }
    return self;
}

- (void)setupFoldingStyles {
    // Setup folding markers
    [self.textView sendmessage:SCI_SETMARGINTYPEN sub:2 wparam:SC_MARGIN_SYMBOL];
    [self.textView sendmessage:SCI_SETMARGINMASKN sub:2 wparam:SC_MASK_FOLDERS];
    [self.textView sendmessage:SCI_SETMARGINWIDTHN sub:2 wparam:14]; // Adjust width as needed
    [self.textView sendmessage:SCI_SETMARGINSENSITIVEN sub:2 wparam:1]; // Make margin sensitive to clicks
    
    // Setup folding markers
    [self.textView sendmessage:SCI_MARKERDEFINE sub:SC_MARKNUM_FOLDEROPEN wparam:SC_MARK_BOXMINUS];
    [self.textView sendmessage:SCI_MARKERDEFINE sub:SC_MARKNUM_FOLDER wparam:SC_MARK_BOXPLUS];
    [self.textView sendmessage:SCI_MARKERDEFINE sub:SC_MARKNUM_FOLDERSUB wparam:SC_MARK_VLINE];
    [self.textView sendmessage:SCI_MARKERDEFINE sub:SC_MARKNUM_FOLDERTAIL wparam:SC_MARK_LCORNER];
    [self.textView sendmessage:SCI_MARKERDEFINE sub:SC_MARKNUM_FOLDEREND wparam:SC_MARK_BOXPLUSCONNECTED];
    [self.textView sendmessage:SCI_MARKERDEFINE sub:SC_MARKNUM_FOLDEROPENMID wparam:SC_MARK_BOXMINUSCONNECTED];
    [self.textView sendmessage:SCI_MARKERDEFINE sub:SC_MARKNUM_FOLDERMIDTAIL wparam:SC_MARK_TCORNER];
    
    // Setup folding colors
    [self.textView sendmessage:SCI_MARKERSETFORE sub:SC_MARKNUM_FOLDEROPEN wparam:0xFFFFFF]; // White
    [self.textView sendmessage:SCI_MARKERSETBACK sub:SC_MARKNUM_FOLDEROPEN wparam:0x000000]; // Black
    [self.textView sendmessage:SCI_MARKERSETFORE sub:SC_MARKNUM_FOLDER wparam:0xFFFFFF]; // White
    [self.textView sendmessage:SCI_MARKERSETBACK sub:SC_MARKNUM_FOLDER wparam:0x000000]; // Black
    [self.textView sendmessage:SCI_MARKERSETFORE sub:SC_MARKNUM_FOLDERSUB wparam:0xFFFFFF]; // White
    [self.textView sendmessage:SCI_MARKERSETBACK sub:SC_MARKNUM_FOLDERSUB wparam:0x000000]; // Black
    [self.textView sendmessage:SCI_MARKERSETFORE sub:SC_MARKNUM_FOLDERTAIL wparam:0xFFFFFF]; // White
    [self.textView sendmessage:SCI_MARKERSETBACK sub:SC_MARKNUM_FOLDERTAIL wparam:0x000000]; // Black
    [self.textView sendmessage:SCI_MARKERSETFORE sub:SC_MARKNUM_FOLDEREND wparam:0xFFFFFF]; // White
    [self.textView sendmessage:SCI_MARKERSETBACK sub:SC_MARKNUM_FOLDEREND wparam:0x000000]; // Black
    [self.textView sendmessage:SCI_MARKERSETFORE sub:SC_MARKNUM_FOLDEROPENMID wparam:0xFFFFFF]; // White
    [self.textView sendmessage:SCI_MARKERSETBACK sub:SC_MARKNUM_FOLDEROPENMID wparam:0x000000]; // Black
    [self.textView sendmessage:SCI_MARKERSETFORE sub:SC_MARKNUM_FOLDERMIDTAIL wparam:0xFFFFFF]; // White
    [self.textView sendmessage:SCI_MARKERSETBACK sub:SC_MARKNUM_FOLDERMIDTAIL wparam:0x000000]; // Black
    
    // Enable folding
    [self.textView sendmessage:SCI_SETFOLDMARGINCOLOUR sub:1 wparam:0xF0F0F0]; // Light gray background
    [self.textView sendmessage:SCI_SETFOLDFLAGS sub:SC_FOLDFLAG_LINEAFTER_CONTRACTED wparam:0];
}

- (void)setupCodeFoldingForLanguage:(NSString *)language {
    // Enable folding
    [self.textView sendmessage:SCI_SETMARGINTYPEN sub:2 wparam:SC_MARGIN_SYMBOL];
    [self.textView sendmessage:SCI_SETMARGINWIDTHN sub:2 wparam:14];
    [self.textView sendmessage:SCI_SETMARGINMASKN sub:2 wparam:SC_MASK_FOLDERS];
    [self.textView sendmessage:SCI_SETMARGINSENSITIVEN sub:2 wparam:1];
    
    // Set folding properties based on language
    if ([language isEqualToString:@"C++"] || [language isEqualToString:@"JavaScript"] || 
        [language isEqualToString:@"Python"] || [language isEqualToString:@"HTML"] ||
        [language isEqualToString:@"XML"]) {
        [self.textView sendmessage:SCI_SETPROPERTY sub:(sptr_t)"fold" wparam:(sptr_t)"1"];
        [self.textView sendmessage:SCI_SETPROPERTY sub:(sptr_t)"fold.compact" wparam:(sptr_t)"0"];
        [self.textView sendmessage:SCI_SETPROPERTY sub:(sptr_t)"fold.comment" wparam:(sptr_t)"1"];
        [self.textView sendmessage:SCI_SETPROPERTY sub:(sptr_t)"fold.preprocessor" wparam:(sptr_t)"1"];
        
        if ([language isEqualToString:@"Python"]) {
            [self.textView sendmessage:SCI_SETPROPERTY sub:(sptr_t)"fold.quotes.python" wparam:(sptr_t)"1"];
        }
        
        if ([language isEqualToString:@"HTML"] || [language isEqualToString:@"XML"]) {
            [self.textView sendmessage:SCI_SETPROPERTY sub:(sptr_t)"fold.html" wparam:(sptr_t)"1"];
        }
    } else {
        // Disable folding for plain text and unsupported languages
        [self.textView sendmessage:SCI_SETMARGINWIDTHN sub:2 wparam:0];
    }
}

- (void)collapseAllFolds {
    [self.textView sendmessage:SCI_COLOURISE sub:0 wparam:-1];
    long maxLine = [self.textView sendmessage:SCI_GETLINECOUNT sub:0 wparam:0];
    for (long line = 0; line < maxLine; line++) {
        long level = [self.textView sendmessage:SCI_GETFOLDLEVEL sub:line wparam:0];
        if ((level & SC_FOLDLEVELHEADERFLAG) && 
            [self.textView sendmessage:SCI_GETFOLDEXPANDED sub:line wparam:0]) {
            [self.textView sendmessage:SCI_TOGGLEFOLD sub:line wparam:0];
        }
    }
}

- (void)expandAllFolds {
    [self.textView sendmessage:SCI_COLOURISE sub:0 wparam:-1];
    long maxLine = [self.textView sendmessage:SCI_GETLINECOUNT sub:0 wparam:0];
    for (long line = 0; line < maxLine; line++) {
        long level = [self.textView sendmessage:SCI_GETFOLDLEVEL sub:line wparam:0];
        if ((level & SC_FOLDLEVELHEADERFLAG) && 
            ![self.textView sendmessage:SCI_GETFOLDEXPANDED sub:line wparam:0]) {
            [self.textView sendmessage:SCI_TOGGLEFOLD sub:line wparam:0];
        }
    }
}

- (void)toggleCurrentFold {
    long currentPos = [self.textView sendmessage:SCI_GETCURRENTPOS sub:0 wparam:0];
    long line = [self.textView sendmessage:SCI_LINEFROMPOSITION sub:currentPos wparam:0];
    
    long level = [self.textView sendmessage:SCI_GETFOLDLEVEL sub:line wparam:0];
    if (level & SC_FOLDLEVELHEADERFLAG) {
        [self.textView sendmessage:SCI_TOGGLEFOLD sub:line wparam:0];
    }
}

- (void)collapseLevel:(int)level {
    [self.textView sendmessage:SCI_COLOURISE sub:0 wparam:-1];
    long maxLine = [self.textView sendmessage:SCI_GETLINECOUNT sub:0 wparam:0];
    for (long line = 0; line < maxLine; line++) {
        long lineLevel = [self.textView sendmessage:SCI_GETFOLDLEVEL sub:line wparam:0];
        if ((lineLevel & SC_FOLDLEVELNUMBERMASK) == level) {
            if ((lineLevel & SC_FOLDLEVELHEADERFLAG) && 
                [self.textView sendmessage:SCI_GETFOLDEXPANDED sub:line wparam:0]) {
                [self.textView sendmessage:SCI_TOGGLEFOLD sub:line wparam:0];
            }
        }
    }
}

- (void)expandLevel:(int)level {
    [self.textView sendmessage:SCI_COLOURISE sub:0 wparam:-1];
    long maxLine = [self.textView sendmessage:SCI_GETLINECOUNT sub:0 wparam:0];
    for (long line = 0; line < maxLine; line++) {
        long lineLevel = [self.textView sendmessage:SCI_GETFOLDLEVEL sub:line wparam:0];
        if ((lineLevel & SC_FOLDLEVELNUMBERMASK) == level) {
            if ((lineLevel & SC_FOLDLEVELHEADERFLAG) && 
                ![self.textView sendmessage:SCI_GETFOLDEXPANDED sub:line wparam:0]) {
                [self.textView sendmessage:SCI_TOGGLEFOLD sub:line wparam:0];
            }
        }
    }
}

@end