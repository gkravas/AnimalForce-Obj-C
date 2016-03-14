//
//  PauseLayer.m
//  AnimalForce
//
//  Created by George Kravas on 11/30/10.
//  Copyright 2010 Protractor Games. All rights reserved.
//

#import "TopBoardLayer.h"
#define CAT_ANIM_NAME @"gatos-come-on"
#define CAT_ANIM_DURATION 3.2

@implementation TopBoardLayer

@synthesize animatedCat, showAnimatedCatCompleteCB,
			hideAnimatedCatCompleteCB, hideBubbleCompleteCB, bubble, level,
			isCatAnimating, catAnimation;

// on "init" you need to initialize your instance
-(id) init {
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self = [super init] )) {
	
	}
	return self;
}

- (void) initWithLevel:(int)levelNum {
	//self.level = levelNum;
	//[self createAnimatedCat];
	[self createBubble];
}

- (void) dealloc {
	[animatedCat release]; 
	[showAnimatedCatCompleteCB release];
	[hideAnimatedCatCompleteCB release];
	[hideBubbleCompleteCB release];
	[bubble release];
	[super dealloc];
}

- (void) createAnimatedCat {
	//NSString *animName = @"gatos-come-on";
	self.animatedCat = [AssetUtil createSpriteWithAnimation:CAT_ANIM_NAME andDuration:CAT_ANIM_DURATION];
	[self addChild:animatedCat];
	self.animatedCat.position = myp(280, 480);
}

- (void) createBubble {
	[self removeChild:bubble cleanup:YES];
	self.bubble = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"bubbles%d-HD.png", level]];
	[self addChild:bubble];
	self.bubble.position = myp(320, 426);
	self.bubble.opacity = 0;
}

#pragma mark Touch
- (BOOL)ccTouchBegan:(UITouch*)touch withEvent:(UIEvent *)event {
	return YES;
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
	[self hideBubble];
}

-(void) showAnimatedCat {
	self.isCatAnimating = YES;
	[self createAnimatedCat];
}

-(void) hideAnimatedCat {
	self.isCatAnimating = NO;
	[self.animatedCat stopAllActions];
	[self removeChild:self.animatedCat cleanup:YES];
}

-(void) showBubble {
	//showBubbleCompleteCB = callback;
	CCSequence *seq = [CCSequence actions:
					   [CCFadeIn actionWithDuration:0.3],
					   [CCCallFunc actionWithTarget:self selector:@selector(showBubbleComplete)],
					   nil];
	[self.bubble runAction:seq];
}

-(void) hideBubble {
	[[CCTouchDispatcher sharedDispatcher] removeDelegate:self];
	//hideBubbleCompleteCB = callback;
	CCSequence *seq = [CCSequence actions:
					   [CCFadeOut actionWithDuration:0.3],
					   [CCCallFunc actionWithTarget:self selector:@selector(hideBubbleComplete)],
					   nil];
	[self.bubble runAction:seq];
}

-(void) showAnimatedCatComplete {
	if (self.showAnimatedCatCompleteCB == nil) return;
	[self.showAnimatedCatCompleteCB invokeWithParams:nil];
	//[showAnimatedCatCompleteCB release];
	//showAnimatedCatCompleteCB = nil;
}

-(void) hideAnimatedCatComplete {
	isCatAnimating = NO;
	if (self.hideAnimatedCatCompleteCB == nil) return;
	[self.hideAnimatedCatCompleteCB invokeWithParams:nil];
	//[hideAnimatedCatCompleteCB release];
	//hideAnimatedCatCompleteCB = nil;
}
- (void) showBubbleComplete {
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
	//if (showBubbleCompleteCB == nil) return;
	//[showBubbleCompleteCB invokeWithParams:nil];
	//[showBubbleCompleteCB release];
	//showBubbleCompleteCB = nil;
}
- (void) hideBubbleComplete {
	//if (hideBubbleCompleteCB == nil) return;
	[self.hideBubbleCompleteCB invokeWithParams:nil];
	//[hideBubbleCompleteCB release];
	//hideBubbleCompleteCB = nil;
}
@end
