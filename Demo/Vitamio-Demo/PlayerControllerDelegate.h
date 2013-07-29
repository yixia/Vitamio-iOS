//
//  PlayerControllerDelegate.h
//  Vitamio-Demo
//
//  Created by erlz nuo on 7/29/13.
//  Copyright (c) 2013 yixia. All rights reserved.
//

#import <Foundation/Foundation.h>


@class PlayerController;

@protocol PlayerControllerDelegate <NSObject>

- (NSURL *)playCtrlGetCurrMediaTitle:(NSString **)title lastPlayPos:(long *)lastPlayPos;
- (NSURL *)playCtrlGetNextMediaTitle:(NSString **)title lastPlayPos:(long *)lastPlayPos;
- (NSURL *)playCtrlGetPrevMediaTitle:(NSString **)title lastPlayPos:(long *)lastPlayPos;

@end
