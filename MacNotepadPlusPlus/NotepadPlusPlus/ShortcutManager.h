//
//  ShortcutManager.h
//  NotepadPlusPlus
//
//  Created by Assistant on 12/12/2025.
//

#import <Cocoa/Cocoa.h>

@interface ShortcutManager : NSObject

@property (nonatomic, strong) NSMutableDictionary *shortcuts;

+ (instancetype)sharedManager;
- (void)registerDefaultShortcuts;
- (void)loadCustomShortcuts;
- (void)saveCustomShortcuts;
- (NSMenuItem *)createMenuItemWithTitle:(NSString *)title 
                                 action:(SEL)action 
                          keyEquivalent:(NSString *)keyEquivalent
                               modifier:(NSEventModifierFlags)modifier
                               target:(id)target;
- (void)setShortcut:(NSString *)keyEquivalent 
           modifier:(NSEventModifierFlags)modifier 
             forKey:(NSString *)key;
- (void)getShortcutForKey:(NSString *)key 
              keyEquivalent:(NSString **)keyEquivalent 
                   modifier:(NSEventModifierFlags *)modifier;
- (BOOL)isShortcutAvailable:(NSString *)keyEquivalent 
                   modifier:(NSEventModifierFlags)modifier 
                     forKey:(NSString *)key;

@end