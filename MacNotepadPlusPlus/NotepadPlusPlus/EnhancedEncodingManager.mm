//
//  EnhancedEncodingManager.m
//  NotepadPlusPlus
//
//  Created by Assistant on 12/12/2025.
//

#import "EnhancedEncodingManager.h"
#import "LocalizationManager.h"

@implementation EnhancedEncodingManager

+ (EnhancedEncodingManager *)sharedManager {
    static EnhancedEncodingManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[EnhancedEncodingManager alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    return self;
}

- (NSArray<NSString *> *)supportedEncodings {
    return @[
        @"UTF-8",
        @"UTF-16",
        @"UTF-16BE",
        @"UTF-16LE",
        @"UTF-32",
        @"UTF-32BE",
        @"UTF-32LE",
        @"ASCII",
        @"ISO-8859-1",
        @"ISO-8859-2",
        @"ISO-8859-3",
        @"ISO-8859-4",
        @"ISO-8859-5",
        @"ISO-8859-6",
        @"ISO-8859-7",
        @"ISO-8859-8",
        @"ISO-8859-9",
        @"ISO-8859-10",
        @"ISO-8859-11",
        @"ISO-8859-13",
        @"ISO-8859-14",
        @"ISO-8859-15",
        @"ISO-8859-16",
        @"Windows-1250",
        @"Windows-1251",
        @"Windows-1252",
        @"Windows-1253",
        @"Windows-1254",
        @"Windows-1255",
        @"Windows-1256",
        @"Windows-1257",
        @"Windows-1258",
        @"MacRoman",
        @"MacJapanese",
        @"MacChineseTrad",
        @"MacKorean",
        @"MacArabic",
        @"MacHebrew",
        @"MacGreek",
        @"MacCyrillic",
        @"MacDevanagari",
        @"MacGurmukhi",
        @"MacGujarati",
        @"MacOriya",
        @"MacBengali",
        @"MacTamil",
        @"MacTelugu",
        @"MacKannada",
        @"MacMalayalam",
        @"MacSinhalese",
        @"MacBurmese",
        @"MacKhmer",
        @"MacThai",
        @"MacLaotian",
        @"MacGeorgian",
        @"MacArmenian",
        @"MacChineseSimp",
        @"MacTibetan",
        @"MacMongolian",
        @"MacEthiopic",
        @"MacCentralEurRoman",
        @"MacVietnamese",
        @"MacExtArabic",
        @"MacSymbol",
        @"MacDingbats",
        @"MacTurkish",
        @"MacCroatian",
        @"MacIcelandic",
        @"MacRomanian"
    ];
}

- (NSString *)localizedNameForEncoding:(NSString *)encoding {
    // Return localized names for common encodings
    if ([encoding isEqualToString:@"UTF-8"]) {
        return [LocalizationManager.sharedManager localizedStringForKey:@"encoding_utf8"];
    } else if ([encoding isEqualToString:@"UTF-16"]) {
        return [LocalizationManager.sharedManager localizedStringForKey:@"encoding_utf16"];
    } else if ([encoding isEqualToString:@"UTF-16BE"]) {
        return [LocalizationManager.sharedManager localizedStringForKey:@"encoding_utf16be"];
    } else if ([encoding isEqualToString:@"UTF-16LE"]) {
        return [LocalizationManager.sharedManager localizedStringForKey:@"encoding_utf16le"];
    } else if ([encoding isEqualToString:@"UTF-32"]) {
        return [LocalizationManager.sharedManager localizedStringForKey:@"encoding_utf32"];
    } else if ([encoding isEqualToString:@"UTF-32BE"]) {
        return [LocalizationManager.sharedManager localizedStringForKey:@"encoding_utf32be"];
    } else if ([encoding isEqualToString:@"UTF-32LE"]) {
        return [LocalizationManager.sharedManager localizedStringForKey:@"encoding_utf32le"];
    } else if ([encoding isEqualToString:@"ASCII"]) {
        return [LocalizationManager.sharedManager localizedStringForKey:@"encoding_ascii"];
    } else if ([encoding isEqualToString:@"ISO-8859-1"]) {
        return [LocalizationManager.sharedManager localizedStringForKey:@"encoding_iso88591"];
    } else if ([encoding isEqualToString:@"Windows-1252"]) {
        return [LocalizationManager.sharedManager localizedStringForKey:@"encoding_windows1252"];
    }
    
    // For other encodings, return the encoding name itself
    return encoding;
}

- (NSStringEncoding)nsStringEncodingForEncoding:(NSString *)encoding {
    if ([encoding isEqualToString:@"UTF-8"]) {
        return NSUTF8StringEncoding;
    } else if ([encoding isEqualToString:@"UTF-16"]) {
        return NSUTF16StringEncoding;
    } else if ([encoding isEqualToString:@"UTF-16BE"]) {
        return NSUTF16BigEndianStringEncoding;
    } else if ([encoding isEqualToString:@"UTF-16LE"]) {
        return NSUTF16LittleEndianStringEncoding;
    } else if ([encoding isEqualToString:@"UTF-32"]) {
        return NSUTF32StringEncoding;
    } else if ([encoding isEqualToString:@"UTF-32BE"]) {
        return NSUTF32BigEndianStringEncoding;
    } else if ([encoding isEqualToString:@"UTF-32LE"]) {
        return NSUTF32LittleEndianStringEncoding;
    } else if ([encoding isEqualToString:@"ASCII"]) {
        return NSASCIIStringEncoding;
    } else if ([encoding isEqualToString:@"ISO-8859-1"]) {
        return NSISOLatin1StringEncoding;
    } else if ([encoding isEqualToString:@"ISO-8859-2"]) {
        return NSISOLatin2StringEncoding;
    } else if ([encoding isEqualToString:@"ISO-8859-3"]) {
        return NSISOLatin3StringEncoding;
    } else if ([encoding isEqualToString:@"ISO-8859-4"]) {
        return NSISOLatin4StringEncoding;
    } else if ([encoding isEqualToString:@"ISO-8859-5"]) {
        return NSISOCyrillicStringEncoding;
    } else if ([encoding isEqualToString:@"ISO-8859-6"]) {
        return NSISOArabicStringEncoding;
    } else if ([encoding isEqualToString:@"ISO-8859-7"]) {
        return NSISO GreekStringEncoding;
    } else if ([encoding isEqualToString:@"ISO-8859-8"]) {
        return NSISO HebrewStringEncoding;
    } else if ([encoding isEqualToString:@"ISO-8859-9"]) {
        return NSISOLatin5StringEncoding;
    } else if ([encoding isEqualToString:@"ISO-8859-10"]) {
        return NSISOLatin6StringEncoding;
    } else if ([encoding isEqualToString:@"ISO-8859-13"]) {
        return NSISOLatin7StringEncoding;
    } else if ([encoding isEqualToString:@"ISO-8859-14"]) {
        return NSISOLatin8StringEncoding;
    } else if ([encoding isEqualToString:@"ISO-8859-15"]) {
        return NSISOLatin9StringEncoding;
    } else if ([encoding isEqualToString:@"ISO-8859-16"]) {
        return NSISOLatin10StringEncoding;
    } else if ([encoding isEqualToString:@"Windows-1250"]) {
        return NSWindowsCP1250StringEncoding;
    } else if ([encoding isEqualToString:@"Windows-1251"]) {
        return NSWindowsCP1251StringEncoding;
    } else if ([encoding isEqualToString:@"Windows-1252"]) {
        return NSWindowsCP1252StringEncoding;
    } else if ([encoding isEqualToString:@"Windows-1253"]) {
        return NSWindowsCP1253StringEncoding;
    } else if ([encoding isEqualToString:@"Windows-1254"]) {
        return NSWindowsCP1254StringEncoding;
    } else if ([encoding isEqualToString:@"Windows-1255"]) {
        return NSWindowsCP1255StringEncoding;
    } else if ([encoding isEqualToString:@"Windows-1256"]) {
        return NSWindowsCP1256StringEncoding;
    } else if ([encoding isEqualToString:@"Windows-1257"]) {
        return NSWindowsCP1257StringEncoding;
    } else if ([encoding isEqualToString:@"Windows-1258"]) {
        return NSWindowsCP1258StringEncoding;
    } else if ([encoding isEqualToString:@"MacRoman"]) {
        return NSMacOSRomanStringEncoding;
    }
    
    // Default to UTF-8 for unknown encodings
    return NSUTF8StringEncoding;
}

- (NSString *)encodingForNSStringEncoding:(NSStringEncoding)nsEncoding {
    switch (nsEncoding) {
        case NSUTF8StringEncoding:
            return @"UTF-8";
        case NSUTF16StringEncoding:
            return @"UTF-16";
        case NSUTF16BigEndianStringEncoding:
            return @"UTF-16BE";
        case NSUTF16LittleEndianStringEncoding:
            return @"UTF-16LE";
        case NSUTF32StringEncoding:
            return @"UTF-32";
        case NSUTF32BigEndianStringEncoding:
            return @"UTF-32BE";
        case NSUTF32LittleEndianStringEncoding:
            return @"UTF-32LE";
        case NSASCIIStringEncoding:
            return @"ASCII";
        case NSISOLatin1StringEncoding:
            return @"ISO-8859-1";
        case NSISOLatin2StringEncoding:
            return @"ISO-8859-2";
        case NSISOLatin3StringEncoding:
            return @"ISO-8859-3";
        case NSISOLatin4StringEncoding:
            return @"ISO-8859-4";
        case NSISOCyrillicStringEncoding:
            return @"ISO-8859-5";
        case NSISOArabicStringEncoding:
            return @"ISO-8859-6";
        case NSISO GreekStringEncoding:
            return @"ISO-8859-7";
        case NSISO HebrewStringEncoding:
            return @"ISO-8859-8";
        case NSISOLatin5StringEncoding:
            return @"ISO-8859-9";
        case NSISOLatin6StringEncoding:
            return @"ISO-8859-10";
        case NSISOLatin7StringEncoding:
            return @"ISO-8859-13";
        case NSISOLatin8StringEncoding:
            return @"ISO-8859-14";
        case NSISOLatin9StringEncoding:
            return @"ISO-8859-15";
        case NSISOLatin10StringEncoding:
            return @"ISO-8859-16";
        case NSWindowsCP1250StringEncoding:
            return @"Windows-1250";
        case NSWindowsCP1251StringEncoding:
            return @"Windows-1251";
        case NSWindowsCP1252StringEncoding:
            return @"Windows-1252";
        case NSWindowsCP1253StringEncoding:
            return @"Windows-1253";
        case NSWindowsCP1254StringEncoding:
            return @"Windows-1254";
        case NSWindowsCP1255StringEncoding:
            return @"Windows-1255";
        case NSWindowsCP1256StringEncoding:
            return @"Windows-1256";
        case NSWindowsCP1257StringEncoding:
            return @"Windows-1257";
        case NSWindowsCP1258StringEncoding:
            return @"Windows-1258";
        case NSMacOSRomanStringEncoding:
            return @"MacRoman";
        default:
            return @"UTF-8";
    }
}

@end