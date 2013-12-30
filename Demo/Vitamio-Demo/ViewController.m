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
@property (nonatomic, assign) IBOutlet UITextField *urlTextFidld;
@property (nonatomic, assign)          int          isPlay2;
@end


@implementation ViewController

static NSString *sMediaURLs[] = {
//	@"assets-library://asset/asset.MOV?id=112C86F5-1A5E-42EF-ADFA-0BE19C540665&ext=MOV",
	
	@"v.mp4",
	
	@"http://hot.vrs.sohu.com/ipad1407291_4596271359934_4618512.m3u8", // 2
	@"http://219.232.161.210:5080/livestream/uv54q5wp_20131215132307_20131215132522.ts",

	@"http://219.232.161.210:5080/livestream/uv54q5wp20131215191827.ts",
	@"http://stream.foream.cn:5080/hls/timeshift/hX1fvBGT.m3u8",

	@"http://219.232.161.210:5080/livestream/uv54q5wp_20131215132307_20131215132522.ts",

//	@"http://ting.weibo.com/page/appclient/getmp3?object_id=1022:10151501_121466&source_id=1040",
	
//	@"d/like.mp4",
//	@"d/like.mkv",
//	@"d/big.mkv",
//	@"d/big.mov",
//	@"d/vv.mp4",
//	@"d/11.rmvb",
//	@"d/2/2.m3u8",
//	@"d/JiaZhouLvGuan.avi",
//	@"d/r.mkv",

//	@"d/beyond.flac",

	@"http://hot.vrs.sohu.com/ipad1407291_4596271359934_4618512.m3u8", // 2
	@"http://hot.vrs.sohu.com/ipad1407282_4596271442077_4618503.m3u8", // 1

	@"http://paikeapp.video.sina.com.cn/stream/D9xQWySKVsGlnzq~.mp4", // open slowly?
	@"http://metal.video.qiyi.com/20131104/dbb56b29ef709ba4c9e17621c0e5c2a5.m3u8", // 40

	@"rtmp://42.121.85.232/live/20854663",

	// bad
//	@"http://v.youku.com/player/getRealM3U8/vid/XMjc5NjQxOTQ4/type//video.m3u8",
//	@"http://mtv.v.iask.com/manifest/20130924906_400.m3u8",
//	@"http://devimages.apple.com/iphone/samples/bipbop/bipbopall.m3u8",

	// good
//	@"http://mp4i.vodfile.m1905.com/movie/1202/120298DF21FC43729B32.mp4",

//	@"rtsp://www.jxtvjd.com/jxtv7",

//	@"mms://218.61.6.228/jtgb?NiMwIzE=",
//	@"mms://cdnmms.cnr.cn/cnr001",
//	@"http://ndrstream.ic.llnwd.net/stream/ndrstream_ndr1wellenord_hi_mp3",


//	@"http://metal.video.qiyi.com/395/07705bd9a5adb020805afdb6bec05168.m3u8", //  泰囧 2012年
//	@"http://v.youku.com/player/getRealM3U8/vid/XNjA1ODU3MDA4/type/mp4", // - 15
//	@"http://metal.video.qiyi.com/276/61739091ac7cf21a479fbe683384fc81.m3u8", // 父子
////	@"http://metal.video.qiyi.com/20131015/8602db40710b279823eefb28851fa7ed.m3u8", // 3
//	@"http://metal.video.qiyi.com/20131014/159fd3bbd63503e3807af1dffcaf107b.m3u8", // 1
//	@"http://metal.video.qiyi.com/20131016/e703483d81fd519619e925fa52d7191d.m3u8", // 2

//	@"http://17173.tv.sohu.com/api/2525361.m3u8",
//	@"http://17173.tv.sohu.com/api/1632389.m3u8",

//	@"http://chanson.cdnvideo.ru/paramlive/chanson128.stream/playlist.m3u8", // only audio stream(AAC)
	@"http://v.youku.com/player/getRealM3U8/vid/XNDY2ODM2NTg0/type/mp4",

	@"http://17173.tv.sohu.com/api/2752061.m3u8",
	@"http://17173.tv.sohu.com/api/1620355.m3u8",

	@"http://devimages.apple.com/iphone/samples/bipbop/bipbopall.m3u8", // contains multiple video stream
//    @"mms://alive.rbc.cn/fm1006",
//	@"mms://218.61.6.228/jtgb?NiMwIzE=",
//	@"rtmp://113.161.212.25/live/atv1",

//	@"http://112.197.2.11:1935/live/vtv3.stream/playlist.m3u8",
//	@"http://184.72.239.149/vod/smil:bigbuckbunnyiphone.smil/playlist.m3u8", // contains multiple video stream
//	@"http://sjlive.cbg.cn/app_2/_definst_/ls_2.stream/playlist.m3u8",

//	@"http://live.gslb.letv.com/gslb?stream_id=cctv1&tag=live&ext=m3u8&sign=live_ipad", // live

//	@"http://v.youku.com/player/getRealM3U8/vid/XMTgzMTQ1NjYw/type/mp4",

	@"http://gslb.yixia.com/stream/brTfKUwBl7asf0bF.mp4?yx=",

	@"http://v.youku.com/player/getRealM3U8/vid/XMTI2NjQzMDAw/type/hd2",
	@"http://v.youku.com/player/getRealM3U8/vid/XNjI1NjM4MDIw/type/hd2",
	@"http://v.youku.com/player/getRealM3U8/vid/XNjI4MzAyOTQ0/type/mp4",

	@"http://pl.youku.com/playlist/m3u8?vid=XMzYwNDAyNDgw&type=mp4&ts=1381806651&keyframe=0",

	@"http://v.youku.com/player/getRealM3U8/vid/XNTY0ODIwODQ0/type/hd2",
//	@"http://f3.r.56.com/f3.c56.56.com/flvdownload/10/9/128093354047hd.flv?v=1&t=KiCn5l4sG4hKYjQ1t1SeJw&r=47239&e=1382603789&tt=6440&sz=215433701&vid=58425523",
	@"http://v.youku.com/player/getRealM3U8/vid/XNjAwMDM5MDI0/type/hd2",

	@"http://pl.youku.com/playlist/m3u8?vid=XMzYwNDAyNDgw&type=mp4&ts=1381806651&keyframe=0",
	@"http://pl.youku.com/playlist/m3u8?vid=XNDM3NTk5NDY0&type=mp4&ts=1381806059&keyframe=0",

//	@"http://v.youku.com/player/getRealM3U8/vid/XNjIxMTM4MjY4/type/mp4/ts/1381743774/useKeyframe/0/video.m3u8",

	@"http://159.226.15.215:8080/hls/zeiou/zeiou.m3u8",
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
	self.isPlay2 = NO;
	sCurrPlayIdx = 0;
	PlayerController *playerCtrl;
	playerCtrl = [[[PlayerController alloc] initWithNibName:nil bundle:nil] autorelease];
	playerCtrl.delegate = self;
	[self presentModalViewController:playerCtrl animated:YES];
}

-(IBAction)playButtonAction2:(id)sender
{
	self.isPlay2 = YES;
	PlayerController *playerCtrl;
	playerCtrl = [[[PlayerController alloc] initWithNibName:nil bundle:nil] autorelease];
	playerCtrl.delegate = self;
	[self presentModalViewController:playerCtrl animated:YES];
}


#pragma mark - PlayerControllerDelegate

- (NSURL *)playCtrlGetCurrMediaTitle:(NSString **)title lastPlayPos:(long *)lastPlayPos
{
	if (self.isPlay2) {
		return [NSURL URLWithString:self.urlTextFidld.text];
	}

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
