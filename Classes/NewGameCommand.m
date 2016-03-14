//
//  NewGameCommand.m
//  AnimalForce
//
//  Created by George Kravas on 12/5/10.
//  Copyright 2010 Protractor Games. All rights reserved.
//

#import "NewGameCommand.h"

@implementation NewGameCommand

+ (void) executeWithParams:(NSArray*)params {
	BOOL resetMaxLevel = [(NSNumber*)[params objectAtIndex:0] boolValue];
	if (resetMaxLevel)
		[[Settings sharedInstance] resetMaxLevel];
	SceneManager *sceneMgr = [SceneManager sharedInstance];
	sceneMgr.levelSelection = [LevelSelectionScene node];
	[sceneMgr.levelSelection markAvailableLevels];
	[[CCDirector sharedDirector] replaceScene:[CCTransitionCrossFade transitionWithDuration:0.5f scene:sceneMgr.levelSelection]];
}

@end
