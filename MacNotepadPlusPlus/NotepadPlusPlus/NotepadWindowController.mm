//
//  NotepadWindowController.m
//  NotepadPlusPlus
//
//  Created by Assistant on 12/12/2025.
//

#import "NotepadWindowController.h"
#import "ScintillaView.h"
#import "ScintillaCocoa.h"
#import "SCIContentView.h"
#import "SCIKeychain.h"

@interface NotepadWindowController()
@property (nonatomic, strong) ScintillaView *textView;
@property (nonatomic, strong) NSMenuItem *undoItem;
@property (nonatomic, strong) NSMenuItem *redoItem;
@end

@implementation NotepadWindowController

- (instancetype)init {
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
        [self setUpWindow];
        [self createMenus];
    }
    
    return self;
}

- (void)setUpWindow {
    [[self window] setTitle:@"Notepad++"];
    
    // Create Scintilla text view
    NSRect contentViewFrame = [[self window] contentRectForFrameRect:[[self window] frame]];
    NSRect textFrame = NSMakeRect(0, 0, contentViewFrame.size.width, contentViewFrame.size.height);
    self.textView = [[ScintillaView alloc] initWithFrame:textFrame];
    
    // Configure Scintilla
    [self configureScintilla];
    
    // Add text view to window
    [[[self window] contentView] addSubview:self.textView];
    
    // Register for notifications
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(textChanged:) 
                                                 name:@"ScintillaNotify" 
                                               object:self.textView];
}

- (void)configureScintilla {
    // Basic configuration
    [self.textView sendmessage:SCI_SETLEXER sub:SCLEX_CONTAINER wparam:0];
    [self.textView sendmessage:SCI_SETSTYLEBITS sub:5 wparam:0];
    
    // Line numbers
    [self.textView sendmessage:SCI_SETMARGINTYPEN sub:0 wparam:SC_MARGIN_NUMBER];
    [self.textView sendmessage:SCI_SETMARGINWIDTHN sub:0 wparam:40];
    
    // Enable folding
    [self.textView sendmessage:SCI_SETPROPERTY sub:0 wparam:(sptr_t)"fold" lpstr:"1"];
    [self.textView sendmessage:SCI_SETPROPERTY sub:0 wparam:(sptr_t)"fold.compact" lpstr:"0"];
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
        [self.textView sendmessage:SCI_MARKERSETBACK sub:i wparam:0];
    }
}

- (void)createMenus {
    NSMenu *mainMenu = [[NSMenu alloc] init];
    
    // Application menu
    NSMenuItem *appMenuItem = [mainMenu addItemWithTitle:@"" action:nil keyEquivalent:@""];
    NSMenu *appMenu = [[NSMenu alloc] initWithTitle:@"Application"];
    [mainMenu setSubmenu:appMenu forItem:appMenuItem];
    
    // Add standard application menu items
    NSString *appName = [[NSProcessInfo processInfo] processName];
    [appMenu addItemWithTitle:[@"About " stringByAppendingString:appName] 
                       action:@selector(orderFrontStandardAboutPanel:) 
                keyEquivalent:@""];
    [appMenu addItem:[NSMenuItem separatorItem]];
    [appMenu addItemWithTitle:@"Preferences…" action:@selector(showPreferences:) keyEquivalent:@","];
    [appMenu addItem:[NSMenuItem separatorItem]];
    [appMenu addItemWithTitle:[@"Quit " stringByAppendingString:appName] 
                       action:@selector(terminate:) 
                keyEquivalent:@"q"];
    
    // File menu
    NSMenuItem *fileMenuItem = [mainMenu addItemWithTitle:@"File" action:nil keyEquivalent:@""];
    NSMenu *fileMenu = [[NSMenu alloc] initWithTitle:@"File"];
    [mainMenu setSubmenu:fileMenu forItem:fileMenuItem];
    
    [fileMenu addItemWithTitle:@"New" action:@selector(newDocument:) keyEquivalent:@"n"];
    [fileMenu addItemWithTitle:@"Open…" action:@selector(openDocument:) keyEquivalent:@"o"];
    [fileMenu addItem:[NSMenuItem separatorItem]];
    [fileMenu addItemWithTitle:@"Close" action:@selector(closeDocument:) keyEquivalent:@"w"];
    [fileMenu addItemWithTitle:@"Save" action:@selector(saveDocument:) keyEquivalent:@"s"];
    [fileMenu addItemWithTitle:@"Save As…" action:@selector(saveDocumentAs:) keyEquivalent:@"S"];
    [fileMenu addItem:[NSMenuItem separatorItem]];
    [fileMenu addItemWithTitle:@"Page Setup…" action:@selector(runPageLayout:) keyEquivalent:@"P"];
    [fileMenu addItemWithTitle:@"Print…" action:@selector(printDocument:) keyEquivalent:@"p"];
    
    // Edit menu
    NSMenuItem *editMenuItem = [mainMenu addItemWithTitle:@"Edit" action:nil keyEquivalent:@""];
    NSMenu *editMenu = [[NSMenu alloc] initWithTitle:@"Edit"];
    [mainMenu setSubmenu:editMenu forItem:editMenuItem];
    
    self.undoItem = [editMenu addItemWithTitle:@"Undo" action:@selector(undo:) keyEquivalent:@"z"];
    self.redoItem = [editMenu addItemWithTitle:@"Redo" action:@selector(redo:) keyEquivalent:@"Z"];
    [editMenu addItem:[NSMenuItem separatorItem]];
    [editMenu addItemWithTitle:@"Cut" action:@selector(cut:) keyEquivalent:@"x"];
    [editMenu addItemWithTitle:@"Copy" action:@selector(copy:) keyEquivalent:@"c"];
    [editMenu addItemWithTitle:@"Paste" action:@selector(paste:) keyEquivalent:@"v"];
    [editMenu addItemWithTitle:@"Delete" action:@selector(delete:) keyEquivalent:@"\x08"];
    [editMenu addItemWithTitle:@"Select All" action:@selector(selectAll:) keyEquivalent:@"a"];
    [editMenu addItem:[NSMenuItem separatorItem]];
    [editMenu addItemWithTitle:@"Find…" action:@selector(showFindPanel:) keyEquivalent:@"f"];
    [editMenu addItemWithTitle:@"Find Next" action:@selector(findNext:) keyEquivalent:@"g"];
    [editMenu addItemWithTitle:@"Find Previous" action:@selector(findPrevious:) keyEquivalent:@"G"];
    [editMenu addItemWithTitle:@"Replace…" action:@selector(showReplacePanel:) keyEquivalent:@"r"];
    [editMenu addItem:[NSMenuItem separatorItem]];
    [editMenu addItemWithTitle:@"Go to Line…" action:@selector(goToLine:) keyEquivalent:@"l"];
    
    // View menu
    NSMenuItem *viewMenuItem = [mainMenu addItemWithTitle:@"View" action:nil keyEquivalent:@""];
    NSMenu *viewMenu = [[NSMenu alloc] initWithTitle:@"View"];
    [mainMenu setSubmenu:viewMenu forItem:viewMenuItem];
    
    [viewMenu addItemWithTitle:@"Show Line Numbers" action:@selector(toggleLineNumbers:) keyEquivalent:@""];
    [viewMenu addItemWithTitle:@"Show White Space" action:@selector(toggleWhitespace:) keyEquivalent:@""];
    [viewMenu addItem:[NSMenuItem separatorItem]];
    [viewMenu addItemWithTitle:@"Zoom In" action:@selector(zoomIn:) keyEquivalent:@"+"];
    [viewMenu addItemWithTitle:@"Zoom Out" action:@selector(zoomOut:) keyEquivalent:@"-"];
    [viewMenu addItemWithTitle:@"Reset Zoom" action:@selector(resetZoom:) keyEquivalent:@"0"];
    
    [NSApp setMainMenu:mainMenu];
}

- (void)textChanged:(NSNotification *)notification {
    // Update undo/redo menu items based on Scintilla state
    BOOL canUndo = [self.textView sendmessage:SCI_CANUNDO sub:0 wparam:0];
    BOOL canRedo = [self.textView sendmessage:SCI_CANREDO sub:0 wparam:0];
    
    [self.undoItem setEnabled:canUndo];
    [self.redoItem setEnabled:canRedo];
}

- (void)newDocument:(id)sender {
    // Clear the current document
    [self.textView sendmessage:SCI_CLEARALL sub:0 wparam:0];
    [[self window] setDocumentEdited:NO];
    [[self window] setRepresentedFilename:@""];
    [[self window] setTitle:@"Untitled"];
}

- (void)openDocument:(id)sender {
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    [panel setCanChooseFiles:YES];
    [panel setCanChooseDirectories:NO];
    [panel setAllowsMultipleSelection:NO];
    
    if ([panel runModal] == NSModalResponseOK) {
        NSURL *fileURL = [panel URL];
        NSError *error;
        NSString *content = [NSString stringWithContentsOfURL:fileURL 
                                                     encoding:NSUTF8StringEncoding 
                                                        error:&error];
        if (error) {
            NSAlert *alert = [NSAlert alertWithMessageText:@"Error Opening File"
                                             defaultButton:@"OK"
                                           alternateButton:nil
                                               otherButton:nil
                                 informativeTextWithFormat:@"%@", error.localizedDescription];
            [alert runModal];
        } else {
            [self.textView sendmessage:SCI_SETTEXT sub:0 wparam:(sptr_t)[content UTF8String]];
            [[self window] setDocumentEdited:NO];
            [[self window] setRepresentedFilename:[fileURL path]];
            [[self window] setTitle:[fileURL lastPathComponent]];
        }
    }
}

- (void)saveDocument:(id)sender {
    // For now, just show Save As panel
    [self saveDocumentAs:sender];
}

- (void)saveDocumentAs:(id)sender {
    NSSavePanel *panel = [NSSavePanel savePanel];
    [panel setNameFieldStringValue:@"Untitled.txt"];
    
    if ([panel runModal] == NSModalResponseOK) {
        NSURL *fileURL = [panel URL];
        
        // Get text from Scintilla
        long length = [self.textView sendmessage:SCI_GETLENGTH sub:0 wparam:0];
        char *buffer = new char[length + 1];
        [self.textView sendmessage:SCI_GETTEXT sub:length+1 wparam:(sptr_t)buffer];
        NSString *content = [NSString stringWithUTF8String:buffer];
        delete[] buffer;
        
        NSError *error;
        BOOL success = [content writeToURL:fileURL 
                                  atomically:YES 
                                    encoding:NSUTF8StringEncoding 
                                       error:&error];
        
        if (!success) {
            NSAlert *alert = [NSAlert alertWithMessageText:@"Error Saving File"
                                             defaultButton:@"OK"
                                           alternateButton:nil
                                               otherButton:nil
                                 informativeTextWithFormat:@"%@", error.localizedDescription];
            [alert runModal];
        } else {
            [[self window] setDocumentEdited:NO];
            [[self window] setRepresentedFilename:[fileURL path]];
            [[self window] setTitle:[fileURL lastPathComponent]];
        }
    }
}

- (void)closeDocument:(id)sender {
    [[self window] close];
}

- (void)printDocument:(id)sender {
    // Printing functionality would go here
    NSAlert *alert = [NSAlert alertWithMessageText:@"Printing Not Implemented"
                                     defaultButton:@"OK"
                                   alternateButton:nil
                                       otherButton:nil
                         informativeTextWithFormat:@"Printing functionality is not yet implemented."];
    [alert runModal];
}

- (void)showFindPanel:(id)sender {
    // Find functionality would go here
    NSAlert *alert = [NSAlert alertWithMessageText:@"Find Not Implemented"
                                     defaultButton:@"OK"
                                   alternateButton:nil
                                       otherButton:nil
                         informativeTextWithFormat:@"Find functionality is not yet implemented."];
    [alert runModal];
}

- (void)showReplacePanel:(id)sender {
    // Replace functionality would go here
    NSAlert *alert = [NSAlert alertWithMessageText:@"Replace Not Implemented"
                                     defaultButton:@"OK"
                                   alternateButton:nil
                                       otherButton:nil
                         informativeTextWithFormat:@"Replace functionality is not yet implemented."];
    [alert runModal];
}

- (void)showPreferences:(id)sender {
    // Preferences functionality would go here
    NSAlert *alert = [NSAlert alertWithMessageText:@"Preferences Not Implemented"
                                     defaultButton:@"OK"
                                   alternateButton:nil
                                       otherButton:nil
                         informativeTextWithFormat:@"Preferences functionality is not yet implemented."];
    [alert runModal];
}

- (void)zoomIn:(id)sender {
    long zoom = [self.textView sendmessage:SCI_GETZOOM sub:0 wparam:0];
    if (zoom < 20) { // Limit zoom
        [self.textView sendmessage:SCI_SETZOOM sub:zoom + 1 wparam:0];
    }
}

- (void)zoomOut:(id)sender {
    long zoom = [self.textView sendmessage:SCI_GETZOOM sub:0 wparam:0];
    if (zoom > -10) { // Limit zoom
        [self.textView sendmessage:SCI_SETZOOM sub:zoom - 1 wparam:0];
    }
}

- (void)resetZoom:(id)sender {
    [self.textView sendmessage:SCI_SETZOOM sub:0 wparam:0];
}

- (void)toggleLineNumbers:(id)sender {
    long width = [self.textView sendmessage:SCI_GETMARGINWIDTHN sub:0 wparam:0];
    if (width > 0) {
        [self.textView sendmessage:SCI_SETMARGINWIDTHN sub:0 wparam:0];
    } else {
        [self.textView sendmessage:SCI_SETMARGINWIDTHN sub:0 wparam:40];
    }
}

- (void)toggleWhitespace:(id)sender {
    long wsMode = [self.textView sendmessage:SCI_GETVIEWWS sub:0 wparam:0];
    if (wsMode == SCWS_INVISIBLE) {
        [self.textView sendmessage:SCI_SETVIEWWS sub:SCWS_VISIBLEALWAYS wparam:0];
    } else {
        [self.textView sendmessage:SCI_SETVIEWWS sub:SCWS_INVISIBLE wparam:0];
    }
}

- (void)showWindow:(id)sender {
    [super showWindow:sender];
}

- (void)windowDidLoad {
    [super windowDidLoad];
    // Window loaded actions can go here
}

@end