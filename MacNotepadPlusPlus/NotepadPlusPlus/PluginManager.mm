//
//  PluginManager.m
//  NotepadPlusPlus
//
//  Created by Assistant on 12/12/2025.
//

#import "PluginManager.h"
#import <dlfcn.h>

@interface PluginManager ()
@property (nonatomic, strong) NSMutableArray<id<NotepadPlugin>> *plugins;
@property (nonatomic, strong) NSMutableDictionary<NSString *, id<NotepadPlugin>> *pluginMap;
@property (nonatomic, strong) NSMutableArray<NSString *> *pluginPaths;
@end

@implementation PluginManager

+ (PluginManager *)sharedManager {
    static PluginManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[PluginManager alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _plugins = [[NSMutableArray alloc] init];
        _pluginMap = [[NSMutableDictionary alloc] init];
        _pluginPaths = [[NSMutableArray alloc] init];
        [self loadPlugins];
    }
    return self;
}

- (void)loadPlugins {
    // Find plugin directories
    NSArray *paths = [self findPluginPaths];
    
    for (NSString *path in paths) {
        NSError *error;
        if ([self loadPluginAtPath:path error:&error]) {
            NSLog(@"Loaded plugin at path: %@", path);
        } else {
            NSLog(@"Failed to load plugin at path: %@, error: %@", path, error.localizedDescription);
        }
    }
}

- (NSArray<NSString *> *)findPluginPaths {
    NSMutableArray *paths = [[NSMutableArray alloc] init];
    
    // Check application bundle plugins directory
    NSString *bundlePluginsPath = [[NSBundle mainBundle] pathForResource:@"Plugins" ofType:nil];
    if (bundlePluginsPath) {
        [paths addObjectsFromArray:[self pluginPathsInDirectory:bundlePluginsPath]];
    }
    
    // Check user plugins directory
    NSArray *libraryPaths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
    if (libraryPaths.count > 0) {
        NSString *userPluginsPath = [[libraryPaths firstObject] stringByAppendingPathComponent:@"NotepadPlusPlus/Plugins"];
        [paths addObjectsFromArray:[self pluginPathsInDirectory:userPluginsPath]];
    }
    
    // Check system-wide plugins directory
    NSString *systemPluginsPath = @"/Library/Application Support/NotepadPlusPlus/Plugins";
    [paths addObjectsFromArray:[self pluginPathsInDirectory:systemPluginsPath]];
    
    return [paths copy];
}

- (NSArray<NSString *> *)pluginPathsInDirectory:(NSString *)directory {
    NSMutableArray *pluginPaths = [[NSMutableArray alloc] init];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:directory]) {
        NSError *error;
        NSArray *contents = [fileManager contentsOfDirectoryAtPath:directory error:&error];
        
        if (error) {
            NSLog(@"Error reading plugin directory %@: %@", directory, error.localizedDescription);
            return [pluginPaths copy];
        }
        
        for (NSString *item in contents) {
            NSString *fullPath = [directory stringByAppendingPathComponent:item];
            
            // Check if it's a bundle or dynamic library
            if ([item hasSuffix:@".bundle"] || [item hasSuffix:@".dylib"]) {
                [pluginPaths addObject:fullPath];
            }
        }
    }
    
    return [pluginPaths copy];
}

- (BOOL)loadPluginAtPath:(NSString *)path error:(NSError **)error {
    if ([self.pluginPaths containsObject:path]) {
        if (error) {
            *error = [NSError errorWithDomain:@"PluginManagerErrorDomain"
                                         code:1
                                     userInfo:@{NSLocalizedDescriptionKey: @"Plugin already loaded"}];
        }
        return NO;
    }
    
    // Try to load the dynamic library
    void *handle = dlopen([path UTF8String], RTLD_LAZY);
    if (!handle) {
        if (error) {
            *error = [NSError errorWithDomain:@"PluginManagerErrorDomain"
                                         code:2
                                     userInfo:@{NSLocalizedDescriptionKey: [NSString stringWithUTF8String:dlerror()]}];
        }
        return NO;
    }
    
    // Look for a function that creates the plugin instance
    NSString *factoryFunctionName = [NSString stringWithFormat:@"create%@Plugin", 
                                    [[path lastPathComponent] stringByDeletingPathExtension]];
    
    // Replace non-alphanumeric characters with underscores
    factoryFunctionName = [factoryFunctionName stringByReplacingOccurrencesOfString:@"[^a-zA-Z0-9]" 
                                                                        withString:@"_" 
                                                                           options:NSRegularExpressionSearch 
                                                                             range:NSMakeRange(0, [factoryFunctionName length])];
    
    id<NotepadPlugin> (*factoryFunction)(void) = (id<NotepadPlugin> (*)(void))dlsym(handle, [factoryFunctionName UTF8String]);
    
    // If specific factory function not found, look for generic one
    if (!factoryFunction) {
        factoryFunction = (id<NotepadPlugin> (*)(void))dlsym(handle, "createPlugin");
    }
    
    if (!factoryFunction) {
        dlclose(handle);
        if (error) {
            *error = [NSError errorWithDomain:@"PluginManagerErrorDomain"
                                         code:3
                                     userInfo:@{NSLocalizedDescriptionKey: @"Plugin factory function not found"}];
        }
        return NO;
    }
    
    // Create plugin instance
    id<NotepadPlugin> plugin = factoryFunction();
    if (!plugin) {
        dlclose(handle);
        if (error) {
            *error = [NSError errorWithDomain:@"PluginManagerErrorDomain"
                                         code:4
                                     userInfo:@{NSLocalizedDescriptionKey: @"Failed to create plugin instance"}];
        }
        return NO;
    }
    
    // Add to our collections
    [self.plugins addObject:plugin];
    [self.pluginMap setObject:plugin forKey:[plugin pluginName]];
    [self.pluginPaths addObject:path];
    
    return YES;
}

- (BOOL)unloadPlugin:(id<NotepadPlugin>)plugin error:(NSError **)error {
    NSString *pluginName = [plugin pluginName];
    NSString *path = nil;
    
    // Find the path for this plugin
    for (NSUInteger i = 0; i < self.plugins.count; i++) {
        if (self.plugins[i] == plugin) {
            path = self.pluginPaths[i];
            break;
        }
    }
    
    if (!path) {
        if (error) {
            *error = [NSError errorWithDomain:@"PluginManagerErrorDomain"
                                         code:5
                                     userInfo:@{NSLocalizedDescriptionKey: @"Plugin not found"}];
        }
        return NO;
    }
    
    // Deactivate the plugin
    [plugin deactivatePlugin];
    
    // Remove from collections
    [self.plugins removeObject:plugin];
    [self.pluginMap removeObjectForKey:pluginName];
    [self.pluginPaths removeObject:path];
    
    return YES;
}

- (id<NotepadPlugin>)pluginNamed:(NSString *)pluginName {
    return self.pluginMap[pluginName];
}

- (void)activatePlugin:(id<NotepadPlugin>)plugin {
    [plugin activatePlugin];
}

- (void)deactivatePlugin:(id<NotepadPlugin>)plugin {
    [plugin deactivatePlugin];
}

- (void)unloadPlugins {
    // Create a copy since we'll be modifying the original arrays
    NSArray *pluginsCopy = [self.plugins copy];
    
    for (id<NotepadPlugin> plugin in pluginsCopy) {
        NSError *error;
        if (![self unloadPlugin:plugin error:&error]) {
            NSLog(@"Error unloading plugin %@: %@", [plugin pluginName], error.localizedDescription);
        }
    }
}

- (NSArray<id<NotepadPlugin>> *)loadedPlugins {
    return [self.plugins copy];
}

- (NSArray<NSString *> *)availablePluginPaths {
    return [self findPluginPaths];
}

@end