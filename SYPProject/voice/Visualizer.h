//
//  Visualizer.h
//  VoiceRecorder
//
//  Created by jinhu zhang on 10-10-27.
//  Copyright 2010 no. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface Visualizer : UIView {
	NSMutableArray *powers;
	float minPower;
}
-(void)setPower:(float)p;
-(void)clear;
@end
