//
//  Button.m
//  Splitboard
//
//  Created by George Kravas on 4/13/10.
//  Copyright 2010 Protractor Games. All rights reserved.
//

#import "Button.h"


@implementation Button

@synthesize showCompleteCB, hideCompleteCB, moveByCompleteCB, badge, badgeNum, num;

-(void) resetWithNumber:(int)number {
    [badge setVisible:YES];
    badge.opacity = 0;
    badgeNum.opacity = 0;
    num = number;
    [self setBadgeNumber:num];
}

-(void) createBadgeWithNumber:(int)number {
    badge = [CCSprite spriteWithSpriteFrameName:@"badge.png"];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        badge.position = ccp(24, 20);
    else
        badge.position = ccp(12, 10);
    
    [self addChild:badge];
    
    CGPoint pos = ccp(badge.textureRect.size.width * 0.5 + 0.5, badge.textureRect.size.height * 0.5 - 1);
    badgeNum = [StylesUtil createLabelWithFont:@"impact" text:@"" position:pos target:nil selector:nil];
    badgeNum.scale = 0.35;
    [badgeNum setColor:ccc3(0,0,0)];
    [badge addChild:badgeNum];
    
    num = number;
    [self setBadgeNumber:num];
    badge.opacity = 0;
    badgeNum.opacity = 0;
}

-(void) setBadgeNumber:(int)number {
    if (badge == nil)
        return;
    if (number > 0)
        [badgeNum setString:[NSString stringWithFormat:@"%d", number]];
    else {
        [badge runAction:[CCSequence actions:
                          [CCFadeOut actionWithDuration:0.2],
                          [CCCallFunc actionWithTarget:self selector:@selector(hideBadgeComplete)],
                          nil]];
        [badgeNum runAction:[CCFadeOut actionWithDuration:0.2]];
    }
}

-(void) decreaseBadgeNumber {
    num--;
    [self setBadgeNumber:num];
}

-(void) setIsEnabled: (BOOL)enabled {
    if (num == 0)
        [super setIsEnabled:NO];
    else {
        [super setIsEnabled:enabled];
        if (enabled) {
            [badge runAction:[CCFadeIn actionWithDuration:0.2]];
            [badgeNum runAction:[CCFadeIn actionWithDuration:0.2]];
        } else {
            [badge runAction:[CCFadeOut actionWithDuration:0.2]];
            [badgeNum runAction:[CCFadeOut actionWithDuration:0.2]];
        }
    }
}

-(void) moveByPosition:(CGPoint)position duration:(double)duration callback:(MyDelegate*)callback {
	self.moveByCompleteCB = callback;
    if (badge.opacity == 255) {
        [badge runAction:[CCFadeOut actionWithDuration:0.2]];
        [badgeNum runAction:[CCFadeOut actionWithDuration:0.2]];
    }
	CCSequence *seq = [CCSequence actions:
					   [CCMoveBy actionWithDuration:duration position:position],
					   [CCCallFunc actionWithTarget:self selector:@selector(moveByComplete)],
					   nil];
	[self runAction:seq];
}
-(void) fadeOutCallback:(MyDelegate*)callback {
	self.hideCompleteCB = callback;
    [badge runAction:[CCFadeOut actionWithDuration:0.2]];
    [badgeNum runAction:[CCFadeOut actionWithDuration:0.2]];
	CCSequence *seq = [CCSequence actions:
					   [CCFadeOut actionWithDuration:0.2],
					   [CCCallFunc actionWithTarget:self selector:@selector(hideComplete)],
					   nil];
	[self runAction:seq];
}
-(void) fadeInCallback:(MyDelegate*)callback {
	self.showCompleteCB = callback;
    [badge runAction:[CCFadeIn actionWithDuration:0.2]];
    [badgeNum runAction:[CCFadeIn actionWithDuration:0.2]];
	CCSequence *seq = [CCSequence actions:
					   [CCFadeIn actionWithDuration:0.2],
					   [CCCallFunc actionWithTarget:self selector:@selector(showComplete)],
					   nil];
	[self runAction:seq];
}

-(void) moveByComplete {
    if (badge.opacity == 0) {
        CCSequence *seq1 = [CCSequence actions:
                           [CCDelayTime actionWithDuration:0.2],
                           [CCFadeIn actionWithDuration:0.2],
                           nil];
        CCSequence *seq2 = [seq1 copy];
        [badge runAction:seq1];
        [badgeNum runAction:seq2];
    }
    if(self.moveByCompleteCB == nil) return;
	[self.moveByCompleteCB invokeWithParams:nil];
	//[self.moveByCompleteCB release];
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
-(void) hideBadgeComplete {
	[badge setVisible:NO];
}
@end
