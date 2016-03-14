//
//  Settings.m
//  Splitboard
//
//  Created by George Kravas on 3/30/10.
//  Copyright 2010 Protractor Games. All rights reserved.
//

#import "Settings.h"
#define MAX_LEVEL_REACHED @"maxLevelReached"
#define MUSIC_ON @"musicON"
#define SFX_ON @"sfxON"
#define SHOW_INTRO @"showIntro"

@implementation Settings

@synthesize helpSnapping, showBoardTime, retinaSupported, currentLevel, musicON, sfxON, survivalLevels,
			isSurvival, survivalScore, showIntro, minScores, maxMoves, minTimes, previousSurvivalScore, maxLevelReached;

static void * volatile sharedInstance = nil;                                                

+ (Settings *) sharedInstance {                                                                    
	while (!sharedInstance) {                                                                          
		Settings *temp = [[self alloc] init];                                                                 
		if(!OSAtomicCompareAndSwapPtrBarrier(0x0, temp, &sharedInstance)) {
			[temp release];                                                                                   
		}                                                                                                    
	}                                                                                                        
	return sharedInstance;                                                                        
}

-(id) init {
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self = [super init] )) {
		helpSnapping = YES;
		showIntro = YES;
		showBoardTime = 1.5;
		self.minScores = [NSArray arrayWithObjects:
                    [NSNumber numberWithInt:2000], //1
                    [NSNumber numberWithInt:2200], //2
                    [NSNumber numberWithInt:2400], //3
                    [NSNumber numberWithInt:2500], //4
                    [NSNumber numberWithInt:2600], //5
                    [NSNumber numberWithInt:2800], //6
                    [NSNumber numberWithInt:3000], //7
                    [NSNumber numberWithInt:3200], //8
                    [NSNumber numberWithInt:3400], //9
                    [NSNumber numberWithInt:3600], //10
                    [NSNumber numberWithInt:3800], //11
                    [NSNumber numberWithInt:4000], //12
                    [NSNumber numberWithInt:4200], //13
                    [NSNumber numberWithInt:4400], //14
                    nil];
        
        self.maxMoves = [NSArray arrayWithObjects:
                          [NSNumber numberWithInt:500], //1
                          [NSNumber numberWithInt:500], //2
                          [NSNumber numberWithInt:500], //3
                          [NSNumber numberWithInt:500], //4
                          [NSNumber numberWithInt:500], //5
                          [NSNumber numberWithInt:500], //6
                          [NSNumber numberWithInt:500], //7
                          [NSNumber numberWithInt:500], //8
                          [NSNumber numberWithInt:500], //9
                          [NSNumber numberWithInt:500], //10
                          [NSNumber numberWithInt:500], //11
                          [NSNumber numberWithInt:500], //12
                          [NSNumber numberWithInt:500], //13
                          [NSNumber numberWithInt:500], //14
                          nil];
        self.minTimes = [NSArray arrayWithObjects:
                         [NSNumber numberWithInt:300], //1
                         [NSNumber numberWithInt:300], //2
                         [NSNumber numberWithInt:300], //3
                         [NSNumber numberWithInt:300], //4
                         [NSNumber numberWithInt:300], //5
                         [NSNumber numberWithInt:300], //6
                         [NSNumber numberWithInt:300], //7
                         [NSNumber numberWithInt:300], //8
                         [NSNumber numberWithInt:300], //9
                         [NSNumber numberWithInt:300], //10
                         [NSNumber numberWithInt:300], //11
                         [NSNumber numberWithInt:300], //12
                         [NSNumber numberWithInt:300], //13
                         [NSNumber numberWithInt:300], //14
                         nil];
		[self loadUserData];
		if (maxLevelReached < 1)
			maxLevelReached = 1;
			
	}
	return self;
}

- (void) startSurvivalMode {
    previousSurvivalScore = 0;
    survivalScore = 0;
	self.isSurvival = YES;
	self.survivalLevels = [NSMutableArray array];
	for (int i = 1; i <= [Settings sharedInstance].maxLevelReached; i++) {
		[self.survivalLevels addObject:[NSNumber numberWithInt:i]];
	}
}

- (void) stopSurvivalMode {
	self.isSurvival = NO;
}

- (NSNumber*) getNextSurvivalLevel {
	if ([self survivalModeEnded])
		return [NSNumber numberWithInt:-2];
	int index = arc4random() % [self.survivalLevels count];
	NSNumber *level = [self.survivalLevels objectAtIndex:index];
	[self.survivalLevels removeObjectAtIndex:index];
	
	return level;
}

- (BOOL) survivalModeEnded {
	return ([self.survivalLevels count] == 0);
}

- (void) setMaxLevelReached:(int)value {
	if (maxLevelReached >= value)
		return;
	
	maxLevelReached = value;
	[self saveUserData];
}

- (void) resetMaxLevel {
	maxLevelReached = 1;
	[self saveUserData];
}

- (void) setSurvivalScore:(int)value {
    previousSurvivalScore = survivalScore;
	survivalScore = value;
}

- (void) setMusicON:(BOOL)on {
	if (musicON == on)
		return;
	
	musicON = on;
	[self saveUserData];
}

- (void) setSfxON:(BOOL)on {
	if (sfxON == on)
		return;
	
	sfxON = on;
	[self saveUserData];
}

- (void) saveUserData {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setValue:[NSNumber numberWithInt:maxLevelReached] forKey:MAX_LEVEL_REACHED];
	[defaults setValue:[NSNumber numberWithBool:musicON] forKey:MUSIC_ON];
	[defaults setValue:[NSNumber numberWithBool:sfxON] forKey:SFX_ON];
	[defaults setValue:@"NO" forKey:SHOW_INTRO];
	[defaults synchronize];
}

- (void) loadUserData {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	maxLevelReached = [(NSNumber*)[defaults valueForKey:MAX_LEVEL_REACHED] intValue];
	musicON = [(NSNumber*)[defaults valueForKey:MUSIC_ON] boolValue];
	sfxON = [(NSNumber*)[defaults valueForKey:SFX_ON] boolValue];
	NSString *dShowIntro = [defaults valueForKey:SHOW_INTRO];
	showIntro = ([dShowIntro isEqualToString:@"NO"]) ? NO : YES;
}

- (int) getCurrentMinScore {
    return [[self.minScores objectAtIndex:(currentLevel - 1)] intValue];
}

- (int) getCurrentMaxMoves {
    return [[self.maxMoves objectAtIndex:(currentLevel - 1)] intValue];
}
- (int) getCurrentMinTime {
    return [[self.minTimes objectAtIndex:(currentLevel - 1)] intValue];
}
@end
