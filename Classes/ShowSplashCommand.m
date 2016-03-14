//
//  ShowSplashCommand.m
//  AnimalForce
//
//  Created by George Kravas on 1/19/11.
//  Copyright 2011 Protractor Games. All rights reserved.
//

#import "ShowSplashCommand.h"


@implementation ShowSplashCommand

+ (void) executeWithParams:(NSArray*)params {
	SceneManager *sceneMgr = [SceneManager sharedInstance];
	[AssetUtil unloadSpritePack:@"intro" sheets:1];
	
	[AssetUtil loadSpritePack:@"splashBGAtlas" sheets:3];
	[AssetUtil createAnimationFromPreloadedSpritesWithName:@"splashBG" withExtension:@"jpg" frames:18 andDelay:ANIMATION_DELAY];
	
	sceneMgr.splash = [SplashScene node];
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:2.0f scene:sceneMgr.splash]];
	[sceneMgr.splash schedule:@selector(startAnimation) interval:0.1f];
}

@end
