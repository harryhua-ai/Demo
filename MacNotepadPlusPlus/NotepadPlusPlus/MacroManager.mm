//
//  EnhancedMacroManager.mm
//  NotepadPlusPlus
//
//  Created by Assistant on 2025-12-12.
//

#import "EnhancedMacroManager.h"
#import <AppKit/AppKit.h>

@implementation EnhancedMacroManager {
    NSMutableArray *_recordedActions;
    BOOL _isRecording;
    BOOL _isPlaying;
}

- (instancetype)initWithTextView:(ScintillaView *)textView {
    self = [super init];
    if (self) {
        _textView = textView;
        _recordedActions = [[NSMutableArray alloc] init];
        _isRecording = NO;
        _isPlaying = NO;
    }
    return self;
}

- (void)startRecording {
    if (_isRecording) {
        return;
    }
    
    [_recordedActions removeAllObjects];
    _isRecording = YES;
    
    // Show notification
    NSAlert *alert = [NSAlert alertWithMessageText:@"Macro Recording Started"
                                     defaultButton:@"OK"
                                   alternateButton:nil
                                       otherButton:nil
                         informativeTextWithFormat:@"All actions will now be recorded."];
    [alert runModal];
}

- (void)stopRecording {
    if (!_isRecording) {
        return;
    }
    
    _isRecording = NO;
    
    // Show notification
    NSAlert *alert = [NSAlert alertWithMessageText:@"Macro Recording Stopped"
                                     defaultButton:@"OK"
                                   alternateButton:nil
                                       otherButton:nil
                         informativeTextWithFormat:@"Recorded %lu actions.", (unsigned long)_recordedActions.count];
    [alert runModal];
}

- (void)playMacro {
    if (_isRecording || _recordedActions.count == 0) {
        return;
    }
    
    _isPlaying = YES;
    
    // Play all recorded actions
    for (NSDictionary *action in _recordedActions) {
        NSString *type = action[@"type"];
        NSNumber *position = action[@"position"];
        NSString *text = action[@"text"];
        
        if ([type isEqualToString:@"insert"]) {
            // Insert text
            long currentPos = [_textView sendmessage:SCI_GETCURRENTPOS sub:0 wparam:0];
            [_textView sendmessage:SCI_INSERTTEXT sub:currentPos wparam:(sptr_t)[text UTF8String]];
        } else if ([type isEqualToString:@"delete"]) {
            // Delete text
            long start = [position longValue];
            long end = start + [text length];
            [_textView sendmessage:SCI_SETSEL sub:start wparam:end];
            [_textView sendmessage:SCI_CLEAR sub:0 wparam:0];
        } else if ([type isEqualToString:@"move"]) {
            // Move cursor
            long pos = [position longValue];
            [_textView sendmessage:SCI_GOTOPOS sub:pos wparam:0];
        }
    }
    
    _isPlaying = NO;
}

- (void)saveMacroWithName:(NSString *)name {
    if (_recordedActions.count == 0) {
        NSAlert *alert = [NSAlert alertWithMessageText:@"No Macro to Save"
                                         defaultButton:@"OK"
                                       alternateButton:nil
                                           otherButton:nil
                                 informativeTextWithFormat:@"Record a macro first."];
        [alert runModal];
        return;
    }
    
    // Get macros directory
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
    NSString *appSupportDir = [paths.firstObject stringByAppendingPathComponent:@"NotepadPlusPlus/Macros"];
    NSError *error;
    
    // Create directory if needed
    if (![[NSFileManager defaultManager] createDirectoryAtPath:appSupportDir
                                      withIntermediateDirectories:YES
                                                       attributes:nil
                                                            error:&error]) {
        NSAlert *alert = [NSAlert alertWithMessageText:@"Error Saving Macro"
                                         defaultButton:@"OK"
                                       alternateButton:nil
                                           otherButton:nil
                                 informativeTextWithFormat:@"Failed to create macros directory: %@", error.localizedDescription];
        [alert runModal];
        return;
    }
    
    // Save to file
    NSString *filePath = [appSupportDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.json", name]];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:_recordedActions
                                                           options:NSJSONWritingPrettyPrinted
                                                             error:&error];
    
    if (error) {
        NSAlert *alert = [NSAlert alertWithMessageText:@"Error Saving Macro"
                                         defaultButton:@"OK"
                                       alternateButton:nil
                                           otherButton:nil
                                 informativeTextWithFormat:@"%@", error.localizedDescription];
        [alert runModal];
        return;
    }
    
    if (![jsonData writeToFile:filePath atomically:YES]) {
        NSAlert *alert = [NSAlert alertWithMessageText:@"Error Saving Macro"
                                         defaultButton:@"OK"
                                       alternateButton:nil
                                           otherButton:nil
                                 informativeTextWithFormat:@"Failed to save macro to file."];
        [alert runModal];
        return;
    }
    
    NSAlert *alert = [NSAlert alertWithMessageText:@"Macro Saved"
                                     defaultButton:@"OK"
                                   alternateButton:nil
                                       otherButton:nil
                         informativeTextWithFormat:@"Macro '%@' saved successfully.", name];
    [alert runModal];
}

- (void)loadMacroWithName:(NSString *)name {
    // Get macros directory
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
    NSString *appSupportDir = [paths.firstObject stringByAppendingPathComponent:@"NotepadPlusPlus/Macros"];
    NSString *filePath = [appSupportDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.json", name]];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSAlert *alert = [NSAlert alertWithMessageText:@"Macro Not Found"
                                         defaultButton:@"OK"
                                       alternateButton:nil
                                           otherButton:nil
                                 informativeTextWithFormat:@"Macro '%@' does not exist.", name];
        [alert runModal];
        return;
    }
    
    // Read file
    NSError *error;
    NSData *jsonData = [NSData dataWithContentsOfFile:filePath options:0 error:&error];
    
    if (error) {
        NSAlert *alert = [NSAlert alertWithMessageText:@"Error Loading Macro"
                                         defaultButton:@"OK"
                                       alternateButton:nil
                                           otherButton:nil
                                 informativeTextWithFormat:@"%@", error.localizedDescription];
        [alert runModal];
        return;
    }
    
    // Parse JSON
    NSArray *actions = [NSJSONSerialization JSONObjectWithData:jsonData
                                                       options:0
                                                         error:&error];
    
    if (error) {
        NSAlert *alert = [NSAlert alertWithMessageText:@"Error Loading Macro"
                                         defaultButton:@"OK"
                                       alternateButton:nil
                                           otherButton:nil
                                 informativeTextWithFormat:@"Invalid macro file format."];
        [alert runModal];
        return;
    }
    
    // Load actions
    [_recordedActions removeAllObjects];
    [_recordedActions addObjectsFromArray:actions];
    
    NSAlert *alert = [NSAlert alertWithMessageText:@"Macro Loaded"
                                     defaultButton:@"OK"
                                   alternateButton:nil
                                       otherButton:nil
                         informativeTextWithFormat:@"Loaded %lu actions from macro '%@'.", (unsigned long)_recordedActions.count, name];
    [alert runModal];
}

- (void)deleteMacroWithName:(NSString *)name {
    // Get macros directory
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
    NSString *appSupportDir = [paths.firstObject stringByAppendingPathComponent:@"NotepadPlusPlus/Macros"];
    NSString *filePath = [appSupportDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.json", name]];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSAlert *alert = [NSAlert alertWithMessageText:@"Macro Not Found"
                                         defaultButton:@"OK"
                                       alternateButton:nil
                                           otherButton:nil
                                 informativeTextWithFormat:@"Macro '%@' does not exist.", name];
        [alert runModal];
        return;
    }
    
    // Delete file
    NSError *error;
    if (![[NSFileManager defaultManager] removeItemAtPath:filePath error:&error]) {
        NSAlert *alert = [NSAlert alertWithMessageText:@"Error Deleting Macro"
                                         defaultButton:@"OK"
                                       alternateButton:nil
                                           otherButton:nil
                                 informativeTextWithFormat:@"%@", error.localizedDescription];
        [alert runModal];
        return;
    }
    
    NSAlert *alert = [NSAlert alertWithMessageText:@"Macro Deleted"
                                     defaultButton:@"OK"
                                   alternateButton:nil
                                       otherButton:nil
                         informativeTextWithFormat:@"Macro '%@' deleted successfully.", name];
    [alert runModal];
}

- (NSArray<NSString *> *)availableMacros {
    // Get macros directory
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
    NSString *appSupportDir = [paths.firstObject stringByAppendingPathComponent:@"NotepadPlusPlus/Macros"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:appSupportDir]) {
        return @[];
    }
    
    // Get all .json files
    NSError *error;
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:appSupportDir error:&error];
    
    if (error) {
        return @[];
    }
    
    NSMutableArray *macros = [[NSMutableArray alloc] init];
    for (NSString *file in files) {
        if ([file hasSuffix:@".json"]) {
            NSString *name = [file stringByDeletingPathExtension];
            [macros addObject:name];
        }
    }
    
    return [macros copy];
}

#pragma mark - Action Recording

- (void)recordInsertText:(NSString *)text atPosition:(long)position {
    if (!_isRecording) {
        return;
    }
    
    NSDictionary *action = @{
        @"type": @"insert",
        @"text": text,
        @"position": @(position)
    };
    
    [_recordedActions addObject:action];
}

- (void)recordDeleteText:(NSString *)text fromPosition:(long)position {
    if (!_isRecording) {
        return;
    }
    
    NSDictionary *action = @{
        @"type": @"delete",
        @"text": text,
        @"position": @(position)
    };
    
    [_recordedActions addObject:action];
}

- (void)recordCursorMoveTo:(long)position {
    if (!_isRecording) {
        return;
    }
    
    NSDictionary *action = @{
        @"type": @"move",
        @"position": @(position)
    };
    
    [_recordedActions addObject:action];
}

@end
//
//  EnhancedMacroManager.h
//  NotepadPlusPlus
//
//  Created by Assistant on 2025-12-12.
//

#import <Foundation/Foundation.h>
#import "ScintillaCocoa.h"

NS_ASSUME_NONNULL_BEGIN

@interface EnhancedMacroManager : NSObject

@property (nonatomic, weak) ScintillaView *textView;

- (instancetype)initWithTextView:(ScintillaView *)textView;

- (void)startRecording;
- (void)stopRecording;
- (void)playMacro;
- (void)saveMacroWithName:(NSString *)name;
- (void)loadMacroWithName:(NSString *)name;
- (void)deleteMacroWithName:(NSString *)name;
- (NSArray<NSString *> *)availableMacros;

@end

NS_ASSUME_NONNULL_END
//
//  MacroManager.m
//  NotepadPlusPlus
//
//  Created by Assistant on 12/12/2025.
//

#import "MacroManager.h"
#import "EnhancedMacroManager.h"

@interface MacroManager ()
@property (nonatomic, strong) EnhancedMacroManager *enhancedMacroManager;
@end

@implementation MacroManager

+ (MacroManager *)sharedManager {
    static MacroManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[MacroManager alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _enhancedMacroManager = nil;
    }
    return self;
}

- (void)setTextView:(ScintillaView *)textView {
    if (!_enhancedMacroManager || _enhancedMacroManager.textView != textView) {
        _enhancedMacroManager = [[EnhancedMacroManager alloc] initWithTextView:textView];
    }
}

- (void)startRecording {
    if (self.enhancedMacroManager) {
        [self.enhancedMacroManager startRecording];
    }
}

- (void)stopRecording {
    if (self.enhancedMacroManager) {
        [self.enhancedMacroManager stopRecording];
    }
}

- (void)playMacro {
    if (self.enhancedMacroManager) {
        [self.enhancedMacroManager playMacro];
    }
}

- (void)saveMacro:(NSString *)name {
    if (self.enhancedMacroManager) {
        [self.enhancedMacroManager saveMacroWithName:name];
    }
}

- (void)loadMacro:(NSString *)name {
    if (self.enhancedMacroManager) {
        [self.enhancedMacroManager loadMacroWithName:name];
    }
}

- (void)deleteMacro:(NSString *)name {
    if (self.enhancedMacroManager) {
        [self.enhancedMacroManager deleteMacroWithName:name];
    }
}

- (NSArray<NSString *> *)availableMacros {
    if (self.enhancedMacroManager) {
        return [self.enhancedMacroManager availableMacros];
    }
    return @[];
}

@end