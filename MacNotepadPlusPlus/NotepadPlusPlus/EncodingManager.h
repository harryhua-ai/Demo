//
//  EncodingManager.h
//  NotepadPlusPlus
//
//  Created by Assistant on 12/12/2025.
//

#import <Cocoa/Cocoa.h>
#import "EnhancedEncodingManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface EncodingManager : NSObject

@property (nonatomic, strong) NSString *currentEncoding;
@property (nonatomic, strong) EnhancedEncodingManager *enhancedEncodingManager;

+ (EncodingManager *)sharedManager;

- (instancetype)init;

- (void)setEncoding:(NSString *)encoding;
- (NSString *)getCurrentEncoding;
- (NSArray<NSString *> *)getSupportedEncodings;
- (NSString *)getLocalizedNameForEncoding:(NSString *)encoding;

@end

NS_ASSUME_NONNULL_END