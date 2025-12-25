//
//  AboutPanelManager.mm
//  NotepadPlusPlus
//
//  Created by xuser on 2024/7/11.
//

#import "AboutPanelManager.h"

@implementation AboutPanelManager

+ (instancetype)sharedInstance {
    static AboutPanelManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[AboutPanelManager alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        // 移除setAboutPanelOptions调用，使用标准关于面板
    }
    return self;
}

- (void)showAboutPanel {
    // 使用标准系统关于面板替代自定义实现
    // 避免在新版本macOS中出现API限制问题
    [[NSApplication sharedApplication] orderFrontStandardAboutPanel:nil];
}

@end