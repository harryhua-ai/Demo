//
//  ShortcutManager.m
//  NotepadPlusPlus
//
//  Created by Assistant on 12/12/2025.
//

#import "ShortcutManager.h"

static ShortcutManager *sharedInstance = nil;
static NSString *const ShortcutsKey = @"CustomShortcuts";

@implementation ShortcutManager

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[ShortcutManager alloc] init];
        [sharedInstance registerDefaultShortcuts];
        [sharedInstance loadCustomShortcuts];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _shortcuts = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)registerDefaultShortcuts {
    // File menu
    [self.shortcuts setObject:@{@"keyEquivalent": @"n", @"modifier": @(NSEventModifierFlagCommand)} 
                       forKey:@"newDocument"];
    [self.shortcuts setObject:@{@"keyEquivalent": @"o", @"modifier": @(NSEventModifierFlagCommand)} 
                       forKey:@"openDocument"];
    [self.shortcuts setObject:@{@"keyEquivalent": @"w", @"modifier": @(NSEventModifierFlagCommand)} 
                       forKey:@"closeDocument"];
    [self.shortcuts setObject:@{@"keyEquivalent": @"s", @"modifier": @(NSEventModifierFlagCommand)} 
                       forKey:@"saveDocument"];
    [self.shortcuts setObject:@{@"keyEquivalent": @"S", @"modifier": @(NSEventModifierFlagCommand | NSEventModifierFlagShift)} 
                       forKey:@"saveDocumentAs"];
    [self.shortcuts setObject:@{@"keyEquivalent": @"p", @"modifier": @(NSEventModifierFlagCommand)} 
                       forKey:@"printDocument"];
    
    // Edit menu
    [self.shortcuts setObject:@{@"keyEquivalent": @"z", @"modifier": @(NSEventModifierFlagCommand)} 
                       forKey:@"undo"];
    [self.shortcuts setObject:@{@"keyEquivalent": @"Z", @"modifier": @(NSEventModifierFlagCommand | NSEventModifierFlagShift)} 
                       forKey:@"redo"];
    [self.shortcuts setObject:@{@"keyEquivalent": @"x", @"modifier": @(NSEventModifierFlagCommand)} 
                       forKey:@"cut"];
    [self.shortcuts setObject:@{@"keyEquivalent": @"c", @"modifier": @(NSEventModifierFlagCommand)} 
                       forKey:@"copy"];
    [self.shortcuts setObject:@{@"keyEquivalent": @"v", @"modifier": @(NSEventModifierFlagCommand)} 
                       forKey:@"paste"];
    [self.shortcuts setObject:@{@"keyEquivalent": @"a", @"modifier": @(NSEventModifierFlagCommand)} 
                       forKey:@"selectAll"];
    
    // Search menu
    [self.shortcuts setObject:@{@"keyEquivalent": @"f", @"modifier": @(NSEventModifierFlagCommand)} 
                       forKey:@"find"];
    [self.shortcuts setObject:@{@"keyEquivalent": @"g", @"modifier": @(NSEventModifierFlagCommand)} 
                       forKey:@"findNext"];
    [self.shortcuts setObject:@{@"keyEquivalent": @"G", @"modifier": @(NSEventModifierFlagCommand | NSEventModifierFlagShift)} 
                       forKey:@"findPrevious"];
    [self.shortcuts setObject:@{@"keyEquivalent": @"r", @"modifier": @(NSEventModifierFlagCommand)} 
                       forKey:@"replace"];
    
    // View menu
    [self.shortcuts setObject:@{@"keyEquivalent": @"+", @"modifier": @(NSEventModifierFlagCommand)} 
                       forKey:@"zoomIn"];
    [self.shortcuts setObject:@{@"keyEquivalent": @"-", @"modifier": @(NSEventModifierFlagCommand)} 
                       forKey:@"zoomOut"];
    [self.shortcuts setObject:@{@"keyEquivalent": @"0", @"modifier": @(NSEventModifierFlagCommand)} 
                       forKey:@"resetZoom"];
    
    // Bookmarks
    [self.shortcuts setObject:@{@"keyEquivalent": @"F2", @"modifier": @(0)} 
                       forKey:@"toggleBookmark"];
    [self.shortcuts setObject:@{@"keyEquivalent": @"F2", @"modifier": @(NSEventModifierFlagCommand)} 
                       forKey:@"nextBookmark"];
    [self.shortcuts setObject:@{@"keyEquivalent": @"F2", @"modifier": @(NSEventModifierFlagShift)} 
                       forKey:@"previousBookmark"];
    
    // Macros
    [self.shortcuts setObject:@{@"keyEquivalent": @"R", @"modifier": @(NSEventModifierFlagCommand)} 
                       forKey:@"startRecording"];
    [self.shortcuts setObject:@{@"keyEquivalent": @"R", @"modifier": @(NSEventModifierFlagCommand | NSEventModifierFlagShift)} 
                       forKey:@"playMacro"];
    
    // Go to
    [self.shortcuts setObject:@{@"keyEquivalent": @"l", @"modifier": @(NSEventModifierFlagCommand)} 
                       forKey:@"goToLine"];
    
    // Folding
    [self.shortcuts setObject:@{@"keyEquivalent": @"0", @"modifier": @(NSEventModifierFlagCommand | NSEventModifierFlagOption)} 
                       forKey:@"collapseAllFolds"];
    [self.shortcuts setObject:@{@"keyEquivalent": @"0", @"modifier": @(NSEventModifierFlagCommand)} 
                       forKey:@"toggleCurrentFold"];
}

- (void)loadCustomShortcuts {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *customShortcuts = [defaults objectForKey:ShortcutsKey];
    
    if (customShortcuts) {
        [self.shortcuts addEntriesFromDictionary:customShortcuts];
    }
}

- (void)saveCustomShortcuts {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.shortcuts forKey:ShortcutsKey];
    [defaults synchronize];
}

- (NSMenuItem *)createMenuItemWithTitle:(NSString *)title 
                                action:(SEL)action 
                         keyEquivalent:(NSString *)keyEquivalent
                              modifier:(NSEventModifierFlags)modifier
                                target:(id)target {
    NSMenuItem *item = [[NSMenuItem alloc] initWithTitle:title 
                                                  action:action 
                                           keyEquivalent:keyEquivalent];
    item.keyEquivalentModifierMask = modifier;
    item.target = target;
    return item;
}

- (void)setShortcut:(NSString *)keyEquivalent 
           modifier:(NSEventModifierFlags)modifier 
             forKey:(NSString *)key {
    // Check if this shortcut is already used
    for (NSString *existingKey in self.shortcuts) {
        NSDictionary *shortcut = self.shortcuts[existingKey];
        NSString *existingKeyEquivalent = shortcut[@"keyEquivalent"];
        NSEventModifierFlags existingModifier = [shortcut[@"modifier"] unsignedLongValue];
        
        if ([existingKeyEquivalent isEqualToString:keyEquivalent] && existingModifier == modifier) {
            // Remove the existing mapping
            [self.shortcuts removeObjectForKey:existingKey];
            break;
        }
    }
    
    // Set the new shortcut
    self.shortcuts[key] = @{@"keyEquivalent": keyEquivalent, @"modifier": @(modifier)};
    [self saveCustomShortcuts];
}

- (void)getShortcutForKey:(NSString *)key 
            keyEquivalent:(NSString **)keyEquivalent 
                 modifier:(NSEventModifierFlags *)modifier {
    NSDictionary *shortcut = self.shortcuts[key];
    if (shortcut) {
        if (keyEquivalent) {
            *keyEquivalent = shortcut[@"keyEquivalent"];
        }
        if (modifier) {
            *modifier = [shortcut[@"modifier"] unsignedLongValue];
        }
    } else {
        if (keyEquivalent) {
            *keyEquivalent = @"";
        }
        if (modifier) {
            *modifier = 0;
        }
    }
}

- (BOOL)isShortcutAvailable:(NSString *)keyEquivalent 
                   modifier:(NSEventModifierFlags)modifier 
                     forKey:(NSString *)key {
    for (NSString *existingKey in self.shortcuts) {
        // Skip checking against itself
        if ([existingKey isEqualToString:key]) {
            continue;
        }
        
        NSDictionary *shortcut = self.shortcuts[existingKey];
        NSString *existingKeyEquivalent = shortcut[@"keyEquivalent"];
        NSEventModifierFlags existingModifier = [shortcut[@"modifier"] unsignedLongValue];
        
        if ([existingKeyEquivalent isEqualToString:keyEquivalent] && existingModifier == modifier) {
            return NO; // Already taken
        }
    }
    return YES; // Available
}

@end