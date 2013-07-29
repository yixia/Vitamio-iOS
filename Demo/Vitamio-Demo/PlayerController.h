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


@interface PlayerController : UIViewController <VMediaPlayerDelegate>

@property (nonatomic, assign) id<PlayerControllerDelegate> delegate;

@end
