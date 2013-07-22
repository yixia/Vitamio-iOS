#import <Foundation/Foundation.h>
#import "VAppInfo.h"


#define kBytesPerG  1073741824    // 1024 * 1024 * 1024
#define kBytesPerM  1048576       // 1024 * 1024
#define kBytesPerK  1024          // 1024



@interface Utilities : NSObject {

}


+(NSString *)localePath:(NSString *)fileName;
+(NSString *)bundlePath:(NSString *)fileName;
+(NSString *)documentsPath:(NSString *)fileName;
+(NSString *)cachesPath:(NSString *)fileName;
+(NSString *)cachesPathWithCString:(const char *)fileName;
+(NSString *)preferencesPath:(NSString *)fileName;
+(BOOL)fileIsExist:(NSString*)file;
+(NSString *)getDirPathCreateIfNeed:(NSString*)dirPath;
+(NSString *)getFilePathCreateIfNeed:(NSString*)dirPath file:(NSString*)fileName;
+(NSString *)getMD5FilePathCreateIfNeed:(NSString*)dirPath file:(NSString*)fileName;
+(NSString *)MD5StringWithKey:(NSString*)key;

+(NSString *)diskSizeToHumanString:(unsigned long long)bytes;
+(NSString *)timeToHumanString:(unsigned long)ms;

+(NSString *)getNowTimeForHumanString;
+(NSString *)dateTimeToHumanString:(NSDate*)date;
+(NSString *)getBatteryLevelForHumanString;
+(NSString *)percentageToHumanString:(float)percentage;

+(BOOL)isLocalMedia:(NSURL*)url;
+(BOOL)isIPodOrCameraFile:(NSURL*)url;
+(void)removeFileInSharingLibrary:(NSURL*)fileURL;
+(BOOL)file:(NSString *)file isExpirationWithSeconds:(int)secs;

+(BOOL)systemVersionIsHighOrEqualToIt:(NSString*)minSystemVersion;
+(BOOL)systemVersionIsEqualToIt:(NSString*)version;
+(BOOL)isFirstTimeTouchHere:(NSString *)str;


+(UIColor*)colorR:(int)r G:(int)g B:(int)b A:(int)a;
+(UIColor*)colorWithRed:(int)r withGreen:(int)g withBlue:(int)b;
+(UIColor*)colorWithHexNumber:(unsigned long)colorHex;
+(unsigned long)colorHexNumberWithUIColor:(UIColor *)color;

+(float)getCurSystemVolume;
+(float)getCurSystemBright;
+(void)setCurSystemVolume:(float)volume;
+(void)setCurSystemBright:(float)bright;

+(BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL;

+(void)showErrorView:(NSString *)sError withReason:(NSString *)sReason;


#pragma mark - debug utilities

+(BOOL)saveYUV420PDataToFile:(NSString*)filename
                       withY:(uint8_t*)y
                       withU:(uint8_t*)u
                       withV:(uint8_t*)v
                withLinesize:(int[3])linesize
                       withW:(int)w
                       withH:(int)h;


@end

