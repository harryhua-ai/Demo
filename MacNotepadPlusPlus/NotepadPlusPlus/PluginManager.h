//
//  PluginManager.h
//  NotepadPlusPlus
//
//  Created by Assistant on 12/12/2025.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

// Plugin protocol that all plugins must conform to
@protocol NotepadPlugin <NSObject>

@required
- (NSString *)pluginName;
- (NSString *)pluginVersion;
- (NSString *)pluginDescription;
- (void)activatePlugin;
- (void)deactivatePlugin;

@optional
- (NSArray<NSMenuItem *> *)menuItems;
- (void)documentOpened:(NSDocument *)document;
- (void)documentClosed:(NSDocument *)document;
- (void)textChanged:(NSString *)newText;

@end

@interface PluginManager : NSObject

@property (class, readonly, strong) PluginManager *sharedManager;
@property (nonatomic, readonly) NSArray<id<NotepadPlugin>> *loadedPlugins;
@property (nonatomic, readonly) NSArray<NSString *> *availablePluginPaths;

- (void)loadPlugins;
- (void)unloadPlugins;
- (BOOL)loadPluginAtPath:(NSString *)path error:(NSError **)error;
- (BOOL)unloadPlugin:(id<NotepadPlugin>)plugin error:(NSError **)error;
- (id<NotepadPlugin>)pluginNamed:(NSString *)pluginName;
- (void)activatePlugin:(id<NotepadPlugin>)plugin;
- (void)deactivatePlugin:(id<NotepadPlugin>)plugin;

@end

NS_ASSUME_NONNULL_END