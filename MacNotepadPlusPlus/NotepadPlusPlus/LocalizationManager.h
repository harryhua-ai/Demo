//
//  LocalizationManager.h
//  NotepadPlusPlus
//
//  Created by Lingma on 12/12/2025.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LocalizationManager : NSObject

@property (nonatomic, strong, readonly) NSDictionary *localizedStrings;

+ (LocalizationManager *)sharedManager;
- (NSString *)localizedStringForKey:(NSString *)key;
- (void)setLanguage:(NSString *)language;

@end

NS_ASSUME_NONNULL_END