//
//  Settings.h
//  Splitboard
//
//  Created by George Kravas on 3/30/10.
//  Copyright 2010 Protractor Games. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <libkern/OSAtomic.h>

@interface Settings : NSObject {
	BOOL helpSnapping;
	float showBoardTime;
	BOOL retinaSupported;
	int maxLevelReached;
	int currentLevel;
	BOOL musicON;
	BOOL sfxON;
	NSMutableArray *survivalLevels;
	BOOL isSurvival;
    int previousSurvivalScore;
	int survivalScore;
	BOOL showIntro;
    NSArray *minScores;
    NSArray *maxMoves;
    NSArray *minTimes;
}

+ (Settings*) sharedInstance;
- (void) resetMaxLevel;
- (void) saveUserData;
- (void) loadUserData;
- (void) startSurvivalMode;
- (void) stopSurvivalMode;
- (NSNumber*) getNextSurvivalLevel;
- (BOOL) survivalModeEnded;
- (int) getCurrentMinScore;
- (int) getCurrentMaxMoves;
- (int) getCurrentMinTime;
@property BOOL helpSnapping;
@property (readonly)float showBoardTime;
@property BOOL retinaSupported;
@property (nonatomic) int maxLevelReached;
@property int currentLevel;
@property (nonatomic) BOOL musicON;
@property (nonatomic) BOOL sfxON;
@property (nonatomic, retain) NSMutableArray *survivalLevels;
@property BOOL isSurvival;
@property (nonatomic, readonly) int previousSurvivalScore;
@property (nonatomic) int survivalScore;
@property BOOL showIntro;
@property (nonatomic, retain) NSArray *minScores;
@property (nonatomic, retain) NSArray *maxMoves;
@property (nonatomic, retain) NSArray *minTimes;

@end
