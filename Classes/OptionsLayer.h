//
//  OptionsLayer.h
//  AnimalForce
//
//  Created by George Kravas on 2/21/11.
//  Copyright 2011 Protractor Games. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "StylesUtil.h"
#import "GameConfig.h"
#import "SimpleAudioEngine.h"
#import "Settings.h"

@interface OptionsLayer : CCLayer {
	CCSprite *bg;
	Label *musicLbl;
	Label *sfxLbl;
	CCMenu *menu;
	CCMenuItemSprite *musicYes;
	CCMenuItemSprite *musicNO;
	CCMenuItemSprite *sfxYes;
	CCMenuItemSprite *sfxNO;
	CCLabelBMFont *close;
	CCLabelBMFont *title;
	Settings *settings;
}

@property (nonatomic, retain) CCSprite *bg;
@property (nonatomic, retain) Label *musicLbl;
@property (nonatomic, retain) Label *sfxLbl;
@property (nonatomic, retain) CCMenu *menu;
@property (nonatomic, retain) CCMenuItemSprite *musicYes;
@property (nonatomic, retain) CCMenuItemSprite *musicNO;
@property (nonatomic, retain) CCMenuItemSprite *sfxYes;
@property (nonatomic, retain) CCMenuItemSprite *sfxNO;
@property (nonatomic, retain) CCLabelBMFont *close;
@property (nonatomic, retain) CCLabelBMFont *title;
@property (nonatomic, retain) Settings *settings;

- (void) create;
-(CCMenuItemSprite*) createButtonWithImageName:(NSString*)imageName callback:(SEL)callback;
- (void) onSwitchPressed:(id)sender;
- (void) open;
- (void) onClose;
- (void) onCloseComplete;

@end
