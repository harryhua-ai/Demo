//
//  FileDialogManager.h
//  NotepadPlusPlus
//
//  Created by Assistant on 12/12/2025.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface FileDialogManager : NSObject

+ (FileDialogManager *)sharedManager;

// File opening dialogs
- (void)showOpenFileDialogWithCompletionHandler:(void (^)(NSArray<NSString *> *filePaths, BOOL success))completionHandler;
- (void)showOpenFileDialogForSingleFileWithCompletionHandler:(void (^)(NSString *filePath, BOOL success))completionHandler;

// File saving dialogs
- (void)showSaveFileDialogWithSuggestedName:(NSString *)suggestedName
                          allowedFileTypes:(NSArray<NSString *> *)allowedFileTypes
                         completionHandler:(void (^)(NSString *filePath, BOOL success))completionHandler;

// Session dialogs
- (void)showSaveSessionDialogWithSuggestedName:(NSString *)suggestedName
                              completionHandler:(void (^)(NSString *sessionName, BOOL success))completionHandler;
- (void)showRestoreSessionDialogWithCompletionHandler:(void (^)(NSString *sessionFilePath, BOOL success))completionHandler;

@end

NS_ASSUME_NONNULL_END