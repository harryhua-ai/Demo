//
//  DocumentStatisticsPanel.h
//  NotepadPlusPlus
//
//  Created by Assistant on 12/12/2025.
//

#import <Cocoa/Cocoa.h>
#import "ScintillaView.h"

NS_ASSUME_NONNULL_BEGIN

@interface DocumentStatisticsPanel : NSWindowController

- (instancetype)initWithTextView:(ScintillaView *)textView;

- (void)showPanel;
- (void)closePanel;
- (void)updateStatistics;

@end

NS_ASSUME_NONNULL_END