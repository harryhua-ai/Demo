//
//  EncodingManager.m
//  NotepadPlusPlus
//
//  Created by Assistant on 12/12/2025.
//

#import "EncodingManager.h"
#import "LocalizationManager.h"

@implementation EncodingManager

+ (EncodingManager *)sharedManager {
    static EncodingManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[EncodingManager alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _currentEncoding = @"UTF-8";
        _enhancedEncodingManager = [EnhancedEncodingManager sharedManager];
    }
    return self;
}

- (void)setEncoding:(NSString *)encoding {
    _currentEncoding = encoding;
    
    // Notify any observers that the encoding has changed
    [[NSNotificationCenter defaultCenter] postNotificationName:@"EncodingChanged" 
                                                        object:self 
                                                      userInfo:@{@"encoding": encoding}];
}

- (NSString *)getCurrentEncoding {
    return self.currentEncoding;
}

- (NSArray<NSString *> *)getSupportedEncodings {
    return [self.enhancedEncodingManager supportedEncodings];
}

- (NSString *)getLocalizedNameForEncoding:(NSString *)encoding {
    return [self.enhancedEncodingManager localizedNameForEncoding:encoding];
}

@end