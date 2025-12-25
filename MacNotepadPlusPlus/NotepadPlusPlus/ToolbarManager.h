//
//  ToolbarManager.h
//  NotepadPlusPlus
//
//  Created by Assistant on 12/12/2025.
//

#import <Cocoa/Cocoa.h>
#import "NotepadDocumentWindowController.h"

NS_ASSUME_NONNULL_BEGIN

// MARK: - Toolbar Item Identifiers
extern NSString * const ToolbarItemIdentifierNew;
extern NSString * const ToolbarItemIdentifierOpen;
extern NSString * const ToolbarItemIdentifierSave;
extern NSString * const ToolbarItemIdentifierPrint;
extern NSString * const ToolbarItemIdentifierFind;

@interface ToolbarManager : NSObject <NSToolbarDelegate>

- (instancetype)initWithWindowController:(NotepadDocumentWindowController *)windowController;

- (NSToolbar *)createToolbar;

@end

NS_ASSUME_NONNULL_END