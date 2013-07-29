//
//  ViewController.m
//  Vitamio-Demo
//
//  Created by erlz nuo(nuoerlz@gmail.com) on 7/8/13.
//  Copyright (c) 2013 yixia. All rights reserved.
//

#import "Vitamio.h"
#import "ViewController.h"
#import "PlayerController.h"
#import "PlayerControllerDelegate.h"


@interface ViewController () <PlayerControllerDelegate>
@end


@implementation ViewController

static NSString *sMediaURLs[] = {
//	[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"video-demo.mkv"],
//	@"assets-library://asset/asset.MOV?id=112C86F5-1A5E-42EF-ADFA-0BE19C540665&ext=MOV",

	@"http://meta.video.qiyi.com/242/de25dc2b5d385a8e27304d1e6dcd1a35.m3u8",
	@"http://ipadlive.cntv.soooner.com/cctv_p2p_hdtaiqiu.m3u8",
//	@"http://219.232.160.145:5080/livestream/esx7h676.ts", // can't loadind?
	@"mms://cdnmms.cnr.cn/cnr001",
	@"http://ndrstream.ic.llnwd.net/stream/ndrstream_ndr1wellenord_hi_mp3",
	@"http://94.242.221.141/hls/a-lo/stream140.m3u8",
	@"http://devimages.apple.com/iphone/samples/bipbop/bipbopall.m3u8", // contains multiple qualities

	@"http://159.226.15.215:8080/hls/zeiou/zeiou.m3u8",
	@"http://www.tingshijie.com/d/ysxs/QMJDYH/2012-12-27/清明记第一回--雨落惊鸿.flv",
	@"http://www.tingshijie.com/d/ysxs/SYCQDESJ/2013-02-01/声音传情第二十期.mp3",
};

static int sCurrPlayIdx;


#pragma makr - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	NSLog(@"NAL 1UIO &&&&&&& Vitamio version: %@", [Vitamio version]);
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
}


#pragma mark - Buttons Action

-(IBAction)playButtonAction:(id)sender
{
	sCurrPlayIdx = 0;
	PlayerController *playerCtrl;
	playerCtrl = [[[PlayerController alloc] initWithNibName:nil bundle:nil] autorelease];
	playerCtrl.delegate = self;
	[self presentModalViewController:playerCtrl animated:YES];
}


#pragma mark - PlayerControllerDelegate

- (NSURL *)playCtrlGetCurrMediaTitle:(NSString **)title lastPlayPos:(long *)lastPlayPos
{
	int num = sizeof(sMediaURLs) / sizeof(sMediaURLs[0]);
	sCurrPlayIdx = (sCurrPlayIdx + num) % num;
	NSString *v = sMediaURLs[sCurrPlayIdx];
	return [NSURL URLWithString:[v stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
}

- (NSURL *)playCtrlGetNextMediaTitle:(NSString **)title lastPlayPos:(long *)lastPlayPos
{
	int num = sizeof(sMediaURLs) / sizeof(sMediaURLs[0]);
	sCurrPlayIdx = (sCurrPlayIdx + num + 1) % num;
	NSString *v = sMediaURLs[sCurrPlayIdx];
	return [NSURL URLWithString:[v stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
}

- (NSURL *)playCtrlGetPrevMediaTitle:(NSString **)title lastPlayPos:(long *)lastPlayPos
{
	int num = sizeof(sMediaURLs) / sizeof(sMediaURLs[0]);
	sCurrPlayIdx = (sCurrPlayIdx + num - 1) % num;
	NSString *v = sMediaURLs[sCurrPlayIdx];
	return [NSURL URLWithString:[v stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
}


@end
