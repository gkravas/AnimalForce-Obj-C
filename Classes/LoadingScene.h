//
//  LoadingScreen.h
//  AnimalForce
//
//  Created by George Kravas on 11/7/10.
//  Copyright 2010 Protractor Games. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameConfig.h"
#import "AssetUtil.h"
#import "Notifications.h"
#import "StylesUtil.h"

@interface LoadingScene : CCScene {
	CCSprite *bg;
	CCSprite *starWing;
	CCSprite *speechBallon;
	CCSprite *cat;
	CCMenuItemLabel *title;
	CCMenuItemLabel *stageInfo;
	CCMenuItemLabel *catSpeech;
	CCMenuItemLabel *loadingText;
	CCMenuItemLabel *loading;
	CCCallFuncO *onShowAction;
}
/*
- (void) intStartAnimation;
*/
- (void) onShow;
- (void) createScene;
//- (void) createAnimatedCat;
- (void) setLevel:(int)level;
//- (CCMenuItemLabel*) createLabelWithText:(NSString*)text position:(CGPoint)position;
//- (CCMenuItemLabel*) createTextAreaWithText:(NSString*)text position:(CGPoint)position;
- (void) onLoadingCurrentProgress:(NSNumber*)current total:(NSNumber*)total;
- (void) onLoadingComplete:(NSString*)name;

@property (nonatomic, retain) CCSprite *bg;
@property (nonatomic, retain) CCSprite *starWing;
@property (nonatomic, retain) CCSprite *speechBallon;
@property (nonatomic, retain) CCSprite *cat;
@property (nonatomic, retain) CCMenuItemLabel *title;
@property (nonatomic, retain) CCMenuItemLabel *stageInfo;
@property (nonatomic, retain) CCMenuItemLabel *catSpeech;
@property (nonatomic, retain) CCMenuItemLabel *loadingText;
@property (nonatomic, retain) CCMenuItemLabel *loading;
@property (nonatomic, retain) CCCallFuncO *onShowAction;

@end
