//
//  NotepadDocument.h
//  NotepadPlusPlus
//
//  Created by Assistant on 12/12/2025.
//

#import <Cocoa/Cocoa.h>

@interface NotepadDocument : NSDocument

@property (nonatomic, strong) NSString *textContent;
@property (nonatomic, assign) NSStringEncoding encoding;

@end
//
//  NotepadDocument.m
//  NotepadPlusPlus
//
//  Created by Assistant on 12/12/2025.
//

#import "NotepadDocument.h"
#import "NotepadDocumentWindowController.h"
#import "EncodingManager.h"
#import "RecentFilesManager.h"
#import "CloudDocumentManager.h"

@interface NotepadDocument ()
@property (nonatomic, strong) NotepadDocumentWindowController *windowController;
@end

@implementation NotepadDocument

- (instancetype)init {
    self = [super init];
    if (self) {
        _textContent = @"";
        _encoding = NSUTF8StringEncoding; // Default encoding
    }
    return self;
}

- (NSString *)windowNibName {
    // We're not using a nib file, so return nil
    return nil;
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError {
    // Convert NSString to NSData
    if (self.windowController) {
        self.textContent = [self.windowController getText];
    }
    
    return [EncodingManager convertToData:self.textContent withEncoding:self.encoding];
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError {
    // Convert NSData to NSString with automatic encoding detection
    self.textContent = [EncodingManager convertToUTF8String:data withEncoding:self.encoding];
    
    // If we already have a window controller, update its content
    if (self.windowController) {
        [self.windowController loadText:self.textContent];
    }
    
    return YES;
}

- (BOOL)loadFromURL:(NSURL *)absoluteURL ofType:(NSString *)typeName error:(NSError **)outError {
    // This is called when opening a document
    BOOL result = [super loadFromURL:absoluteURL ofType:typeName error:outError];
    
    // Add to recent files
    [[RecentFilesManager sharedManager] addRecentFile:[absoluteURL path]];
    
    // Create window controller if needed
    if (!self.windowController) {
        self.windowController = [[NotepadDocumentWindowController alloc] initWithDocument:self];
        [[self windowController] showWindow:self];
    }
    
    // Load the text content
    [self.windowController loadText:self.textContent];
    
    // Check for iCloud conflicts
    [[CloudDocumentManager sharedManager] resolveConflictVersionsForDocument:self completion:^(NSFileVersion * _Nullable resolvedVersion, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error resolving iCloud conflicts: %@", error.localizedDescription);
        }
    }];
    
    return result;
}

- (BOOL)saveToURL:(NSURL *)absoluteURL ofType:(NSString *)typeName forSaveOperation:(NSSaveOperationType)saveOperation error:(NSError **)outError {
    // Update text content from window
    if (self.windowController) {
        self.textContent = [self.windowController getText];
    }
    
    // Save the document
    BOOL result = [super saveToURL:absoluteURL ofType:typeName forSaveOperation:saveOperation error:outError];
    
    // Add to recent files
    [[RecentFilesManager sharedManager] addRecentFile:[absoluteURL path]];
    
    // Update window title
    if (self.windowController && self.windowController.window) {
        NSString *encodingName = [EncodingManager stringFromEncoding:self.encoding];
        [[self.windowController window] setTitle:[NSString stringWithFormat:@"%@ [%@]", [absoluteURL lastPathComponent], encodingName]];
    }
    
    return result;
}

- (void)makeWindowControllers {
    // Create the window controller
    self.windowController = [[NotepadDocumentWindowController alloc] initWithDocument:self];
    [self addWindowController:self.windowController];
    
    // Load the text content
    [self.windowController loadText:self.textContent];
    
    // Show the window
    [[self.windowController] showWindow:self];
}

- (BOOL)canSaveToURL:(NSURL *)url forSaveOperation:(NSSaveOperationType)saveOperation error:(NSError *__autoreleasing *)outError {
    // Check if we can save to this URL, including iCloud URLs
    if ([[CloudDocumentManager sharedManager] isCloudAvailable]) {
        // iCloud is available, allow saving to iCloud URLs
        return YES;
    }
    
    // Fall back to default behavior
    return [super canSaveToURL:url forSaveOperation:saveOperation error:outError];
}

- (void)autosaveWithCompletionHandler:(void (^)(NSError * _Nullable))completionHandler {
    // Handle autosaving, including to iCloud
    [super autosaveWithCompletionHandler:completionHandler];
}

- (void)presaveWithCompletionHandler:(void (^)(void))completionHandler {
    // Handle presave operations
    [super presaveWithCompletionHandler:completionHandler];
}

- (void)didSaveToURL:(NSURL *)url {
    // Called after saving to a URL
    [super didSaveToURL:url];
    
    // Update recent files
    [[RecentFilesManager sharedManager] addRecentFile:[url path]];
}

- (void)didMoveToURL:(NSURL *)url {
    // Called after moving to a new URL
    [super didMoveToURL:url];
    
    // Update recent files
    [[RecentFilesManager sharedManager] addRecentFile:[url path]];
}

@end