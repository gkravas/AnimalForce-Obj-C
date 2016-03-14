//
//  YesNoPanel.m
//  AnimalForce
//
//  Created by George Kravas on 11/25/10.
//  Copyright 2010 Protractor Games. All rights reserved.
//

#import "YesNoPanel.h"

#define YES_BUTTON_POS myp(276.5, 641.5)
#define NO_BUTTON_POS myp(444.5, 653.5)

@implementation YesNoPanel

@synthesize bg, menu, yesBtn, noBtn, closeCallBack, result, infoText;

-(id) init {
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if ( (self = [super init] )) {
		[self createMenu];
		[self createInfoText];
	}
	return self;
}

- (void) dealloc {
	[bg release];
	[menu release];
	[yesBtn release];
	[noBtn release];
	[closeCallBack release];
	[result release];
	[super dealloc];
}

- (void) createMenu {
	self.bg = [CCSprite spriteWithSpriteFrameName:@"yesNoPanel.png"];
	//self.bg.anchorPoint = ccp(0, 0);
	self.bg.position = myp(320, 480);
	[self addChild:self.bg];
	
	self.yesBtn = [self createButtonWithImageName:@"yesNoEngage" callback:@selector(buttonTapped:)];
	self.yesBtn.position = YES_BUTTON_POS;
	//[self addChild:yesBtn];
	
	self.noBtn = [self createButtonWithImageName:@"yesNoCancel" callback:@selector(buttonTapped:)];
	self.noBtn.position = NO_BUTTON_POS;
	//[self addChild:noBtn];
	
	self.menu = [CCMenu menuWithItems:yesBtn, noBtn,	nil];
	self.menu.position = ccp(0, 0);
	[self addChild:menu];
	
	self.position = ccp(0, -self.contentSize.height);
}

- (CCMenuItemSprite*) createButtonWithImageName:(NSString*)imageName callback:(SEL)callback {
	CCSprite *spriteNormal = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"%@A.png", imageName]];
	CCSprite *spriteSelected = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"%@P.png", imageName]];
	CCSprite *spriteDisabled = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"%@D.png", imageName]];
	CCMenuItemSprite *button = [CCMenuItemSprite itemFromNormalSprite:spriteNormal selectedSprite:spriteSelected disabledSprite:spriteDisabled target:self selector:callback];
	return button;
}

- (void) createInfoText {
	self.infoText = (CCLabelBMFont*)[StylesUtil createLabelWithFont:@"splashYellow" text:@" Do you\nwant to\n  quit?" position:myp(390, 420) target:nil selector:nil];
	self.infoText.color = ccc3(120, 184, 102);
	//infoText.scale = 0.8;
	self.infoText.rotation = 6;
	[self addChild:infoText];
}

- (void) initInfoText:(NSString*)text scaleText:(CGFloat)scaleText {
	[self.infoText setString:text];
	[self.infoText setScale:scaleText];
	[self.infoText runAction:[CCRepeatForever actionWithAction:[CCSequence actions:
																	 [CCFadeTo actionWithDuration:0.5 opacity:100],
																	 [CCFadeTo actionWithDuration:0.5 opacity:200],
																	 nil]]];
}

- (void) open {
	CCSequence *seq = [CCSequence actions:
					   [CCEaseOut actionWithAction:[CCMoveTo actionWithDuration:0.3 position:mypChild(0, 960)] rate:1.6],
					   [CCCallFunc actionWithTarget:self selector:@selector(panelOpened)],
					   nil];
	[self runAction:seq];
}

- (void) close {
	CCSequence *seq = [CCSequence actions:
					   [CCEaseIn actionWithAction:[CCMoveTo actionWithDuration:0.3 position:ccp(0, -self.contentSize.height)] rate:2],
					   [CCCallFunc actionWithTarget:self selector:@selector(panelClosed)],
					   nil];
	[self runAction:seq];
}

- (void) buttonTapped:(id)sender {
    if([sender isEqual:yesBtn]) {
        [NSString stringWithString:@"yes"];
        [[SimpleAudioEngine sharedEngine] playEffect:@"ok.mp3"];
    } else {
        [NSString stringWithString:@"no"];
        [[SimpleAudioEngine sharedEngine] playEffect:@"cancel.mp3"];
    }
    
	//[result retain];
	[self close];
}

- (void) panelOpened {
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

- (void) panelClosed {
	[[CCTouchDispatcher sharedDispatcher] removeDelegate:self];
	[self.infoText stopAllActions];
	
	if (closeCallBack == nil)
		return;
		
	[self.closeCallBack invokeWithParams:[NSArray arrayWithObject:result]];
	//[closeCallBack release];
	//closeCallBack = nil;
	//[result release];
	//result = nil;
}

#pragma mark Touch
- (BOOL)ccTouchBegan:(UITouch*)touch withEvent:(UIEvent *)event {
	return YES;
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {

}
@end
