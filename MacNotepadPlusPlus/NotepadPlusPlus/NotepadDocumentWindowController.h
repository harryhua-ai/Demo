//
//  NotepadDocumentWindowController.h
//  NotepadPlusPlus
//
//  Created by Assistant on 12/12/2025.
//

#import <Cocoa/Cocoa.h>
#import "ScintillaView.h"
#import "EnhancedFindReplacePanel.h"
#import "GoToLinePanel.h"
#import "StatusBar.h"
#import "BookmarkManager.h"
#import "MacroManager.h"
#import "AutoCompletionManager.h"
#import "CodeFoldingManager.h"
#import "FileMonitor.h"
#import "TouchpadGestureHandler.h"
#import "ToolbarManager.h"
#import "DocumentStatisticsPanel.h"
#import "EnhancedPrintPanel.h"
#import "EncodingManager.h"
#import "SessionManager.h"
#import "FunctionListPanel.h"

@interface NotepadDocumentWindowController : NSWindowController <FileMonitorDelegate> {
@private
    FunctionListPanel *_functionListPanel;
}

@property (nonatomic, strong) ScintillaView *textView;
@property (nonatomic, strong) NSDocument *document;
@property (nonatomic, strong) NSPopUpButton *languageSelector;
@property (nonatomic, strong) EnhancedFindReplacePanel *findReplacePanel;
@property (nonatomic, strong) GoToLinePanel *goToLinePanel;
@property (nonatomic, strong) DocumentStatisticsPanel *documentStatisticsPanel;
@property (nonatomic, strong) EnhancedPrintPanel *enhancedPrintPanel;
@property (nonatomic, strong) StatusBar *statusBar;
@property (nonatomic, strong) BookmarkManager *bookmarkManager;
@property (nonatomic, strong) MacroManager *macroManager;
@property (nonatomic, strong) AutoCompletionManager *autoCompletionManager;
@property (nonatomic, strong) CodeFoldingManager *codeFoldingManager;
@property (nonatomic, strong) FileMonitor *fileMonitor;
@property (nonatomic, strong) TouchpadGestureHandler *touchpadGestureHandler;
@property (nonatomic, strong) ToolbarManager *toolbarManager;
@property (nonatomic, strong) EncodingManager *encodingManager;
@property (nonatomic, strong) SessionManager *sessionManager;
@property (nonatomic, strong) FunctionListPanel *functionListPanel;
@property (nonatomic, strong) NSString *currentLanguage;

- (instancetype)initWithDocument:(NSDocument *)document;
- (void)loadText:(NSString *)text;
- (NSString *)getText;
- (void)applyTheme;
- (void)enterFullScreen;
- (void)exitFullScreen;
- (void)changeLanguage:(NSMenuItem *)sender;
- (void)changeEncoding:(NSMenuItem *)sender;
- (void)saveDocumentSettings;
- (void)loadDocumentSettings;
- (IBAction)showDocumentStatistics:(id)sender;
- (IBAction)showEnhancedPrintPanel:(id)sender;
- (IBAction)saveSession:(id)sender;
- (IBAction)restoreSession:(id)sender;
- (IBAction)manageSessions:(id)sender;
- (IBAction)toggleBookmark:(id)sender;
- (IBAction)nextBookmark:(id)sender;
- (IBAction)previousBookmark:(id)sender;
- (IBAction)clearAllBookmarks:(id)sender;
- (IBAction)startRecording:(id)sender;
- (IBAction)stopRecording:(id)sender;
- (IBAction)playMacro:(id)sender;
- (IBAction)saveMacro:(id)sender;
- (IBAction)loadMacro:(id)sender;
- (IBAction)showAutoCompletion:(id)sender;
- (IBAction)expandAllFolds:(id)sender;
- (IBAction)collapseAllFolds:(id)sender;
- (IBAction)toggleCurrentFold:(id)sender;
- (IBAction)showMissionControlHelp:(id)sender;
- (IBAction)showMissionControl:(id)sender;
- (IBAction)moveWindowToNextSpace:(id)sender;
- (IBAction)moveWindowToPreviousSpace:(id)sender;
- (IBAction)assignWindowToAllSpaces:(id)sender;
- (IBAction)showEncodingConverter:(id)sender;
- (IBAction)showLineOperations:(id)sender;
- (IBAction)showFunctionList:(id)sender;

@end