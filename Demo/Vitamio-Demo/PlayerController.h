//
//  PlayerController.h
//  Vitamio-Demo
//
//  Created by erlz nuo on 7/8/13.
//  Copyright (c) 2013 yixia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Vitamio.h"


@interface PlayerController : UIViewController <VMediaPlayerDelegate>

@property (nonatomic, copy)   NSURL *videoURL;

@end
