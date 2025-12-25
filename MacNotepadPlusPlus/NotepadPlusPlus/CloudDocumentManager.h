//
//  CloudDocumentManager.h
//  NotepadPlusPlus
//
//  Created by xuser on 2024/7/11.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface CloudDocumentManager : NSObject

+ (instancetype)sharedInstance;

@property (nonatomic, strong, readonly) NSURL *cloudDocumentsURL;

- (void)enableCloudForDocument:(NSDocument *)document;
- (void)disableCloudForDocument:(NSDocument *)document;
- (BOOL)isDocumentInCloud:(NSDocument *)document;
- (void)resolveConflictVersionsForDocument:(NSDocument *)document completion:(void(^)(NSFileVersion *_Nullable resolvedVersion, NSError *_Nullable error))completion;
- (NSArray<NSFileVersion *> *)unresolvedConflictVersionsForDocument:(NSDocument *)document;

@end

NS_ASSUME_NONNULL_END