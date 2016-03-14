//
//  Label.m
//  Splitboard
//
//  Created by George Kravas on 4/20/10.
//  Copyright 2010 Protractor Games. All rights reserved.
//

#import "Label.h"


@implementation Label

@synthesize hideCompleteCB, showCompleteCB;

-(void) fadeOutCallback:(MyDelegate*)callback {
	self.hideCompleteCB = callback;
	CCSequence *seq = [CCSequence actions:
					   [CCFadeOut actionWithDuration:0.2],
					   [CCCallFunc actionWithTarget:self selector:@selector(hideComplete)],
					   nil];
	[self runAction:seq];
}
-(void) fadeInCallback:(MyDelegate*)callback {
	self.showCompleteCB = callback;
	CCSequence *seq = [CCSequence actions:
					   [CCFadeIn actionWithDuration:0.2],
					   [CCCallFunc actionWithTarget:self selector:@selector(showComplete)],
					   nil];
	[self runAction:seq];
}

-(void) showComplete {
	if(self.showCompleteCB == nil) return;
	[self.showCompleteCB invokeWithParams:nil];
	//[self.showCompleteCB release];
}
-(void) hideComplete {
	if(self.hideCompleteCB == nil) return;
	[self.hideCompleteCB invokeWithParams:nil];
	//[self.hideCompleteCB release];
}

@end
