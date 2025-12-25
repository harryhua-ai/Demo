//
//  AutoCompletionManager.h
//  NotepadPlusPlus
//
//  Created by Assistant on 2025-05-13.
//

#import <Foundation/Foundation.h>
#import "ScintillaCocoa.h"

@interface AutoCompletionManager : NSObject

@property (nonatomic, readonly) id enhancedAutoCompletionManager;

+ (AutoCompletionManager *)sharedManager;
- (void)setTextView:(ScintillaView *)textView;
- (void)setupAutoCompletionForLanguage:(NSString *)language;
- (void)showAutoCompletion;
- (void)hideAutoCompletion;
- (void)addCustomWord:(NSString *)word;
- (void)removeCustomWord:(NSString *)word;
- (void)handleCharacter:(char)ch;

@end
//
//  EnhancedAutoCompletionManager.mm
//  NotepadPlusPlus
//
//  Created by Assistant on 2025-05-13.
//

#import "EnhancedAutoCompletionManager.h"
#import "ScintillaCocoa.h"

@implementation EnhancedAutoCompletionManager {
    NSMutableSet<NSString *> *_customWords;
    NSMutableDictionary<NSString *, NSString *> *_languageKeywords;
}

- (instancetype)initWithTextView:(ScintillaView *)textView {
    self = [super init];
    if (self) {
        _textView = textView;
        _customWords = [[NSMutableSet alloc] init];
        _languageKeywords = [[NSMutableDictionary alloc] init];
        
        // Initialize language keywords
        [self initializeLanguageKeywords];
        
        // Setup default auto-completion
        [self setupAutoCompletionForLanguage:@"cpp"];
        
        // Register for notifications if needed
    }
    return self;
}

- (void)initializeLanguageKeywords {
    // C++ keywords
    NSString *cppWords = @"auto break case catch char class const continue default delete do double else enum extern false float for friend goto if inline int long mutable namespace new operator private protected public register return short signed sizeof static struct switch template this throw true try typedef union unsigned using virtual void volatile while";
    
    // Python keywords
    NSString *pythonWords = @"and as assert break class continue def del elif else except exec finally for from global if import in is lambda not or pass print raise return try while with yield";
    
    // JavaScript keywords
    NSString *jsWords = @"abstract boolean break byte case catch char class const continue debugger default delete do double else enum export extends final finally float for function goto if implements import in instanceof int interface long native new package private protected public return short static super switch synchronized this throw throws transient try typeof var void volatile while with";
    
    // HTML tags
    NSString *htmlWords = @"a abbr acronym address applet area b base basefont bdo big blockquote body br button caption center cite code col colgroup dd del dfn dir div dl dt em fieldset font form frame frameset h1 h2 h3 h4 h5 h6 head hr html i iframe img input ins isindex kbd label legend li link map menu meta noframes noscript object ol optgroup option p param pre q s samp script select small span strike strong style sub sup table tbody td textarea tfoot th thead title tr tt u ul var xml xmlns";
    
    // CSS properties and values
    NSString *cssWords = @"align-content align-items align-self all animation animation-delay animation-direction animation-duration animation-fill-mode animation-iteration-count animation-name animation-play-state animation-timing-function backface-visibility background background-attachment background-clip background-color background-image background-origin background-position background-repeat background-size border border-bottom border-bottom-color border-bottom-left-radius border-bottom-right-radius border-bottom-style border-bottom-width border-collapse border-color border-left border-left-color border-left-style border-left-width border-radius border-right border-right-color border-right-style border-right-width border-spacing border-style border-top border-top-color border-top-left-radius border-top-right-radius border-top-style border-top-width border-width bottom box-shadow box-sizing caption-side clear clip color column-count column-fill column-gap column-rule column-rule-color column-rule-style column-rule-width column-span column-width columns content cursor direction display empty-cells filter flex flex-basis flex-direction flex-flow flex-grow flex-shrink flex-wrap float font font-family font-feature-settings font-kerning font-language-override font-size font-size-adjust font-stretch font-style font-synthesis font-variant font-variant-alternates font-variant-caps font-variant-east-asian font-variant-ligatures font-variant-numeric font-variant-position font-weight height justify-content left letter-spacing line-height list-style list-style-image list-style-position list-style-type margin margin-bottom margin-left margin-right margin-top max-height max-width min-height min-width opacity order outline outline-color outline-offset outline-style outline-width overflow overflow-x overflow-y padding padding-bottom padding-left padding-right padding-top page-break-after page-break-before page-break-inside perspective perspective-origin pointer-events position quotes resize right tab-size table-layout text-align text-align-last text-decoration text-decoration-color text-decoration-line text-decoration-style text-indent text-overflow text-shadow text-transform top transform transform-origin transform-style transition transition-delay transition-duration transition-property transition-timing-function unicode-bidi vertical-align visibility white-space width word-break word-spacing word-wrap writing-mode z-index";
    
    _languageKeywords[@"cpp"] = cppWords;
    _languageKeywords[@"python"] = pythonWords;
    _languageKeywords[@"javascript"] = jsWords;
    _languageKeywords[@"html"] = htmlWords;
    _languageKeywords[@"css"] = cssWords;
    _languageKeywords[@"js"] = jsWords; // Alias for javascript
}

- (void)setupAutoCompletionForLanguage:(NSString *)language {
    // Enable auto-completion
    [_textView sendmessage:SCI_AUTOCSETSEPARATOR sub:' ' wparam:0];
    
    // Set auto-completion fillups - characters that auto-trigger completion
    [_textView sendmessage:SCI_AUTOCSETFillUPS sub:0 wparam:(sptr_t)".("];
    
    // Set auto-completion to cancel when typing whitespace
    [_textView sendmessage:SCI_AUTOCSETCANCELATSTART sub:1 wparam:0];
    
    // Set auto-completion to auto-hide
    [_textView sendmessage:SCI_AUTOCSETAUTOHIDE sub:1 wparam:0];
    
    // Set auto-completion to drop rest of word when selecting
    [_textView sendmessage:SCI_AUTOCSETDROPRESTOFWORD sub:1 wparam:0];
    
    // Set auto-completion colors
    [_textView sendmessage:SCI_AUTOCSETBACK sub:0xffffff wparam:0]; // White background
    [_textView sendmessage:SCI_AUTOCSETFORE sub:0x000000 wparam:0]; // Black text
    
    // Set auto-completion selection colors
    [_textView sendmessage:SCI_AUTOCSETSELBACK sub:0x000080 wparam:0]; // Blue selection background
    [_textView sendmessage:SCI_AUTOCSETSELFORE sub:0xffffff wparam:0]; // White selection text
    
    // Set auto-completion width and height
    [_textView sendmessage:SCI_AUTOCSETMAXHEIGHT sub:15 wparam:0]; // Max 15 rows
    [_textView sendmessage:SCI_AUTOCSETMAXWIDTH sub:0 wparam:0];   // No max width
    
    // Set auto-completion choose single
    [_textView sendmessage:SCI_AUTOCSETCHOOSESINGLE sub:1 wparam:0];
    
    // Set case insensitive behavior
    [_textView sendmessage:SCI_AUTOCSETIGNORECASE sub:1 wparam:0];
    
    // Register for character added notifications
    [_textView sendmessage:SCI_SETMODEVENTMASK sub:SC_MOD_INSERTTEXT wparam:0];
}

- (void)showAutoCompletion {
    // Get current word
    long currentPos = [_textView sendmessage:SCI_GETCURRENTPOS sub:0 wparam:0];
    long wordStart = [_textView sendmessage:SCI_WORDSTARTPOSITION sub:currentPos wparam:1];
    long wordEnd = [_textView sendmessage:SCI_WORDENDPOSITION sub:currentPos wparam:1];
    
    if (wordEnd - wordStart > 0) {
        // Get the word
        char *buffer = new char[wordEnd - wordStart + 1];
        [_textView sendmessage:SCI_GETTEXTRANGE sub:wordStart wparam:(sptr_t)buffer lParam:wordEnd];
        NSString *word = [NSString stringWithUTF8String:buffer];
        delete[] buffer;
        
        // Show auto-completion based on current word
        [self showCompletionForWord:word];
    }
}

- (void)showCompletionForWord:(NSString *)word {
    // Determine which set of words to use based on current lexer
    long lexer = [_textView sendmessage:SCI_GETLEXER sub:0 wparam:0];
    NSString *words = nil;
    
    switch (lexer) {
        case SCLEX_PYTHON:
            words = _languageKeywords[@"python"];
            break;
        case SCLEX_CPP:
            words = _languageKeywords[@"cpp"];
            break;
        case SCLEX_HTML:
            words = _languageKeywords[@"html"];
            break;
        case SCLEX_CSS:
            words = _languageKeywords[@"css"];
            break;
        case SCLEX_JS:
        case SCLEX_JSON:
            words = _languageKeywords[@"javascript"];
            break;
        default:
            words = _languageKeywords[@"cpp"]; // Default to C++
            break;
    }
    
    // Add custom words to the completion list
    NSMutableSet *allWords = [NSMutableSet setWithArray:[words componentsSeparatedByString:@" "]];
    [allWords unionSet:_customWords];
    
    // Filter words based on current input
    NSArray *filteredWords = @[];
    if (word.length > 0) {
        filteredWords = [[allWords objectsPassingTest:^BOOL(NSString *w, BOOL *stop) {
            return [w.lowercaseString hasPrefix:word.lowercaseString];
        }] allObjects];
    } else {
        filteredWords = [allWords allObjects];
    }
    
    if (filteredWords.count > 0) {
        NSString *completionList = [filteredWords componentsJoinedByString:@" "];
        // Show auto-completion
        [_textView sendmessage:SCI_AUTOCSHOW sub:word.length wparam:(sptr_t)[completionList UTF8String]];
    }
}

- (void)hideAutoCompletion {
    [_textView sendmessage:SCI_AUTOCCANCEL sub:0 wparam:0];
}

- (void)addCustomWord:(NSString *)word {
    if (word && word.length > 0) {
        [_customWords addObject:word];
    }
}

- (void)removeCustomWord:(NSString *)word {
    if (word && word.length > 0) {
        [_customWords removeObject:word];
    }
}

- (void)handleCharacter:(char)ch {
    // Trigger auto-completion on certain characters
    switch (ch) {
        case '.':
        case '>':
        case ':':
        case '#':
        case '@':
            // Show auto-completion after these characters
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self showAutoCompletion];
            });
            break;
        case ' ':
        case '\n':
        case '\t':
        case ';':
        case '{':
        case '}':
        case '[':
        case ']':
        case '(':
        case ')':
            // Cancel auto-completion on various delimiters
            [_textView sendmessage:SCI_AUTOCCANCEL sub:0 wparam:0];
            break;
        default:
            // For alphabetic characters, show auto-completion if we're at a word start
            if ((ch >= 'a' && ch <= 'z') || (ch >= 'A' && ch <= 'Z') || ch == '_') {
                long currentPos = [_textView sendmessage:SCI_GETCURRENTPOS sub:0 wparam:0];
                long wordStart = [_textView sendmessage:SCI_WORDSTARTPOSITION sub:currentPos wparam:1];
                
                // If we're at the start of a word, show auto-completion
                if (currentPos == wordStart) {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self showAutoCompletion];
                    });
                }
            }
            break;
    }
}

@end
//
//  EnhancedAutoCompletionManager.h
//  NotepadPlusPlus
//
//  Created by Assistant on 2025-05-13.
//

#import <Foundation/Foundation.h>
#import "ScintillaCocoa.h"

@interface EnhancedAutoCompletionManager : NSObject

@property (nonatomic, weak) ScintillaView *textView;

- (instancetype)initWithTextView:(ScintillaView *)textView;
- (void)setupAutoCompletionForLanguage:(NSString *)language;
- (void)showAutoCompletion;
- (void)hideAutoCompletion;
- (void)addCustomWord:(NSString *)word;
- (void)removeCustomWord:(NSString *)word;
- (void)handleCharacter:(char)ch;

@end
//
//  AutoCompletionManager.m
//  NotepadPlusPlus
//
//  Created by Assistant on 12/12/2025.
//

#import "AutoCompletionManager.h"
#import "EnhancedAutoCompletionManager.h"

@implementation AutoCompletionManager {
    EnhancedAutoCompletionManager *_enhancedAutoCompletionManager;
}

+ (AutoCompletionManager *)sharedManager {
    static AutoCompletionManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[AutoCompletionManager alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)setTextView:(ScintillaView *)textView {
    if (!_enhancedAutoCompletionManager || _enhancedAutoCompletionManager.textView != textView) {
        _enhancedAutoCompletionManager = [[EnhancedAutoCompletionManager alloc] initWithTextView:textView];
    }
}

- (void)setupAutoCompletionForLanguage:(NSString *)language {
    if (self.enhancedAutoCompletionManager) {
        [self.enhancedAutoCompletionManager setupAutoCompletionForLanguage:language];
    }
}

- (void)showAutoCompletion {
    if (self.enhancedAutoCompletionManager) {
        [self.enhancedAutoCompletionManager showAutoCompletion];
    }
}

- (void)hideAutoCompletion {
    if (self.enhancedAutoCompletionManager) {
        [self.enhancedAutoCompletionManager hideAutoCompletion];
    }
}

- (void)addCustomWord:(NSString *)word {
    if (self.enhancedAutoCompletionManager) {
        [self.enhancedAutoCompletionManager addCustomWord:word];
    }
}

- (void)removeCustomWord:(NSString *)word {
    if (self.enhancedAutoCompletionManager) {
        [self.enhancedAutoCompletionManager removeCustomWord:word];
    }
}

- (void)handleCharacter:(char)ch {
    if (self.enhancedAutoCompletionManager) {
        [self.enhancedAutoCompletionManager handleCharacter:ch];
    }
}

@end