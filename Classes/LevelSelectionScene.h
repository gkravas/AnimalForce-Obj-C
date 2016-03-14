//
//  LevelSelectionScene.h
//  AnimalForce
//
//  Created by George Kravas on 12/5/10.
//  Copyright 2010 Protractor Games. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameConfig.h"
#import "Button.h"
#import "AssetUtil.h"
#import "Settings.h"
#import "Notifications.h"
#import "StylesUtil.h"
#import "SimpleAudioEngine.h"

@interface LevelSelectionScene : CCScene {
	CCSprite *bg;
	CCMenu *menu;
	Button *level1;
	Button *level2;
	Button *level3;
	Button *level4;
	Button *level5;
	Button *level6;
	Button *level7;
	Button *level8;
	Button *level9;
	Button *level10;
	Button *level11;
	Button *level12;
	Button *level13;
	Button *level14;
	CCMenuItemLabel *selectStage;
}

- (void) createBG;
- (void) createButtons;

- (Button*) createButtonForLevel:(int)level;
- (CGPoint) getLevelButtonPositionFromIndex:(int)index;
- (void) levelSelected:(id)sender;
- (void) markAvailableLevels;

@property (nonatomic, retain) CCSprite *bg;
@property (nonatomic, retain) CCMenu *menu;
@property (nonatomic, retain) Button *level1;
@property (nonatomic, retain) Button *level2;
@property (nonatomic, retain) Button *level3;
@property (nonatomic, retain) Button *level4;
@property (nonatomic, retain) Button *level5;
@property (nonatomic, retain) Button *level6;
@property (nonatomic, retain) Button *level7;
@property (nonatomic, retain) Button *level8;
@property (nonatomic, retain) Button *level9;
@property (nonatomic, retain) Button *level10;
@property (nonatomic, retain) Button *level11;
@property (nonatomic, retain) Button *level12;
@property (nonatomic, retain) Button *level13;
@property (nonatomic, retain) Button *level14;
@property (nonatomic, retain) CCMenuItemLabel *selectStage;
@end
