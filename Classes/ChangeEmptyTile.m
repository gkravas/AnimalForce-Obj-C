//
//  ChangeEmptyTile.m
//  Splitboard
//
//  Created by George Kravas on 4/16/10.
//  Copyright 2010 Protractor Games. All rights reserved.
//

#import "ChangeEmptyTile.h"


@implementation ChangeEmptyTile;

@synthesize newEmptyTile, boardEmptyTile, anim;

+(id) initWithCallbacksOnStart:(MyDelegate*)onStart onEnd:(MyDelegate*)onEnd {
	ChangeEmptyTile *o = [ChangeEmptyTile new];
	o.onStartCB = onStart;
	o.onEndCB = onEnd;
	return [o autorelease];
}

-(BOOL) validateTile:(TileSprite*)tile {
	if (self.newEmptyTile == nil) {
		self.newEmptyTile = tile;
		[self applyFxTile:self.newEmptyTile];
		return	YES;
	} else if (self.newEmptyTile == tile) {
		[self removeFxTile:self.newEmptyTile];
		[self.newEmptyTile release];
		self.newEmptyTile = nil;
		return	NO;
	} else if (self.newEmptyTile != tile && self.newEmptyTile != nil) {
		return	YES;
	}
	return	NO;
}

-(void) applyFxTile:(TileSprite*)tile {
	self.anim = [self getFX];
	[tile runAction:self.anim];
}

-(void) reApplyFxTile:(TileSprite*)tile {
	[tile stopAction:self.anim];
	[self applyFxTile:tile];
}

-(void) resetFxTile:(TileSprite*)tile {
	[tile runAction:[self getResetFX]];
}

-(void) removeFxTile:(TileSprite*)tile {
	[tile stopAction:anim];
    [self resetFxTile:tile];
}

-(id) getFX {
	id action = [CCFadeOut actionWithDuration:0.35];
	id actionR = [CCFadeIn actionWithDuration:0.35];
	id repeat = [CCRepeatForever actionWithAction:[CCSequence actions:action, actionR, nil]];
	return repeat;
}

-(id) getResetFX {
	return [CCFadeTo actionWithDuration:0.3 opacity:255];
}

-(id) getExecutionAnimationOpacity:(GLubyte)opacity callback:(SEL)callback {
	CCSequence *seq;
	if (callback != nil) {
		seq = [CCSequence actions:
						   [CCFadeTo actionWithDuration:0.3 opacity:opacity],
						   [CCCallFunc actionWithTarget:self selector:callback],
						   nil];
	} else {
		seq = [CCSequence actions:
						   [CCFadeTo actionWithDuration:0.3 opacity:opacity],
						   nil];
	}

	return seq;
}

-(void) start {
	[super start];
	[self removeFxTile:newEmptyTile];
	[self.newEmptyTile runAction:[self getExecutionAnimationOpacity:0 callback:nil]];
	[self.boardEmptyTile runAction:[self getExecutionAnimationOpacity:255 callback:@selector(end)]];
}
-(void) end {
	[super end];
	[self.newEmptyTile.parent reorderChild:newEmptyTile z:0];
	[self.newEmptyTile release];
	self.newEmptyTile = nil;
}
-(void) cancel {
	[self removeFxTile:self.newEmptyTile];
	[self.newEmptyTile release];
	self.newEmptyTile = nil;
}
@end
