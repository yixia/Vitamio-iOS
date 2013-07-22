#import <sys/xattr.h>
#import "UIKit/UIKit.h"
#import <MediaPlayer/MediaPlayer.h>
#import <CommonCrypto/CommonDigest.h>
#import "Utilities.h"

@implementation Utilities



+(NSString *)localePath:(NSString *)fileName
{
	NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
	NSString *localeProj = [language stringByAppendingPathExtension:@"lproj"];
	NSString *localePath = [self bundlePath:localeProj];
	return [localePath stringByAppendingPathComponent:fileName];
}

+(NSString *)bundlePath:(NSString *)fileName
{
	return [[[VAppInfo sharedInstance] bundlePath] stringByAppendingPathComponent:fileName];
}

+(NSString *)documentsPath:(NSString *)fileName
{
	return [[[VAppInfo sharedInstance] docmentsPath] stringByAppendingPathComponent:fileName];
}

+(NSString *)cachesPath:(NSString *)fileName
{
    return [[[VAppInfo sharedInstance] cachesPath] stringByAppendingPathComponent:fileName];
}

+(NSString *)cachesPathWithCString:(const char *)fileName
{
    NSString *nsfile = [[[NSString alloc] initWithCString:fileName
                                                 encoding:NSUTF8StringEncoding] autorelease];
    return [self cachesPath:nsfile];
}

+(NSString *)preferencesPath:(NSString *)fileName
{
    return [[[VAppInfo sharedInstance] preferencesPath] stringByAppendingPathComponent:fileName];
}

+(BOOL)fileIsExist:(NSString*)file
{
    return [[NSFileManager defaultManager] fileExistsAtPath:file];
}

+(NSString *)getDirPathCreateIfNeed:(NSString*)dirPath
{
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    if ( ![fileManager fileExistsAtPath:dirPath] ) {
        [fileManager createDirectoryAtPath:dirPath
               withIntermediateDirectories:YES
                                attributes:nil
                                     error:NULL];
    }
    [fileManager release];

    return dirPath;
}

+(NSString *)getFilePathCreateIfNeed:(NSString*)dirPath file:(NSString*)fileName
{
    return [[Utilities getDirPathCreateIfNeed:dirPath]
            stringByAppendingPathComponent:fileName];
}

+(NSString *)getMD5FilePathCreateIfNeed:(NSString*)dirPath file:(NSString*)fileName
{
    return [self getFilePathCreateIfNeed:dirPath
                                    file:[self MD5StringWithKey:fileName]];
}

+(NSString *)MD5StringWithKey:(NSString*)key
{
    const char *str = [key UTF8String];
    unsigned char r[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), r);
    NSString *md5str = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x"
                        "%02x%02x%02x%02x%02x%02x",
                        r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9],
                        r[10], r[11], r[12], r[13], r[14], r[15]];
    return md5str;
}


+(NSString *)diskSizeToHumanString:(unsigned long long)bytes
{
    char buff[128] = { 0 };
    NSString *nsRet = nil;

    long G = bytes / kBytesPerG;
    long M = (bytes - G * kBytesPerG) / kBytesPerM;
    long K = (bytes - G * kBytesPerG - M * kBytesPerM) / kBytesPerK;
    long B = bytes - G * kBytesPerG - M * kBytesPerM - K * kBytesPerK;

    if ( G > 0 )
        snprintf(buff, sizeof(buff), "%.2fGB", (double)bytes / kBytesPerG);
    else if ( M > 0 )
        snprintf(buff, sizeof(buff), "%ldMB", M + 1);
    else if ( K > 0 )
        snprintf(buff, sizeof(buff), "%ldKB", K + 1);
    else
        snprintf(buff, sizeof(buff), "%ldB", B);

    nsRet = [[[NSString alloc] initWithCString:buff
                                      encoding:NSUTF8StringEncoding] autorelease];

    return nsRet;
}

+(NSString *)timeToHumanString:(unsigned long)ms
{
    int seconds, h, m, s;
    char buff[128] = { 0 };
    NSString *nsRet = nil;

    seconds = ms / 1000;
    h = seconds / 3600;
    m = (seconds - h * 3600) / 60;
    s = seconds - h * 3600 - m * 60;
    snprintf(buff, sizeof(buff), "%02d:%02d:%02d", h, m, s);
    nsRet = [[[NSString alloc] initWithCString:buff
                                      encoding:NSUTF8StringEncoding] autorelease];

    return nsRet;
}


+(NSString *)getNowTimeForHumanString
{
    NSDate *now = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone systemTimeZone]];
	[formatter setDateFormat:@"HH:mm"];
    NSString *nsNow = [formatter stringFromDate:now];
    [formatter release];

    return nsNow;
}

+(NSString *)dateTimeToHumanString:(NSDate*)date
{
    if ( date == nil ) return nil;

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterShortStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setTimeZone:[NSTimeZone localTimeZone]];
    NSString *ns = [formatter stringFromDate:date];
    [formatter release];

    return ns;
}

+(NSString *)getBatteryLevelForHumanString
{
    [[UIDevice currentDevice] setBatteryMonitoringEnabled:YES];
    float battLvl = [[UIDevice currentDevice] batteryLevel];
    char buff[32] = { 0 };
    NSString *nsRet = nil;

    snprintf(buff, sizeof(buff), "%d%%", (int)(battLvl * 100));
    nsRet = [[[NSString alloc] initWithCString:buff
                                      encoding:NSUTF8StringEncoding] autorelease];

    return nsRet;
}

+(NSString *)percentageToHumanString:(float)percentage
{
    char buff[16] = { 0 };
    NSString *nsRet = nil;

    snprintf(buff, sizeof(buff), "%d%%", (int)(percentage * 100));
    nsRet = [[[NSString alloc] initWithCString:buff
                                      encoding:NSUTF8StringEncoding] autorelease];

    return nsRet;
}

+(BOOL)isLocalMedia:(NSURL*)url
{
    static NSString * const local = @"/";
    static NSString * const local2 = @"file://localhost/";
    static NSString * const iPod = @"ipod-library://";
    static NSString * const camera = @"assets-library://";

    NSString * urlStr = [url absoluteString];
    if ( [urlStr hasPrefix:local] ) return YES;
    if ( [urlStr hasPrefix:local2] ) return YES;
    if ( [urlStr hasPrefix:iPod] ) return YES;
    if ( [urlStr hasPrefix:camera] ) return YES;

    return NO;
}

+(BOOL)isIPodOrCameraFile:(NSURL*)url
{
    static NSString * const iPod = @"ipod-library://";
    static NSString * const camera = @"assets-library://";

    NSString * urlStr = [url absoluteString];
    if ( [urlStr hasPrefix:iPod] ) return YES;
    if ( [urlStr hasPrefix:camera] ) return YES;

    return NO;
}

+(void)removeFileInSharingLibrary:(NSURL*)fileURL
{
    if ( ![fileURL isFileURL] ) {
        return;
    }
    NSFileManager *fileMg = [[NSFileManager alloc] init];
    [fileMg removeItemAtPath:[fileURL path] error:nil];
    [fileMg release];
}

+(BOOL)file:(NSString *)file isExpirationWithSeconds:(int)secs
{
    if (!file || ![[NSFileManager defaultManager] fileExistsAtPath:file])
		return YES;
    NSDate *exp = [NSDate dateWithTimeIntervalSinceNow:-secs];
	NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfItemAtPath:file error:nil];
	if ([[[attrs fileModificationDate] laterDate:exp] isEqualToDate:exp]) {
		return YES;
    }
	return NO;
}

+(BOOL)systemVersionIsHighOrEqualToIt:(NSString*)minSystemVersion
{
	NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
	if ( [systemVersion compare:minSystemVersion options:NSNumericSearch] != NSOrderedAscending ) {
        return YES;
    }
    return NO;
}

+(BOOL)systemVersionIsEqualToIt:(NSString*)version
{
	NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
	if ( [systemVersion compare:version options:NSNumericSearch] == NSOrderedSame ) {
        return YES;
    }
    return NO;
}

+(BOOL)isFirstTimeTouchHere:(NSString *)str
{
	assert(str != nil && ![str isEqualToString:@""]);
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:str] == nil) {
		[defaults setObject:str forKey:str];
		[defaults synchronize];
        return YES;
    }
    return NO;
}

+(UIColor*)colorR:(int)r G:(int)g B:(int)b A:(int)a
{
	return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a/255.0];
}

+(UIColor*)colorWithRed:(int)r withGreen:(int)g withBlue:(int)b
{
	return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0];
}

+(UIColor*)colorWithHexNumber:(unsigned long)colorHex
{
    return [UIColor colorWithRed:((colorHex & 0xFF000000) >> 24)/255.0
                           green:((colorHex & 0x00FF0000) >> 16)/255.0
                            blue:((colorHex & 0x0000FF00) >> 8) /255.0
                           alpha:((colorHex & 0x000000FF))      /255.0];
}

+(unsigned long)colorHexNumberWithUIColor:(UIColor *)color
{
	CGFloat red = 0.0, green = 0.0, blue = 0.0, alpha = 1.0;
	const CGFloat *components = CGColorGetComponents(color.CGColor);
	int num = CGColorGetNumberOfComponents(color.CGColor);
	if (num == 4) {
		red = components[0];
		green = components[1];
		blue = components[2];
		alpha = components[3];
	} else if (num == 3) {
		red = components[0];
		green = components[1];
		blue = components[2];
	}

	int r = (int)(red * 255)   & 0xFF;
	int g = (int)(green * 255) & 0xFF;
	int b = (int)(blue * 255)  & 0xFF;
	int a = (int)(alpha * 255) & 0xFF;
	unsigned long rgba = r<<24 | g<<16 | b<< 8 | a;

	return rgba;
}


+(float)getCurSystemVolume
{
    return [[MPMusicPlayerController applicationMusicPlayer] volume];
}

+(float)getCurSystemBright
{
    if ( [[UIScreen mainScreen] respondsToSelector:@selector(brightness)] ) {
        return [UIScreen mainScreen].brightness;
    }
    return 1.0;
}

+(void)setCurSystemVolume:(float)volume
{
    [[MPMusicPlayerController applicationMusicPlayer] setVolume:volume];
}

+(void)setCurSystemBright:(float)bright
{
    if ( [[UIScreen mainScreen] respondsToSelector:@selector(brightness)] ) {
        [[UIScreen mainScreen] setBrightness:bright];
    }
}


+(BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL
{
    if ( ! [[NSFileManager defaultManager] fileExistsAtPath:[URL path]] ) return YES;

    BOOL success = YES;
    if ( [self systemVersionIsHighOrEqualToIt:@"5.1"] ) {
        NSError *error = nil;
        success = [URL setResourceValue:[NSNumber numberWithBool:YES]
                                 forKey:NSURLIsExcludedFromBackupKey
                                  error:&error];
    } else if ( [self systemVersionIsEqualToIt:@"5.0.1"] ) {
        const char *filePath = [[URL path] fileSystemRepresentation];
        const char *attrName = "com.apple.MobileBackup";
        u_int8_t attrValue = 1;
        int result = setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
        success = (result == 0);
    }

    return success;
}

+(void)showErrorView:(NSString *)sError withReason:(NSString *)sReason
{
	if (!sError) sError = @"Unknown Error";
	if (!sReason) sReason = @"Unknown Reason!";

	NSDictionary *errorDict = [NSDictionary dictionaryWithObjectsAndKeys:
							   sError, NSLocalizedDescriptionKey,
							   sReason, NSLocalizedFailureReasonErrorKey,
							   nil];
	NSError *error = [NSError errorWithDomain:@"VPlayer" code:0 userInfo:errorDict];

	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[error localizedDescription]
														message:[error localizedFailureReason]
													   delegate:nil
											  cancelButtonTitle:@"OK"
											  otherButtonTitles:nil];
	[alertView show];
	[alertView release];
}


#pragma mark - debug utilities

+(BOOL)saveYUV420PDataToFile:(NSString*)filename
                       withY:(uint8_t*)y
                       withU:(uint8_t*)u
                       withV:(uint8_t*)v
                withLinesize:(int[3])linesize
                       withW:(int)w
                       withH:(int)h
{
#define kDebugYUV420PDirPath [[VAppInfo sharedInstance] homePath]

    int ret;
    FILE *pYUV = NULL;
    NSString *savefile = [self getFilePathCreateIfNeed:kDebugYUV420PDirPath file:filename];


    pYUV = fopen([savefile cStringUsingEncoding:NSUTF8StringEncoding], "w");
    if ( pYUV == NULL ) return NO;

    ret = fwrite(&w, 1, sizeof(int), pYUV);
    ret = fwrite(&h, 1, sizeof(int), pYUV);

    ret = fwrite(y, 1, sizeof(uint8_t)*w*h, pYUV);
    ret = fwrite(u, 1, sizeof(uint8_t)*(w/2)*(h/2), pYUV);
    ret = fwrite(v, 1, sizeof(uint8_t)*(w/2)*(h/2), pYUV);
    assert(ret == (w/2)*(h/2));

    fclose(pYUV);

    return YES;

#undef kDebugYUV420PDirPath
}

@end
