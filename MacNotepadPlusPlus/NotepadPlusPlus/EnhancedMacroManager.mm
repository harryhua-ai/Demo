//
//  EnhancedMacroManager.m
//  NotepadPlusPlus
//
//  Created by Assistant on 12/12/2025.
//

#import "EnhancedMacroManager.h"
#import "ScintillaCocoa.h"

@implementation EnhancedMacroManager

- (instancetype)initWithTextView:(ScintillaView *)textView {
    self = [super init];
    if (self) {
        _textView = textView;
        _recordedActions = [NSMutableArray array];
        _isRecording = NO;
    }
    return self;
}

- (void)startRecording {
    if (!self.isRecording) {
        [self.recordedActions removeAllObjects];
        self.isRecording = YES;
    }
}

- (void)stopRecording {
    self.isRecording = NO;
}

- (void)playMacro {
    if (self.isRecording) return;
    
    for (NSDictionary *action in self.recordedActions) {
        NSString *type = action[@"type"];
        
        if ([type isEqualToString:@"insertText"]) {
            NSString *text = action[@"text"];
            [self.textView sendmessage:SCI_ADDTEXT sub:(long)text.length wparam:(sptr_t)[text UTF8String]];
        } else if ([type isEqualToString:@"deleteBack"]) {
            [self.textView sendmessage:SCI_DELETEBACK sub:0 wparam:0];
        } else if ([type isEqualToString:@"gotoPos"]) {
            NSNumber *pos = action[@"position"];
            [self.textView sendmessage:SCI_GOTOPOS sub:[pos longValue] wparam:0];
        } else if ([type isEqualToString:@"setSelection"]) {
            NSNumber *start = action[@"start"];
            NSNumber *end = action[@"end"];
            [self.textView sendmessage:SCI_SETSEL sub:[start longValue] wparam:[end longValue]];
        }
    }
}

- (void)saveMacroWithName:(NSString *)name {
    // Get application support directory
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
    NSString *applicationSupportDirectory = [paths firstObject];
    NSString *macrosDirectory = [applicationSupportDirectory stringByAppendingPathComponent:@"Notepad++/Macros"];
    
    // Create macros directory if it doesn't exist
    [[NSFileManager defaultManager] createDirectoryAtPath:macrosDirectory 
                              withIntermediateDirectories:YES 
                                               attributes:nil 
                                                    error:nil];
    
    // Save macro to file
    NSString *macroFilePath = [macrosDirectory stringByAppendingPathComponent:[name stringByAppendingPathExtension:@"macro"]];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self.recordedActions options:0 error:nil];
    [jsonData writeToFile:macroFilePath atomically:YES];
}

- (void)loadMacroWithName:(NSString *)name {
    // Get macro file path
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
    NSString *applicationSupportDirectory = [paths firstObject];
    NSString *macroFilePath = [[applicationSupportDirectory stringByAppendingPathComponent:@"Notepad++/Macros"] 
                               stringByAppendingPathComponent:[name stringByAppendingPathExtension:@"macro"]];
    
    // Check if macro file exists
    if (![[NSFileManager defaultManager] fileExistsAtPath:macroFilePath]) {
        return;
    }
    
    // Read macro data
    NSData *jsonData = [NSData dataWithContentsOfFile:macroFilePath];
    NSError *error;
    NSArray *macroData = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
    
    if (error || !macroData) {
        return;
    }
    
    // Load macro actions
    [self.recordedActions removeAllObjects];
    [self.recordedActions addObjectsFromArray:macroData];
}

- (void)deleteMacroWithName:(NSString *)name {
    // Get macro file path
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
    NSString *applicationSupportDirectory = [paths firstObject];
    NSString *macroFilePath = [[applicationSupportDirectory stringByAppendingPathComponent:@"Notepad++/Macros"] 
                               stringByAppendingPathComponent:[name stringByAppendingPathExtension:@"macro"]];
    
    // Delete macro file
    [[NSFileManager defaultManager] removeItemAtPath:macroFilePath error:nil];
}

- (NSArray<NSString *> *)availableMacros {
    // Get macros directory
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
    NSString *applicationSupportDirectory = [paths firstObject];
    NSString *macrosDirectory = [applicationSupportDirectory stringByAppendingPathComponent:@"Notepad++/Macros"];
    
    // Get all macro files
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:macrosDirectory error:nil];
    
    // Filter and extract macro names
    NSMutableArray *macroNames = [NSMutableArray array];
    
    for (NSString *file in files) {
        if ([file hasSuffix:@".macro"]) {
            NSString *macroName = [file stringByDeletingPathExtension];
            [macroNames addObject:macroName];
        }
    }
    
    return [macroNames copy];
}

#pragma mark - Recording Methods

- (void)recordInsertText:(NSString *)text {
    if (self.isRecording) {
        NSDictionary *action = @{
            @"type": @"insertText",
            @"text": text
        };
        [self.recordedActions addObject:action];
    }
}

- (void)recordDeleteBack {
    if (self.isRecording) {
        NSDictionary *action = @{
            @"type": @"deleteBack"
        };
        [self.recordedActions addObject:action];
    }
}

- (void)recordGotoPos:(long)position {
    if (self.isRecording) {
        NSDictionary *action = @{
            @"type": @"gotoPos",
            @"position": @(position)
        };
        [self.recordedActions addObject:action];
    }
}

- (void)recordSetSelectionWithStart:(long)start end:(long)end {
    if (self.isRecording) {
        NSDictionary *action = @{
            @"type": @"setSelection",
            @"start": @(start),
            @"end": @(end)
        };
        [self.recordedActions addObject:action];
    }
}

@end