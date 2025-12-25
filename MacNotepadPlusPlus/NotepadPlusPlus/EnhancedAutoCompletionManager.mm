//
//  EnhancedAutoCompletionManager.m
//  NotepadPlusPlus
//
//  Created by Assistant on 12/12/2025.
//

#import "EnhancedAutoCompletionManager.h"
#import "ScintillaCocoa.h"

@implementation EnhancedAutoCompletionManager

- (instancetype)initWithTextView:(ScintillaView *)textView {
    self = [super init];
    if (self) {
        _textView = textView;
        _customWords = [NSMutableArray array];
        [self setupLanguageKeywords];
    }
    return self;
}

- (void)setupLanguageKeywords {
    // Setup keywords for different languages
    NSMutableDictionary *keywords = [NSMutableDictionary dictionary];
    
    // C++ keywords
    keywords[@"C++"] = @[
        @"auto", @"break", @"case", @"char", @"const", @"continue", @"default", @"do",
        @"double", @"else", @"enum", @"extern", @"float", @"for", @"goto", @"if",
        @"int", @"long", @"register", @"return", @"short", @"signed", @"sizeof", @"static",
        @"struct", @"switch", @"typedef", @"union", @"unsigned", @"void", @"volatile", @"while",
        @"bool", @"catch", @"class", @"const_cast", @"delete", @"dynamic_cast", @"explicit",
        @"false", @"friend", @"inline", @"mutable", @"namespace", @"new", @"operator",
        @"private", @"protected", @"public", @"reinterpret_cast", @"static_cast",
        @"template", @"this", @"throw", @"true", @"try", @"typeid", @"typename",
        @"using", @"virtual", @"wchar_t"
    ];
    
    // Python keywords
    keywords[@"Python"] = @[
        @"and", @"as", @"assert", @"break", @"class", @"continue", @"def", @"del",
        @"elif", @"else", @"except", @"exec", @"finally", @"for", @"from", @"global",
        @"if", @"import", @"in", @"is", @"lambda", @"not", @"or", @"pass",
        @"print", @"raise", @"return", @"try", @"while", @"with", @"yield",
        @"None", @"True", @"False"
    ];
    
    // JavaScript keywords
    keywords[@"JavaScript"] = @[
        @"break", @"case", @"catch", @"class", @"const", @"continue", @"debugger", @"default",
        @"delete", @"do", @"else", @"export", @"extends", @"finally", @"for", @"function",
        @"if", @"import", @"in", @"instanceof", @"let", @"new", @"return", @"super",
        @"switch", @"this", @"throw", @"try", @"typeof", @"var", @"void", @"while",
        @"with", @"yield", @"null", @"true", @"false", @"undefined"
    ];
    
    // HTML tags
    keywords[@"HTML"] = @[
        @"a", @"abbr", @"address", @"area", @"article", @"aside", @"audio",
        @"b", @"base", @"bb", @"bdo", @"blockquote", @"body", @"br", @"button",
        @"canvas", @"caption", @"cite", @"code", @"col", @"colgroup", @"command",
        @"datalist", @"dd", @"del", @"details", @"dfn", @"dialog", @"div", @"dl",
        @"dt", @"em", @"embed", @"eventsource",
        @"fieldset", @"figcaption", @"figure", @"footer", @"form",
        @"h1", @"h2", @"h3", @"h4", @"h5", @"h6", @"head", @"header", @"hgroup", @"hr", @"html",
        @"i", @"iframe", @"img", @"input", @"ins", @"kbd", @"keygen",
        @"label", @"legend", @"li", @"link",
        @"map", @"mark", @"menu", @"meta", @"meter",
        @"nav", @"noscript",
        @"object", @"ol", @"optgroup", @"option", @"output",
        @"p", @"param", @"pre", @"progress",
        @"q", @"ruby", @"rp", @"rt",
        @"samp", @"script", @"section", @"select", @"small", @"source", @"span", @"strong", @"style", @"sub", @"summary", @"sup",
        @"table", @"tbody", @"td", @"textarea", @"tfoot", @"th", @"thead", @"time", @"title", @"tr", @"track",
        @"ul", @"var", @"video",
        @"wbr"
    ];
    
    // XML tags
    keywords[@"XML"] = @[
        @"element", @"attribute", @"text", @"comment", @"processing-instruction", @"cdata"
    ];
    
    // Plain text (no keywords)
    keywords[@"Plain Text"] = @[ ];
    
    _languageKeywords = [keywords copy];
}

- (void)setupAutoCompletionForLanguage:(NSString *)language {
    // Clear any existing keywords
    [self.textView sendmessage:SCI_CLEARALLCMDKEYS sub:0 wparam:0];
    
    // Get keywords for the language
    NSArray *keywords = self.languageKeywords[language];
    if (!keywords) {
        keywords = @[];
    }
    
    // Combine language keywords with custom words
    NSMutableArray *allWords = [NSMutableArray arrayWithArray:keywords];
    [allWords addObjectsFromArray:self.customWords];
    
    // Sort and remove duplicates
    NSSet *uniqueWords = [NSSet setWithArray:allWords];
    NSArray *sortedWords = [[uniqueWords allObjects] sortedArrayUsingSelector:@selector(compare:)];
    
    // Create auto-completion list
    NSMutableString *wordList = [NSMutableString string];
    for (NSString *word in sortedWords) {
        if (wordList.length > 0) {
            [wordList appendString:@" "];
        }
        [wordList appendString:word];
    }
    
    // Register auto-completion words with Scintilla
    if (wordList.length > 0) {
        [self.textView sendmessage:SCI_AUTOCSETIGNORECASE sub:1 wparam:0]; // Case insensitive
        [self.textView sendmessage:SCI_AUTOCSETCHOOSESINGLE sub:1 wparam:0]; // Auto-insert if single match
        [self.textView sendmessage:SCI_AUTOCSETDROPRESTOFWORD sub:1 wparam:0]; // Drop rest of word after completion
        [self.textView sendmessage:SCI_AUTOCSETMAXHEIGHT sub:10 wparam:0]; // Max 10 rows
        [self.textView sendmessage:SCI_AUTOCSETMAXWIDTH sub:0 wparam:0]; // No width limit
        
        // Set auto-completion separator (space)
        [self.textView sendmessage:SCI_AUTOCSETSEPARATOR sub:' ' wparam:0];
    }
}

- (void)showAutoCompletion {
    // Get current position
    long currentPos = [self.textView sendmessage:SCI_GETCURRENTPOS sub:0 wparam:0];
    
    // Get word start position
    long wordStartPos = [self.textView sendmessage:SCI_WORDSTARTPOSITION sub:currentPos wparam:1];
    
    // Calculate word length
    long wordLen = currentPos - wordStartPos;
    
    // Show auto-completion if we have at least 1 character
    if (wordLen > 0) {
        [self.textView sendmessage:SCI_AUTOCSHOW sub:wordLen wparam:0];
    }
}

- (void)hideAutoCompletion {
    [self.textView sendmessage:SCI_AUTOCCANCEL sub:0 wparam:0];
}

- (void)addCustomWord:(NSString *)word {
    if (![self.customWords containsObject:word]) {
        [(NSMutableArray *)self.customWords addObject:word];
    }
}

- (void)removeCustomWord:(NSString *)word {
    if ([self.customWords containsObject:word]) {
        [(NSMutableArray *)self.customWords removeObject:word];
    }
}

- (NSArray *)getSuggestionsForPrefix:(NSString *)prefix {
    NSMutableArray *suggestions = [NSMutableArray array];
    
    // Collect all words
    NSMutableArray *allWords = [NSMutableArray array];
    
    // Add language keywords
    for (NSArray *keywords in self.languageKeywords.allValues) {
        [allWords addObjectsFromArray:keywords];
    }
    
    // Add custom words
    [allWords addObjectsFromArray:self.customWords];
    
    // Filter by prefix
    for (NSString *word in allWords) {
        if ([word hasPrefix:prefix]) {
            [suggestions addObject:word];
        }
    }
    
    // Remove duplicates and sort
    NSSet *uniqueSuggestions = [NSSet setWithArray:suggestions];
    return [[uniqueSuggestions allObjects] sortedArrayUsingSelector:@selector(compare:)];
}

@end