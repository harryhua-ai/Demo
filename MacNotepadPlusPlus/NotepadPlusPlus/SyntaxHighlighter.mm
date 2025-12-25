//
//  SyntaxHighlighter.m
//  NotepadPlusPlus
//
//  Created by Assistant on 12/12/2025.
//

#import "SyntaxHighlighter.h"
#import "ScintillaCocoa.h"

@implementation SyntaxHighlighter

+ (void)applySyntaxHighlighting:(ScintillaView *)sciView language:(NSString *)language {
    // Reset to default
    [sciView sendmessage:SCI_SETLEXER sub:SCLEX_CONTAINER wparam:0];
    
    if ([language isEqualToString:@"C++"]) {
        [self setupCppHighlighting:sciView];
    } else if ([language isEqualToString:@"Python"]) {
        [self setupPythonHighlighting:sciView];
    } else if ([language isEqualToString:@"JavaScript"]) {
        [self setupJavaScriptHighlighting:sciView];
    } else if ([language isEqualToString:@"HTML"]) {
        [self setupHtmlHighlighting:sciView];
    } else if ([language isEqualToString:@"XML"]) {
        [self setupXmlHighlighting:sciView];
    } else {
        // Plain text - no highlighting
        [sciView sendmessage:SCI_STYLECLEARALL sub:0 wparam:0];
    }
}

+ (void)setupCppHighlighting:(ScintillaView *)sciView {
    [sciView sendmessage:SCI_SETLEXER sub:SCLEX_CPP wparam:0];
    
    // Define styles
    [sciView sendmessage:SCI_STYLESETFORE sub:SCE_C_COMMENT wparam:0x008000];         // Green
    [sciView sendmessage:SCI_STYLESETFORE sub:SCE_C_COMMENTLINE wparam:0x008000];     // Green
    [sciView sendmessage:SCI_STYLESETFORE sub:SCE_C_WORD wparam:0x0000FF];            // Blue
    [sciView sendmessage:SCI_STYLESETBOLD sub:SCE_C_WORD wparam:1];
    [sciView sendmessage:SCI_STYLESETFORE sub:SCE_C_STRING wparam:0xFF00FF];          // Magenta
    [sciView sendmessage:SCI_STYLESETFORE sub:SCE_C_CHARACTER wparam:0xFF00FF];       // Magenta
    [sciView sendmessage:SCI_STYLESETFORE sub:SCE_C_PREPROCESSOR wparam:0x804000];    // Brown
    [sciView sendmessage:SCI_STYLESETFORE sub:SCE_C_OPERATOR wparam:0x000000];        // Black
    [sciView sendmessage:SCI_STYLESETFORE sub:SCE_C_IDENTIFIER wparam:0x000000];      // Black
    [sciView sendmessage:SCI_STYLESETFORE sub:SCE_C_NUMBER wparam:0xFF8000];          // Orange
    
    // Set keywords
    const char* cppKeywords = "asm auto break case catch char class const const_cast continue default delete do double dynamic_cast else enum explicit export extern false float for friend goto if inline int long mutable namespace new operator private protected public register reinterpret_cast return short signed sizeof static static_cast struct switch template this throw true try typedef typeid typename union unsigned using virtual void volatile wchar_t while";
    [sciView sendmessage:SCI_SETKEYWORDS sub:0 wparam:(sptr_t)cppKeywords];
}

+ (void)setupPythonHighlighting:(ScintillaView *)sciView {
    [sciView sendmessage:SCI_SETLEXER sub:SCLEX_PYTHON wparam:0];
    
    // Define styles
    [sciView sendmessage:SCI_STYLESETFORE sub:SCE_P_COMMENTLINE wparam:0x008000];     // Green
    [sciView sendmessage:SCI_STYLESETFORE sub:SCE_P_WORD wparam:0x0000FF];            // Blue
    [sciView sendmessage:SCI_STYLESETBOLD sub:SCE_P_WORD wparam:1];
    [sciView sendmessage:SCI_STYLESETFORE sub:SCE_P_STRING wparam:0xFF00FF];          // Magenta
    [sciView sendmessage:SCI_STYLESETFORE sub:SCE_P_CHARACTER wparam:0xFF00FF];       // Magenta
    [sciView sendmessage:SCI_STYLESETFORE sub:SCE_P_TRIPLE wparam:0xFF8000];          // Orange
    [sciView sendmessage:SCI_STYLESETFORE sub:SCE_P_TRIPLEDOUBLE wparam:0xFF8000];    // Orange
    [sciView sendmessage:SCI_STYLESETFORE sub:SCE_P_CLASSNAME wparam:0x0000FF];       // Blue
    [sciView sendmessage:SCI_STYLESETFORE sub:SCE_P_DEFNAME wparam:0x0000FF];         // Blue
    [sciView sendmessage:SCI_STYLESETFORE sub:SCE_P_OPERATOR wparam:0x000000];        // Black
    [sciView sendmessage:SCI_STYLESETFORE sub:SCE_P_IDENTIFIER wparam:0x000000];      // Black
    [sciView sendmessage:SCI_STYLESETFORE sub:SCE_P_COMMENTBLOCK wparam:0x008000];    // Green
    [sciView sendmessage:SCI_STYLESETFORE sub:SCE_P_STRINGEOL wparam:0xFF00FF];       // Magenta
    [sciView sendmessage:SCI_STYLESETFORE sub:SCE_P_WORD2 wparam:0x0000FF];           // Blue
    [sciView sendmessage:SCI_STYLESETFORE sub:SCE_P_DECORATOR wparam:0x804000];       // Brown
    
    // Set keywords
    const char* pythonKeywords = "and as assert break class continue def del elif else except exec finally for from global if import in is lambda not or pass print raise return try while with yield";
    [sciView sendmessage:SCI_SETKEYWORDS sub:0 wparam:(sptr_t)pythonKeywords];
    
    const char* pythonBuiltins = "ArithmeticError AssertionError AttributeError BaseException BufferError BytesWarning DeprecationWarning EOFError Ellipsis EnvironmentError Exception False FloatingPointError FutureWarning GeneratorExit IOError ImportError ImportWarning IndentationError IndexError KeyError KeyboardInterrupt LookupError MemoryError NameError None NotImplemented NotImplementedError OSError OverflowError PendingDeprecationWarning ReferenceError RuntimeError RuntimeWarning StandardError StopIteration SyntaxError SyntaxWarning SystemError SystemExit TabError True TypeError UnboundLocalError UnicodeDecodeError UnicodeEncodeError UnicodeError UnicodeTranslateError UnicodeWarning UserWarning ValueError Warning ZeroDivisionError __debug__ __doc__ __import__ __name__ __package__ abs all any apply basestring bin bool buffer bytearray bytes callable chr classmethod cmp coerce compile complex copyright credits delattr dict dir divmod enumerate eval execfile exit file filter float format frozenset getattr globals hasattr hash help hex id input int intern isinstance issubclass iter len license list locals long map max memoryview min next object oct open ord pow print property quit range raw_input reduce reload repr reversed round set setattr slice sorted staticmethod str sum super tuple type unichr unicode vars xrange zip";
    [sciView sendmessage:SCI_SETKEYWORDS sub:1 wparam:(sptr_t)pythonBuiltins];
}

+ (void)setupJavaScriptHighlighting:(ScintillaView *)sciView {
    [sciView sendmessage:SCI_SETLEXER sub:SCLEX_JAVASCRIPT wparam:0];
    
    // Define styles
    [sciView sendmessage:SCI_STYLESETFORE sub:SCE_JS_COMMENT wparam:0x008000];        // Green
    [sciView sendmessage:SCI_STYLESETFORE sub:SCE_JS_COMMENTLINE wparam:0x008000];    // Green
    [sciView sendmessage:SCI_STYLESETFORE sub:SCE_JS_COMMENTDOC wparam:0x008000];     // Green
    [sciView sendmessage:SCI_STYLESETFORE sub:SCE_JS_WORD wparam:0x0000FF];           // Blue
    [sciView sendmessage:SCI_STYLESETBOLD sub:SCE_JS_WORD wparam:1];
    [sciView sendmessage:SCI_STYLESETFORE sub:SCE_JS_STRING wparam:0xFF00FF];         // Magenta
    [sciView sendmessage:SCI_STYLESETFORE sub:SCE_JS_STRINGEOL wparam:0xFF00FF];      // Magenta
    [sciView sendmessage:SCI_STYLESETFORE sub:SCE_JS_REGEX wparam:0xFF8000];          // Orange
    [sciView sendmessage:SCI_STYLESETFORE sub:SCE_JS_NUMBER wparam:0xFF8000];         // Orange
    [sciView sendmessage:SCI_STYLESETFORE sub:SCE_JS_OPERATOR wparam:0x000000];       // Black
    [sciView sendmessage:SCI_STYLESETFORE sub:SCE_JS_IDENTIFIER wparam:0x000000];     // Black
    
    // Set keywords
    const char* jsKeywords = "abstract boolean break byte case catch char class const continue debugger default delete do double else enum export extends final finally float for function goto if implements import in instanceof int interface long native new package private protected public return short static super switch synchronized this throw throws transient try typeof var void volatile while with";
    [sciView sendmessage:SCI_SETKEYWORDS sub:0 wparam:(sptr_t)jsKeywords];
}

+ (void)setupHtmlHighlighting:(ScintillaView *)sciView {
    [sciView sendmessage:SCI_SETLEXER sub:SCLEX_HTML wparam:0];
    
    // Define styles
    [sciView sendmessage:SCI_STYLESETFORE sub:SCE_H_TAG wparam:0x0000FF];             // Blue
    [sciView sendmessage:SCI_STYLESETBOLD sub:SCE_H_TAG wparam:1];
    [sciView sendmessage:SCI_STYLESETFORE sub:SCE_H_TAGUNKNOWN wparam:0x0000FF];      // Blue
    [sciView sendmessage:SCI_STYLESETBOLD sub:SCE_H_TAGUNKNOWN wparam:1];
    [sciView sendmessage:SCI_STYLESETFORE sub:SCE_H_ATTRIBUTE wparam:0xFF0000];       // Red
    [sciView sendmessage:SCI_STYLESETFORE sub:SCE_H_ATTRIBUTEUNKNOWN wparam:0xFF0000]; // Red
    [sciView sendmessage:SCI_STYLESETFORE sub:SCE_H_NUMBER wparam:0xFF8000];          // Orange
    [sciView sendmessage:SCI_STYLESETFORE sub:SCE_H_DOUBLESTRING wparam:0xFF00FF];    // Magenta
    [sciView sendmessage:SCI_STYLESETFORE sub:SCE_H_SINGLESTRING wparam:0xFF00FF];    // Magenta
    [sciView sendmessage:SCI_STYLESETFORE sub:SCE_H_OTHER wparam:0x000000];           // Black
    [sciView sendmessage:SCI_STYLESETFORE sub:SCE_H_COMMENT wparam:0x008000];         // Green
    [sciView sendmessage:SCI_STYLESETFORE sub:SCE_H_ENTITY wparam:0x804000];          // Brown
    
    // Set keywords
    const char* htmlTags = "a abbr acronym address applet area b base basefont bdo big blockquote body br button caption center cite code col colgroup dd del dfn dir div dl dt em fieldset font form frame frameset h1 h2 h3 h4 h5 h6 head hr html i iframe img input ins isindex kbd label legend li link map menu meta noframes noscript object ol optgroup option p param pre q s samp script select small span strike strong style sub sup table tbody td textarea tfoot th thead title tr tt u ul var xml xmlns";
    [sciView sendmessage:SCI_SETKEYWORDS sub:0 wparam:(sptr_t)htmlTags];
}

+ (void)setupXmlHighlighting:(ScintillaView *)sciView {
    [sciView sendmessage:SCI_SETLEXER sub:SCLEX_XML wparam:0];
    
    // Define styles
    [sciView sendmessage:SCI_STYLESETFORE sub:SCE_H_TAG wparam:0x0000FF];             // Blue
    [sciView sendmessage:SCI_STYLESETBOLD sub:SCE_H_TAG wparam:1];
    [sciView sendmessage:SCI_STYLESETFORE sub:SCE_H_TAGUNKNOWN wparam:0x0000FF];      // Blue
    [sciView sendmessage:SCI_STYLESETBOLD sub:SCE_H_TAGUNKNOWN wparam:1];
    [sciView sendmessage:SCI_STYLESETFORE sub:SCE_H_ATTRIBUTE wparam:0xFF0000];       // Red
    [sciView sendmessage:SCI_STYLESETFORE sub:SCE_H_ATTRIBUTEUNKNOWN wparam:0xFF0000]; // Red
    [sciView sendmessage:SCI_STYLESETFORE sub:SCE_H_NUMBER wparam:0xFF8000];          // Orange
    [sciView sendmessage:SCI_STYLESETFORE sub:SCE_H_DOUBLESTRING wparam:0xFF00FF];    // Magenta
    [sciView sendmessage:SCI_STYLESETFORE sub:SCE_H_SINGLESTRING wparam:0xFF00FF];    // Magenta
    [sciView sendmessage:SCI_STYLESETFORE sub:SCE_H_OTHER wparam:0x000000];           // Black
    [sciView sendmessage:SCI_STYLESETFORE sub:SCE_H_COMMENT wparam:0x008000];         // Green
    [sciView sendmessage:SCI_STYLESETFORE sub:SCE_H_ENTITY wparam:0x804000];          // Brown
}

@end