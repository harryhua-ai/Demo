//
//  FileDialogManager.m
//  NotepadPlusPlus
//
//  Created by Assistant on 12/12/2025.
//

#import "FileDialogManager.h"

@implementation FileDialogManager

+ (FileDialogManager *)sharedManager {
    static FileDialogManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[FileDialogManager alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    return self;
}

- (void)showOpenFileDialogWithCompletionHandler:(void (^)(NSArray<NSString *> *filePaths, BOOL success))completionHandler {
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    openPanel.canChooseFiles = YES;
    openPanel.canChooseDirectories = NO;
    openPanel.allowsMultipleSelection = YES;
    openPanel.resolvesAliases = YES;
    
    [openPanel beginWithCompletionHandler:^(NSModalResponse result) {
        if (result == NSModalResponseOK) {
            NSMutableArray *paths = [NSMutableArray array];
            for (NSURL *url in openPanel.URLs) {
                [paths addObject:url.path];
            }
            completionHandler([paths copy], YES);
        } else {
            completionHandler(nil, NO);
        }
    }];
}

- (void)showOpenFileDialogForSingleFileWithCompletionHandler:(void (^)(NSString *filePath, BOOL success))completionHandler {
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    openPanel.canChooseFiles = YES;
    openPanel.canChooseDirectories = NO;
    openPanel.allowsMultipleSelection = NO;
    openPanel.resolvesAliases = YES;
    
    [openPanel beginWithCompletionHandler:^(NSModalResponse result) {
        if (result == NSModalResponseOK) {
            completionHandler(openPanel.URL.path, YES);
        } else {
            completionHandler(nil, NO);
        }
    }];
}

- (void)showSaveFileDialogWithSuggestedName:(NSString *)suggestedName
                          allowedFileTypes:(NSArray<NSString *> *)allowedFileTypes
                         completionHandler:(void (^)(NSString *filePath, BOOL success))completionHandler {
    NSSavePanel *savePanel = [NSSavePanel savePanel];
    savePanel.nameFieldStringValue = suggestedName ?: @"Untitled";
    
    if (allowedFileTypes && allowedFileTypes.count > 0) {
        savePanel.allowedFileTypes = allowedFileTypes;
    }
    
    [savePanel beginWithCompletionHandler:^(NSModalResponse result) {
        if (result == NSModalResponseOK) {
            completionHandler(savePanel.URL.path, YES);
        } else {
            completionHandler(nil, NO);
        }
    }];
}

- (void)showSaveSessionDialogWithSuggestedName:(NSString *)suggestedName
                              completionHandler:(void (^)(NSString *sessionName, BOOL success))completionHandler {
    NSSavePanel *savePanel = [NSSavePanel savePanel];
    savePanel.nameFieldStringValue = suggestedName ?: @"Untitled Session";
    savePanel.allowedFileTypes = @[@"json"];
    
    [savePanel beginWithCompletionHandler:^(NSModalResponse result) {
        if (result == NSModalResponseOK) {
            NSString *sessionName = [savePanel.URL.lastPathComponent stringByDeletingPathExtension];
            completionHandler(sessionName, YES);
        } else {
            completionHandler(nil, NO);
        }
    }];
}

- (void)showRestoreSessionDialogWithCompletionHandler:(void (^)(NSString *sessionFilePath, BOOL success))completionHandler {
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    openPanel.canChooseFiles = YES;
    openPanel.canChooseDirectories = NO;
    openPanel.allowsMultipleSelection = NO;
    openPanel.allowedFileTypes = @[@"json"];
    openPanel.resolvesAliases = YES;
    
    [openPanel beginWithCompletionHandler:^(NSModalResponse result) {
        if (result == NSModalResponseOK) {
            completionHandler(openPanel.URL.path, YES);
        } else {
            completionHandler(nil, NO);
        }
    }];
}

@end