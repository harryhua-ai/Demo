//
//  EnhancedEncodingManager.h
//  NotepadPlusPlus
//
//  Created by Assistant on 12/12/2025.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface EnhancedEncodingManager : NSObject

+ (EnhancedEncodingManager *)sharedManager;

- (NSArray<NSString *> *)supportedEncodings;
- (NSString *)localizedNameForEncoding:(NSString *)encoding;
- (NSStringEncoding)nsStringEncodingForEncoding:(NSString *)encoding;
- (NSString *)encodingForNSStringEncoding:(NSStringEncoding)nsEncoding;

@end

NS_ASSUME_NONNULL_END