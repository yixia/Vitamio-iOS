//
//  VAppInfo.m
//  VPlayer
//
//  Created by erlz nuo on 13-1-16.
//
//

#import "VAppInfo.h"


@interface VAppInfo ()

@property (nonatomic, readwrite, assign) BOOL		isJailbroken;
@property (nonatomic, readwrite, copy)   NSString	*homePath;
@property (nonatomic, readwrite, copy)   NSString	*docmentsPath;
@property (nonatomic, readwrite, copy)   NSString	*libraryPath;
@property (nonatomic, readwrite, copy)   NSString	*tmpPath;
@property (nonatomic, readwrite, copy)   NSString	*cachesPath;
@property (nonatomic, readwrite, copy)   NSString	*preferencesPath;
@property (nonatomic, readwrite, copy)   NSString	*bundlePath;

- (BOOL) initialize;

@end



#pragma mark -

@implementation VAppInfo

static VAppInfo  *sVAppInfoShared = nil;


- (BOOL)initialize
{
	[self initIsJailbroken];

	[self initDirPath];

	return YES;
}


#pragma mark - Private Methods

- (void)initIsJailbroken
{
	self.isJailbroken = NO;
	NSString *cydiaPath = @"/Applications/Cydia.app";
	NSString *aptPath = @"/private/var/lib/apt/";
	if ( [[NSFileManager defaultManager] fileExistsAtPath:cydiaPath] ) {
		self.isJailbroken = YES;
	}
	if ( [[NSFileManager defaultManager] fileExistsAtPath:aptPath] ) {
		self.isJailbroken = YES;
	}
}

- (void)initDirPath
{
	self.homePath = NSHomeDirectory();
	self.docmentsPath = [_homePath stringByAppendingPathComponent:@"Documents"];
	self.libraryPath = [_homePath stringByAppendingPathComponent:@"Library/VPlayer"];
	self.tmpPath = [_homePath stringByAppendingPathComponent:@"tmp/VPlayer"];
	self.cachesPath = [_homePath stringByAppendingPathComponent:@"Library/Caches/VPlayer"];
	self.preferencesPath = [_homePath stringByAppendingPathComponent:@"Library/Preferences/VPlayer"];
	self.bundlePath = [[NSBundle mainBundle] bundlePath];

	[self createDirPathIfNeed:self.homePath];
	[self createDirPathIfNeed:self.docmentsPath];
	[self createDirPathIfNeed:self.libraryPath];
	[self createDirPathIfNeed:self.tmpPath];
	[self createDirPathIfNeed:self.cachesPath];
	[self createDirPathIfNeed:self.preferencesPath];
	[self createDirPathIfNeed:self.bundlePath];
}

- (NSString *)createDirPathIfNeed:(NSString*)dirPath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ( ![fileManager fileExistsAtPath:dirPath] ) {
        [fileManager createDirectoryAtPath:dirPath
               withIntermediateDirectories:YES
                                attributes:nil
                                     error:NULL];
    }
    return dirPath;
}


#pragma mark - VAppInfo Singleton Implementation

+ (VAppInfo *)sharedInstance
{
	@synchronized([self class]) {
		if ( sVAppInfoShared == nil ) {
			sVAppInfoShared = [[[self class] alloc] init];
			[sVAppInfoShared initialize];
		}
		return sVAppInfoShared;
	}
}


#pragma mark - Public Instance Methods

@end
