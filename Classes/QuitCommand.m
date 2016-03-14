//
//  QuitCommand.m
//  AnimalForce
//
//  Created by George Kravas on 11/28/10.
//  Copyright 2010 Protractor Games. All rights reserved.
//

#import "QuitCommand.h"


@implementation QuitCommand

+ (void) executeWithParams:(NSArray*)params {
	//Always in any case
	[[Settings sharedInstance] stopSurvivalMode];
	SceneManager *sceneMgr = [SceneManager sharedInstance];
	//sceneMgr.splash = [SplashScene node];
	
	//[AssetUtil loadSpritePack:@"splashBGAtlas" sheets:6];
	//[AssetUtil createAnimationFromPreloadedSpritesWithName:@"splashBG" withExtension:@"jpg" frames:18 andDelay:ANIMATION_DELAY];
	
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:2.0f scene:sceneMgr.splash]];
	[sceneMgr.splash schedule:@selector(startAnimation) interval:0.1f];
}

@end
