//
//  PauseLayer.h
//  AnimalForce
//
//  Created by George Kravas on 11/30/10.
//  Copyright 2010 Protractor Games. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "AssetUtil.h"
#import "MyDelegate.h"
#import "GameConfig.h"

@interface TopBoardLayer : CCLayer {
	CCSprite *animatedCat;
	CCSprite *bubble;
	CCAnimation *catAnimation;
	MyDelegate *showAnimatedCatCompleteCB;
	MyDelegate *hideAnimatedCatCompleteCB;
	MyDelegate *hideBubbleCompleteCB;
	int level;
	BOOL isCatAnimating;
}

@property (nonatomic, retain) CCSprite *animatedCat;
@property (nonatomic, retain) CCSprite *bubble;
@property (nonatomic, retain) MyDelegate *showAnimatedCatCompleteCB;
@property (nonatomic, retain) MyDelegate *hideAnimatedCatCompleteCB;
//@property (nonatomic, retain) MyDelegate *showBubbleCompleteCB;
@property (nonatomic, retain) MyDelegate *hideBubbleCompleteCB;
@property (nonatomic, retain) CCAnimation *catAnimation;
@property int level;
@property BOOL isCatAnimating;

- (void) initWithLevel:(int)levelNum;
- (void) createAnimatedCat;
- (void) createBubble;
- (void) showAnimatedCat;
- (void) hideAnimatedCat;
- (void) showBubble;
- (void) hideBubble;
- (void) showAnimatedCatComplete;
- (void) hideAnimatedCatComplete;
- (void) showBubbleComplete;
- (void) hideBubbleComplete;

@end
