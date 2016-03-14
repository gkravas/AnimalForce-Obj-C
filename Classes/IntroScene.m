//
//  IntroScene.m
//  AnimalForce
//
//  Created by George Kravas on 1/19/11.
//  Copyright 2011 Protractor Games. All rights reserved.
//

#import "IntroScene.h"
#define INTRO_POS myp(320, 370)
#define TEXT_POS myp(320, 820)

@implementation IntroScene

@synthesize bg, part1, part2, text1, text2;

// on "init" you need to initialize your instance
-(id) init {
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self = [super init] )) {
		[self createBaseUI];
		[self createAnimationParts];
	}
	return self;
}

- (void) dealloc {
	[super dealloc];
}

-(void) onEnterTransitionDidFinish {
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
	[self startStory];
	[super onEnterTransitionDidFinish];
}


-(void) onExit {
	[[CCTouchDispatcher sharedDispatcher] removeDelegate:self];
	[super onExit];
	//[self removeChild:part1 cleanup:YES];
	//[self removeChild:part2 cleanup:YES];
}


#pragma mark Creation
- (void) createBaseUI {
	bg = [CCSprite spriteWithSpriteFrameName:@"introBG.png"];
	bg.position = myp(320, 480);
	[self addChild:bg];
	
	text1 = [CCSprite spriteWithSpriteFrameName:@"introText1.png"];
	text1.position = TEXT_POS;
	[self addChild:text1];
	text2 = [CCSprite spriteWithSpriteFrameName:@"introText2.png"];
	text2.position = TEXT_POS;
	text2.opacity = 0;
	[self addChild:text2];
}

- (void) createAnimationParts {
	part1 = [CCSprite spriteWithSpriteFrameName:@"intro1_1.jpg"];
	part1.position = INTRO_POS;
	[self addChild:part1];
	
	part2 = [CCSprite spriteWithSpriteFrameName:@"intro2_1.jpg"];
	part2.position = INTRO_POS;
	[self addChild:part2];
	part2.opacity = 0;
}

#pragma mark Story
- (void) startStory {
	CCSequence *seq1 = [CCSequence actions:
						[CCDelayTime actionWithDuration:4.5],
						[CCFadeOut actionWithDuration:1.0],
						nil];
	[part1 runAction:seq1];
	CCSequence *seqText1 = [CCSequence actions:
						[CCDelayTime actionWithDuration:4.5],
						[CCFadeOut actionWithDuration:1.0],
						nil];
	[text1 runAction:seqText1];
	
	CCSequence *seq2 = [CCSequence actions:
						[CCDelayTime actionWithDuration:5.0],
						[CCFadeIn actionWithDuration:1.0],
						nil];
	[part2 runAction:seq2];
	CCSequence *seqText2 = [CCSequence actions:
						[CCDelayTime actionWithDuration:5.0],
						[CCFadeIn actionWithDuration:1.0],
						nil];
	[text2 runAction:seqText2];
	
	[self runAction:[CCSequence actions:
					 [CCDelayTime actionWithDuration:10.0],
					 [CCCallFunc actionWithTarget:self selector:@selector(stopStory)],
					 nil]];
}

- (void) stopStory {
	[self stopAllActions];
	
	Settings *settings = [Settings sharedInstance];
	settings.showIntro = NO;
	[settings saveUserData];
	
	NSDictionary *dic = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"ShowSplash", nil]
													forKeys:[NSArray arrayWithObjects:@"name", nil]];
	[Notifications notifyForName:[Notifications signalCommand] object:self userInfo:dic];
}

#pragma mark Misc
-(CCMenuItemSprite*) createButtonWithImageName:(NSString*)imageName callback:(SEL)callback {
	CCSprite *spriteNormal = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"%@A.png", imageName]];
	CCSprite *spriteSelected = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"%@P.png", imageName]];
	//CCSprite *spriteDisabled = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"%@D.png", imageName]];
	CCMenuItemSprite *button = [CCMenuItemSprite itemFromNormalSprite:spriteNormal selectedSprite:spriteSelected disabledSprite:nil target:self selector:callback];
	[button setAnchorPoint:ccp(0, 0)];
	return button;
}

#pragma mark Touch
- (BOOL)ccTouchBegan:(UITouch*)touch withEvent:(UIEvent *)event
{
	return YES;
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
	Settings *settings = [Settings sharedInstance];
	if (settings.showIntro)
		return;
	
	[self stopStory];
}
@end
