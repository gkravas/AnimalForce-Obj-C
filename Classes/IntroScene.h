//
//  IntroScene.h
//  AnimalForce
//
//  Created by George Kravas on 1/19/11.
//  Copyright 2011 Protractor Games. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameConfig.h"
#import "Notifications.h"
#import "AssetUtil.h"
#import "Settings.h"

@interface IntroScene : CCScene <CCTargetedTouchDelegate> {
	CCSprite *bg;
	CCSprite *part1;
	CCSprite *part2;
	CCSprite *text1;
	CCSprite *text2;
}

@property (nonatomic, assign) CCSprite *bg;
@property (nonatomic, assign) CCSprite *part1;
@property (nonatomic, assign) CCSprite *part2;
@property (nonatomic, assign) CCSprite *text1;
@property (nonatomic, assign) CCSprite *text2;

- (void) createBaseUI;
- (void) createAnimationParts;
#pragma mark Story
- (void) startStory;
- (void) stopStory;
#pragma mark Misc
-(CCMenuItemSprite*) createButtonWithImageName:(NSString*)imageName callback:(SEL)callback;
@end
