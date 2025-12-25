//
//  EnhancedSessionManager.m
//  NotepadPlusPlus
//
//  Created by Assistant on 12/12/2025.
//

#import "EnhancedSessionManager.h"
#import "NotepadDocument.h"

@interface EnhancedSessionManager()
@property (nonatomic, strong) NSString *sessionsDirectory;
@end

@implementation EnhancedSessionManager

+ (EnhancedSessionManager *)sharedManager {
    static EnhancedSessionManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[EnhancedSessionManager alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        // Set up sessions directory
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
        NSString *applicationSupportDirectory = [paths firstObject];
        _sessionsDirectory = [applicationSupportDirectory stringByAppendingPathComponent:@"Notepad++/Sessions"];
        
        // Create sessions directory if it doesn't exist
        [[NSFileManager defaultManager] createDirectoryAtPath:_sessionsDirectory 
                                  withIntermediateDirectories:YES 
                                                   attributes:nil 
                                                        error:nil];
    }
    return self;
}

- (void)saveSessionWithName:(NSString *)sessionName {
    // Get all open documents
    NSDocumentController *docController = [NSDocumentController sharedDocumentController];
    NSArray *documents = [docController documents];
    
    if (documents.count == 0) {
        // No documents to save
        return;
    }
    
    // Create session dictionary
    NSMutableArray *sessionData = [NSMutableArray array];
    
    for (NotepadDocument *document in documents) {
        NSMutableDictionary *docInfo = [NSMutableDictionary dictionary];
        
        // Save file path (if saved)
        if ([document fileURL]) {
            docInfo[@"filePath"] = [[document fileURL] path];
        }
        
        // Save document content (for unsaved documents)
        if (![[document fileURL] path]) {
            docInfo[@"content"] = [document getText];
        }
        
        // Save cursor position
        // This would need to be implemented in the NotepadDocument class
        // docInfo[@"cursorPosition"] = @([document cursorPosition]);
        
        // Save encoding
        // This would need to be implemented in the NotepadDocument class
        // docInfo[@"encoding"] = [document encoding];
        
        // Save language
        // This would need to be implemented in the NotepadDocument class
        // docInfo[@"language"] = [document language];
        
        [sessionData addObject:docInfo];
    }
    
    // Save session data to file
    NSString *sessionFilePath = [_sessionsDirectory stringByAppendingPathComponent:[sessionName stringByAppendingPathExtension:@"session"]];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:sessionData options:0 error:nil];
    [jsonData writeToFile:sessionFilePath atomically:YES];
}

- (void)restoreSessionWithName:(NSString *)sessionName {
    NSString *sessionFilePath = [_sessionsDirectory stringByAppendingPathComponent:[sessionName stringByAppendingPathExtension:@"session"]];
    
    // Check if session file exists
    if (![[NSFileManager defaultManager] fileExistsAtPath:sessionFilePath]) {
        return;
    }
    
    // Read session data
    NSData *jsonData = [NSData dataWithContentsOfFile:sessionFilePath];
    NSError *error;
    NSArray *sessionData = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
    
    if (error || !sessionData) {
        return;
    }
    
    NSDocumentController *docController = [NSDocumentController sharedDocumentController];
    
    // Close all current documents
    for (NSDocument *doc in [docController documents]) {
        [doc close];
    }
    
    // Open documents from session
    for (NSDictionary *docInfo in sessionData) {
        NSString *filePath = docInfo[@"filePath"];
        NSString *content = docInfo[@"content"];
        
        if (filePath) {
            // Open existing file
            NSURL *fileURL = [NSURL fileURLWithPath:filePath];
            [docController openDocumentWithContentsOfURL:fileURL 
                                                 display:YES 
                                       completionHandler:nil];
        } else if (content) {
            // Create new document with content
            [docController newDocument:self];
            // Would need to set content in the new document
        }
    }
}

- (void)deleteSessionWithName:(NSString *)sessionName {
    NSString *sessionFilePath = [_sessionsDirectory stringByAppendingPathComponent:[sessionName stringByAppendingPathExtension:@"session"]];
    
    // Delete session file
    [[NSFileManager defaultManager] removeItemAtPath:sessionFilePath error:nil];
}

- (NSArray<NSString *> *)availableSessions {
    // Get all session files
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:_sessionsDirectory error:nil];
    
    // Filter and extract session names
    NSMutableArray *sessionNames = [NSMutableArray array];
    
    for (NSString *file in files) {
        if ([file hasSuffix:@".session"]) {
            NSString *sessionName = [file stringByDeletingPathExtension];
            [sessionNames addObject:sessionName];
        }
    }
    
    return [sessionNames copy];
}

- (void)renameSessionFrom:(NSString *)oldName to:(NSString *)newName {
    NSString *oldSessionPath = [_sessionsDirectory stringByAppendingPathComponent:[oldName stringByAppendingPathExtension:@"session"]];
    NSString *newSessionPath = [_sessionsDirectory stringByAppendingPathComponent:[newName stringByAppendingPathExtension:@"session"]];
    
    // Rename session file
    [[NSFileManager defaultManager] moveItemAtPath:oldSessionPath toPath:newSessionPath error:nil];
}

@end