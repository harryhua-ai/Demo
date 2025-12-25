//
//  PrintingHandler.h
//  NotepadPlusPlus
//
//  Created by Assistant on 12/12/2025.
//

#import <Cocoa/Cocoa.h>
#import "ScintillaView.h"

@interface PrintingHandler : NSObject

+ (void)printTextView:(ScintillaView *)textView 
            withTitle:(NSString *)title
             delegate:(id)delegate;

@end