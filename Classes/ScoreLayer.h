//
//  ScoreLayer.h
//  AnimalForce
//
//  Created by George Kravas on 2/7/11.
//  Copyright 2011 Protractor Games. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "MyDelegate.h"
#import "StylesUtil.h"
#import "GameConfig.h"
#import "Settings.h"

@interface ScoreLayer : CCLayer {
	CCSprite *bg;
	MyDelegate *onNextLevel;
    MyDelegate *onHideComplete;
	CCMenuItemLabel *levelCompleteLbl;
	CCMenuItemLabel *timeLbl;
	CCMenuItemLabel *timeCnt;
	CCMenuItemLabel *movesLbl;
	CCMenuItemLabel *movesCnt;
	CCMenuItemLabel *scoreLbl;
	CCMenuItemLabel *scoreCnt;
	CCMenuItemLabel *totalSurvivalScoreLbl;
	CCMenuItemLabel *totalSurvivalScoreCnt;
	CCMenuItemLabel *continueLbl;
	int score;
    int minScore;
    int scoreVal;
	int time;
    int timeVal;
	int moves;
    int movesVal;
    BOOL isSurvival;
    BOOL playerLost;
}

@property (nonatomic, retain) CCSprite *bg;
@property (nonatomic, retain) MyDelegate *onNextLevel;
@property (nonatomic, retain) MyDelegate *onHideComplete;
@property (nonatomic, retain) CCMenuItemLabel *levelCompleteLbl;
@property (nonatomic, retain) CCMenuItemLabel *timeLbl;
@property (nonatomic, retain) CCMenuItemLabel *timeCnt;
@property (nonatomic, retain) CCMenuItemLabel *movesLbl;
@property (nonatomic, retain) CCMenuItemLabel *movesCnt;
@property (nonatomic, retain) CCMenuItemLabel *scoreLbl;
@property (nonatomic, retain) CCMenuItemLabel *scoreCnt;
@property (nonatomic, retain) CCMenuItemLabel *continueLbl;
@property (nonatomic, retain) CCMenuItemLabel *totalSurvivalScoreLbl;
@property (nonatomic, retain) CCMenuItemLabel *totalSurvivalScoreCnt;
@property int score;
@property int minScore;
@property int scoreVal;
@property int time;
@property int timeVal;
@property int moves;
@property int movesVal;
@property BOOL isSurvival;
@property BOOL playerLost;

- (void) createBG;
- (void) createLabels;
- (void) show;
- (void) showComplete;
- (void) showAnimatedScore;
- (void) showAnimatedScoreComplete;
- (void) hideEX;
- (void) hide;
- (void) hideComplete;
- (void) resetScoreWithHide:(BOOL)hide;
- (void) setTime:(int)value;
- (void) setMoves:(int)value;
- (void) setScore:(int)value;
#pragma mark SETTERS
- (void) setMovesAnim:(int)value;
- (void) setScoreAnim:(int)value;
- (void) setTotalSurvivalScoreAnim:(int)value;
- (void) setTimeAnim:(int)value;
#pragma mark GETTERS
- (int) movesAnim;
- (int) scoreAnim;
- (int) totalSurvivalScoreAnim;
- (int) timeAnim;
@end
