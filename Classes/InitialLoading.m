//
//  InitialLoading.m
//  AnimalForce
//
//  Created by George Kravas on 11/12/10.
//  Copyright 2010 Protractor Games. All rights reserved.
//

#import "InitialLoading.h"


@implementation InitialLoading

+ (void) executeWithParams:(NSArray*)params {
	NSLog(@"Intro loaded");
	[AssetUtil loadSpritePack:@"intro" sheets:1];

	[AssetUtil loadSpritePack:@"imgPack" sheets:4];
	NSLog(@"imgPacks loaded");
	[AssetUtil createAnimationFromPreloadedSpritesWithName:@"starWingGlance" withExtension:@"png" frames:7 andDelay:ANIMATION_DELAY];
	NSLog(@"starWingGlance loaded");
	[AssetUtil createAnimationFromPreloadedSpritesWithName:@"catLoading" withExtension:@"png" frames:18 andDelay:ANIMATION_DELAY];
	NSLog(@"catLoading loaded");
	[AssetUtil createAnimationFromPreloadedSpritesWithName:@"gatos-come-on" withExtension:@"png" frames:18 andDelay:ANIMATION_DELAY];
    
	//[[SimpleAudioEngine sharedEngine] preloadEffect:@"helpingFunctionEngage.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"slide.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"pause.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"ok.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"cancel.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"selection.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"snap.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"help.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"stageFail.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"stageComplete.mp3"];
	[[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"intro.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"stage1.mp3"];
	NSLog(@"bubbles loaded");
	[AssetUtil loadSpritePack:@"bubbles" sheets:1];
	//NSLog(@"texts");
	//[AssetUtil loadSpritePack:@"texts" sheets:1];
	
	SceneManager *sceneMgr = [SceneManager sharedInstance];
	sceneMgr.intro = [IntroScene node];
	sceneMgr.splitboard = [SplitboardScene node];
	//[[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"intro.mp3"];
	[[CCDirector sharedDirector] runWithScene:[CCTransitionFade transitionWithDuration:1.0 scene:sceneMgr.intro]];
}

@end
