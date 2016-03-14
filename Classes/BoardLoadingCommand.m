//
//  BoardLoadingCommand.m
//  AnimalForce
//
//  Created by George Kravas on 11/9/10.
//  Copyright 2010 Protractor Games. All rights reserved.
//

#import "BoardLoadingCommand.h"

@implementation BoardLoadingCommand

+ (void) executeWithParams:(NSArray*)params {
	SceneManager *sceneMgr = [SceneManager sharedInstance];
	sceneMgr.loading = [LoadingScene node];
	
	int level = [(NSNumber*)[params objectAtIndex:0] intValue];//0 is level number
	Settings *settings = [Settings sharedInstance];
	settings.currentLevel = level;
    if (!settings.isSurvival)
        settings.maxLevelReached = level;
	//if ((level > settings.maxLevelReached))
	//	settings.maxLevelReached = level;
	
	int sheets = (level > 1 && level != 7) ? 3 : 2;
	sheets = (level == 8) ? 1 : sheets;
	[sceneMgr.loading setLevel:level];
	sceneMgr.loading.onShowAction = [CCCallFuncO actionWithTarget:[BoardLoadingCommand class]
														 selector:@selector(loadLevel:) 
														   object:[NSArray arrayWithObjects:[params objectAtIndex:0], [NSNumber numberWithInt:sheets], nil]],
	//[sceneMgr.loading intStartAnimation];
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:2.0f scene:sceneMgr.loading]];
	[sceneMgr.loading schedule:@selector(onShow) interval:2.0f];
}

+ (void) loadLevel:(NSArray*)params {
	int level = [(NSNumber*)[params objectAtIndex:0] intValue];//0 is level number
	int sheets = [(NSNumber*)[params objectAtIndex:1] intValue];//1 is sheets number
	SceneManager *sceneMgr = [SceneManager sharedInstance];
	[[ImageSlicer slicer] sliceTexturesAndCreateAnimation:[NSString stringWithFormat:@"level%d", level, nil]
												   sheets:sheets
												   frames:TOTAL_TEXTURES_PER_BOARD
												  columns:BOARD_COLUMNS rows:BOARD_ROWS 
												scaleSize:CGSizeZero
										 onProgressUpdate:[MyDelegate initWithObj:sceneMgr.loading selector:@selector(onLoadingCurrentProgress:total:)]
											   onComplete:[MyDelegate initWithObj:sceneMgr.loading selector:@selector(onLoadingComplete:)]];
}

@end
