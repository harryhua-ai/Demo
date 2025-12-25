//
//  DocumentSettingsManager.m
//  NotepadPlusPlus
//
//  Created by Assistant on 12/12/2025.
//

#import "DocumentSettingsManager.h"

@implementation DocumentSettingsManager

+ (DocumentSettingsManager *)sharedManager {
    static DocumentSettingsManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[DocumentSettingsManager alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    return self;
}

- (void)saveSettingsForDocument:(NSString *)documentPath
                   withEncoding:(NSString *)encoding
                   withLanguage:(NSString *)language
                    withCursors:(NSArray<NSNumber *> *)cursorPositions {
    if (!documentPath) return;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    // 修复ARC问题：移除autorelease。使用?:运算符时，两边都应为有效的mutableCopy对象或创建新对象。
    NSMutableDictionary *documentSettings = [[defaults dictionaryForKey:@"DocumentSettings"] mutableCopy];
    if (!documentSettings) {
        documentSettings = [NSMutableDictionary dictionary];
    }
    
    NSMutableDictionary *settings = [NSMutableDictionary dictionary];
    settings[@"encoding"] = encoding;
    settings[@"language"] = language;
    settings[@"cursorPositions"] = cursorPositions;
    settings[@"lastAccessed"] = [NSDate date];
    
    documentSettings[documentPath] = settings;
    [defaults setObject:documentSettings forKey:@"DocumentSettings"];
    [defaults synchronize];
}

- (NSDictionary *)loadSettingsForDocument:(NSString *)documentPath {
    if (!documentPath) return nil;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *documentSettings = [defaults dictionaryForKey:@"DocumentSettings"];
    return documentSettings[documentPath];
}

- (NSMutableDictionary *)loadDocumentSettings {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    // 修复ARC问题，移除autorelease并简化代码
    NSMutableDictionary *documentSettings = [[defaults dictionaryForKey:@"DocumentSettings"] mutableCopy];
    if (!documentSettings) {
        documentSettings = [NSMutableDictionary dictionary];
    }
    return documentSettings;
}

- (void)saveWindowState:(NSRect)windowFrame
           isFullScreen:(BOOL)isFullScreen
         isLineNumbers:(BOOL)isLineNumbers
          isWhiteSpace:(BOOL)isWhiteSpace {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSMutableDictionary *windowState = [NSMutableDictionary dictionary];
    windowState[@"frame"] = [NSValue valueWithRect:windowFrame];
    windowState[@"fullScreen"] = @(isFullScreen);
    windowState[@"lineNumbers"] = @(isLineNumbers);
    windowState[@"whiteSpace"] = @(isWhiteSpace);
    
    [defaults setObject:windowState forKey:@"WindowState"];
    [defaults synchronize];
}

- (NSDictionary *)loadWindowState {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults dictionaryForKey:@"WindowState"];
}

@end