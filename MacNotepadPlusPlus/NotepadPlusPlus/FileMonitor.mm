//
//  FileMonitor.m
//  NotepadPlusPlus
//
//  Created by Assistant on 12/12/2025.
//

#import "FileMonitor.h"

@implementation FileMonitor {
    NSDate *_lastModificationDate;
    dispatch_source_t _timer;
}

- (instancetype)initWithFilePath:(NSString *)filePath delegate:(id<FileMonitorDelegate>)delegate {
    self = [super init];
    if (self) {
        _filePath = filePath;
        _delegate = delegate;
        
        // Get initial modification date
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSDictionary *attrs = [fileManager attributesOfItemAtPath:filePath error:nil];
        if (attrs) {
            _lastModificationDate = attrs[NSFileModificationDate];
        }
    }
    return self;
}

- (void)startMonitoring {
    if (_timer) {
        return;
    }
    
    // Create a timer to periodically check file modification date
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0));
    dispatch_source_set_timer(_timer, DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC, 0); // Check every 1 second
    dispatch_source_set_event_handler(_timer, ^{
        [self checkFileModification];
    });
    dispatch_resume(_timer);
}

- (void)stopMonitoring {
    if (_timer) {
        dispatch_source_cancel(_timer);
        _timer = NULL;
    }
}

- (void)checkFileModification {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSDictionary *attrs = [fileManager attributesOfItemAtPath:self.filePath error:nil];
    
    if (attrs) {
        NSDate *modificationDate = attrs[NSFileModificationDate];
        
        if (!_lastModificationDate || ![modificationDate isEqualToDate:_lastModificationDate]) {
            _lastModificationDate = modificationDate;
            
            // Notify delegate on main queue
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([self.delegate respondsToSelector:@selector(fileDidChange:)]) {
                    [self.delegate fileDidChange:self.filePath];
                }
            });
        }
    }
}

- (void)dealloc {
    [self stopMonitoring];
}

@end