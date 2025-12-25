//
//  RegexHelpPanel.h
//  NotepadPlusPlus
//
//  Created by Assistant on 12/12/2025.
//

#import <Cocoa/Cocoa.h>

@interface RegexHelpPanel : NSObject

@property (nonatomic, strong) NSPanel *panel;
@property (nonatomic, strong) NSTextView *textView;

+ (instancetype)sharedPanel;
- (void)showPanel:(id)sender;

@end