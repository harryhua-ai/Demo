//
//  FileMonitor.h
//  NotepadPlusPlus
//
//  Created by Assistant on 12/12/2025.
//

#import <Foundation/Foundation.h>

@protocol FileMonitorDelegate <NSObject>
- (void)fileDidChange:(NSString *)filePath;
@end

@interface FileMonitor : NSObject

@property (nonatomic, weak) id<FileMonitorDelegate> delegate;
@property (nonatomic, strong) NSString *filePath;

- (instancetype)initWithFilePath:(NSString *)filePath delegate:(id<FileMonitorDelegate>)delegate;
- (void)startMonitoring;
- (void)stopMonitoring;

@end