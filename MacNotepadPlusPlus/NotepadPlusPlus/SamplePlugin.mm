//
//  SamplePlugin.m
//  NotepadPlusPlus
//
//  Created by Assistant on 12/12/2025.
//

#import "SamplePlugin.h"
#import <Cocoa/Cocoa.h>

@implementation SamplePlugin {
    BOOL _active;
}

- (NSString *)pluginName {
    return @"Sample Plugin";
}

- (NSString *)pluginVersion {
    return @"1.0.0";
}

- (NSString *)pluginDescription {
    return @"A sample plugin demonstrating the plugin architecture.";
}

- (void)activatePlugin {
    if (_active) return;
    
    _active = YES;
    NSLog(@"Sample plugin activated");
}

- (void)deactivatePlugin {
    if (!_active) return;
    
    _active = NO;
    NSLog(@"Sample plugin deactivated");
}

- (NSArray<NSMenuItem *> *)menuItems {
    NSMenuItem *sampleItem = [[NSMenuItem alloc] initWithTitle:@"Sample Plugin Action"
                                                       action:@selector(sampleAction:)
                                                keyEquivalent:@""];
    sampleItem.target = self;
    
    return @[sampleItem];
}

- (void)sampleAction:(id)sender {
    NSAlert *alert = [[NSAlert alloc] init];
    [alert setMessageText:@"Sample Plugin"];
    [alert setInformativeText:@"This is a sample action from the plugin."];
    [alert addButtonWithTitle:@"OK"];
    [alert runModal];
}

@end

// Export the factory function
extern "C" __attribute__((visibility("default"))) id<NotepadPlugin> createPlugin(void) {
    return [[SamplePlugin alloc] init];
}