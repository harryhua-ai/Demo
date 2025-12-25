//
//  SyntaxHighlighter.h
//  NotepadPlusPlus
//
//  Created by Assistant on 12/12/2025.
//

#import <Foundation/Foundation.h>
#import "ScintillaView.h"

@interface SyntaxHighlighter : NSObject

+ (void)applySyntaxHighlighting:(ScintillaView *)sciView language:(NSString *)language;

@end