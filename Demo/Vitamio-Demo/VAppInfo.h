//
//  VAppInfo.h
//  VPlayer
//
//  Created by erlz nuo on 13-1-16.
//
//


@interface VAppInfo : NSObject
{
}

@property (nonatomic, readonly, assign) BOOL		isJailbroken;
@property (nonatomic, readonly, copy)   NSString	*homePath;
@property (nonatomic, readonly, copy)   NSString	*docmentsPath;
@property (nonatomic, readonly, copy)   NSString	*libraryPath;
@property (nonatomic, readonly, copy)   NSString	*tmpPath;
@property (nonatomic, readonly, copy)   NSString	*cachesPath;
@property (nonatomic, readonly, copy)   NSString	*preferencesPath;
@property (nonatomic, readonly, copy)   NSString	*bundlePath;

+ (VAppInfo *) sharedInstance;


@end
