//
//  EncodingConverterPanel.h
//  NotepadPlusPlus
//
//  Created by Assistant on 12/12/2025.
//

#import <Cocoa/Cocoa.h>
#import "NotepadDocumentWindowController.h"

NS_ASSUME_NONNULL_BEGIN

@interface EncodingConverterPanel : NSObject

+ (EncodingConverterPanel *)sharedPanel;

- (void)showPanelWithWindowController:(NotepadDocumentWindowController *)windowController;

@end

NS_ASSUME_NONNULL_END