//
//  DocumentSettingsManager.h
//  NotepadPlusPlus
//
//  Created by Assistant on 12/12/2025.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DocumentSettingsManager : NSObject

+ (DocumentSettingsManager *)sharedManager;

// Document-specific settings
- (void)saveSettingsForDocument:(NSString *)documentPath
                   withEncoding:(NSString *)encoding
                   withLanguage:(NSString *)language
                    withCursors:(NSArray<NSNumber *> *)cursorPositions;

- (NSDictionary *)loadSettingsForDocument:(NSString *)documentPath;

// Window state settings
- (void)saveWindowState:(NSRect)windowFrame
           isFullScreen:(BOOL)isFullScreen
         isLineNumbers:(BOOL)isLineNumbers
          isWhiteSpace:(BOOL)isWhiteSpace;

- (NSDictionary *)loadWindowState;

@end

NS_ASSUME_NONNULL_END