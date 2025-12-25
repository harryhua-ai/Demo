//
//  NotepadDocument.h
//  NotepadPlusPlus
//
//  Created by Assistant on 12/12/2025.
//

#import <Cocoa/Cocoa.h>

@interface NotepadDocument : NSDocument

@property (nonatomic, strong) NSData *documentData;
@property (nonatomic, strong) NSString *textContent;
@property (nonatomic, assign) NSStringEncoding encoding;

@end