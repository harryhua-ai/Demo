//
//  EnhancedSyntaxHighlighter.h
//  NotepadPlusPlus
//
//  Created by Assistant on 12/12/2025.
//

#import <Cocoa/Cocoa.h>
#import "ScintillaView.h"

@interface EnhancedSyntaxHighlighter : NSObject

+ (void)applySyntaxHighlighting:(ScintillaView *)textView forLanguage:(NSString *)language;

+ (void)setupCodeFolding:(ScintillaView *)textView;
+ (void)setupBraceMatching:(ScintillaView *)textView;

// Individual language setup methods
+ (void)setupCppHighlighting:(ScintillaView *)textView;
+ (void)setupPythonHighlighting:(ScintillaView *)textView;
+ (void)setupJavaScriptHighlighting:(ScintillaView *)textView;
+ (void)setupHtmlHighlighting:(ScintillaView *)textView;
+ (void)setupXmlHighlighting:(ScintillaView *)textView;
+ (void)setupJavaHighlighting:(ScintillaView *)textView;
+ (void)setupPhpHighlighting:(ScintillaView *)textView;
+ (void)setupRubyHighlighting:(ScintillaView *)textView;
+ (void)setupCssHighlighting:(ScintillaView *)textView;
+ (void)setupSqlHighlighting:(ScintillaView *)textView;
+ (void)setupJsonHighlighting:(ScintillaView *)textView;
+ (void)setupYamlHighlighting:(ScintillaView *)textView;
+ (void)setupMarkdownHighlighting:(ScintillaView *)textView;
+ (void)setupBashHighlighting:(ScintillaView *)textView;

@end