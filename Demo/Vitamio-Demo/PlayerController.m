//
//  PlayerController.m
//  Vitamio-Demo
//
//  Created by erlz nuo(nuoerlz@gmail.com) on 7/8/13.
//  Copyright (c) 2013 yixia. All rights reserved.
//

#import "Utilities.h"
#import "PlayerController.h"
#import "VSegmentSlider.h"


@interface PlayerController ()
{
    VMediaPlayer       *mMPayer;
    long               mDuration;
    long               mCurPostion;
    NSTimer            *mSyncSeekTimer;
}

@property (nonatomic, assign) IBOutlet UIButton *startPause;
@property (nonatomic, assign) IBOutlet UIButton *prevBtn;
@property (nonatomic, assign) IBOutlet UIButton *nextBtn;
@property (nonatomic, assign) IBOutlet UIButton *modeBtn;
@property (nonatomic, assign) IBOutlet UIButton *reset;
@property (nonatomic, assign) IBOutlet VSegmentSlider *progressSld;
@property (nonatomic, assign) IBOutlet UILabel  *curPosLbl;
@property (nonatomic, assign) IBOutlet UILabel  *durationLbl;
@property (nonatomic, assign) IBOutlet UILabel  *bubbleMsgLbl;
@property (nonatomic, assign) IBOutlet UILabel  *downloadRate;
@property (nonatomic, assign) IBOutlet UIView  	*activityCarrier;
@property (nonatomic, assign) IBOutlet UIView  	*backView;
@property (nonatomic, assign) IBOutlet UIView  	*carrier;

@property (nonatomic, copy)   NSURL *videoURL;
@property (nonatomic, retain) UIActivityIndicatorView *activityView;
@property (nonatomic, assign) BOOL progressDragging;

@end



@implementation PlayerController


#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];

	self.view.bounds = [[UIScreen mainScreen] bounds];
	self.activityView = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:
						  UIActivityIndicatorViewStyleWhiteLarge] autorelease];
	[self.activityCarrier addSubview:self.activityView];

	UITapGestureRecognizer *gr = [[[UITapGestureRecognizer alloc]
								   initWithTarget:self 
								   action:@selector(progressSliderTapped:)] autorelease];
    [self.progressSld addGestureRecognizer:gr];
    [self.progressSld setThumbImage:[UIImage imageNamed:@"pb-seek-bar-btn"] forState:UIControlStateNormal];
    [self.progressSld setMinimumTrackImage:[UIImage imageNamed:@"pb-seek-bar-fr"] forState:UIControlStateNormal];
    [self.progressSld setMaximumTrackImage:[UIImage imageNamed:@"pb-seek-bar-bg"] forState:UIControlStateNormal];

	if (!mMPayer) {
		mMPayer = [VMediaPlayer sharedInstance];
		NSString *akey = @"wn9iKq0p9JSMfWz3G78ZvtlN";
		NSString *skey = @"348b3e1ed183154034ce49decc8e1d69";
		[mMPayer setupPlayerWithCarrierView:self.carrier withDelegate:self withAppKey:akey withSecretKey:skey];
		[self setupObservers];
	}
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	[[UIApplication sharedApplication] setStatusBarHidden:YES];
	[[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
	[self becomeFirstResponder];

	[self currButtonAction:nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
	[[UIApplication sharedApplication] setStatusBarHidden:NO];
	[[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    [self resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
	[self unSetupObservers];
	[_videoURL release];
	[_activityView release];
	[mMPayer unSetupPlayer];

	[super dealloc];
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
	return UIInterfaceOrientationMaskAll;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)to duration:(NSTimeInterval)duration
{
	if (UIInterfaceOrientationIsLandscape(to)) {
		self.backView.frame = self.view.bounds;
	} else {
		self.backView.frame = kBackviewDefaultRect;
	}
	NSLog(@"NAL 1HUI &&&&&&&&& frame=%@", NSStringFromCGRect(self.carrier.frame));
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
	NSLog(@"NAL 2HUI &&&&&&&&& frame=%@", NSStringFromCGRect(self.carrier.frame));
}


#pragma mark - Respond to the Remote Control Events

- (BOOL)canBecomeFirstResponder
{
	return YES;
}

- (void)remoteControlReceivedWithEvent:(UIEvent *)event
{
	switch (event.subtype) {
		case UIEventSubtypeRemoteControlTogglePlayPause:
			if ([mMPayer isPlaying]) {
				[mMPayer pause];
			} else {
				[mMPayer start];
			}
			break;
		case UIEventSubtypeRemoteControlPlay:
			[mMPayer start];
			break;
		case UIEventSubtypeRemoteControlPause:
			[mMPayer pause];
			break;
		case UIEventSubtypeRemoteControlPreviousTrack:
			[self prevButtonAction:nil];
			break;
		case UIEventSubtypeRemoteControlNextTrack:
			[self nextButtonAction:nil];
			break;
		default:
			break;
	}
}

- (void)applicationDidEnterForeground:(NSNotification *)notification
{
	[mMPayer setVideoShown:YES];
    if (![mMPayer isPlaying]) {
		[mMPayer start];
		[self.startPause setTitle:@"Pause" forState:UIControlStateNormal];
	}
}

- (void)applicationDidEnterBackground:(NSNotification *)notification
{
    if ([mMPayer isPlaying]) {
		[mMPayer pause];
		[mMPayer setVideoShown:NO];
    }
}


#pragma mark - VMediaPlayerDelegate Implement

#pragma mark VMediaPlayerDelegate Implement / Required

- (void)mediaPlayer:(VMediaPlayer *)player didPrepared:(id)arg
{
//	[player setVideoFillMode:VMVideoFillMode100];

	mDuration = [player getDuration];
    [player start];

	[self setBtnEnableStatus:YES];
	[self stopActivity];
    mSyncSeekTimer = [NSTimer scheduledTimerWithTimeInterval:1.0/3
                                                      target:self
                                                    selector:@selector(syncUIStatus)
                                                    userInfo:nil
                                                     repeats:YES];
}

- (void)mediaPlayer:(VMediaPlayer *)player playbackComplete:(id)arg
{
	[self goBackButtonAction:nil];
}

- (void)mediaPlayer:(VMediaPlayer *)player error:(id)arg
{
	NSLog(@"NAL 1RRE &&&& VMediaPlayer Error: %@", arg);
	[self stopActivity];
//	[self showVideoLoadingError];
	[self setBtnEnableStatus:YES];
}

#pragma mark VMediaPlayerDelegate Implement / Optional

- (void)mediaPlayer:(VMediaPlayer *)player setupManagerPreference:(id)arg
{
	player.decodingSchemeHint = VMDecodingSchemeSoftware;
	player.autoSwitchDecodingScheme = NO;
}

- (void)mediaPlayer:(VMediaPlayer *)player setupPlayerPreference:(id)arg
{
	// Set buffer size, default is 1024KB(1*1024*1024).
//	[player setBufferSize:256*1024];
	[player setBufferSize:512*1024];
//	[player setAdaptiveStream:YES];

	[player setVideoQuality:VMVideoQualityHigh];

	player.useCache = YES;
	[player setCacheDirectory:[self getCacheRootDirectory]];
}

- (void)mediaPlayer:(VMediaPlayer *)player seekComplete:(id)arg
{
}

- (void)mediaPlayer:(VMediaPlayer *)player notSeekable:(id)arg
{
	self.progressDragging = NO;
	NSLog(@"NAL 1HBT &&&&&&&&&&&&&&&&.......&&&&&&&&&&&&&&&&&");
}

- (void)mediaPlayer:(VMediaPlayer *)player bufferingStart:(id)arg
{
	self.progressDragging = YES;
	NSLog(@"NAL 2HBT &&&&&&&&&&&&&&&&.......&&&&&&&&&&&&&&&&&");
	if (![Utilities isLocalMedia:self.videoURL]) {
		[player pause];
		[self.startPause setTitle:@"Start" forState:UIControlStateNormal];
		[self startActivityWithMsg:@"Buffering... 0%"];
	}
}

- (void)mediaPlayer:(VMediaPlayer *)player bufferingUpdate:(id)arg
{
	if (!self.bubbleMsgLbl.hidden) {
		self.bubbleMsgLbl.text = [NSString stringWithFormat:@"Buffering... %d%%",
								  [((NSNumber *)arg) intValue]];
	}
}

- (void)mediaPlayer:(VMediaPlayer *)player bufferingEnd:(id)arg
{
	if (![Utilities isLocalMedia:self.videoURL]) {
		[player start];
		[self.startPause setTitle:@"Pause" forState:UIControlStateNormal];
		[self stopActivity];
	}
	self.progressDragging = NO;
	NSLog(@"NAL 3HBT &&&&&&&&&&&&&&&&.......&&&&&&&&&&&&&&&&&");
}

- (void)mediaPlayer:(VMediaPlayer *)player downloadRate:(id)arg
{
	if (![Utilities isLocalMedia:self.videoURL]) {
		self.downloadRate.text = [NSString stringWithFormat:@"%dKB/s", [arg intValue]];
	} else {
		self.downloadRate.text = nil;
	}
}

- (void)mediaPlayer:(VMediaPlayer *)player videoTrackLagging:(id)arg
{
//	NSLog(@"NAL 1BGR video lagging....");
}

#pragma mark VMediaPlayerDelegate Implement / Cache

- (void)mediaPlayer:(VMediaPlayer *)player cacheNotAvailable:(id)arg
{
	NSLog(@"NAL .... media can't cache.");
	self.progressSld.segments = nil;
}

- (void)mediaPlayer:(VMediaPlayer *)player cacheStart:(id)arg
{
	NSLog(@"NAL 1GFC .... media caches index : %@", arg);
}

- (void)mediaPlayer:(VMediaPlayer *)player cacheUpdate:(id)arg
{
	NSArray *segs = (NSArray *)arg;
//	NSLog(@"NAL .... media cacheUpdate, %d, %@", segs.count, segs);
	if (mDuration > 0) {
		NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
		for (int i = 0; i < segs.count; i++) {
			float val = (float)[segs[i] longLongValue] / mDuration;
			[arr addObject:[NSNumber numberWithFloat:val]];
		}
		self.progressSld.segments = arr;
	}
}

- (void)mediaPlayer:(VMediaPlayer *)player cacheSpeed:(id)arg
{
//	NSLog(@"NAL .... media cacheSpeed: %dKB/s", [(NSNumber *)arg intValue]);
}

- (void)mediaPlayer:(VMediaPlayer *)player cacheComplete:(id)arg
{
	NSLog(@"NAL .... media cacheComplete");
	self.progressSld.segments = @[@(0.0), @(1.0)];
}


#pragma mark - Convention Methods

#define TEST_Common					1
#define TEST_setOptionsWithKeys		0
#define TEST_setDataSegmentsSource	0

-(void)quicklyPlayMovie:(NSURL*)fileURL title:(NSString*)title seekToPos:(long)pos
{
	[UIApplication sharedApplication].idleTimerDisabled = YES;
//	[self setBtnEnableStatus:NO];

	NSString *docDir = [NSString stringWithFormat:@"%@/Documents", NSHomeDirectory()];
	NSLog(@"NAL &&& Doc: %@", docDir);


//	fileURL = [NSURL URLWithString:@"http://v.17173.com/api/5981245-4.m3u8"];



#if TEST_Common // Test Common
	NSString *abs = [fileURL absoluteString];
	if ([abs rangeOfString:@"://"].length == 0) {
		NSString *docDir = [NSString stringWithFormat:@"%@/Documents", NSHomeDirectory()];
		NSString *videoUrl = [NSString stringWithFormat:@"%@/%@", docDir, abs];
		self.videoURL = [NSURL fileURLWithPath:videoUrl];
	} else {
		self.videoURL = fileURL;
	}
//    [mMPayer setDataSource:self.videoURL header:nil];
    [mMPayer setDataSource:self.videoURL];
#elif TEST_setOptionsWithKeys // Test setOptionsWithKeys:withValues:
	self.videoURL = [NSURL URLWithString:@"rtmp://videodownls.9xiu.com/9xiu/552"]; // This is a live stream.
	NSMutableArray *keys = [NSMutableArray arrayWithCapacity:0];
	NSMutableArray *vals = [NSMutableArray arrayWithCapacity:0];
	keys[0] = @"-rtmp_live";
	vals[0] = @"-1";
    [mMPayer setDataSource:self.videoURL header:nil];
	[mMPayer setOptionsWithKeys:keys withValues:vals];
#elif TEST_setDataSegmentsSource // Test setDataSegmentsSource:fileList:
	NSMutableArray *list = [NSMutableArray arrayWithCapacity:0];
	[list addObject:@"http://112.65.235.140/vlive.qqvideo.tc.qq.com/95V8NuxWX2J.p202.1.mp4?vkey=E3D97333E93EDF36E56CB85CE0B02018E1001BA5C023DFFD298C0204CD81610CFCE546C79DE6C3E2"];
	[list addObject:@"http://112.65.235.140/vlive.qqvideo.tc.qq.com/95V8NuxWX2J.p202.2.mp4?vkey=5E82F44940C19CCF26610E7E4088438E868AB2CAB5255E5FDE6763484B9B7E967EF9A97D7E54A324"];
	[list addObject:@"http://112.65.235.140/vlive.qqvideo.tc.qq.com/95V8NuxWX2J.p202.3.mp4?vkey=0A1EA30BCB057BAE8746C2D7B07FE4ABF3BD839FF011224F31F7544BFFB647F06A6D5245C57277BC"];
	[list addObject:@"http://112.65.235.140/vlive.qqvideo.tc.qq.com/95V8NuxWX2J.p202.4.mp4?vkey=DF36DC29AD2C2F0BA5A688223AFCD0008BDD681D8B060C9F4739E1A365495CD165E28DFD80E8E41C"];
	[list addObject:@"http://112.65.235.140/vlive.qqvideo.tc.qq.com/95V8NuxWX2J.p202.5.mp4?vkey=76172D18B89A91CDB803889B4C5127741EF4BBD9B90CC54269B89CEEF558B9B286DDE6083ADB8195"];
	[list addObject:@"http://112.65.235.140/vlive.qqvideo.tc.qq.com/95V8NuxWX2J.p202.6.mp4?vkey=27718B68A396DCFBC483321827604179D35F31C41EC57908C0F78D9416690F6986B0766872C2AF60"];
	[list addObject:@"http://112.65.235.140/vlive.qqvideo.tc.qq.com/95V8NuxWX2J.p202.7.mp4?vkey=B56628DD31A60E975CC9EE321DCE2FC9554AF2CE5BC2BFCEFCEEA633F27CDF16CADA9915338AB2E5"];
	[list addObject:@"http://112.65.235.140/vlive.qqvideo.tc.qq.com/95V8NuxWX2J.p202.8.mp4?vkey=40F45871CE7827699FACE57A95CA1FDA58B16A8A2523C738C422ADCBF015F50254C356614EFAFDE0"];
	[list addObject:@"http://112.65.235.140/vlive.qqvideo.tc.qq.com/95V8NuxWX2J.p202.9.mp4?vkey=553157FD5A7607CC1E255D0E26B503FAD842DC509F15D766C31446E8607E60A621F7B9FABC5B8C7D"];
	[list addObject:@"http://112.65.235.140/vlive.qqvideo.tc.qq.com/95V8NuxWX2J.p202.10.mp4?vkey=2968D15E93D1C1A295FC810DA561789487330F8BEA5B408533BF396648400A89924611724FD5BE67"];
	[list addObject:@"http://112.65.235.140/vlive.qqvideo.tc.qq.com/95V8NuxWX2J.p202.11.mp4?vkey=495CDFCAD30945947CE1E43CBD88DE32E505B4D02BD4AAB2F4B17F98EFF702485C270558951A3109"];
	[list addObject:@"http://112.65.235.140/vlive.qqvideo.tc.qq.com/95V8NuxWX2J.p202.12.mp4?vkey=01B5580A0A6F3597D66440C060885AFC7AA03CD7272D36472FBC9C261D72D2E964D254775C574CA3"];
	[list addObject:@"http://112.65.235.140/vlive.qqvideo.tc.qq.com/95V8NuxWX2J.p202.13.mp4?vkey=2256FFE5FABC971F6A0D6889A1EA1CE8E837D17929708C6ACC6F903939076BB926442DBF6F3AD309"];
	[list addObject:@"http://112.65.235.140/vlive.qqvideo.tc.qq.com/95V8NuxWX2J.p202.14.mp4?vkey=77BB2C40B9383BF048206EC357FE5F061A0A16B9242CAD207CBEA3C3C53E50B24056D93E578A400F"];
	[list addObject:@"http://112.65.235.140/vlive.qqvideo.tc.qq.com/95V8NuxWX2J.p202.15.mp4?vkey=1366F026BB6B987C82C58CF707269C091EA086BB1A09430611A6E124A419E04774FE793E11EB64C1"];
	[list addObject:@"http://112.65.235.140/vlive.qqvideo.tc.qq.com/95V8NuxWX2J.p202.16.mp4?vkey=E0F358E64365C5B12614EA74B25C4F87C7E8CD4003DCB2C792850180CF3CD7645BB22E5E57B40CC5"];
	[list addObject:@"http://112.65.235.140/vlive.qqvideo.tc.qq.com/95V8NuxWX2J.p202.17.mp4?vkey=E95EC62FAE0D92BE8A2FE85842B875F2E9B9B07616B8892D1EF18A0C645994E885D65BDAC24EF0FD"];
	[list addObject:@"http://112.65.235.140/vlive.qqvideo.tc.qq.com/95V8NuxWX2J.p202.18.mp4?vkey=48B021C886CFC23E22FA56C71C7C204E300E7D58CBB97867F23CC8F30EB4D1B53ABE41627F7D6610"];
	[list addObject:@"http://112.65.235.140/vlive.qqvideo.tc.qq.com/95V8NuxWX2J.p202.19.mp4?vkey=0D51F428BB12C2C5C015E41997371FC80338924F804D9D688C7B9560C7336A48870873F34189C58D"];
    [mMPayer setDataSegmentsSource:nil fileList:list];
#endif

    [mMPayer prepareAsync];
	[self startActivityWithMsg:@"Loading..."];
}

-(void)quicklyReplayMovie:(NSURL*)fileURL title:(NSString*)title seekToPos:(long)pos
{
    [self quicklyStopMovie];
    [self quicklyPlayMovie:fileURL title:title seekToPos:pos];
}

-(void)quicklyStopMovie
{
	[mMPayer reset];
	[mSyncSeekTimer invalidate];
	mSyncSeekTimer = nil;
	self.progressSld.value = 0.0;
	self.progressSld.segments = nil;
	self.curPosLbl.text = @"00:00:00";
	self.durationLbl.text = @"00:00:00";
	self.downloadRate.text = nil;
	mDuration = 0;
	mCurPostion = 0;
	[self stopActivity];
	[self setBtnEnableStatus:YES];
	[UIApplication sharedApplication].idleTimerDisabled = NO;
}


#pragma mark - UI Actions

#define DELEGATE_IS_READY(x) (self.delegate && [self.delegate respondsToSelector:@selector(x)])

-(IBAction)goBackButtonAction:(id)sender
{
	[self quicklyStopMovie];
	[self dismissModalViewControllerAnimated:YES];
}

-(IBAction)startPauseButtonAction:(id)sender
{
	BOOL isPlaying = [mMPayer isPlaying];
	if (isPlaying) {
		[mMPayer pause];
		[self.startPause setTitle:@"Start" forState:UIControlStateNormal];
	} else {
		[mMPayer start];
		[self.startPause setTitle:@"Pause" forState:UIControlStateNormal];
	}
}

-(void)currButtonAction:(id)sender
{
	NSURL *url = nil;
	NSString *title = nil;
	long lastPos = 0;
	if (DELEGATE_IS_READY(playCtrlGetPrevMediaTitle:lastPlayPos:)) {
		url = [self.delegate playCtrlGetCurrMediaTitle:&title lastPlayPos:&lastPos];
	}
	if (url) {
		[self quicklyPlayMovie:url title:title seekToPos:lastPos];
	} else {
		NSLog(@"WARN: No previous media url found!");
	}
}

-(IBAction)prevButtonAction:(id)sender
{
	NSURL *url = nil;
	NSString *title = nil;
	long lastPos = 0;
	if (DELEGATE_IS_READY(playCtrlGetPrevMediaTitle:lastPlayPos:)) {
		url = [self.delegate playCtrlGetPrevMediaTitle:&title lastPlayPos:&lastPos];
	}
	if (url) {
		[self quicklyReplayMovie:url title:title seekToPos:lastPos];
	} else {
		NSLog(@"WARN: No previous media url found!");
	}
}

-(IBAction)nextButtonAction:(id)sender
{
	NSURL *url = nil;
	NSString *title = nil;
	long lastPos = 0;
	if (DELEGATE_IS_READY(playCtrlGetPrevMediaTitle:lastPlayPos:)) {
		url = [self.delegate playCtrlGetNextMediaTitle:&title lastPlayPos:&lastPos];
	}
	if (url) {
		[self quicklyReplayMovie:url title:title seekToPos:lastPos];
	} else {
		NSLog(@"WARN: No previous media url found!");
	}
}

-(IBAction)switchVideoViewModeButtonAction:(id)sender
{
	static emVMVideoFillMode modes[] = {
		VMVideoFillModeFit,
		VMVideoFillMode100,
		VMVideoFillModeCrop,
		VMVideoFillModeStretch,
	};
	static int curModeIdx = 0;

	curModeIdx = (curModeIdx + 1) % (int)(sizeof(modes)/sizeof(modes[0]));
	[mMPayer setVideoFillMode:modes[curModeIdx]];
}

-(IBAction)resetButtonAction:(id)sender
{
	static int bigView = 0;

	[UIView animateWithDuration:0.3 animations:^{
		if (bigView) {
			self.backView.frame = kBackviewDefaultRect;
			bigView = 0;
		} else {
			self.backView.frame = self.view.bounds;
			bigView = 1;
		}
		NSLog(@"NAL 1NBV &&&& backview.frame=%@", NSStringFromCGRect(self.backView.frame));
	}];


//	[self quicklyStopMovie];
}

-(IBAction)progressSliderDownAction:(id)sender
{
	self.progressDragging = YES;
	NSLog(@"NAL 4HBT &&&&&&&&&&&&&&&&.......&&&&&&&&&&&&&&&&&");
	NSLog(@"NAL 1DOW &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& Touch Down");
}

-(IBAction)progressSliderUpAction:(id)sender
{
	UISlider *sld = (UISlider *)sender;
	NSLog(@"NAL 1BVC &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& seek = %ld", (long)(sld.value * mDuration));
	[self startActivityWithMsg:@"Buffering"];
	[mMPayer seekTo:(long)(sld.value * mDuration)];
}

-(IBAction)dragProgressSliderAction:(id)sender
{
	UISlider *sld = (UISlider *)sender;
	self.curPosLbl.text = [Utilities timeToHumanString:(long)(sld.value * mDuration)];
}

-(void)progressSliderTapped:(UIGestureRecognizer *)g
{
    UISlider* s = (UISlider*)g.view;
    if (s.highlighted)
        return;
    CGPoint pt = [g locationInView:s];
    CGFloat percentage = pt.x / s.bounds.size.width;
    CGFloat delta = percentage * (s.maximumValue - s.minimumValue);
    CGFloat value = s.minimumValue + delta;
    [s setValue:value animated:YES];
    long seek = percentage * mDuration;
	self.curPosLbl.text = [Utilities timeToHumanString:seek];
	NSLog(@"NAL 2BVC &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& seek = %ld", seek);
	[self startActivityWithMsg:@"Buffering"];
    [mMPayer seekTo:seek];
}


#pragma mark - Sync UI Status

-(void)syncUIStatus
{
	if (!self.progressDragging) {
		mCurPostion  = [mMPayer getCurrentPosition];
		[self.progressSld setValue:(float)mCurPostion/mDuration];
		self.curPosLbl.text = [Utilities timeToHumanString:mCurPostion];
		self.durationLbl.text = [Utilities timeToHumanString:mDuration];
	}
}


#pragma mark Others

-(void)startActivityWithMsg:(NSString *)msg
{
	self.bubbleMsgLbl.hidden = NO;
	self.bubbleMsgLbl.text = msg;
	[self.activityView startAnimating];
}

-(void)stopActivity
{
	self.bubbleMsgLbl.hidden = YES;
	self.bubbleMsgLbl.text = nil;
	[self.activityView stopAnimating];
}

-(void)setBtnEnableStatus:(BOOL)enable
{
	self.startPause.enabled = enable;
	self.prevBtn.enabled = enable;
	self.nextBtn.enabled = enable;
	self.modeBtn.enabled = enable;
}

- (void)setupObservers
{
	NSNotificationCenter *def = [NSNotificationCenter defaultCenter];
    [def addObserver:self
			selector:@selector(applicationDidEnterForeground:)
				name:UIApplicationDidBecomeActiveNotification
			  object:[UIApplication sharedApplication]];
    [def addObserver:self
			selector:@selector(applicationDidEnterBackground:)
				name:UIApplicationWillResignActiveNotification
			  object:[UIApplication sharedApplication]];
}

- (void)unSetupObservers
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)showVideoLoadingError
{
	NSString *sError = NSLocalizedString(@"Video cannot be played", @"description");
	NSString *sReason = NSLocalizedString(@"Video cannot be loaded.", @"reason");
	NSDictionary *errorDict = [NSDictionary dictionaryWithObjectsAndKeys:
							   sError, NSLocalizedDescriptionKey,
							   sReason, NSLocalizedFailureReasonErrorKey,
							   nil];
	NSError *error = [NSError errorWithDomain:@"Vitamio" code:0 userInfo:errorDict];
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[error localizedDescription]
														message:[error localizedFailureReason]
													   delegate:nil
											  cancelButtonTitle:@"OK"
											  otherButtonTitles:nil];
	[alertView show];
	[alertView release];
}

- (NSString *)getCacheRootDirectory
{
	NSString *cache = [NSString stringWithFormat:@"%@/Library/Caches/MediasCaches", NSHomeDirectory()];
    if (![[NSFileManager defaultManager] fileExistsAtPath:cache]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:cache
								  withIntermediateDirectories:YES
												   attributes:nil
														error:NULL];
    }
	return cache;
}

@end