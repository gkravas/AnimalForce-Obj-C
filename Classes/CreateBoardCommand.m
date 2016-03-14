//
//  CreateBoardCommand.m
//  AnimalForce
//
//  Created by George Kravas on 11/12/10.
//  Copyright 2010 Protractor Games. All rights reserved.
//

#import "CreateBoardCommand.h"


@implementation CreateBoardCommand

+ (void) executeWithParams:(NSArray*)params {
	SceneManager *sceneMgr = [SceneManager sharedInstance];
	//sceneMgr.splitboard = [SplitboardScene node];
	
	int level = [(NSNumber*)[params objectAtIndex:0] intValue];//0 is board name
	sceneMgr.splitboard.level = level;
	[sceneMgr.splitboard preInit];
	[[CCDirector sharedDirector] replaceScene:[CCTransitionCrossFade transitionWithDuration:1.0f scene:sceneMgr.splitboard]];
	[sceneMgr.splitboard schedule:@selector(initBoard) interval:1.0f];
}


@end
