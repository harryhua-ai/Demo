//
//  DarkModeManager.m
//  NotepadPlusPlus
//
//  Created by Assistant on 12/12/2025.
//

#import "DarkModeManager.h"
#import "ScintillaCocoa.h"

@implementation DarkModeManager

+ (BOOL)isDarkMode {
    NSString *osxMode = [[NSUserDefaults standardUserDefaults] stringForKey:@"AppleInterfaceStyle"];
    return [osxMode isEqualToString:@"Dark"];
}

- (void)applyDarkModeToTextView:(ScintillaView *)textView {
    // 修复方法调用问题，使用正确的ScintillaView方法
    [textView styleSetBack:STYLE_DEFAULT toColor:0x1e1e1e];
    [textView styleSetFore:STYLE_DEFAULT toColor:0xd4d4d4];
    
    // 设置光标颜色
    [textView setCaretFore:0xffffff];
    
    // 应用样式
    [textView colourise];
}

+ (void)applyLightModeToTextView:(ScintillaView *)textView {
    // Set background color to light
    [textView sendmessage:SCI_STYLESETBACK sub:STYLE_DEFAULT wparam:0xffffff];
    [textView sendmessage:SCI_STYLESETFORE sub:STYLE_DEFAULT wparam:0x000000];
    
    // Set caret color to dark
    [textView sendmessage:SCI_SETCARETFORE sub:0x000000 wparam:0];
    
    // Set selection background
    [textView sendmessage:SCI_SETSELBACK sub:1 wparam:0xc0c0c0];
    
    // Set margin background
    [textView sendmessage:SCI_SETMARGINBACKN sub:0 wparam:0xf0f0f0];
    [textView sendmessage:SCI_SETMARGINBACKN sub:1 wparam:0xf0f0f0];
    [textView sendmessage:SCI_SETMARGINBACKN sub:2 wparam:0xf0f0f0];
    
    // Apply to all styles
    [textView sendmessage:SCI_STYLECLEARALL sub:0 wparam:0];
    
    // Set colors for specific syntax elements (light mode defaults)
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_C_COMMENT wparam:0x008000];         // Green comment
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_C_COMMENTLINE wparam:0x008000];     // Green comment line
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_C_WORD wparam:0x0000ff];            // Blue keywords
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_C_STRING wparam:0xff00ff];          // Magenta strings
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_C_CHARACTER wparam:0xff00ff];       // Magenta chars
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_C_PREPROCESSOR wparam:0x804000];    // Brown preprocessors
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_C_OPERATOR wparam:0x000000];        // Black operators
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_C_IDENTIFIER wparam:0x000000];      // Black identifiers
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_C_NUMBER wparam:0xff8000];          // Orange numbers
    
    // Python specific
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_P_COMMENTLINE wparam:0x008000];    // Green comment
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_P_WORD wparam:0x0000ff];           // Blue keywords
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_P_STRING wparam:0xff00ff];         // Magenta strings
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_P_CHARACTER wparam:0xff00ff];      // Magenta chars
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_P_TRIPLE wparam:0xff00ff];         // Magenta triple strings
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_P_TRIPLEDOUBLE wparam:0xff00ff];   // Magenta triple double strings
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_P_CLASSNAME wparam:0x0000ff];      // Blue class names
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_P_DEFNAME wparam:0x0000ff];        // Blue def names
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_P_OPERATOR wparam:0x000000];       // Black operators
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_P_IDENTIFIER wparam:0x000000];     // Black identifiers
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_P_COMMENTBLOCK wparam:0x008000];   // Green comment blocks
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_P_STRINGEOL wparam:0xff00ff];      // Magenta EOL strings
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_P_WORD2 wparam:0x0000ff];          // Blue built-ins
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_P_DECORATOR wparam:0x804000];      // Brown decorators
    
    // JavaScript specific
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_JS_COMMENT wparam:0x008000];       // Green comment
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_JS_COMMENTLINE wparam:0x008000];   // Green comment line
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_JS_COMMENTDOC wparam:0x008000];    // Green doc comment
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_JS_WORD wparam:0x0000ff];          // Blue keywords
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_JS_STRING wparam:0xff00ff];        // Magenta strings
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_JS_STRINGEOL wparam:0xff00ff];     // Magenta EOL strings
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_JS_REGEX wparam:0xff0000];         // Red regex
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_JS_NUMBER wparam:0xff8000];        // Orange numbers
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_JS_OPERATOR wparam:0x000000];      // Black operators
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_JS_IDENTIFIER wparam:0x000000];    // Black identifiers
    
    // HTML specific
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_H_TAG wparam:0x0000ff];            // Blue tags
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_H_TAGUNKNOWN wparam:0x0000ff];     // Blue unknown tags
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_H_ATTRIBUTE wparam:0xff0000];      // Red attributes
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_H_ATTRIBUTEUNKNOWN wparam:0xff0000]; // Red unknown attributes
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_H_NUMBER wparam:0xff8000];         // Orange numbers
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_H_DOUBLESTRING wparam:0xff00ff];   // Magenta strings
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_H_SINGLESTRING wparam:0xff00ff];   // Magenta strings
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_H_OTHER wparam:0x000000];          // Black other
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_H_COMMENT wparam:0x008000];        // Green comments
    [textView sendmessage:SCI_STYLESETFORE sub:SCE_H_ENTITY wparam:0x804000];         // Brown entities
    
    // Set marker colors for light mode
    for (int i = 25; i <= 31; i++) {
        [textView sendmessage:SCI_MARKERSETFORE sub:i wparam:0xFFFFFF];
        [textView sendmessage:SCI_MARKERSETBACK sub:i wparam:0x000000];
    }
}

@end