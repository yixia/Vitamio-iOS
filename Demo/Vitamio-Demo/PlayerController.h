//
//  PlayerController.h
//  Vitamio-Demo
//
//  Created by erlz nuo on 7/8/13.
//  Copyright (c) 2013 yixia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Vitamio.h"
#import "PlayerControllerDelegate.h"


#define kBackviewDefaultRect		CGRectMake(20, 47, 280, 180)


@interface PlayerController : UIViewController <VMediaPlayerDelegate>

@property (nonatomic, assign) id<PlayerControllerDelegate> delegate;

@end
