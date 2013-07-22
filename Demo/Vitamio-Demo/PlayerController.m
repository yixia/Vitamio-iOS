//
//  PlayerController.m
//  Vitamio-Demo
//
//  Created by erlz nuo(nuoerlz@gmail.com) on 7/8/13.
//  Copyright (c) 2013 yixia. All rights reserved.
//

#import "Utilities.h"
#import "PlayerController.h"


@interface PlayerController ()
{
    VMediaPlayer       *mMPayer;
    long               mDuration;
    long               mCurPostion;
    NSTimer            *mSyncSeekTimer;
}

@property (nonatomic, assign) IBOutlet UIButton *startPause;
@property (nonatomic, assign) IBOutlet UISlider *progressSld;
@property (nonatomic, assign) IBOutlet UILabel  *curPosLbl;
@property (nonatomic, assign) IBOutlet UILabel  *durationLbl;
@property (nonatomic, assign) IBOutlet UILabel  *bubbleMsgLbl;
@property (nonatomic, assign) IBOutlet UIView  	*activityCarrier;

@property (nonatomic, retain) UIActivityIndicatorView *activityView;

@end



@implementation PlayerController


#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];

	self.activityView = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:
						  UIActivityIndicatorViewStyleWhiteLarge] autorelease];
	[self.activityCarrier addSubview:self.activityView];
	if (!mMPayer) {
		mMPayer = [VMediaPlayer sharedInstance];
		[mMPayer setupPlayerWithCarrierView:self.view withDelegate:self];
	}
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];

	[self quicklyPlayMovie:self.videoURL title:nil seekToPos:0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
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


#pragma mark - VMediaPlayerDelegate Implement

#pragma mark VMediaPlayerDelegate Implement / Required

- (void)mediaPlayer:(VMediaPlayer *)player didPrepared:(id)arg
{
	mDuration = [player getDuration];
    [player start];

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
	[self showVideoLoadingError];
}

#pragma mark VMediaPlayerDelegate Implement / Optional

- (void)mediaPlayer:(VMediaPlayer *)player setupPlayerPreference:(id)arg
{
	// Set buffer size, default is 1024KB(1*1024*1024).
	[player setBufferSize:2*1024*1024];
}

- (void)mediaPlayer:(VMediaPlayer *)player bufferingStart:(id)arg
{
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
}


#pragma mark - Convention Methods

-(void)quicklyPlayMovie:(NSURL*)fileURL title:(NSString*)title seekToPos:(long)pos
{
	[UIApplication sharedApplication].idleTimerDisabled = YES;
	[[UIApplication sharedApplication] setStatusBarHidden:YES];

    [mMPayer setDataSource:self.videoURL header:nil];
    [mMPayer prepareAsync];
	[self startActivityWithMsg:@"Loading..."];
}

-(void)quicklyStopMovie
{
	[mMPayer reset];

	[mSyncSeekTimer invalidate];
	mSyncSeekTimer = nil;

	[UIApplication sharedApplication].idleTimerDisabled = NO;
	[[UIApplication sharedApplication] setStatusBarHidden:NO];
}


#pragma mark - UI Actions

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

-(IBAction)restartButtonAction:(id)sender
{
	[self quicklyStopMovie];
	[self quicklyPlayMovie:self.videoURL title:nil seekToPos:0];
}

-(IBAction)dragProgressSliderAction:(id)sender
{
	UISlider *sld = (UISlider *)sender;
	[mMPayer seekTo:(long)(sld.value * mDuration)];
}


#pragma mark - Sync UI Status

-(void)syncUIStatus
{
	mCurPostion  = [mMPayer getCurrentPosition];
	[self.progressSld setValue:(float)mCurPostion/mDuration];
	self.curPosLbl.text = [Utilities timeToHumanString:mCurPostion];
	self.durationLbl.text = [Utilities timeToHumanString:mDuration];
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

-(void)showVideoLoadingError
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


@end
