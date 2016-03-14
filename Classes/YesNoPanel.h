//
//  YesNoPanel.h
//  AnimalForce
//
//  Created by George Kravas on 11/25/10.
//  Copyright 2010 Protractor Games. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameConfig.h"
#import "MyDelegate.h"
#import "StylesUtil.h"
#import "SimpleAudioEngine.h"

@interface YesNoPanel : CCLayer {
	CCSprite *bg;
	CCMenu *menu;
	CCMenuItemSprite *yesBtn;
	CCMenuItemSprite *noBtn;
	MyDelegate *closeCallBack;
	NSString *result;
	CCLabelBMFont *infoText;
}

@property(nonatomic, retain) CCSprite *bg;
@property(nonatomic, retain) CCMenu *menu;
@property(nonatomic, retain) CCMenuItemSprite *yesBtn;
@property(nonatomic, retain) CCMenuItemSprite *noBtn;
@property(nonatomic, retain) MyDelegate *closeCallBack;
@property(nonatomic, retain) NSString *result;
@property(nonatomic, retain) CCLabelBMFont *infoText;

- (void) createMenu;
- (CCMenuItemSprite*) createButtonWithImageName:(NSString*)imageName callback:(SEL)callback;
- (void) createInfoText;
- (void) open;
- (void) close;
- (void) panelOpened;
- (void) panelClosed;
- (void) buttonTapped:(id)sender;
- (void) initInfoText:(NSString*)text scaleText:(CGFloat)scaleText;

@end
