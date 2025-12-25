//
//  PrintingHandler.m
//  NotepadPlusPlus
//
//  Created by Assistant on 12/12/2025.
//

#import "PrintingHandler.h"
#import "ScintillaCocoa.h"

@implementation PrintingHandler

+ (void)printTextView:(ScintillaView *)textView 
            withTitle:(NSString *)title
             delegate:(id)delegate {
    
    // Create a print operation with a custom print view
    NSPrintOperation *printOp = [self createPrintOperationForTextView:textView withTitle:title];
    printOp.delegate = delegate;
    
    // Run the print operation
    [printOp runOperation];
}

+ (NSPrintOperation *)createPrintOperationForTextView:(ScintillaView *)textView withTitle:(NSString *)title {
    // Get the text content from Scintilla
    long length = [textView sendmessage:SCI_GETLENGTH sub:0 wparam:0];
    if (length == 0) {
        // Show alert for empty document
        NSAlert *alert = [NSAlert alertWithMessageText:@"Nothing to Print"
                                         defaultButton:@"OK"
                                       alternateButton:nil
                                           otherButton:nil
                                 informativeTextWithFormat:@"The document is empty."];
        [alert runModal];
        return nil;
    }
    
    char *buffer = new char[length + 1];
    [textView sendmessage:SCI_GETTEXT sub:length+1 wparam:(sptr_t)buffer];
    NSString *content = [NSString stringWithUTF8String:buffer];
    delete[] buffer;
    
    // Create an attributed string for printing
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:content];
    
    // Apply basic styling
    NSFont *font = [NSFont userFixedPitchFontOfSize:10.0];
    [attributedString addAttribute:NSFontAttributeName 
                             value:font 
                             range:NSMakeRange(0, content.length)];
    
    // Create a text view for printing
    NSTextView *printView = [[NSTextView alloc] init];
    printView.textContainerInset = NSMakeSize(20, 20);
    [printView.textStorage setAttributedString:attributedString];
    
    // Create a scroll view for the print view
    NSScrollView *scrollView = [[NSScrollView alloc] init];
    scrollView.documentView = printView;
    
    // Set up print info
    NSPrintInfo *printInfo = [NSPrintInfo sharedPrintInfo];
    [printInfo setTopMargin:20.0];
    [printInfo setLeftMargin:20.0];
    [printInfo setRightMargin:20.0];
    [printInfo setBottomMargin:20.0];
    [printInfo setOrientation:NSPortraitOrientation];
    [printInfo setHorizontallyCentered:NO];
    [printInfo setVerticallyCentered:NO];
    
    // Create print operation
    NSPrintOperation *printOp = [NSPrintOperation printOperationWithView:scrollView.printDocumentView
                                                               printInfo:printInfo];
    printOp.showsProgressPanel = YES;
    printOp.jobTitle = title ?: @"Untitled";
    
    return printOp;
}

@end