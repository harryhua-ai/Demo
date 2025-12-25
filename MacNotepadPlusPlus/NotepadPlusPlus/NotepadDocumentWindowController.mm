//
//  NotepadDocumentWindowController.m
//  NotepadPlusPlus
//
//  Created by Assistant on 12/12/2025.
//

#import "NotepadDocumentWindowController.h"
#import "ScintillaView.h"
#import "ScintillaCocoa.h"
#import "SyntaxHighlighter.h"
#import "FindReplacePanel.h"
#import "StatusBar.h"
#import "NotepadDocument.h"
#import "EncodingManager.h"
#import "PrintingHandler.h"
#import "BookmarkManager.h"
#import "MacroManager.h"
#import "DarkModeManager.h"
#import "AutoCompletionManager.h"
#import "EnhancedSyntaxHighlighter.h"
#import "CodeFoldingManager.h"
#import "RecentFilesManager.h"
#import "ShortcutManager.h"
#import "TouchBarManager.h"
#import "CloudDocumentManager.h"
#import "PluginManager.h"
#import "SessionManager.h"
#import "MenuManager.h"
#import "DocumentSettingsManager.h"
#import "HistoryManager.h"
#import "FileDialogManager.h"
#import "ToolbarManager.h"
#import "DocumentStatisticsPanel.h"
#import "EnhancedPrintPanel.h"
#import "MissionControlManager.h"
#import "EncodingConverterPanel.h"
#import "LineOperationsPanel.h"

@interface NotepadDocumentWindowController()
@property (nonatomic, strong) NSMenuItem *undoItem;
@property (nonatomic, strong) NSMenuItem *redoItem;
@property (nonatomic, strong) NSToolbar *toolbar;
@property (nonatomic, strong) ToolbarManager *toolbarManager;
@end

@implementation NotepadDocumentWindowController

- (instancetype)initWithDocument:(NSDocument *)document {
    // Create window rect
    NSRect frame = NSMakeRect(100, 100, 800, 600);
    
    // Initialize window
    NSWindow *window = [[NSWindow alloc] initWithContentRect:frame
                                                   styleMask:NSWindowStyleMaskTitled | 
                                                             NSWindowStyleMaskClosable | 
                                                             NSWindowStyleMaskResizable | 
                                                             NSWindowStyleMaskMiniaturizable
                                                     backing:NSBackingStoreBuffered
                                                       defer:NO];
    
    self = [super initWithWindow:window];
    
    if (self) {
        _document = document;
        _encodingManager = [EncodingManager sharedManager];
        _sessionManager = [SessionManager sharedManager];
        _bookmarkManager = [BookmarkManager sharedManager];
        _macroManager = [MacroManager sharedManager];
        _autoCompletionManager = [AutoCompletionManager sharedManager];
        _codeFoldingManager = [CodeFoldingManager sharedManager];
        [self setUpWindow];
        [[MenuManager sharedManager] createMenusForWindowController:self];
        [self createToolbar];
        [self createStatusBar];
        [self loadDocumentSettings];
    }
    
    return self;
}

- (void)setUpWindow {
    [[self window] setTitle:[self.document displayName]];
    
    // Create window with full screen support
    NSWindow *window = [self window];
    [window setCollectionBehavior: NSWindowCollectionBehaviorFullScreenPrimary];
    
    // Set up Touch Bar if available
    if ([window respondsToSelector:@selector(setTouchBar:)]) {
        TouchBarManager *touchBarManager = [TouchBarManager sharedManager];
        [window setTouchBar:[touchBarManager makeTouchBar]];
    }
    
    // Create Scintilla text view
    NSRect contentViewFrame = [[window contentRectForFrameRect:[window frame]];
    NSRect textFrame = NSMakeRect(0, 30, contentViewFrame.size.width, contentViewFrame.size.height - 60); // Leave space for toolbar and status bar
    self.textView = [[ScintillaView alloc] initWithFrame:textFrame];
    
    // Configure Scintilla
    [self configureScintilla];
    
    // Apply theme
    [self applyTheme];
    
    // Add text view to window
    [[window contentView] addSubview:self.textView];
    
    // Register for notifications
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(textChanged:) 
                                                 name:@"ScintillaNotify" 
                                               object:self.textView];
    
    // Listen for appearance changes
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(themeChanged:)
                                                 name:NSWindowDidChangeEffectiveAppearanceNotification
                                               object:window];
}

- (void)configureScintilla {
    // Basic configuration
    [self.textView sendmessage:SCI_SETLEXER sub:SCLEX_CONTAINER wparam:0];
    [self.textView sendmessage:SCI_SETSTYLEBITS sub:5 wparam:0];
    
    // Enable undo/redo
    [self.textView sendmessage:SCI_SETUNDOCOLLECTION sub:1 wparam:0];
    
    // Line numbers
    [self.textView sendmessage:SCI_SETMARGINTYPEN sub:0 wparam:SC_MARGIN_NUMBER];
    [self.textView sendmessage:SCI_SETMARGINWIDTHN sub:0 wparam:40];
    
    // Folding
    [self.textView sendmessage:SCI_SETMARGINTYPEN sub:2 wparam:SC_MARGIN_SYMBOL];
    [self.textView sendmessage:SCI_SETMARGINMASKN sub:2 wparam:SC_MASK_FOLDERS];
    [self.textView sendmessage:SCI_SETMARGINWIDTHN sub:2 wparam:20];
    [self.textView sendmessage:SCI_SETMARGINSENSITIVEN sub:2 wparam:1];
    
    // Setup fold markers
    [self setupFoldMarkers];
    
    // Set tab width
    [self.textView sendmessage:SCI_SETTABWIDTH sub:4 wparam:0];
    
    // End of line mode
    [self.textView sendmessage:SCI_SETEOLMODE sub:SC_EOL_LF wparam:0];
    
    // White space visibility
    [self.textView sendmessage:SCI_SETVIEWWS sub:SCWS_INVISIBLE wparam:0];
    
    // Indentation guides
    [self.textView sendmessage:SCI_SETINDENTATIONGUIDES sub:SC_IV_REAL wparam:0];
}

- (void)setupFoldMarkers {
    // Setup folder markers
    [self.textView sendmessage:SCI_MARKERDEFINE sub:SC_MARKNUM_FOLDEROPEN wparam:SC_MARK_BOXMINUS];
    [self.textView sendmessage:SCI_MARKERDEFINE sub:SC_MARKNUM_FOLDER wparam:SC_MARK_BOXPLUS];
    [self.textView sendmessage:SCI_MARKERDEFINE sub:SC_MARKNUM_FOLDERSUB wparam:SC_MARK_VLINE];
    [self.textView sendmessage:SCI_MARKERDEFINE sub:SC_MARKNUM_FOLDERTAIL wparam:SC_MARK_LCORNER];
    [self.textView sendmessage:SCI_MARKERDEFINE sub:SC_MARKNUM_FOLDEREND wparam:SC_MARK_BOXPLUSCONNECTED];
    [self.textView sendmessage:SCI_MARKERDEFINE sub:SC_MARKNUM_FOLDEROPENMID wparam:SC_MARK_BOXMINUSCONNECTED];
    [self.textView sendmessage:SCI_MARKERDEFINE sub:SC_MARKNUM_FOLDERMIDTAIL wparam:SC_MARK_TCORNER];
    
    // Set marker colors
    for (int i = 25; i <= 31; i++) {
        [self.textView sendmessage:SCI_MARKERSETFORE sub:i wparam:0xffffff];
        [self.textView sendmessage:SCI_MARKERSETBACK sub:i wparam:0x808080];
    }
    
    // Special colors for open/close markers
    [self.textView sendmessage:SCI_MARKERSETBACK sub:SC_MARKNUM_FOLDEROPEN wparam:0x808080];
    [self.textView sendmessage:SCI_MARKERSETBACK sub:SC_MARKNUM_FOLDER wparam:0xbfbfbf];
}

- (void)createToolbar {
    self.toolbarManager = [[ToolbarManager alloc] initWithWindowController:self];
    NSToolbar *toolbar = [self.toolbarManager createToolbar];
    [[self window] setToolbar:toolbar];
}

- (void)createStatusBar {
    NSRect statusBarFrame = NSMakeRect(0, 0, [[self window] frame].size.width, 24);
    self.statusBar = [[StatusBar alloc] initWithFrame:statusBarFrame textView:self.textView];
    [[self window] setContentBorderThickness:statusBarFrame.size.height forEdge:NSMinYEdge];
    [[self window] setContentView:self.statusBar];
}

- (void)setupTextView {
    // Create Scintilla text view
    NSRect contentViewFrame = [[self window] contentRectForFrameRect:[self window] frame]];
    NSRect textFrame = NSMakeRect(0, 30, contentViewFrame.size.width, contentViewFrame.size.height - 60); // Leave space for toolbar and status bar
    self.textView = [[ScintillaView alloc] initWithFrame:textFrame];
    
    // Configure Scintilla
    [self configureScintilla];
    
    // Apply theme
    [self applyTheme];
    
    // Add text view to window
    [[self window] setContentView:self.textView];
    
    // Set up notifications for status bar updates
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textChanged:)
                                                 name:@"SCN_UPDATEUI"
                                               object:self.textView];
    
    // Initial status bar update
    [self updateStatusBar];
}

- (void)updateStatusBar {
    if (self.statusBar) {
        [self.statusBar updateStatusBar];
    }
}

- (void)textChanged:(NSNotification *)notification {
    [self updateStatusBar];
}

- (void)loadText:(NSString *)text {
    if (text) {
        [self.textView sendmessage:SCI_SETTEXT sub:0 wparam:(sptr_t)[text UTF8String]];
    }
    
    // Update status bar
    [self.statusBar updateStatusBar];
}

- (NSString *)getText {
    // Get text from Scintilla
    long length = [self.textView sendmessage:SCI_GETLENGTH sub:0 wparam:0];
    if (length == 0) {
        return @"";
    }
    
    char *buffer = new char[length + 1];
    [self.textView sendmessage:SCI_GETTEXT sub:length+1 wparam:(sptr_t)buffer];
    NSString *content = [NSString stringWithUTF8String:buffer];
    delete[] buffer;
    
    return content;
}

- (void)applyTheme {
    BOOL isDarkMode = [[DarkModeManager sharedManager] isDarkMode];
    
    // Set background color
    NSColor *backgroundColor = isDarkMode ? [NSColor colorWithCalibratedRed:0.1 green:0.1 blue:0.1 alpha:1.0] : [NSColor whiteColor];
    NSColor *foregroundColor = isDarkMode ? [NSColor whiteColor] : [NSColor blackColor];
    
    [self.textView sendmessage:SCI_STYLESETBACK sub:STYLE_DEFAULT wparam:(sptr_t)backgroundColor.intValue];
    [self.textView sendmessage:SCI_STYLESETFORE sub:STYLE_DEFAULT wparam:(sptr_t)foregroundColor.intValue];
    [self.textView sendmessage:SCI_SETSELBACK sub:1 wparam:(sptr_t)[NSColor selectedTextBackgroundColor].intValue];
    
    // Update line numbers margin
    [self.textView sendmessage:SCI_SETMARGINBACKN sub:0 wparam:(sptr_t)backgroundColor.intValue];
    
    // Update folding margin
    [self.textView sendmessage:SCI_SETMARGINBACKN sub:2 wparam:(sptr_t)backgroundColor.intValue];
}

- (void)themeChanged:(NSNotification *)notification {
    [self applyTheme];
}

- (void)enterFullScreen:(id)sender {
    [[self window] toggleFullScreen:sender];
}

- (void)exitFullScreen:(id)sender {
    [[self window] toggleFullScreen:sender];
}

- (void)changeLanguage:(NSMenuItem *)sender {
    NSString *language = sender.representedObject;
    self.currentLanguage = language;
    
    // Apply syntax highlighting using the improved class method
    [EnhancedSyntaxHighlighter applySyntaxHighlighting:self.textView forLanguage:language];
    
    // Update status bar if it exists
    if (self.statusBar) {
        [self.statusBar setLanguage:language];
    }
    
    // Update auto-completion
    [[AutoCompletionManager sharedManager] setupAutoCompletionForLanguage:language];
    
    // Update code folding
    [[CodeFoldingManager sharedManager] setupCodeFoldingForLanguage:language];
}

- (void)changeLanguageWithLanguage:(NSString *)language {
    self.currentLanguage = language;
    
    // Update syntax highlighting
    EnhancedSyntaxHighlighter *highlighter = [[EnhancedSyntaxHighlighter alloc] init];
    [highlighter applySyntaxHighlighting:self.textView language:language];
    
    // Update status bar
    [self.statusBar setLanguage:language];
    
    // Update language selector in toolbar if it exists
    if (self.toolbarManager) {
        // The toolbar popup button will be updated automatically when the language is changed programmatically
    }
}

- (void)loadDocumentSettings {
    NSString *documentPath = [(NotepadDocument *)self.document fileURL].path;
    
    // Load document settings
    NSDictionary *settings = [[DocumentSettingsManager sharedManager] loadSettingsForDocument:documentPath];
    if (settings) {
        // Apply language
        NSString *language = settings[@"language"];
        if (language) {
            self.currentLanguage = language;
            [self changeLanguageWithLanguage:language];
        }
        
        // Apply cursor positions
        NSArray *cursorPositions = settings[@"cursorPositions"];
        if (cursorPositions && cursorPositions.count > 0) {
            NSNumber *firstCursor = cursorPositions.firstObject;
            [self.textView sendmessage:SCI_SETCURRENTPOS sub:0 wparam:[firstCursor longValue]];
        }
    }
    
    // Load window state
    NSDictionary *windowState = [[DocumentSettingsManager sharedManager] loadWindowState];
    if (windowState) {
        // Apply line numbers visibility
        NSNumber *showLineNumbers = windowState[@"lineNumbers"];
        if (showLineNumbers) {
            long width = [showLineNumbers boolValue] ? 40 : 0;
            [self.textView sendmessage:SCI_SETMARGINWIDTHN sub:0 wparam:width];
        }
        
        // Apply whitespace visibility
        NSNumber *showWhiteSpace = windowState[@"whiteSpace"];
        if (showWhiteSpace) {
            long wsVisibility = [showWhiteSpace boolValue] ? SCWS_VISIBLEALWAYS : SCWS_INVISIBLE;
            [self.textView sendmessage:SCI_SETVIEWWS sub:wsVisibility wparam:0];
        }
    }
}

- (void)saveDocumentSettings {
    // Save document-specific settings
    NSString *documentPath = [(NotepadDocument *)self.document fileURL].path;
    NSString *encoding = [EncodingManager stringFromEncoding:((NotepadDocument *)self.document).encoding];
    NSString *language = self.currentLanguage ?: @"Plain Text";
    
    // Get cursor positions
    NSMutableArray *cursorPositions = [NSMutableArray array];
    long currentPos = [self.textView sendmessage:SCI_GETCURRENTPOS sub:0 wparam:0];
    [cursorPositions addObject:@(currentPos)];
    
    // Save settings
    [[DocumentSettingsManager sharedManager] saveSettingsForDocument:documentPath
                                                        withEncoding:encoding
                                                        withLanguage:language
                                                         withCursors:cursorPositions];
    
    // Save window state
    NSRect windowFrame = [[self window] frame];
    BOOL isFullScreen = ([[self window] styleMask] & NSWindowStyleMaskFullScreen) != 0;
    long lineNumbersWidth = [self.textView sendmessage:SCI_GETMARGINWIDTHN sub:0 wparam:0];
    BOOL showLineNumbers = lineNumbersWidth > 0;
    long whiteSpaceVisibility = [self.textView sendmessage:SCI_GETVIEWWS sub:0 wparam:0];
    BOOL showWhiteSpace = whiteSpaceVisibility != SCWS_INVISIBLE;
    
    [[DocumentSettingsManager sharedManager] saveWindowState:windowFrame
                                                isFullScreen:isFullScreen
                                              isLineNumbers:showLineNumbers
                                               isWhiteSpace:showWhiteSpace];
    
    // Add to document history
    [[HistoryManager sharedManager] addDocumentToHistory:documentPath];
}

- (IBAction)newDocument:(id)sender {
    NSDocumentController *docController = [NSDocumentController sharedDocumentController];
    [docController newDocument:sender];
}

- (IBAction)openDocument:(id)sender {
    [[FileDialogManager sharedManager] showOpenFileDialogWithCompletionHandler:^(NSArray<NSString *> *filePaths, BOOL success) {
        if (success && filePaths.count > 0) {
            for (NSString *filePath in filePaths) {
                NSURL *fileURL = [NSURL fileURLWithPath:filePath];
                [[NSDocumentController sharedDocumentController] openDocumentWithContentsOfURL:fileURL
                                                                                  display:YES
                                                                                    error:NULL];
                
                // Add to recent files
                [[RecentFilesManager sharedManager] addRecentFile:filePath];
            }
        }
    }];
}

- (IBAction)openDocumentFromHistory:(id)sender {
    NSString *filePath = [sender representedObject];
    NSURL *fileURL = [NSURL fileURLWithPath:filePath];
    
    NSDocumentController *docController = [NSDocumentController sharedDocumentController];
    [docController openDocumentWithContentsOfURL:fileURL display:YES completionHandler:nil];
}

- (IBAction)reopenRecentlyClosedDocument:(id)sender {
    NSString *filePath = [sender representedObject];
    NSURL *fileURL = [NSURL fileURLWithPath:filePath];
    
    NSDocumentController *docController = [NSDocumentController sharedDocumentController];
    [docController openDocumentWithContentsOfURL:fileURL display:YES completionHandler:nil];
}

- (IBAction)closeDocument:(id)sender {
    // Add to recently closed documents before closing
    NSString *documentPath = [(NotepadDocument *)self.document fileURL].path;
    [[HistoryManager sharedManager] addRecentlyClosedDocument:documentPath];
    
    // Save settings before closing
    [self saveDocumentSettings];
    [[self window] performClose:sender];
}

- (IBAction)saveDocument:(id)sender {
    [self.document save:self];
    // Save settings after saving
    [self saveDocumentSettings];
}

- (IBAction)saveDocumentAs:(id)sender {
    NotepadDocument *doc = (NotepadDocument *)self.document;
    NSString *displayName = doc.displayName ?: @"Untitled";
    
    [[FileDialogManager sharedManager] showSaveFileDialogWithSuggestedName:displayName
                                                      allowedFileTypes:nil
                                                         completionHandler:^(NSString *filePath, BOOL success) {
        if (success && filePath) {
            NSURL *fileURL = [NSURL fileURLWithPath:filePath];
            [doc writeToURL:fileURL ofType:@"public.plain-text" forSaveOperation:NSSaveAsOperation originalContentsURL:nil error:nil];
            
            // Save settings after saving
            [self saveDocumentSettings];
        }
    }];
}

- (IBAction)printDocument:(id)sender {
    PrintingHandler *printingHandler = [[PrintingHandler alloc] init];
    [printingHandler printTextView:self.textView];
}

- (IBAction)runPageLayout:(id)sender {
    PrintingHandler *printingHandler = [[PrintingHandler alloc] init];
    [printingHandler runPageLayout:self];
}

- (IBAction)undo:(id)sender {
    [self.textView sendmessage:SCI_UNDO sub:0 wparam:0];
}

- (IBAction)redo:(id)sender {
    [self.textView sendmessage:SCI_REDO sub:0 wparam:0];
}

- (IBAction)cut:(id)sender {
    [self.textView sendmessage:SCI_CUT sub:0 wparam:0];
}

- (IBAction)copy:(id)sender {
    [self.textView sendmessage:SCI_COPY sub:0 wparam:0];
}

- (IBAction)paste:(id)sender {
    [self.textView sendmessage:SCI_PASTE sub:0 wparam:0];
}

- (IBAction)delete:(id)sender {
    [self.textView sendmessage:SCI_CLEAR sub:0 wparam:0];
}

- (IBAction)selectAll:(id)sender {
    [self.textView sendmessage:SCI_SELECTALL sub:0 wparam:0];
}

- (IBAction)showFindPanel:(id)sender {
    if (!self.findReplacePanel) {
        self.findReplacePanel = [[FindReplacePanel alloc] initWithTextView:self.textView];
    }
    [self.findReplacePanel showFindPanel];
}

- (IBAction)showReplacePanel:(id)sender {
    if (!self.findReplacePanel) {
        self.findReplacePanel = [[FindReplacePanel alloc] initWithTextView:self.textView];
    }
    [self.findReplacePanel showReplacePanel];
}

- (IBAction)findNext:(id)sender {
    if (self.findReplacePanel) {
        [self.findReplacePanel findNext];
    }
}

- (IBAction)findPrevious:(id)sender {
    if (self.findReplacePanel) {
        [self.findReplacePanel findPrevious];
    }
}

- (IBAction)toggleBookmark:(id)sender {
    // Get current line
    long currentPos = [self.textView sendmessage:SCI_GETCURRENTPOS sub:0 wparam:0];
    long currentLine = [self.textView sendmessage:SCI_LINEFROMPOSITION sub:currentPos wparam:0];
    
    // Toggle bookmark at current line
    [[BookmarkManager sharedManager] toggleBookmarkAtLine:currentLine];
}

- (IBAction)nextBookmark:(id)sender {
    [[BookmarkManager sharedManager] navigateToNextBookmark];
}

- (IBAction)previousBookmark:(id)sender {
    [[BookmarkManager sharedManager] navigateToPreviousBookmark];
}

- (IBAction)clearAllBookmarks:(id)sender {
    NSAlert *alert = [NSAlert alertWithMessageText:@"Clear All Bookmarks"
                                     defaultButton:@"Cancel"
                                   alternateButton:@"Clear All"
                                       otherButton:nil
                         informativeTextWithFormat:@"Are you sure you want to clear all bookmarks?"];
    
    [alert beginSheetModalForWindow:[self window] completionHandler:^(NSModalResponse response) {
        if (response == NSAlertSecondButtonReturn) { // "Clear All" button clicked
            [[BookmarkManager sharedManager] clearAllBookmarks];
        }
    }];
}

- (IBAction)startRecording:(id)sender {
    [[MacroManager sharedManager] startRecording];
    
    // Update UI to indicate recording state
    NSAlert *alert = [NSAlert alertWithMessageText:@"Macro Recording Started"
                                     defaultButton:@"OK"
                                   alternateButton:nil
                                       otherButton:nil
                         informativeTextWithFormat:@"Macro recording is now active. Perform actions to record them."];
    [alert runModal];
}

- (IBAction)stopRecording:(id)sender {
    [[MacroManager sharedManager] stopRecording];
    
    // Update UI to indicate stopped recording state
    NSAlert *alert = [NSAlert alertWithMessageText:@"Macro Recording Stopped"
                                     defaultButton:@"OK"
                                   alternateButton:nil
                                       otherButton:nil
                         informativeTextWithFormat:@"Macro recording has been stopped."];
    [alert runModal];
}

- (IBAction)playMacro:(id)sender {
    [[MacroManager sharedManager] playMacro];
}

- (IBAction)saveMacro:(id)sender {
    // Show save panel to get macro name
    NSSavePanel *savePanel = [NSSavePanel savePanel];
    savePanel.title = @"Save Macro";
    savePanel.nameFieldStringValue = @"Untitled Macro";
    savePanel.allowedFileTypes = @[@"macro"];
    
    [savePanel beginSheetModalForWindow:[self window] completionHandler:^(NSModalResponse result) {
        if (result == NSModalResponseOK) {
            NSString *macroName = [savePanel.URL lastPathComponent];
            macroName = [macroName stringByDeletingPathExtension];
            [[MacroManager sharedManager] saveMacro:macroName];
        }
    }];
}

- (IBAction)loadMacro:(id)sender {
    // Show open panel to select macro file
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    openPanel.title = @"Load Macro";
    openPanel.allowedFileTypes = @[@"macro"];
    
    [openPanel beginSheetModalForWindow:[self window] completionHandler:^(NSModalResponse result) {
        if (result == NSModalResponseOK) {
            NSString *macroName = [openPanel.URL lastPathComponent];
            macroName = [macroName stringByDeletingPathExtension];
            [[MacroManager sharedManager] loadMacro:macroName];
        }
    }];
}

- (IBAction)showAutoCompletion:(id)sender {
    [[AutoCompletionManager sharedManager] showAutoCompletion];
}

- (IBAction)goToLine:(id)sender {
    if (!self.goToLinePanel) {
        self.goToLinePanel = [[GoToLinePanel alloc] initWithTextView:self.textView];
    }
    [self.goToLinePanel showPanel];
}

- (IBAction)toggleLineNumbers:(id)sender {
    long currentWidth = [self.textView sendmessage:SCI_GETMARGINWIDTHN sub:0 wparam:0];
    if (currentWidth > 0) {
        [self.textView sendmessage:SCI_SETMARGINWIDTHN sub:0 wparam:0];
    } else {
        [self.textView sendmessage:SCI_SETMARGINWIDTHN sub:0 wparam:40];
    }
}

- (IBAction)toggleWhitespace:(id)sender {
    long currentViewWS = [self.textView sendmessage:SCI_GETVIEWWS sub:0 wparam:0];
    if (currentViewWS == SCWS_INVISIBLE) {
        [self.textView sendmessage:SCI_SETVIEWWS sub:SCWS_VISIBLEALWAYS wparam:0];
    } else {
        [self.textView sendmessage:SCI_SETVIEWWS sub:SCWS_INVISIBLE wparam:0];
    }
}

- (IBAction)toggleDarkMode:(id)sender {
    [[DarkModeManager sharedManager] toggleDarkMode];
    [self applyTheme];
}

- (IBAction)expandAllFolds:(id)sender {
    [[CodeFoldingManager sharedManager] expandAllFolds];
}

- (IBAction)collapseAllFolds:(id)sender {
    [[CodeFoldingManager sharedManager] collapseAllFolds];
}

- (IBAction)toggleCurrentFold:(id)sender {
    [[CodeFoldingManager sharedManager] toggleCurrentFold];
}

- (IBAction)zoomIn:(id)sender {
    long zoom = [self.textView sendmessage:SCI_GETZOOM sub:0 wparam:0];
    [self.textView sendmessage:SCI_SETZOOM sub:zoom + 1 wparam:0];
}

- (IBAction)zoomOut:(id)sender {
    long zoom = [self.textView sendmessage:SCI_GETZOOM sub:0 wparam:0];
    [self.textView sendmessage:SCI_SETZOOM sub:zoom - 1 wparam:0];
}

- (IBAction)resetZoom:(id)sender {
    [self.textView sendmessage:SCI_SETZOOM sub:0 wparam:0];
}

- (IBAction)openRecentFile:(id)sender {
    NSString *filePath = [sender representedObject];
    NSURL *fileURL = [NSURL fileURLWithPath:filePath];
    
    NSDocumentController *docController = [NSDocumentController sharedDocumentController];
    [docController openDocumentWithContentsOfURL:fileURL display:YES completionHandler:nil];
}

- (IBAction)clearRecentFiles:(id)sender {
    RecentFilesManager *recentFilesManager = [RecentFilesManager sharedManager];
    [recentFilesManager clearRecentFiles];
    // Note: Menu updates would be handled by MenuManager
}

- (IBAction)clearDocumentHistory:(id)sender {
    [[HistoryManager sharedManager] clearDocumentHistory];
}

- (IBAction)clearRecentlyClosedDocuments:(id)sender {
    [[HistoryManager sharedManager] clearRecentlyClosedDocuments];
}

- (IBAction)saveSession:(id)sender {
    // Show save panel to get session name
    NSSavePanel *savePanel = [NSSavePanel savePanel];
    savePanel.title = @"Save Session";
    savePanel.nameFieldStringValue = @"Untitled Session";
    savePanel.allowedFileTypes = @[@"session"];
    
    [savePanel beginSheetModalForWindow:[self window] completionHandler:^(NSModalResponse result) {
        if (result == NSModalResponseOK) {
            NSString *sessionName = [savePanel.URL lastPathComponent];
            sessionName = [sessionName stringByDeletingPathExtension];
            [[SessionManager sharedManager] saveSession:sessionName];
        }
    }];
}

- (IBAction)restoreSession:(id)sender {
    // Show open panel to select session file
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    openPanel.title = @"Restore Session";
    openPanel.allowedFileTypes = @[@"session"];
    
    [openPanel beginSheetModalForWindow:[self window] completionHandler:^(NSModalResponse result) {
        if (result == NSModalResponseOK) {
            NSString *sessionName = [openPanel.URL lastPathComponent];
            sessionName = [sessionName stringByDeletingPathExtension];
            [[SessionManager sharedManager] restoreSession:sessionName];
        }
    }];
}

- (IBAction)restoreSessionFromMenu:(id)sender {
    NSString *sessionName = [sender representedObject];
    
    NSError *error;
    SessionManager *sessionManager = [SessionManager sharedManager];
    if ([sessionManager restoreSessionWithName:sessionName error:&error]) {
        NSLog(@"Session restored successfully");
    } else {
        NSAlert *alert = [NSAlert alertWithMessageText:@"Failed to Restore Session"
                                         defaultButton:@"OK"
                                       alternateButton:nil
                                           otherButton:nil
                                 informativeTextWithFormat:@"%@", error.localizedDescription];
        [alert beginSheetModalForWindow:self.window completionHandler:nil];
    }
}

- (IBAction)manageSessions:(id)sender {
    // Placeholder for session management UI
    NSAlert *alert = [NSAlert alertWithMessageText:@"Session Management"
                                     defaultButton:@"OK"
                                   alternateButton:nil
                                       otherButton:nil
                         informativeTextWithFormat:@"This feature is under development."];
    [alert runModal];
}

- (IBAction)reloadPlugins:(id)sender {
    PluginManager *pluginManager = [PluginManager sharedManager];
    [pluginManager reloadPlugins];
    
    // Refresh plugins menu - handled by MenuManager
}

- (IBAction)pluginAction:(id)sender {
    id plugin = [sender representedObject];
    if ([plugin respondsToSelector:@selector(execute)]) {
        [plugin execute];
    }
}

- (IBAction)moveToICloud:(id)sender {
    if (![[CloudDocumentManager sharedManager] isCloudAvailable]) {
        NSAlert *alert = [NSAlert alertWithMessageText:@"iCloud Not Available"
                                         defaultButton:@"OK"
                                       alternateButton:nil
                                           otherButton:nil
                                 informativeTextWithFormat:@"iCloud is not available on this device."];
        [alert runModal];
        return;
    }
    
    NotepadDocument *doc = (NotepadDocument *)self.document;
    if ([[CloudDocumentManager sharedManager] isDocumentInCloud:doc]) {
        NSAlert *alert = [NSAlert alertWithMessageText:@"Already in iCloud"
                                         defaultButton:@"OK"
                                       alternateButton:nil
                                           otherButton:nil
                                 informativeTextWithFormat:@"This document is already stored in iCloud."];
        [alert runModal];
        return;
    }
    
    [[CloudDocumentManager sharedManager] enableCloudForDocument:doc];
    
    NSAlert *alert = [NSAlert alertWithMessageText:@"Moved to iCloud"
                                     defaultButton:@"OK"
                                   alternateButton:nil
                                       otherButton:nil
                                 informativeTextWithFormat:@"Document has been moved to iCloud."];
    [alert runModal];
}

- (IBAction)moveFromICloud:(id)sender {
    if (![[CloudDocumentManager sharedManager] isCloudAvailable]) {
        NSAlert *alert = [NSAlert alertWithMessageText:@"iCloud Not Available"
                                         defaultButton:@"OK"
                                       alternateButton:nil
                                           otherButton:nil
                                 informativeTextWithFormat:@"iCloud is not available on this device."];
        [alert runModal];
        return;
    }
    
    NotepadDocument *doc = (NotepadDocument *)self.document;
    if (![[CloudDocumentManager sharedManager] isDocumentInCloud:doc]) {
        NSAlert *alert = [NSAlert alertWithMessageText:@"Not in iCloud"
                                         defaultButton:@"OK"
                                       alternateButton:nil
                                           otherButton:nil
                                 informativeTextWithFormat:@"This document is not stored in iCloud."];
        [alert runModal];
        return;
    }
    
    [[CloudDocumentManager sharedManager] disableCloudForDocument:doc];
    
    NSAlert *alert = [NSAlert alertWithMessageText:@"Moved from iCloud"
                                     defaultButton:@"OK"
                                   alternateButton:nil
                                       otherButton:nil
                                 informativeTextWithFormat:@"Document has been moved from iCloud to local storage."];
    [alert runModal];
}

- (IBAction)showDocumentStatistics:(id)sender {
    if (!self.documentStatisticsPanel) {
        self.documentStatisticsPanel = [[DocumentStatisticsPanel alloc] initWithTextView:self.textView];
    }
    [self.documentStatisticsPanel showPanel];
}

- (IBAction)showEnhancedPrintPanel:(id)sender {
    if (!self.enhancedPrintPanel) {
        self.enhancedPrintPanel = [[EnhancedPrintPanel alloc] initWithTextView:self.textView];
    }
    [self.enhancedPrintPanel showPrintPanel];
}

- (IBAction)showLineOperations:(id)sender {
    [[LineOperationsPanel sharedPanel] showPanelWithWindowController:self];
}

- (IBAction)showFunctionListPanel:(id)sender {
    [_functionListPanel togglePanel];
}

- (NSString *)currentLanguage {
    return self.currentLanguage ?: @"Plain Text";
}

- (void)changeEncoding:(NSMenuItem *)sender {
    NSString *encoding = sender.representedObject;
    [[EncodingManager sharedManager] setEncoding:encoding];
    
    // Update status bar if it exists
    if (self.statusBar) {
        [self.statusBar setEncoding:encoding];
    }
}

- (IBAction)showMissionControlHelp:(id)sender {
    [[MissionControlManager sharedManager] moveWindowToSpace:1];
}

- (IBAction)showMissionControl:(id)sender {
    [[MissionControlManager sharedManager] showMissionControl];
}

- (IBAction)moveWindowToNextSpace:(id)sender {
    [[MissionControlManager sharedManager] moveWindowToNextSpace];
}

- (IBAction)moveWindowToPreviousSpace:(id)sender {
    [[MissionControlManager sharedManager] moveWindowToPreviousSpace];
}

- (IBAction)assignWindowToAllSpaces:(id)sender {
    [[MissionControlManager sharedManager] assignWindowToAllSpaces];
}

- (IBAction)showEncodingConverter:(id)sender {
    [[EncodingConverterPanel sharedPanel] showPanelWithWindowController:self];
}

- (void)windowDidLoad {
    [super windowDidLoad];
    
    [self setupTextView];
    [self setupLanguageSelector];
    [self setupSyntaxHighlighting];
    [self applyPreferences];
    
    // 初始化函数列表面板
    _functionListPanel = [FunctionListPanel sharedPanel];
    
    // 如果这是第一次运行，将语言设置为默认值
    if (!_currentLanguage) {
        _currentLanguage = @"cpp"; // 默认语言设为C++
    }
    
    [_languageSelector selectItemWithTag:[self languageTagForLanguage:_currentLanguage]];
}

- (NSInteger)languageTagForLanguage:(NSString *)language {
    if ([language isEqualToString:@"cpp"]) return 0;
    if ([language isEqualToString:@"python"]) return 1;
    if ([language isEqualToString:@"javascript"]) return 2;
    if ([language isEqualToString:@"java"]) return 3;
    return 0; // 默认为C++
}

@end