//
//  SwapTiles.m
//  Splitboard
//
//  Created by George Kravas on 4/16/10.
//  Copyright 2010 Protractor Games. All rights reserved.
//

#import "SwapTiles.h"


@implementation SwapTiles
@synthesize swapTile1, swapTile2, anim1, anim2;

+(id) initWithCallbacksOnStart:(MyDelegate*)onStart onEnd:(MyDelegate*)onEnd {
	SwapTiles *o = [SwapTiles new];
	o.onStartCB = onStart;
	o.onEndCB = onEnd;
	return [o autorelease];
}

-(BOOL) validateTile:(TileSprite*)tile {
	if (self.swapTile1 == nil) {
		self.swapTile1 = tile;
		[self applyFxTile:self.swapTile1];
		//[self reApplyFxTile:swapTile2];
	} else if (self.swapTile1 == tile){
		[self removeFxTile:self.swapTile1];
		[self.swapTile1 release];
		self.swapTile1 = nil;
	} else if (self.swapTile2 == nil) {
		self.swapTile2 = [tile retain];
		[self applyFxTile:self.swapTile2];
		//[self reApplyFxTile:swapTile1];
	} else if (self.swapTile2 == tile){
		[self removeFxTile:self.swapTile2];
		[self.swapTile2 release];
		self.swapTile2 = nil;
	}
	
	if (self.swapTile1 != self.swapTile2 && self.swapTile1 != nil && self.swapTile2 != nil)
		return YES;
	else
		return	NO;
}

-(void) applyFxTile:(TileSprite*)tile {
	id anim = [self getFX];
	if ([tile isEqual:swapTile1])
		self.anim1 = anim;
	else
		self.anim2 = anim;
		 
	[tile runAction:anim];
}

-(void) reApplyFxTile:(TileSprite*)tile {
	if ([tile isEqual:self.swapTile1] && ![self.anim1 isEqual:nil]) {
		[tile stopAction:self.anim1];
		[self applyFxTile:self.swapTile1];
		return;
	} else if ([tile isEqual:self.swapTile2] && ![self.anim2 isEqual:nil]) {
		[tile stopAction:self.anim2];
		[self applyFxTile:self.swapTile2];
		return;
	}
}

-(void) resetFxTile:(TileSprite*)tile {
	id anim = [self getResetFX];
	if ([tile isEqual:self.swapTile1])
		self.anim1 = anim;
	else
		self.anim2 = anim;
	
	[tile runAction:anim];
}

-(void) removeFxTile:(TileSprite*)tile {
	if ([tile isEqual:self.swapTile1]) {
		[self.swapTile1 stopAction:self.anim1];
		[self resetFxTile:self.swapTile1];
	} else if ([tile isEqual:self.swapTile2]) {
		[self.swapTile2 stopAction:self.anim2];
		[self resetFxTile:self.swapTile2];
	}
}

-(id) getFX {
	id action = [CCScaleTo actionWithDuration:0.3 scale:0.7];
	id actionR = [CCScaleTo actionWithDuration:0.3 scale:1];
	id ease = [CCEaseBounceInOut actionWithAction:action];
	id easeR = [CCEaseBounceInOut actionWithAction:actionR];
	id repeat = [CCRepeatForever actionWithAction:[CCSequence actions:ease, easeR, nil]];
	return repeat;
}

-(id) getResetFX {
	id action = [CCScaleTo actionWithDuration:0.3 scale:1];
	id ease = [CCEaseBounceInOut actionWithAction:action];
	return ease;
}

-(id) getExecutionAnimationPosition:(CGPoint)position callback:(SEL)callback {
	CCSequence *seq;
	if (callback != nil) {
		seq = [CCSequence actions:
						   [CCScaleTo actionWithDuration:0.3 scale:0],
						   [CCMoveTo actionWithDuration:0.3 position:position],
						   [CCScaleTo actionWithDuration:0.3 scale:1],
						   [CCCallFunc actionWithTarget:self selector:callback],
						   nil];
	} else {
		seq = [CCSequence actions:
						   [CCScaleTo actionWithDuration:0.3 scale:0],
						   [CCMoveTo actionWithDuration:0.3 position:position],
						   [CCScaleTo actionWithDuration:0.3 scale:1],
						   nil];
	}

	return seq;
}

-(void) start {
	[super start];
	[self removeFxTile:self.swapTile1];
	[self removeFxTile:self.swapTile2];
	[self.swapTile1 runAction:[self getExecutionAnimationPosition:self.swapTile2.position callback:nil]];
	[self.swapTile2 runAction:[self getExecutionAnimationPosition:self.swapTile1.position callback:@selector(end)]];
}

-(void) end {
	CGPoint pos = swapTile1.currentPosition;
	self.swapTile1.currentPosition = self.swapTile2.currentPosition;
	self.swapTile2.currentPosition = pos;
	
	[self.swapTile1 release];
	self.swapTile1 = nil;
	[self.swapTile2 release];
	self.swapTile2 = nil;
	
	[super end];
}
-(void) cancel {
	[self removeFxTile:swapTile1];
	[self removeFxTile:swapTile2];
	[super end];
	[self.swapTile1 release];
	self.swapTile1 = nil;
	[self.swapTile2 release];
	self.swapTile2 = nil;
}
@end
