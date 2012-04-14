//
//  Visualizer.m
//  VoiceRecorder
//
//  Created by jinhu zhang on 10-10-27.
//  Copyright 2010 no. All rights reserved.
//

#import "Visualizer.h"


@implementation Visualizer

-(id)initWithCoder:(NSCoder *)aDecoder{
	if(self = [super initWithCoder:aDecoder]){
		powers=[[NSMutableArray alloc]initWithCapacity:self.frame.size.width/2];
		
	
	}return self;
}

-(void)setPower:(float)p{
	[powers addObject:[NSNumber numberWithFloat:p]];
	while (powers.count*2>self.frame.size.width) {
		[powers removeObjectAtIndex:0];
		
	}
	if(p<minPower){
		minPower=p;
	}

}
-(void)clear{
	[powers removeAllObjects];
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context=UIGraphicsGetCurrentContext();
	CGSize size = self.frame.size;
	for(int i = 0;i<powers.count;i++){
	
		float newPower= [[powers objectAtIndex:i]floatValue];
		float height =(1-newPower/minPower)*(size.height/2);
		CGContextMoveToPoint(context,i*2,size.height/2-height);
		CGContextAddLineToPoint(context,i*2,size.height/2+height);
		CGContextSetRGBStrokeColor(context,0, 1, 0, 1);
		CGContextStrokePath(context);
		
	}
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

- (void)dealloc {
	[powers release];
    [super dealloc];
}


@end
