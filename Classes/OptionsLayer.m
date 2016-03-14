//
//  OptionsLayer.m
//  AnimalForce
//
//  Created by George Kravas on 2/21/11.
//  Copyright 2011 Protractor Games. All rights reserved.
//

#import "OptionsLayer.h"

#define MUSIC_POS myp(240, 250)
#define SFX_POS myp(200, 350)
#define CLOSE_POS myp(320, 900)
#define TITLE_POS myp(320, 60)

@implementation OptionsLayer

@synthesize bg, musicLbl, sfxLbl, menu, musicYes, musicNO, sfxYes, sfxNO, close, title, settings;

-(id) init {
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self = [super init] )) {
		[self create];
		settings = [Settings sharedInstance];
	}
	return self;
}

- (void) create {
	self.anchorPoint = ccp(0.5, 0.5);
	self.bg = [CCSprite spriteWithSpriteFrameName:@"optionsBG-HD.jpg"];
	bg.position = myp(320, 480);
	
	[self addChild:bg];
	
	musicLbl = [StylesUtil createLabelWithFont:@"splashYellow" text:@"Music" position:MUSIC_POS target:nil selector:nil];
	[self addChild:musicLbl];
	
	sfxLbl = [StylesUtil createLabelWithFont:@"splashYellow" text:@"Sound FX" position:SFX_POS target:nil selector:nil];
	[self addChild:sfxLbl];
	
	menu = [[CCMenu menuWithItems:musicYes, musicNO, sfxYes, sfxNO, close, nil] retain];
	menu.position = ccp(0, 0);
	[self addChild:menu];
	
	musicYes = [self createButtonWithImageName:@"yesNoEngage" callback:@selector(onSwitchPressed:)];
	[menu addChild:musicYes];
    
	musicNO = [self createButtonWithImageName:@"yesNoCancel" callback:@selector(onSwitchPressed:)];
	[menu addChild:musicNO];
	
	sfxYes = [self createButtonWithImageName:@"yesNoEngage" callback:@selector(onSwitchPressed:)];
	[menu addChild:sfxYes];
	
	
	sfxNO = [self createButtonWithImageName:@"yesNoCancel" callback:@selector(onSwitchPressed:)];
	[menu addChild:sfxNO];
	
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        musicYes.position = ccpAdd(MUSIC_POS, ccp(340, 0));
        musicNO.position = ccpAdd(MUSIC_POS, ccp(230, 0));
        sfxYes.position = ccpAdd(SFX_POS, ccp(380, 0));
        sfxNO.position = ccpAdd(SFX_POS, ccp(260, 0));
    } else {
        musicYes.position = ccpAdd(MUSIC_POS, ccp(170, 0));
        musicNO.position = ccpAdd(MUSIC_POS, ccp(115, 0));
        sfxYes.position = ccpAdd(SFX_POS, ccp(190, 0));
        sfxNO.position = ccpAdd(SFX_POS, ccp(130, 0));
    }
    
	close = (CCLabelBMFont*)[StylesUtil createLabelWithFont:@"splashYellow" text:@"close" position:CLOSE_POS target:self selector:@selector(onClose)];
	[menu addChild:close];
	
	title = (CCLabelBMFont*)[StylesUtil createLabelWithFont:@"splashOrange" text:@"Options" position:TITLE_POS target:nil selector:nil];
	[self addChild:title];
}

-(CCMenuItemSprite*) createButtonWithImageName:(NSString*)imageName callback:(SEL)callback {
	CCSprite *spriteNormal = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"%@A.png", imageName]];
	CCSprite *spriteSelected = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"%@P.png", imageName]];
	CCSprite *spriteDisabled = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"%@D.png", imageName]];
	CCMenuItemSprite *button = [CCMenuItemSprite itemFromNormalSprite:spriteNormal selectedSprite:spriteSelected disabledSprite:spriteDisabled target:self selector:callback];
	return button;
}

- (void) onSwitchPressed:(id)sender {
	if ([sender isEqual:musicYes]) {
		[SimpleAudioEngine sharedEngine].backgroundMusicVolume = 1.0;
		musicYes.opacity = 255;
		musicNO.opacity = 128;
		settings.musicON = YES;
	} else if ([sender isEqual:musicNO]) {
		[SimpleAudioEngine sharedEngine].backgroundMusicVolume = 0;
		musicYes.opacity = 128;
		musicNO.opacity = 255;
		settings.musicON = NO;
	} else if ([sender isEqual:sfxYes]) {
		[SimpleAudioEngine sharedEngine].effectsVolume = 1.0;
		sfxYes.opacity = 255;
		sfxNO.opacity = 128;
		settings.sfxON = YES;
	} else if ([sender isEqual:sfxNO]) {
		[SimpleAudioEngine sharedEngine].effectsVolume = 0;
		sfxYes.opacity = 128;
		sfxNO.opacity = 255;
		settings.sfxON = NO;
	}
}

- (void) open {
	musicYes.opacity = (settings.musicON) ? 255 : 128;
	musicNO.opacity = (settings.musicON) ? 128 : 255;
	sfxYes.opacity = (settings.sfxON) ? 255 : 128;
	sfxNO.opacity = (settings.sfxON) ? 128 : 255;
	
	//[self.parent reorderChild:self z:200];
	[self runAction:[CCEaseSineIn actionWithAction:[CCScaleTo actionWithDuration:0.3 scale:1.0]]];
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

- (void) onClose {
	[self runAction:[CCSequence actions:
								[CCEaseSineOut actionWithAction:[CCScaleTo actionWithDuration:0.3 scale:0.0]],
								[CCCallFunc actionWithTarget:self selector:@selector(onCloseComplete)],
								[CCCallFunc actionWithTarget:self.parent selector:@selector(optionsClosed)],
								nil]];
}

- (void) onCloseComplete {
	[[CCTouchDispatcher sharedDispatcher] removeDelegate:self];
	//[self.parent reorderChild:self z:1];
}

#pragma mark Touch
- (BOOL)ccTouchBegan:(UITouch*)touch withEvent:(UIEvent *)event {
	return YES;
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
	
}

@end
