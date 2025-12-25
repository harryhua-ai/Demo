//
//  TouchBarManager.m
//  NotepadPlusPlus
//
//  Created by Assistant on 12/12/2025.
//

#import "TouchBarManager.h"
#import "ScintillaView.h"

static TouchBarManager *sharedInstance = nil;

@interface TouchBarManager () <NSTouchBarDelegate>
@end

@implementation TouchBarManager

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[TouchBarManager alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        // Initialize touch bar
        self.touchBar = [[NSTouchBar alloc] init];
        self.touchBar.delegate = self;
        self.touchBar.customizationIdentifier = @"com.notepadplusplus.touchbar";
        self.touchBar.defaultItemIdentifiers = @[
            NSTouchBarItemIdentifierFlexibleSpace,
            @"com.notepadplusplus.touchbar.new",
            @"com.notepadplusplus.touchbar.open",
            @"com.notepadplusplus.touchbar.save",
            NSTouchBarItemIdentifierFlexibleSpace,
            @"com.notepadplusplus.touchbar.undo",
            @"com.notepadplusplus.touchbar.redo",
            NSTouchBarItemIdentifierFlexibleSpace,
            @"com.notepadplusplus.touchbar.find",
            @"com.notepadplusplus.touchbar.replace",
            NSTouchBarItemIdentifierFlexibleSpace,
            @"com.notepadplusplus.touchbar.zoomIn",
            @"com.notepadplusplus.touchbar.zoomOut"
        ];
        self.touchBar.customizationAllowedItemIdentifiers = self.touchBar.defaultItemIdentifiers;
    }
    return self;
}

- (NSTouchBar *)makeTouchBar {
    return self.touchBar;
}

#pragma mark - NSTouchBarDelegate

- (NSTouchBarItem *)touchBar:(NSTouchBar *)touchBar makeItemForIdentifier:(NSTouchBarItemIdentifier)identifier {
    if ([identifier isEqualToString:@"com.notepadplusplus.touchbar.new"]) {
        NSCustomTouchBarItem *item = [[NSCustomTouchBarItem alloc] initWithIdentifier:identifier];
        item.view = [self createButtonWithTitle:@"New" action:@selector(touchBarNewDocument:)];
        return item;
    }
    
    if ([identifier isEqualToString:@"com.notepadplusplus.touchbar.open"]) {
        NSCustomTouchBarItem *item = [[NSCustomTouchBarItem alloc] initWithIdentifier:identifier];
        item.view = [self createButtonWithTitle:@"Open" action:@selector(touchBarOpenDocument:)];
        return item;
    }
    
    if ([identifier isEqualToString:@"com.notepadplusplus.touchbar.save"]) {
        NSCustomTouchBarItem *item = [[NSCustomTouchBarItem alloc] initWithIdentifier:identifier];
        item.view = [self createButtonWithTitle:@"Save" action:@selector(touchBarSaveDocument:)];
        return item;
    }
    
    if ([identifier isEqualToString:@"com.notepadplusplus.touchbar.undo"]) {
        NSCustomTouchBarItem *item = [[NSCustomTouchBarItem alloc] initWithIdentifier:identifier];
        item.view = [self createButtonWithTitle:@"Undo" action:@selector(touchBarUndo:)];
        return item;
    }
    
    if ([identifier isEqualToString:@"com.notepadplusplus.touchbar.redo"]) {
        NSCustomTouchBarItem *item = [[NSCustomTouchBarItem alloc] initWithIdentifier:identifier];
        item.view = [self createButtonWithTitle:@"Redo" action:@selector(touchBarRedo:)];
        return item;
    }
    
    if ([identifier isEqualToString:@"com.notepadplusplus.touchbar.find"]) {
        NSCustomTouchBarItem *item = [[NSCustomTouchBarItem alloc] initWithIdentifier:identifier];
        item.view = [self createButtonWithTitle:@"Find" action:@selector(touchBarFind:)];
        return item;
    }
    
    if ([identifier isEqualToString:@"com.notepadplusplus.touchbar.replace"]) {
        NSCustomTouchBarItem *item = [[NSCustomTouchBarItem alloc] initWithIdentifier:identifier];
        item.view = [self createButtonWithTitle:@"Replace" action:@selector(touchBarReplace:)];
        return item;
    }
    
    if ([identifier isEqualToString:@"com.notepadplusplus.touchbar.zoomIn"]) {
        NSCustomTouchBarItem *item = [[NSCustomTouchBarItem alloc] initWithIdentifier:identifier];
        item.view = [self createButtonWithTitle:@"+" action:@selector(touchBarZoomIn:)];
        return item;
    }
    
    if ([identifier isEqualToString:@"com.notepadplusplus.touchbar.zoomOut"]) {
        NSCustomTouchBarItem *item = [[NSCustomTouchBarItem alloc] initWithIdentifier:identifier];
        item.view = [self createButtonWithTitle:@"-" action:@selector(touchBarZoomOut:)];
        return item;
    }
    
    return nil;
}

- (NSButton *)createButtonWithTitle:(NSString *)title action:(SEL)action {
    NSButton *button = [NSButton buttonWithTitle:title target:self action:action];
    button.bezelColor = [NSColor controlAccentColor];
    return button;
}

#pragma mark - Touch Bar Actions

- (void)touchBarNewDocument:(id)sender {
    // Post notification that can be observed by document controller
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TouchBarNewDocument" object:nil];
}

- (void)touchBarOpenDocument:(id)sender {
    // Post notification that can be observed by document controller
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TouchBarOpenDocument" object:nil];
}

- (void)touchBarSaveDocument:(id)sender {
    // Post notification that can be observed by document controller
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TouchBarSaveDocument" object:nil];
}

- (void)touchBarUndo:(id)sender {
    // Post notification that can be observed by document controller
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TouchBarUndo" object:nil];
}

- (void)touchBarRedo:(id)sender {
    // Post notification that can be observed by document controller
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TouchBarRedo" object:nil];
}

- (void)touchBarFind:(id)sender {
    // Post notification that can be observed by document controller
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TouchBarFind" object:nil];
}

- (void)touchBarReplace:(id)sender {
    // Post notification that can be observed by document controller
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TouchBarReplace" object:nil];
}

- (void)touchBarZoomIn:(id)sender {
    // Post notification that can be observed by document controller
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TouchBarZoomIn" object:nil];
}

- (void)touchBarZoomOut:(id)sender {
    // Post notification that can be observed by document controller
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TouchBarZoomOut" object:nil];
}

@end