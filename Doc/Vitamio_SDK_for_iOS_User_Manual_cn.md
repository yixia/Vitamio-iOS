************** Vitamio SDK for iOS User Manual **************

* Version:				1.1.5
* Release date:			2013-08-05


# 简介

**Vitamio SDK for iOS** 是[Yixia Ltd][d1]官方推出的 iOS 平台上使用的软件开发工
具包(SDK), 为 iOS 开发者提供简单, 快捷的接口, 帮助开发者实现 iOS 平台上的媒体
播放应用.

Vitamio 完整下载包是 Vitamio-iOS-`version`.zip, 解压缩后包含 Demo, Vitamio,
Doc 三个部分, 解压后的目录结构如下所示:

>
	- Vitamio/	该目录存放 Vitamio SDK 的头文件和静态库(.a)文件.
	- Doc/		该目录存放用户手册和类参考文档.
	- Demo/		该目录主要存放1个iOS示例工程, 用于帮助开发都快速了解如何使用SDK.


# 阅读对象

本文档面向所有使用该SDK的开发人员, 测试人员等, 要求读者具有一定的iOS编程开发经
验.


# Vitamio SDK 功能说明

- 本地全媒体格式支持, 并对主流的媒体格式(mp4, avi, wmv, flv, mkv, mov, rmvb 等
  )进行优化;
- 支持广泛的流式视频格式, HLS, RTMP, HTTP Rseudo-Streaming 等;
- 性能强大, 资源CPU/内存占用率低, 充分利用 iPhone/iPod Touch/iPad 视频硬解能力;
- API 简单易用, 可扩展, 高度灵活.


# Vitamio SDK 快速入门

详细代码参见 Vitamio-Demo .

## 运行环境

Vitamio SDK for iOS 可运行于 iPhone/iPod Touch/iPad, 支持 iOS 4.3 及以上版本;
支持 armv7/armv7s/i386(模拟器).

## 新建工程

在 Xcode 中新建一个新的 iOS 工程.

## 配置Target链接参数

选择 Build Settings | Linking | Other Linker Flags, 将该选项的 Debug/Release
键都配置为 -ObjC .

## 添加依赖

Vitamio SDK 依赖的系统框架和系统库如下:

>
	- AVFoundation.framwork		音视频播放基本工具
	- AudioToolbox.framwork		音频控制API
	- CoreGraphics.framwork		轻量级2D渲染API
	- CoreMedia.framwork		音视频低级API
	- CoreVideo.framwork		视频低级API
	- Foundation.framwork		基本工具
	- MediaPlayer.framwork		系统播放器接口
	- OpenGLES.framwork			3D图形渲染API
	- QuartzCore.framwork		视频渲染输出需要
	- UIKit.framwork			界面API
	- libbz2.dylib				压缩工具
	- libz.dylib				压缩工具
	- libstdc++.dylib			C++标准库
	- libiconv.dylib			字符编码转换工具

配置 target, 在 Xcode Build Phases | Link Binary With Libraries 中添加以上所列
框架和库.

## 导入 Vitamio SDK

把 Vitamio SDK 的头文件文件夹(include)和静态库 lib*.a 拖入 Xcode 工程中.

	- Vitamio/
		- include/			该文件夹下存放所需头文件
		- lib*.a			Vitamio 所需的各个静态库

## 调用 API

### 获取播放地址

- 对于已导入到应用文档目录的媒体文件, 可以用如下方法获取其路径:

>
```Objc
	NSString *docDir = [NSString stringWithFormat:@"%@/Documents", NSHomeDirectory()];
    NSString *videoUrl = [NSString stringWithFormat:@"%@/%@", docDir, @"demo.mkv"];
```

- 对于网络视频流地址, 可直接获取, 如:

>
```Objc
    NSString *videoUrl = @"http://meta.video.qiyi.com/242/de25dc2b5d385a8e27304d1e6dcd1a35.m3u8"
```

### 播放器的简单使用流程

- 在您将要使用的Controller中声明使用 VMediaPlayerDelegate 协议

>
```Objc
	@interface PlayerController : UIViewController <VMediaPlayerDelegate>
```

- 使用类 VMediaPlayer 的类方法 +sharedInstance 获取播放器共享实例, 然后调用实例
  方法 -setupPlayerWithCarrierView:withDelegate: 来注册使用播放器.

>
```Objc
	mMPayer = [VMediaPlayer sharedInstance];
	[mMPayer setupPlayerWithCarrierView:self.view withDelegate:self];
```

- 给播放器传入要播放的视频URL, 并告知其进行播放准备

>
```Objc
	self.videoURL = [NSURL URLWithString:videoUrl];
    [mMPayer setDataSource:self.videoURL header:nil];
    [mMPayer prepareAsync];
```

- 实现 VMediaPlayerDelegate 协议, 以获得'播放器准备完成'等通知

>
```ObjC
	// 当'播放器准备完成'时, 该协议方法被调用, 我们可以在此调用 [player start]
	// 来开始音视频的播放.
	- (void)mediaPlayer:(VMediaPlayer *)player didPrepared:(id)arg
	{
		[player start];
	}
	// 当'该音视频播放完毕'时, 该协议方法被调用, 我们可以在此作一些播放器善后
	// 操作, 如: 重置播放器, 准备播放下一个音视频等
	- (void)mediaPlayer:(VMediaPlayer *)player playbackComplete:(id)arg
	{
		[player reset];
	}
	// 如果播放由于某某原因发生了错误, 导致无法正常播放, 该协议方法被调用, 参
	// 数 arg 包含了错误原因.
	- (void)mediaPlayer:(VMediaPlayer *)player error:(id)arg
	{
		NSLog(@"NAL 1RRE &&&& VMediaPlayer Error: %@", arg);
	}
```

- 当不再使用播放器时, 可以调用 -unSetupPlayer 实例方法来取消注册播放器.

>
```Objc
	[mMPayer unSetupPlayer];
```

至此, Vitamio SDK 的快速入门就结束了, 更详细的代码及注释见 Vitamio-Demo 工程,
其它 API 及协议的使用方法详见 ["Vitamio SDK for iOS 参考文档"][A1].


[A1]: https://github.com/yixia/Vitamio-iOS/tree/master/Doc
[d1]: http://www.vitamio.org/en/


(end)
