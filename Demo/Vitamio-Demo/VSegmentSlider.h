//
//  VSegmentSlider.h
//  VPlayer
//
//  Created by erlz nuo on 6/26/13.
//
//

#import <UIKit/UIKit.h>

@interface VSegmentSlider : UISlider
{
	NSArray *_segments;
}

@property (atomic, retain) NSArray *segments;

@end
