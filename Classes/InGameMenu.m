//
//  InGameMenu.m
//  Splitboard
//
//  Created by George Kravas on 3/26/10.
//  Copyright 2010 Protractor Games. All rights reserved.
//

#import "InGameMenu.h"

static int const MAIN_MENU_BUTTONS_OFFSET = 10;
static int const MAIN_MENU_WIDTH = 320;
static int const BUTTON_STD_DIMENSION = 55;
static float const MENU_POP_UP_TIME = 0.15;

@implementation InGameMenu

-(id) init {
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if ( (self = [super init] )) {
		self.isTouchEnabled = YES;
		[self createMainMenu];
		[self createInfoMenu];
		[self createHelpMenu];
		[self createPauseMenu];
		[self createHFMenu];
		//menu = [CCMenu menuWithItems:panel, nil];
		menu = [CCMenu menuWithItems:timePassed, moves,
				helpButton, infoButton, pauseButton, 
				swapTilesButton, changeEmptyTileButton, showBoardButton, reshuffleButton,
				resumeButton, optionsButton, quitButton, restartButton,
				cancelHFButton, engageHFButton, timeIcon, movesIcon,				
				nil];
		[self prepareNotifications];
	}
	return self;
}
//NOTIFICATIONS
-(void) prepareNotifications {
	[Notifications addNotificationName:[Notifications helpingFunctionCanBeEngaged] object:self selector:@selector(helpingFunctionCanBeEngaged:)];
	[Notifications addNotificationName:[Notifications helpingFunctionCanNotBeEngaged] object:self selector:@selector(helpingFunctionCanNotBeEngaged:)];
	[Notifications addNotificationName:[Notifications updateStageTime] object:self selector:@selector(updateStageTime:)];
	[Notifications addNotificationName:[Notifications updateMovesCounter] object:self selector:@selector(updateMovesCounter:)];
	[Notifications addNotificationName:[Notifications setActiveSubMenuEnabled] object:self selector:@selector(setActiveSubMenuEnabledNotification:)];
}

-(void) initMenu {
	[self addChild:panel];
	[self addChild:menu];
	menu.position = myp(0, 960);
}

-(void) resetMenu {
    Settings *set = [Settings sharedInstance];
	isMenuReseting = YES;
	[self setActiveButton:infoButton];
	[self hideSubMenu];
    int timeNum = (set.isSurvival) ? SURVIVAL_TIME : [set getCurrentMinTime];
	[timePassed.label setString:[self getFormetedTime:timeNum]];
    int movesNum = (set.isSurvival) ? SURVIVAL_MOVES : [set getCurrentMaxMoves];
	[moves.label setString:[NSString stringWithFormat:@"%d", movesNum]];
    [swapTilesButton resetWithNumber:1];
    [changeEmptyTileButton resetWithNumber:1];
    [showBoardButton resetWithNumber:3];
	//[menu setIsTouchEnabled:NO];
	//menu.opacity = 1.0;
	//[self showSubMenu];
}

-(CCMenuItemSprite*) createPanel {
	CCSprite *spriteNormal = [CCSprite spriteWithSpriteFrameName:@"inGamePanel.jpg"];
	CCSprite *spriteSelected = [CCSprite spriteWithSpriteFrameName:@"inGamePanel.jpg"];
	CCMenuItemSprite *tempPanel = [CCMenuItemSprite itemFromNormalSprite:spriteNormal selectedSprite:spriteSelected];
	[tempPanel setAnchorPoint:ccp(0, 0)];
    tempPanel.position = myp(0, 960);
	[tempPanel setIsEnabled:NO];
	return tempPanel;
}
		
-(Button*) createButtonWithImageName:(NSString*)imageName callback:(SEL)callback hasBadge:(BOOL)hasBadge {
	CCSprite *spriteNormal = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"%@A.png", imageName]];
	CCSprite *spriteSelected = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"%@P.png", imageName]];
	CCSprite *spriteDisabled = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"%@D.png", imageName]];
	Button *button = [Button itemFromNormalSprite:spriteNormal selectedSprite:spriteSelected disabledSprite:spriteDisabled target:self selector:callback];
	[button setAnchorPoint:ccp(0, 0)];
	button.position = [self getMainMenuButtonStdPosition];
	[menu addChild:button z:1];
	[button setIsEnabled:NO];
    if (hasBadge)
        [button createBadgeWithNumber:2];
    else
        button.num = -1;
    
	return button;
}

-(Label*) createLabelWithText:(NSString*)text position:(CGPoint)position callback:(SEL)callback {
	Label *mLabel = [StylesUtil createLabelWithFont:@"splashYellow" text:text position:position target:nil selector:nil];
	//CCLabelBMFont *label = [CCLabelBMFont labelWithString:text fntFile:@"font.fnt"];
	//Label *mLabel= [Label itemWithLabel:label target:self selector:callback];
	//mLabel.disabledColor = ccc3(32,32,64);
	[mLabel setAnchorPoint:ccp(0, 0)];
	[menu addChild:mLabel z:1];
	[mLabel setIsEnabled:NO];
	mLabel.opacity = 0;
	mLabel.scale = 0.75;
	return mLabel;
}

-(Button*) createIconWithImageName:(NSString*)imageName callback:(SEL)callback {
	CCSprite *spriteNormal = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"%@A.png", imageName]];
	CCSprite *disabledNormal = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"%@D.png", imageName]];
	Button *button = [Button itemFromNormalSprite:spriteNormal selectedSprite:nil disabledSprite:disabledNormal target:self selector:callback];
	[button setAnchorPoint:ccp(0, 0)];
	[menu addChild:button z:1];
	[button setIsEnabled:NO];
	button.opacity = 0;
    button.num = -1;
	return button;
}

-(void) createMainMenu {
	panel = [self createPanel];
	helpButton = [self createButtonWithImageName:@"help" callback:@selector(mainMenuButtonCallback:) hasBadge:NO];
	[helpButton setAnchorPoint:ccp(0, 0)];
	infoButton = [self createButtonWithImageName:@"info" callback:@selector(mainMenuButtonCallback:) hasBadge:NO];
	[infoButton setAnchorPoint:ccp(0, 0)];
	pauseButton = [self createButtonWithImageName:@"pause" callback:@selector(mainMenuButtonCallback:) hasBadge:NO];
	[pauseButton setAnchorPoint:ccp(0, 0)];
	mainMenuButtons = [[NSArray arrayWithObjects:helpButton, infoButton, pauseButton, nil] retain];
}
-(void) createHelpMenu {
	swapTilesButton = [self createButtonWithImageName:@"swapTiles" callback:@selector(swapTileButtonCallback:) hasBadge:YES];
	changeEmptyTileButton = [self createButtonWithImageName:@"changeEmptyTile" callback:@selector(changeEmptyTileButtonCallback:) hasBadge:YES];
	showBoardButton = [self createButtonWithImageName:@"showBoard" callback:@selector(showBoardButtonCallback:) hasBadge:YES];
	reshuffleButton = [self createButtonWithImageName:@"reshuffle" callback:@selector(reShuffleButtonCallback:) hasBadge:NO];
	helpMenuButtons = [[NSArray arrayWithObjects:swapTilesButton, changeEmptyTileButton, showBoardButton, reshuffleButton, nil] retain];
}
-(void) createPauseMenu {
	resumeButton = [self createButtonWithImageName:@"resume" callback:@selector(resumeButtonCallback:) hasBadge:NO];
	optionsButton = [self createButtonWithImageName:@"options" callback:@selector(optionsButtonCallback:) hasBadge:NO];
	quitButton = [self createButtonWithImageName:@"quit" callback:@selector(quitButtonCallback:) hasBadge:NO];
	restartButton = [self createButtonWithImageName:@"nextBoard" callback:@selector(nextBoardCallback:) hasBadge:NO];
	pauseMenuButtons = [[NSArray arrayWithObjects:resumeButton, optionsButton, restartButton, quitButton , nil] retain];
}
-(void) createInfoMenu {
	timePassed = [self createLabelWithText:@"00:00" position:mypChild(130, 945) callback:nil];
	timeIcon = [self createIconWithImageName:@"timer" callback:nil];
	timeIcon.position = mypChild(2 * MAIN_MENU_BUTTONS_OFFSET, 959);
	moves = [self createLabelWithText:@"0" position:mypChild(380, 945) callback:nil];
	movesIcon = [self createIconWithImageName:@"moves" callback:nil];
	movesIcon.position = mypChild(2 * ((MAIN_MENU_WIDTH + BUTTON_STD_DIMENSION) * 0.42 - MAIN_MENU_BUTTONS_OFFSET) - 20, 959);
	infoMenuButtons = [[NSArray arrayWithObjects:timePassed, timeIcon, moves, movesIcon, nil] retain];
}
-(void) createHFMenu {
	cancelHFButton = [self createButtonWithImageName:@"cancelHF" callback:@selector(cancelHFButtonCallback:) hasBadge:NO];
	cancelHFButton.position =mypChild(2 * ((MAIN_MENU_WIDTH - BUTTON_STD_DIMENSION) * 0.42 - MAIN_MENU_BUTTONS_OFFSET), 959);
	cancelHFButton.opacity = 0;
	engageHFButton = [self createButtonWithImageName:@"engageHF" callback:@selector(engageHFButtonCallback:) hasBadge:NO];
	engageHFButton.position =mypChild(2 * ((MAIN_MENU_WIDTH + BUTTON_STD_DIMENSION) * 0.42 + MAIN_MENU_BUTTONS_OFFSET), 959);
	engageHFButton.opacity = 0;
	HFMenuButtons = [[NSArray arrayWithObjects:cancelHFButton, engageHFButton, nil] retain];
}

-(void) setActiveButton:(Button*)button {
	if (activeMenuButton == button) return;
	if (activeMenuButton != nil) {
		[activeMenuButton setIsEnabled:NO];

		[previousSubMenu release];
		previousSubMenu = [activeSubMenu retain];
		[previousMenuButton release];
		previousMenuButton = [activeMenuButton retain];
	}
	
	[activeMenuButton release];
	activeMenuButton = [button retain];

	[menu reorderChild:activeMenuButton z:100];
	[activeMenuButton setIsEnabled:(!isMenuReseting)];
	[activeSubMenu release];
	
	if (activeMenuButton == helpButton)
		activeSubMenu = [helpMenuButtons retain];
	else if (activeMenuButton == pauseButton)
		activeSubMenu = [pauseMenuButtons retain];
	else if (activeMenuButton == infoButton)
		activeSubMenu = [infoMenuButtons retain];
}

-(void) setActiveSubMenu:(NSArray*)subMenu {
	if (previousSubMenu != nil)
		[previousSubMenu release];
		previousSubMenu = [activeSubMenu retain];
	
	[activeSubMenu release];
	activeSubMenu = [subMenu retain];
}

-(void) setActiveSubMenuEnabled:(BOOL)enabled {
	NSMutableArray *arr = [NSMutableArray arrayWithArray:activeSubMenu];
	[activeMenuButton setIsEnabled:enabled];
	
	Button *menuItem;

	int numButtons = [arr count];
	
	for (int i = 0; i < numButtons; i++) {
		menuItem = [arr objectAtIndex:i];
		[menuItem setIsEnabled:enabled];
	}
}

-(CGPoint) getMainMenuButtonStdPosition {
	int stdX = 2 * (MAIN_MENU_WIDTH - BUTTON_STD_DIMENSION) - 11;
	int stdY = 960;
	return mypChild(stdX, stdY);
}

//CALLBACKS
//MAIN MENU
-(void) mainMenuButtonCallback:(id)sender {
    if ([sender isEqual:pauseButton])
        [[SimpleAudioEngine sharedEngine] playEffect:@"pause.mp3"];
	sameMenu = (activeMenuButton == sender);
	if (activeMenuButton == sender && isMenuOpened == NO) {
		activeMenuButton = sender;
		[self showMainMenuButtons];
	} else if (activeMenuButton == sender && isMenuOpened == YES) {
		[self hideMainMenuButtons];
	}else {
		//if paused is pressed the pause
		[self hideMainMenuButtonsAndShowSubMenu:sender];
	}
}
//HELPING FUNCTIONS
-(void) swapTileButtonCallback:(id)sender {
	[Notifications notifyForName:[Notifications swapTiles] object:self userInfo:nil];
	[self showHelpingFunctionMenu];
}
-(void) changeEmptyTileButtonCallback:(id)sender {
	[Notifications notifyForName:[Notifications changeEmptyTile] object:self userInfo:nil];
	[self showHelpingFunctionMenu];
}
-(void) showBoardButtonCallback:(id)sender {
    [showBoardButton decreaseBadgeNumber];
	[Notifications notifyForName:[Notifications showBoard] object:self userInfo:nil];
	[self setActiveSubMenuEnabled:NO];
}
-(void) reShuffleButtonCallback:(id)sender {
	[Notifications notifyForName:[Notifications reshuffle] object:self userInfo:nil];
	[self setActiveSubMenuEnabled:NO];
}
-(void) helpingFunctionCanBeEngaged:(NSNotification *)notification {
	[engageHFButton setIsEnabled:YES];
}
-(void) helpingFunctionCanNotBeEngaged:(NSNotification *)notification {
	[engageHFButton setIsEnabled:NO];
}

//PAUSE
-(void) notifyForPause {
	[Notifications notifyForName:[Notifications pauseGame] object:self userInfo:nil];
}
-(void) resumeButtonCallback:(id)sender {
	[Notifications notifyForName:[Notifications resumeGame] object:self userInfo:nil];
	[self setActiveButton:previousMenuButton];
	//[self setActiveSubMenu:[previousSubMenu retain]];
	//[self setActiveButton:[previousMenuButton retain]];
	//[arr release];
	[self hideSubMenu];
}
-(void) optionsButtonCallback:(id)sender {
	[Notifications notifyForName:[Notifications showOptions] object:self userInfo:nil];
}
-(void) quitButtonCallback:(id)sender {
	[Notifications notifyForName:[Notifications quitGame] object:self userInfo:nil];
}
-(void) nextBoardCallback:(id)sender {
	[Notifications notifyForName:[Notifications nextBoard] object:self userInfo:nil];
}

//INFO
-(void) updateStageTime:(NSNotification *)notification {
	NSDictionary *dict = [notification userInfo];
	int time = [[dict objectForKey:@"timePassed"] intValue];
	[timePassed.label setString:[self getFormetedTime:time]];
	
}

-(NSString*) getFormetedTime:(int)time {
	int hours, minutes, seconds;
	seconds = time % 60;
	//time -= seconds;
	minutes = time / 60 % 60;
	//time -= minutes * 60;
	hours = time / 3600 % 24;
	NSString *fTime, *fSeconds, *fMinutes, *fHours;
	fSeconds = (seconds > 9) ? [NSString stringWithFormat:@"%i", seconds] : [NSString stringWithFormat:@"0%i", seconds];
	fMinutes = (minutes > 9) ? [NSString stringWithFormat:@"%i", minutes] : [NSString stringWithFormat:@"%i", minutes];
	fHours = (hours > 9) ? [NSString stringWithFormat:@"%i", hours] : [NSString stringWithFormat:@"0%i", hours];
	if (hours == 0)
		fTime = [NSString stringWithFormat:@"%@:%@", fMinutes, fSeconds];
	else
		fTime = [NSString stringWithFormat:@"%@:%@:%@", fHours, fMinutes, fSeconds];
    
    return fTime;
}

-(void) updateMovesCounter:(NSNotification *)notification {
	NSDictionary *dict = [notification userInfo];
	NSNumberFormatter *formatter = [[NSNumberFormatter new] autorelease];
	NSString *movesCnt = [formatter stringFromNumber:[dict objectForKey:@"moves"]];
	[moves.label setString:movesCnt];
}
-(void) setActiveSubMenuEnabledNotification:(NSNotification *)notification {
	NSDictionary *dict = [notification userInfo];
	//NSNumberFormatter *formatter = [NSNumberFormatter new];
	BOOL enabled = [[dict objectForKey:@"enabled"] boolValue];
	[self setActiveSubMenuEnabled:enabled];
}

//HELPING FUNCTIONS
-(void) showHelpingFunctionMenu {
	[activeMenuButton setIsEnabled:NO];
	[self setActiveSubMenu:HFMenuButtons];
	[self hideSubMenu];//automaticly will show the new sub menu
}
-(void) hideHelpingFunctionMenu {
	[activeMenuButton setIsEnabled:YES];
	[self setActiveSubMenu:[previousSubMenu retain]];
	[self hideSubMenu];//automaticly will show the new sub menu
}
-(void) cancelHFButtonCallback:(id)sender {
    [[SimpleAudioEngine sharedEngine] playEffect:@"cancel.mp3"];
	[self hideHelpingFunctionMenu];
	[Notifications notifyForName:[Notifications cancelHelpingFunction] object:self userInfo:nil];
}
-(void) engageHFButtonCallback:(id)sender {
	[self hideHelpingFunctionMenu];
    [swapTilesButton decreaseBadgeNumber];
    [changeEmptyTileButton decreaseBadgeNumber];
	[Notifications notifyForName:[Notifications engageHelpingFunction] object:self userInfo:nil];
}
-(void) initHFMenu {
	[engageHFButton setIsEnabled:NO];
}

//END CALLBACKS

//TWEENS
//SHOW
-(void) showSubMenuAlphaCallback:(MyDelegate*)callback {
	Button *menuItem;
	int numButtons = [activeSubMenu count];
	for (int i = 0; i < numButtons; i++) {
		menuItem = [activeSubMenu objectAtIndex:i];
		if (i == 0)
			[menuItem fadeInCallback:callback];
		else
			[menuItem fadeInCallback:nil];
		
		[menuItem setIsEnabled:(!isMenuReseting)];
	}
}

-(void) showSubMenuAlphaComplete {
}

-(void) showSubMenu {
	if (activeSubMenu == infoMenuButtons || previousSubMenu == HFMenuButtons) {
		if (isMenuReseting)
			[self showSubMenuAlphaCallback:[MyDelegate initWithObj:self selector:@selector(hideMe)]];
		else
			[self showSubMenuAlphaCallback:nil];
	} else if (activeSubMenu == HFMenuButtons)
		[self showSubMenuAlphaCallback:[MyDelegate initWithObj:self selector:@selector(initHFMenu)]];
	else if (activeSubMenu == pauseMenuButtons)
		[self showSubMenuAccordeonCallback:[MyDelegate initWithObj:self selector:@selector(notifyForPause)]];
	else
		[self showSubMenuAccordeonCallback:nil];
}
-(void) showMainMenuButtons {
	isMenuOpened = YES;
	NSMutableArray *arr = [NSMutableArray arrayWithArray:mainMenuButtons];
	int index = [arr indexOfObject:activeMenuButton];
	[arr removeObjectAtIndex:index];
	
	Button *menuItem;
	CGPoint dp;
	double dur;
	int numButtons = [arr count];
	
	for (int i = 0; i < numButtons; i++) {
		menuItem = [arr objectAtIndex:i];
		dp = ccp(0, (numButtons - i) * (MAIN_MENU_BUTTONS_OFFSET + activeMenuButton.contentSize.width));
		dur = (numButtons - i) * MENU_POP_UP_TIME;
		[menuItem moveByPosition:dp duration:dur callback:nil];
		[menuItem setIsEnabled:YES];
	}
	//[helpButton setIsEnabled:![Settings sharedInstance].isSurvival];
	inactiveMenuButtons = [arr retain];
}

-(void) showSubMenuAccordeonCallback:(MyDelegate*) callback {
	Button *menuItem;
	CGPoint dp;
	double dur;
	int numButtons = [activeSubMenu count];
	for (int i = 0; i < numButtons; i++) {
		menuItem = [activeSubMenu objectAtIndex:i];
		dp = mypChild( 2 * ((i + 1) * (BUTTON_STD_DIMENSION + MAIN_MENU_BUTTONS_OFFSET) - MAIN_MENU_WIDTH), 960);
		dur = (numButtons - i)* MENU_POP_UP_TIME;
		if (i == 0)
			[menuItem moveByPosition:dp duration:dur callback:callback];
		else
			[menuItem moveByPosition:dp duration:dur callback:nil];
		[menuItem setIsEnabled:YES];
	}
}

- (void) showMe {
	for (Button *menuItem in activeSubMenu)
		[menuItem setIsEnabled:YES];
	
	for (Button *menuItem in mainMenuButtons)
		[menuItem setIsEnabled:YES];
	if (activeMenuButton == pauseButton)
		[pauseButton setIsEnabled:NO];
}

//HIDE
-(void) hideSubMenuAlphaCallback:(MyDelegate*)callback {
	int numButtons = [previousSubMenu count];
	//If no previous button, call complete
	if (numButtons == 0) {
		[self hideSubMenuAlphaComplete];
		return;
	}
	Button *menuItem;
	for (int i = 0; i < numButtons; i++) {
		menuItem = [previousSubMenu objectAtIndex:i];
		if (i == 0)
			[menuItem fadeOutCallback:callback];
		else
			[menuItem fadeOutCallback:nil];
		[menuItem setIsEnabled:NO];
	}
}

-(void) hideSubMenuAlphaComplete {
	[self showSubMenuAlphaCallback:nil];
}

-(void) hideSubMenu {
	if (previousSubMenu == infoMenuButtons || previousSubMenu == HFMenuButtons || activeSubMenu == HFMenuButtons)
		[self hideSubMenuAlphaCallback:[MyDelegate initWithObj:self selector:@selector(showSubMenu)]];
	else
		[self hideSubMenuAccordeonCallback:[MyDelegate initWithObj:self selector:@selector(showSubMenu)]];
}
-(void) hideMainMenuButtonsAndShowSubMenu:(Button*)button {
	[self setActiveButton:button];
	[self hideMainMenuButtons];
	isMenuOpened = NO;
}

-(void) hideMainMenuButtons {
	Button *menuItem;
	CGPoint dp;
	CGPoint stdPos = [self getMainMenuButtonStdPosition];
	double dur;
	int numButtons = [inactiveMenuButtons count];
	for (int i = 0; i < numButtons; i++) {
		menuItem = [inactiveMenuButtons objectAtIndex:i];
		dp = ccp(0, stdPos.y - menuItem.position.y);
		dur = abs(dp.y / (BUTTON_STD_DIMENSION + MAIN_MENU_BUTTONS_OFFSET)) * MENU_POP_UP_TIME;
		[menuItem moveByPosition:dp duration:dur callback:nil];
		[menuItem setIsEnabled:NO];
	}
	if (!sameMenu)
		[inactiveMenuButtons release];
	//
	[activeMenuButton setIsEnabled:YES];
	if (previousSubMenu != activeSubMenu && !sameMenu)
		[self hideSubMenu];
	else
		isMenuOpened = NO;
	
	//To disable pause button from being used
	if (activeMenuButton == pauseButton)
		[pauseButton setIsEnabled:NO];
}

-(void) hideMainMenuButton {
}
-(void) hideSubMenuAccordeonCallback:(MyDelegate*) callback {
	int numButtons = [previousSubMenu count];
	//If no previous button, call complete
	if (numButtons == 0) {
		[callback invokeWithParams:nil];
		return;
	}
	Button *menuItem;
	CGPoint dp;
	double dur;
	for (int i = 0; i < numButtons; i++) {
		menuItem = [previousSubMenu objectAtIndex:i];
		dp = ccp(activeMenuButton.position.x - menuItem.position.x, 0);
		dur = (numButtons - i) * MENU_POP_UP_TIME;
		if (i == 0)
			[menuItem moveByPosition:dp duration:dur callback:callback];
		else
			[menuItem moveByPosition:dp duration:dur callback:nil];
		[menuItem setIsEnabled:NO];
	}
}
-(void) hideSubMenuAccordeonComplete {
	[self showSubMenuAccordeonCallback:nil];
}
- (void) hideMe {
	isMenuReseting = NO;//Treli bakalia, alla ti na kaneis, kanonika prepei na vgei exo apo edo
	for (Button *menuItem in activeSubMenu)
		[menuItem setIsEnabled:NO];
	
	for (Button *menuItem in mainMenuButtons)
		[menuItem setIsEnabled:NO];
}
//END TWEENS

//DEALLOC
-(void) dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[super dealloc];
}
@end
