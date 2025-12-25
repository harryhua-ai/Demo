//
//  EnhancedMacroManager.h
//  NotepadPlusPlus
//
//  Created by Assistant on 12/12/2025.
//

#import <Cocoa/Cocoa.h>
#import "ScintillaView.h"

NS_ASSUME_NONNULL_BEGIN

@interface EnhancedMacroManager : NSObject

@property (nonatomic, weak) ScintillaView *textView;
@property (nonatomic, strong) NSMutableArray *recordedActions;
@property (nonatomic, assign) BOOL isRecording;

- (instancetype)initWithTextView:(ScintillaView *)textView;

- (void)startRecording;
- (void)stopRecording;
- (void)playMacro;
- (void)saveMacroWithName:(NSString *)name;
- (void)loadMacroWithName:(NSString *)name;
- (void)deleteMacroWithName:(NSString *)name;
- (NSArray<NSString *> *)availableMacros;

@end

NS_ASSUME_NONNULL_END