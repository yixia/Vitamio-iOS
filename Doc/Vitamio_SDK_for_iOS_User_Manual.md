************** Vitamio SDK for iOS User Manual **************

* Version:				1.1.5
* Release date:			2013-08-05


# Description

**Vitamio SDK for iOS** is a Objective-C library for develop multimedia player on iOS
platform. It is powered by [Yixia Ltd][d1]. It provide simple, high and
convenient API for all iOS developer.

The full name of the **Vitamio SDK** zip archive is Vitamio-iOS-`version`.zip .
It contain three folder with Vitamio, Doc and Demo.

>
	- Vitamio/	This folder contain Vitamio API header files and static libraries;
	- Demo/		This folder contain one demo of show how to use this API;
	- Doc/		This folder contain documents of Vitamio API and Demo.


# Intended audience

This documents is written for software engineers who want to design or develop
iOS applications based on this API. It assumes you are an software developer,
and that you are familiar with Objective C language.


# Vitamio Quickly Start

The detail see project `Vitamio-Demo`.

## Run environment

It runs in iPhone/iPod Touch/iPad, support iOS 4.3+, support armv7/armv7s/i386.

## Create new project

Firstly, just create a new iOS project in Xcode.

## Configure

Follow `'Your target' | Build Settings | Linking | Other Linker Flags`, set
the value of Debug&Release keys to `-ObjC` .

## Add system framwork

The bellow is a system framwork list of Vitamio dependency.

>
	- AVFoundation.framwork
	- AudioToolbox.framwork
	- CoreGraphics.framwork
	- CoreMedia.framwork
	- CoreVideo.framwork
	- Foundation.framwork
	- MediaPlayer.framwork
	- OpenGLES.framwork
	- QuartzCore.framwork
	- UIKit.framwork
	- libbz2.dylib
	- libz.dylib
	- libstdc++.dylib
	- libiconv.dylib

Follow `'Your target' | Build phases | Link Binary With Libraries`, Add the
framworks or libraries show in above list to project.

## Import Vitamio SDK

Drag the header files and static libraries to project.

	- Vitamio/
		- include/
		- lib*.a

## API usage

### How to get media url

- For media have imported to application documents directory

>
```Objc
	NSString *docDir = [NSString stringWithFormat:@"%@/Documents", NSHomeDirectory()];
    NSString *videoUrl = [NSString stringWithFormat:@"%@/%@", docDir, @"demo.mkv"];
```

- For online media stream

>
```Objc
    NSString *videoUrl = @"http://meta.video.qiyi.com/242/de25dc2b5d385a8e27304d1e6dcd1a35.m3u8"
```

### Use Vitamio API play media

- Add code for support VMediaPlayerDelegate protocol

>
```Objc
	@interface PlayerController : UIViewController <VMediaPlayerDelegate>
```

- Use +sharedInstance get the player share instance, then call
  -setupPlayerWithCarrierView:withDelegate: register player.

>
```Objc
	mMPayer = [VMediaPlayer sharedInstance];
	[mMPayer setupPlayerWithCarrierView:self.view withDelegate:self];
```

- Set the media url for player, then call -prepareAsync to start prepare

>
```Objc
	self.videoURL = [NSURL URLWithString:videoUrl];
    [mMPayer setDataSource:self.videoURL header:nil];
    [mMPayer prepareAsync];
```

- Implement VMediaPlayerDelegate protocols for receive player notifications,
  e.g. `did prepared`, `playback completed`.

>
```Objc
	// This protocol method will be called when player did prepared, so we can
	// call -start in here to start playing.
	- (void)mediaPlayer:(VMediaPlayer *)player didPrepared:(id)arg
	{
		[player start];
	}
	// This protocol method will be called when playback complete, so we can
	// do something here, e.g. reset player.
	- (void)mediaPlayer:(VMediaPlayer *)player playbackComplete:(id)arg
	{
		[player reset];
	}
	// If an error occur, this protocol method will be triggered.
	- (void)mediaPlayer:(VMediaPlayer *)player error:(id)arg
	{
		NSLog(@"NAL 1RRE &&&& VMediaPlayer Error: %@", arg);
	}
```

- Use -unSetupPlayer to unregister player.

>
```Objc
	[mMPayer unSetupPlayer];
```

A simple media player have worked! Please refer demo project and
[Documents][A1] for detail about how to use Vitamio SDK.


[A1]: https://github.com/yixia/Vitamio-iOS/tree/master/Doc
[d1]: http://www.vitamio.org/en/


(end)
