//
//  MacroManager.h
//  NotepadPlusPlus
//
//  Created by Assistant on 12/12/2025.
//

#import <Cocoa/Cocoa.h>
#import "EnhancedMacroManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface MacroManager : NSObject

@property (nonatomic, strong) EnhancedMacroManager *enhancedMacroManager;

+ (MacroManager *)sharedManager;

- (instancetype)init;

- (void)setTextView:(ScintillaView *)textView;
- (void)startRecording;
- (void)stopRecording;
- (void)playMacro;
- (void)saveMacro:(NSString *)name;
- (void)loadMacro:(NSString *)name;
- (void)deleteMacro:(NSString *)name;
- (NSArray<NSString *> *)availableMacros;

@end

NS_ASSUME_NONNULL_END