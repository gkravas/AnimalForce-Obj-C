//
//  SplashScreenScene.h
//  BattleAnimals
//
//  Created by George Kravas on 10/28/10.
//  Copyright 2010 Protractor Games. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameConfig.h"
#import "AssetUtil.h"
#import "Notifications.h"
#import "Label.h"
#import "StylesUtil.h"
#import "Settings.h"
#import "OptionsLayer.h"
#import "CDXPropertyModifierAction.h"

@interface SplashScene : CCScene <UIAlertViewDelegate> {
	CCSprite *bg;
	CCSprite *bgStatic;
	CCSprite *starWing;
	CCSprite *starWingGlance;
	CCSprite *title;
	CCMenu *menu;
	CCMenuItemLabel *newGameBtn;
	CCMenuItemLabel *survivalModeBtn;
	CCMenuItemLabel *optionsBtn;
	CCMenuItemLabel *creditsBtn;
	CCMenuItemLabel *continueBtn;
	OptionsLayer *optionsLayer;
}

- (void) startAnimation;
#pragma mark Scene creation
- (void) createBGStatic;
- (void) createBG;
- (void) createWingStarAndTitle;
- (void) createWingStarGlance;
- (void) createButtons;
- (void) createOptions;
- (CCMenuItemLabel*) createOrangeButtonWithText:(NSString*)text position:(CGPoint)position selector:(SEL)selector;
- (CCMenuItemLabel*) createYellowButtonWithText:(NSString*)text position:(CGPoint)position selector:(SEL)selector;
#pragma mark UI Events
- (void) newGame:(id)sender;
- (void) newGameEX;
- (void) survivalGame:(id)sender;
- (void) options:(id)sender;
- (void) optionsClosed;
- (void) continueGame:(id)sender;
- (void) credits:(id)sender;

@property (nonatomic, retain) CCSprite *bg;
@property (nonatomic, retain) CCSprite *bgStatic;
@property (nonatomic, retain) CCSprite *starWing;
@property (nonatomic, retain) CCSprite *starWingGlance;
@property (nonatomic, retain) CCSprite *title;
@property (nonatomic, retain) CCMenu *menu;
@property (nonatomic, retain) CCMenuItemLabel *newGameBtn;
@property (nonatomic, retain) CCMenuItemLabel *survivalModeBtn;
@property (nonatomic, retain) CCMenuItemLabel *optionsBtn;
@property (nonatomic, retain) CCMenuItemLabel *creditsBtn;
@property (nonatomic, retain) CCMenuItemLabel *continueBtn;
@property (nonatomic, retain) OptionsLayer *optionsLayer;

@end
