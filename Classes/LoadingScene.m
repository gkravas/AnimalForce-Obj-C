//
//  LoadingScreen.m
//  AnimalForce
//
//  Created by George Kravas on 11/7/10.
//  Copyright 2010 Protractor Games. All rights reserved.
//

#import "LoadingScene.h"

#define STAR_WING_POS myp(127, 808)
#define CAT_POS myp(420.50, 650.50)
#define PROGRESS_BAR_POS myp(15, 942)
#define SPEECH_BALOON_POS myp(180, 516)
#define TITLE_POS myp(321.71, 58.03)
#define STAGE_INFO_POS myp(319.40, 123.58)
#define CAT_SPEECH_POS myp(154.69, 518.30)
#define LOADING_POS myp(340, 920)

@implementation LoadingScene

@synthesize bg, starWing, speechBallon, cat, title, stageInfo, catSpeech, loadingText, loading, onShowAction;

// on "init" you need to initialize your instance
-(id) init {
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self = [super init] )) {
		[self createScene];
	}
	return self;
}

- (void) dealloc {
	[self.bg release];
	[self.starWing release];
	[self.title release];
	[self.speechBallon release];
	[self.cat release];
	[self.stageInfo release];
	[self.catSpeech release];
	[self.loadingText release];
	[super dealloc];
}
/*
- (void) onExit {
	[self removeChild:cat cleanup:YES];
	[self removeChild:title cleanup:YES];
	[self removeChild:stageInfo cleanup:YES];
	[self removeChild:catSpeech cleanup:YES];
}

- (void) intStartAnimation {
	[self unschedule:@selector(intStartAnimation)];
	progressBar.scaleX = 0;
	[self createAnimatedCat];
}
*/
- (void) onShow {
	[self unschedule:@selector(onShow)];
	[self runAction:onShowAction];
}

//#==================================================================================================================================
#pragma mark Scene creation
- (void) createScene {
	self.bg = [CCSprite spriteWithSpriteFrameName:@"loadingScreenBG-HD.png"];
	self.bg.position = myp(320, 480);
	[self addChild:bg];
	
	self.starWing = [CCSprite spriteWithSpriteFrameName:@"starWing-HD.png"];
	self.starWing.position = STAR_WING_POS;
	[self addChild:starWing];
	
	/*
	progressBarBG = [[CCSprite spriteWithSpriteFrameName:@"progressBarBG-HD.png"] retain];
	progressBarBG.position = PROGRESS_BAR_POS;
	progressBarBG.anchorPoint = ccp(0, 0);
	[self addChild:progressBarBG];
	
	progressBar = [[CCSprite spriteWithSpriteFrameName:@"progressBar-HD.png"] retain];
	progressBar.position = PROGRESS_BAR_POS;
	progressBar.anchorPoint = ccp(0, 0);
	progressBar.scaleX = 0;
	[self addChild:progressBar];
	*/
	
	self.speechBallon = [CCSprite spriteWithSpriteFrameName:@"loadingSpeechBalloon-HD.png"];
	self.speechBallon.position = SPEECH_BALOON_POS;
	[self addChild:self.speechBallon];
	
	self.cat = [CCSprite spriteWithSpriteFrameName:@"catLoading1-HD.png"];
	self.cat.position = CAT_POS;
	[self addChild:self.cat];
}

/*
- (void) createAnimatedCat {
	//NSString *animName = @"catLoading";
	//cat = [[AssetUtil createSpriteWithAnimation:animName andDuration:1.5] retain];
	//[cat setDisplayFrameWithAnimationName:animName index:0];
	cat = [CCSprite spriteWithSpriteFrameName:@"catLoading1-HD"];
	cat.position = CAT_POS;
	[self addChild:cat];
	
}
*/

- (void) setLevel:(int)level {
	self.title = [StylesUtil createLabelWithFont:@"splashOrange" text:[NSString stringWithFormat:@"Level %d", level, nil] position:TITLE_POS target:nil selector:nil];
	self.title.color = ccc3(230,144,37);
	[self addChild:self.title];
	
	self.stageInfo = [StylesUtil createLabelWithFont:@"splashYellow" text:@"MEET MASTER CHUCK THE CAT,\nLEADER OF THE ANIMAL NINJA\nCLAN, AND  FOUNDING MEMBER\nOF THE “ANIMAL FORCE” TEAM" position:STAGE_INFO_POS target:nil selector:nil];
	self.stageInfo.anchorPoint = ccp(0.5, 1);
	self.stageInfo.scale = 0.5;
	//stageInfo.position = STAGE_INFO_POS;
	[self addChild:self.stageInfo];
	
	self.catSpeech = [StylesUtil createLabelWithFont:@"bubble" text:@"PLEASE WAIT,\nTHE CHALLENGE\nIS ABOUT\nTO BEGIN !" position:CAT_SPEECH_POS target:nil selector:nil];
	[self addChild:self.catSpeech];
	
	self.loading = [StylesUtil createLabelWithFont:@"splashOrange" text:@"Loading..." position:LOADING_POS target:nil selector:nil];
	self.loading.color = ccc3(230,144,37);
	[self addChild:self.loading];
}

/*
- (CCMenuItemLabel*) createLabelWithText:(NSString*)text position:(CGPoint)position {
	CCLabelBMFont *label = [CCLabelBMFont labelWithString:text fntFile:@"haeOrange-HD.fnt"];
	CCMenuItemLabel *mLabel = [CCMenuItemLabel itemWithLabel:label target:self selector:nil];
	mLabel.position = position;
	[self addChild:mLabel z:1];
	return [mLabel retain];
}

- (CCMenuItemLabel*) createTextAreaWithText:(NSString*)text position:(CGPoint)position {
	CCLabelBMFont *label = [CCLabelBMFont labelWithString:text fntFile:@"haeOrange-HD.fnt"];
	CCMenuItemLabel *mLabel = [CCMenuItemLabel itemWithLabel:label target:self selector:nil];
	mLabel.position = position;
	[self addChild:mLabel z:1];
	return mLabel;
}
*/
- (void) onLoadingCurrentProgress:(NSNumber*)current total:(NSNumber*)total {
	NSLog(@"slicing progress %d / %d", [current intValue], [total intValue]);
	//float progress = (float)([current floatValue] / [total floatValue]);
}

- (void) onLoadingComplete:(NSString*)name {
	NSNumber *level = [NSNumber numberWithInt:[[name stringByReplacingOccurrencesOfString:@"level" withString:@""] intValue]];
	NSDictionary *dic = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"CreateBoardCommand", [NSArray arrayWithObject:level], nil]
													forKeys:[NSArray arrayWithObjects:@"name", @"params", nil]];
	[Notifications notifyForName:[Notifications signalCommand] object:self userInfo:dic];
}

@end
