//
//  SplashScreenScene.m
//  BattleAnimals
//
//  Created by George Kravas on 10/28/10.
//  Copyright 2010 Protractor Games. All rights reserved.
//

#import "SplashScene.h"

#define SPLASH_BG @"splashBG"
#define STAR_WING_POS myp(321.50, 45.50)
#define NEW_GAME_POS myp(318.21, 376.92)
#define SURVIVAL_MODE_POS myp(318.15, 509.52)
#define OPTIONS_POS myp(319.49, 632.78)
#define CREDITS_POS myp(319.49, 759.60)
#define CONTINUE_POS myp(324.67, 873.32)
#define TITLE_POS myp(319.50, 182.10)

@implementation SplashScene

@synthesize bg, bgStatic, starWing, starWingGlance, title, menu, newGameBtn, survivalModeBtn, optionsBtn, creditsBtn, continueBtn, optionsLayer;

// on "init" you need to initialize your instance
-(id) init {
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self = [super init] )) {
		//[AssetUtil createAnimationWithName:@"splashBG" atlasName:@"splashBGAtlas" sheets:3 framesInSheets:6 frameType:@"jpg" andDelay:ANIMATION_DELAY];
		[self createBGStatic];
		[self createWingStarAndTitle];
		[self createButtons];
		[self createOptions];
	}
	return self;
}

- (void) dealloc {
	[bg release];
	[starWing release];
	[starWingGlance release];
	[title release];
	[menu release];
	[newGameBtn release];
	[survivalModeBtn release];
	[optionsBtn release];
	[creditsBtn release];
	[continueBtn release];
	[optionsLayer release];
	[super dealloc];
}
/*
-(void) onEnterTransitionDidFinish {
	[self startAnimation];
}
*/
-(void) onExit {
	[self removeChild:bg cleanup:YES];
	//[self removeChild:starWing cleanup:YES];
	[self removeChild:starWingGlance cleanup:YES];
	//[self removeChild:title cleanup:YES];
	[self removeChild:menu cleanup:YES];
	[self removeChild:optionsLayer cleanup:YES];
	[AssetUtil unloadSpritePack:@"splashBGAtlas" sheets:3];
}

- (void) startAnimation {
	//SimpleAudioEngine *sae = [SimpleAudioEngine sharedEngine];
	//if (![sae isBackgroundMusicPlaying]) {
	//	[sae setBackgroundMusicVolume:1.0f];
	//	[sae rewindBackgroundMusic];
	//	[sae playBackgroundMusic:@"intro.aac"];
	//}
	[self unschedule:@selector(startAnimation)];
	[self createBG];
	[self reorderChild:starWing z:1];
	[self reorderChild:title z:1];
	[self addChild:menu];
	[self createWingStarGlance];
	[self addChild:optionsLayer z:100];
	[continueBtn setIsEnabled:([Settings sharedInstance].maxLevelReached > 1)];
    [[CCTextureCache sharedTextureCache] removeUnusedTextures];
}

//#==================================================================================================================================
#pragma mark Scene creation
- (void) createBGStatic {
	bgStatic = [CCSprite spriteWithSpriteFrameName:@"splashBG1-HD.jpg"];
	bgStatic.position = myp(320, 480);
	[self addChild:bgStatic];
}

- (void) createBG {
	bg = [AssetUtil createSpriteWithAnimation:SPLASH_BG andDuration:1.3];
	bg.position = myp(320, 480);
	[self addChild:bg];
}

- (void) createWingStarAndTitle {
	starWing = [CCSprite spriteWithSpriteFrameName:@"starWing-HD.png"];
	starWing.position = STAR_WING_POS;
	[self addChild:starWing];
	
	title = [CCSprite spriteWithSpriteFrameName:@"splashTitle-HD.png"];
	title.position = TITLE_POS;
	[self addChild:title];
}

- (void) createWingStarGlance {
	starWingGlance = [AssetUtil createSpriteWithAnimation:@"starWingGlance" andDuration:1.5];
	starWingGlance.position = STAR_WING_POS;
	[self addChild:starWingGlance z:100];
}

- (void) createButtons {
	menu = [[CCMenu menuWithItems: newGameBtn, survivalModeBtn, optionsBtn, creditsBtn, continueBtn, nil] retain];
	menu.position = mypChild(0, 960);
	//[self addChild:menu];
	
	newGameBtn = [self createOrangeButtonWithText:@"new game" position:NEW_GAME_POS selector:@selector(newGame:)];
	survivalModeBtn = [self createYellowButtonWithText:@"survival mode" position:SURVIVAL_MODE_POS selector:@selector(survivalGame:)];
	optionsBtn = [self createOrangeButtonWithText:@"options" position:OPTIONS_POS selector:@selector(options:)];
	creditsBtn = [self createYellowButtonWithText:@"credits" position:CREDITS_POS selector:@selector(credits:)];
	continueBtn = [self createOrangeButtonWithText:@"continue" position:CONTINUE_POS selector:@selector(continueGame:)];
}

- (void) createOptions {
	optionsLayer = [[OptionsLayer node] retain];
	//[self addChild:optionsLayer];
	optionsLayer.scale = 0;
}

- (CCMenuItemLabel*) createOrangeButtonWithText:(NSString*)text position:(CGPoint)position selector:(SEL)selector {
	Label *mLabel = [StylesUtil createLabelWithFont:@"splashOrange" text:text position:position target:self selector:selector];
	[menu addChild:mLabel z:1];
	return mLabel;
}

- (CCMenuItemLabel*) createYellowButtonWithText:(NSString*)text position:(CGPoint)position selector:(SEL)selector {
	Label *mLabel = [StylesUtil createLabelWithFont:@"splashYellow" text:text position:position target:self selector:selector];
	[menu addChild:mLabel z:1];
	return mLabel;
}

//#======================================================================================================================================================
#pragma mark UI Events
- (void) newGame:(id)sender {
    [[SimpleAudioEngine sharedEngine] playEffect:@"selection.mp3"];
	if ([Settings sharedInstance].maxLevelReached == 1) {
		[self newGameEX];
		return;
	}
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
													message:@"Your unlocked levels will be erased.\nDo you want to continue?"
												   delegate:self cancelButtonTitle:@"No" 
										  otherButtonTitles:@"Yes",  nil];
	[alert show];
	[alert release];
}

- (void) newGameEX {
	[CDXPropertyModifierAction fadeBackgroundMusic:1.0f finalVolume:0.0f curveType:kIT_Exponential shouldStop:YES];
	NSDictionary *dic = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"NewGameCommand", [NSArray arrayWithObject:[NSNumber numberWithBool:YES]], nil]
													forKeys:[NSArray arrayWithObjects:@"name", @"params", nil]];
	[Notifications notifyForName:[Notifications signalCommand] object:self userInfo:dic];
}

- (void) survivalGame:(id)sender {
    [[SimpleAudioEngine sharedEngine] playEffect:@"selection.mp3"];
	[CDXPropertyModifierAction fadeBackgroundMusic:1.0f finalVolume:0.0f curveType:kIT_Exponential shouldStop:YES];
	[[Settings sharedInstance] startSurvivalMode];
	NSNumber *level = [[Settings sharedInstance] getNextSurvivalLevel];
	NSDictionary *dic = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"BoardLoadingCommand", [NSArray arrayWithObject:level], nil]
													forKeys:[NSArray arrayWithObjects:@"name", @"params", nil]];
	[Notifications notifyForName:[Notifications signalCommand] object:self userInfo:dic];
}

- (void) options:(id)sender {
    [[SimpleAudioEngine sharedEngine] playEffect:@"selection.mp3"];
	menu.isTouchEnabled = NO;
	optionsLayer.isTouchEnabled = YES;
	[optionsLayer open];
}
- (void) optionsClosed {
	menu.isTouchEnabled = YES;
	optionsLayer.isTouchEnabled = NO;
}

- (void) continueGame:(id)sender {
    [[SimpleAudioEngine sharedEngine] playEffect:@"selection.mp3"];
	[CDXPropertyModifierAction fadeBackgroundMusic:1.0f finalVolume:0.0f curveType:kIT_Exponential shouldStop:YES];
	NSDictionary *dic = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"NewGameCommand", [NSArray arrayWithObject:[NSNumber numberWithBool:NO]], nil]
													forKeys:[NSArray arrayWithObjects:@"name", @"params", nil]];
	[Notifications notifyForName:[Notifications signalCommand] object:self userInfo:dic];
}

- (void) credits:(id)sender {
    [[SimpleAudioEngine sharedEngine] playEffect:@"selection.mp3"];
	
}

#pragma mark Alert Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 1)
		[self newGameEX];
}
@end
