//
//  InGameMenu.h
//  Splitboard
//
//  Created by George Kravas on 3/26/10.
//  Copyright 2010 Protractor Games. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Button.h"
#import "Label.h"
#import "Notifications.h"
#import "StylesUtil.h"
#import "Settings.h"
#import "GameConfig.h"
#import "SimpleAudioEngine.h"

@class CCMenu;

@interface InGameMenu : CCLayer {
	CCMenuItemSprite *panel;
	Button *helpButton;
	Button *infoButton;
	Button *pauseButton;
	Button *activeMenuButton;
	Button *previousMenuButton;
	CCMenu *menu;
	NSMutableArray *inactiveMenuButtons;
	BOOL isMenuReseting;
	BOOL isMenuOpened;
	BOOL sameMenu;
	NSArray *previousSubMenu;
	NSArray *activeSubMenu;
	NSArray *beforeHFPreviousSubMenu;
	//MAIN MENU BUTTONS
	NSArray *mainMenuButtons;
	NSArray *helpMenuButtons;
	NSArray *infoMenuButtons;
	NSArray *pauseMenuButtons;
	NSArray *HFMenuButtons;
	//HELP MENU BUTTONS
	Button *swapTilesButton;
	Button *changeEmptyTileButton;
	Button *showBoardButton;
	Button *reshuffleButton;
	//PAUSE MENU
	Button *resumeButton;
	Button *optionsButton;
	Button *quitButton;
	Button *restartButton;
	//INFO MENU
	Label *timePassed;
	Label *moves;
	Button *timeIcon;
	Button *movesIcon;
	//HELPING FUNCTIONS MENU
	Button *cancelHFButton;
	Button *engageHFButton;
    int remainingTime;
}

//NOTIFICATIONS
-(void) prepareNotifications;
-(void) initMenu;
-(void) resetMenu;
-(CCMenuItemSprite*) createPanel;
-(Button*) createButtonWithImageName:(NSString*)imageName callback:(SEL)callback hasBadge:(BOOL)hasBadge;
-(Button*) createIconWithImageName:(NSString*)imageName callback:(SEL)callback;
-(Label*) createLabelWithText:(NSString*)text position:(CGPoint)position callback:(SEL)callback;
//MENU CREATION
-(void) createMainMenu;
-(void) createHelpMenu;
-(void) createPauseMenu;
-(void) createInfoMenu;
-(void) createHFMenu;
-(void) setActiveButton:(Button*)button;
-(void) setActiveSubMenu:(NSArray*)subMenu;
-(void) setActiveSubMenuEnabled:(BOOL)enabled;
-(CGPoint) getMainMenuButtonStdPosition;
//CALLBACKS
//MAIN MENU
-(void) mainMenuButtonCallback:(id)sender;
//HELPING FUNCTIONS
-(void) swapTileButtonCallback:(id)sender;
-(void) changeEmptyTileButtonCallback:(id)sender;
-(void) showBoardButtonCallback:(id)sender;
-(void) reShuffleButtonCallback:(id)sender;
//PAUSE
-(void) resumeButtonCallback:(id)sender;
-(void) optionsButtonCallback:(id)sender;
-(void) quitButtonCallback:(id)sender;
-(void) nextBoardCallback:(id)sender;
//INFO
-(void) helpingFunctionCanBeEngaged:(NSNotification *)notification;
-(void) helpingFunctionCanNotBeEngaged:(NSNotification *)notification;
-(void) updateStageTime:(NSNotification *)notification;
-(NSString*) getFormetedTime:(int)time;
-(void) updateMovesCounter:(NSNotification *)notification;
-(void) setActiveSubMenuEnabledNotification:(NSNotification *)notification;
//HELPING FUNCTIONS
-(void) showHelpingFunctionMenu;
-(void) hideHelpingFunctionMenu;
-(void) cancelHFButtonCallback:(id)sender;
-(void) engageHFButtonCallback:(id)sender;
-(void) initHFMenu;
//TWEENS
//SHOW

-(void) showSubMenuAlphaCallback:(MyDelegate*)callback;
-(void) showSubMenuAlphaComplete;
-(void) showMainMenuButtons;
-(void) showSubMenu;
-(void) showSubMenuAccordeonCallback:(MyDelegate*) callback;
-(void) showMe;
//HIDE
-(void) hideSubMenuAlphaCallback:(MyDelegate*)callback;
-(void) hideSubMenuAlphaComplete;
-(void) hideSubMenu;
-(void) hideMainMenuButtonsAndShowSubMenu:(Button*)button;
-(void) hideMainMenuButtons;
-(void) hideMainMenuButton;
-(void) hideSubMenuAccordeonCallback:(MyDelegate*) callback;
-(void) hideSubMenuAccordeonComplete;
-(void) hideMe;
@end