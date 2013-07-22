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


@interface ViewController ()
@end


@implementation ViewController


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
	PlayerController *playerCtrl;
	playerCtrl = [[[PlayerController alloc] initWithNibName:nil bundle:nil] autorelease];

	NSString *v = nil;

//	v = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"video-demo.mkv"];
//	v = @"http://meta.video.qiyi.com/242/de25dc2b5d385a8e27304d1e6dcd1a35.m3u8";
//	v = @"assets-library://asset/asset.MOV?id=112C86F5-1A5E-42EF-ADFA-0BE19C540665&ext=MOV";
//	v = @"http://ipadlive.cntv.soooner.com/cctv_p2p_hdtaiqiu.m3u8";
//	v = @"http://219.232.160.145:5080/livestream/esx7h676.ts"; // 打不开?
//	v = @"http://119.97.131.69/hls/playlist.m3u8";
	v = @"mms://cdnmms.cnr.cn/cnr001";

	playerCtrl.videoURL = [NSURL URLWithString:v];

	[self presentModalViewController:playerCtrl animated:YES];
}


@end
