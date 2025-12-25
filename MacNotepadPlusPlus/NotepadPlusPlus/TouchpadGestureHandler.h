//
//  TouchpadGestureHandler.h
//  NotepadPlusPlus
//
//  Created by Assistant on 12/12/2025.
//

#import <Cocoa/Cocoa.h>
#import "ScintillaView.h"

@interface TouchpadGestureHandler : NSObject

@property (nonatomic, weak) ScintillaView *textView;
@property (nonatomic, weak) NSWindow *window;

- (instancetype)initWithTextView:(ScintillaView *)textView window:(NSWindow *)window;
- (void)setupGestureRecognizers;

@end