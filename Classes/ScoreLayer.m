//
//  ScoreLayer.m
//  AnimalForce
//
//  Created by George Kravas on 2/7/11.
//  Copyright 2011 Protractor Games. All rights reserved.
//

#import "ScoreLayer.h"

#define LEVEL_COMPLETE myp(320, 75)
#define MOVES myp(320, 232)
#define TIME myp(320, 406)
#define SCORE myp(320, 576)
#define TOTAL_SURVIVAL_SCORE myp(320, 746)
#define TOUCH_TO_CONTINUE myp(320, 910)

@implementation ScoreLayer

@synthesize bg, onNextLevel, onHideComplete, levelCompleteLbl, timeLbl, timeCnt, movesLbl, movesCnt, scoreLbl, scoreCnt, continueLbl,
			score, minScore, scoreVal, time, timeVal, moves, movesVal, totalSurvivalScoreLbl, totalSurvivalScoreCnt, isSurvival, playerLost;

-(id) init {
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self = [super init] )) {
		[self createBG];
		[self createLabels];
	}
	return self;
}

- (void) dealloc {

	[self.bg release]; 
	[self.onNextLevel release];    
    [self.levelCompleteLbl release]; 
	[self.timeLbl release];
    [self.timeCnt release]; 
	[self.movesLbl release];
    [self.movesCnt release]; 
	[self.onNextLevel release];
    [self.scoreLbl release]; 
	[self.scoreCnt release];
    [self.continueLbl release]; 
    [self.totalSurvivalScoreLbl release];
	[self.totalSurvivalScoreCnt release];
	[super dealloc];
}

- (void) createBG {
	self.bg = [CCSprite spriteWithSpriteFrameName:@"scoreBG-HD.png"];
	//self.bg.anchorPoint = ccp(0, 0);
	self.bg.position = myp(320, 480);
	[self addChild:bg];
}

- (void) createLabels {
    CGPoint offset;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
         offset = ccp(0, -60);
    else
         offset = ccp(0, -30);
    
	ccColor3B black = ccc3(0,0,0);
	const float totalScale = 0.7;
	
	self.levelCompleteLbl = [StylesUtil createLabelWithFont:@"impact" text:@"Mission Complete" position:LEVEL_COMPLETE target:nil selector:nil];
	self.levelCompleteLbl.scale = totalScale;
	[self addChild:self.levelCompleteLbl];
	
	self.timeLbl = [StylesUtil createLabelWithFont:@"impact" text:@"elapsed time" position:TIME target:nil selector:nil];
	self.timeLbl.scale = totalScale;
	[self addChild:self.timeLbl];
	
	self.timeCnt = [StylesUtil createLabelWithFont:@"impact" text:@"0 x 10: 0" position:ccpAdd(TIME, offset) target:nil selector:nil];
	self.timeCnt.scale = totalScale;
	self.timeCnt.color = black;
	[self addChild:self.timeCnt];
	
	self.movesLbl = [StylesUtil createLabelWithFont:@"impact" text:@"remaining moves" position:MOVES target:nil selector:nil];
	self.movesLbl.scale = totalScale;
	[self addChild:self.movesLbl];
	
	self.movesCnt = [StylesUtil createLabelWithFont:@"impact" text:@"0 x 10: 0" position:ccpAdd(MOVES, offset) target:nil selector:nil];
	self.movesCnt.scale = totalScale;
	self.movesCnt.color = black;
	[self addChild:self.movesCnt];
	
	self.scoreLbl = [StylesUtil createLabelWithFont:@"impact" text:@"score" position:SCORE target:nil selector:nil];
	self.scoreLbl.scale = totalScale;
	[self addChild:self.scoreLbl];
	
	self.scoreCnt = [StylesUtil createLabelWithFont:@"impact" text:@"0" position:ccpAdd(SCORE, offset) target:nil selector:nil];
	self.scoreCnt.scale = totalScale;
	self.scoreCnt.color = black;
	[self addChild:self.scoreCnt];
	
	self.totalSurvivalScoreLbl = [StylesUtil createLabelWithFont:@"impact" text:@"total score" position:TOTAL_SURVIVAL_SCORE target:nil selector:nil];
	self.totalSurvivalScoreLbl.scale = totalScale;
	[self addChild:self.totalSurvivalScoreLbl];
	
	self.totalSurvivalScoreCnt = [StylesUtil createLabelWithFont:@"impact" text:@"0" position:ccpAdd(TOTAL_SURVIVAL_SCORE, offset) target:nil selector:nil];
	self.totalSurvivalScoreCnt.scale = totalScale;
	self.totalSurvivalScoreCnt.color = black;
	[self addChild:self.totalSurvivalScoreCnt];
	
	self.continueLbl = [StylesUtil createLabelWithFont:@"impact" text:@"Touch to continue" position:TOUCH_TO_CONTINUE target:nil selector:nil];
	self.continueLbl.scale = totalScale;
	self.continueLbl.color = ccc3(230,144,37);
	[self addChild:self.continueLbl];
}

- (void) show {
    NSString *leema = (playerLost) ? @"Mission Failed" : @"Mission Complete";
    [self.levelCompleteLbl setString:leema];
    
	Settings *settings = [Settings sharedInstance];
    minScore = [settings getCurrentMinScore];
	isSurvival = [settings isSurvival];
	
    self.timeLbl.visible = !playerLost;
	self.timeCnt.visible = !playerLost;
    self.movesLbl.visible = !playerLost;
	self.movesCnt.visible = !playerLost;
    self.scoreLbl.visible = !(playerLost && !isSurvival);
	self.scoreCnt.visible = !(playerLost && !isSurvival);
    
	self.totalSurvivalScoreLbl.visible = isSurvival;
	self.totalSurvivalScoreCnt.visible = isSurvival;
	[self.timeCnt setString:[NSString stringWithFormat:@"%d x %d: 0", time, SCORE_PER_SEC]];
    [self.movesCnt setString:[NSString stringWithFormat:@"%d x %d: 0", moves, SCORE_PER_MOVE]];
    if (isSurvival) {
        [self.scoreCnt setString:@"0"];
        [self.totalSurvivalScoreCnt setString:[NSString stringWithFormat:@"%d", settings.previousSurvivalScore, nil]];
    } else
        [self.scoreCnt setString:[NSString stringWithFormat:@"0 / %d", minScore,  nil]];
    
    CGFloat dur = (playerLost) ? 0.89 : 0.3;
	CCSequence *seq = [CCSequence actions:
					   [CCEaseOut actionWithAction:[CCMoveTo actionWithDuration:dur position:ccp(0, 0)] rate:1.6],
					   [CCCallFunc actionWithTarget:self selector:@selector(showComplete)],
					   nil];
	[self runAction:seq];
}

- (void) showComplete {
	[self showAnimatedScore];
}

- (void) showAnimatedScore {
	Settings *settings = [Settings sharedInstance];
	
    if ((score >= [[settings.minScores objectAtIndex:(settings.currentLevel -1)] intValue] && !playerLost) || isSurvival)
        [continueLbl setString:@"Continue"];
    else
        [continueLbl setString:@"Try Again"];
    
	
	
    if (!playerLost) {
        CCSequence *totalSeq = nil;
        if (!isSurvival) {
        totalSeq = [CCSequence actions:
                    [CCActionTween actionWithDuration:1.0 key:@"movesAnim" from:0 to:(moves * SCORE_PER_MOVE)],
                    [CCActionTween actionWithDuration:1.0 key:@"timeAnim" from:0 to:(time * SCORE_PER_SEC)],
                    [CCActionTween actionWithDuration:2.0 key:@"scoreAnim" from:0 to:score],
                    [CCCallFunc actionWithTarget:self selector:@selector(showAnimatedScoreComplete)],
                    nil];
        } else {
            if ([settings survivalModeEnded])
                [continueLbl setString:@"Exit"];
            totalSeq = [CCSequence actions:
                        [CCActionTween actionWithDuration:1.0 key:@"movesAnim" from:0 to:(moves * SCORE_PER_MOVE)],
                        [CCActionTween actionWithDuration:1.0 key:@"timeAnim" from:0 to:(time * SCORE_PER_SEC)],
                        [CCActionTween actionWithDuration:2.0 key:@"scoreAnim" from:0 to:score],
                        [CCActionTween actionWithDuration:2.0 key:@"totalSurvivalScoreAnim" from:settings.previousSurvivalScore to:settings.survivalScore],
                        [CCCallFunc actionWithTarget:self selector:@selector(showAnimatedScoreComplete)],
                        nil];
        }
        [self runAction:totalSeq];
    } else {
        [self showAnimatedScoreComplete];
    }
}

- (void) showAnimatedScoreComplete {
	[self.continueLbl runAction:[CCFadeIn actionWithDuration:0.3]];
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

- (void) hideEX {
    [[CCTouchDispatcher sharedDispatcher] removeDelegate:self];
    [onNextLevel invokeWithParams:nil];
}

- (void) hide {
    CCSequence *seq = [CCSequence actions:
                       [CCEaseIn actionWithAction:[CCMoveTo actionWithDuration:0.3 position:ccp(0, self.contentSize.height)] rate:2],
                       [CCCallFunc actionWithTarget:self selector:@selector(hideComplete)],
                       nil];
	[self runAction:seq];
}

- (void) hideComplete {
	[self.onHideComplete invokeWithParams:nil];
}

- (void) resetScoreWithHide:(BOOL)hide {
	[self.timeCnt setString:[NSString stringWithFormat:@"%d x %d: 0", time, SCORE_PER_SEC]];
    [self.movesCnt setString:[NSString stringWithFormat:@"%d x %d: 0", moves, SCORE_PER_MOVE]];
	[self.scoreCnt setString:@"0"];
    [self.totalSurvivalScoreCnt setString:@"0"];
	self.continueLbl.opacity = 0;
    if (hide)
        self.position = ccp(0, self.contentSize.height);
}

#pragma mark Touch
- (BOOL)ccTouchBegan:(UITouch*)touch withEvent:(UIEvent *)event {
	return YES;
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
	[self hideEX];
}

#pragma mark Anim
-(void) setMovesAnim:(int)value {
    movesVal = value;
    [self.movesCnt setString:[NSString stringWithFormat:@"%d x %d: %d", moves, SCORE_PER_MOVE, value]];
}
-(int) movesAnim {
	return movesVal;//[[self.movesCnt.label string] intValue];
}
-(void) setScoreAnim:(int)value {
    scoreVal = value;
    if (isSurvival)
        [self.scoreCnt setString:[NSString stringWithFormat:@"%d", value,  nil]];
    else
        [self.scoreCnt setString:[NSString stringWithFormat:@"%d / %d", value , minScore,  nil]];
}
-(int) scoreAnim {
	return scoreVal;//[[self.scoreCnt.label string] intValue];
}
-(void) setTotalSurvivalScoreAnim:(int)value {
	[self.totalSurvivalScoreCnt setString:[NSString stringWithFormat:@"%d", value , nil]];
}
-(int) totalSurvivalScoreAnim {
	return [[self.totalSurvivalScoreCnt.label string] intValue];
}

-(void) setTimeAnim:(int)value {
    timeVal = value;
	/*int hours, minutes, seconds;
	seconds = value % 60;
	//time -= seconds;
	minutes = value / 60 % 60;
	//time -= minutes * 60;
	hours = value / 3600 % 24;
	NSString *fTime, *fSeconds, *fMinutes, *fHours;
	fSeconds = (seconds > 9) ? [NSString stringWithFormat:@"%i", seconds] : [NSString stringWithFormat:@"0%i", seconds];
	fMinutes = (minutes > 9) ? [NSString stringWithFormat:@"%i", minutes] : [NSString stringWithFormat:@"0%i", minutes];
	fHours = (hours > 9) ? [NSString stringWithFormat:@"%i", hours] : [NSString stringWithFormat:@"0%i", hours];
	if (hours == 0)
		fTime = [NSString stringWithFormat:@"%@:%@", fMinutes, fSeconds];
	else
		fTime = [NSString stringWithFormat:@"%@:%@:%@", fHours, fMinutes, fSeconds];*/
    NSString *fTime = [NSString stringWithFormat:@"%d x %d: %d", time, SCORE_PER_SEC, value];
	[self.timeCnt setString:fTime];
	
}
-(int) timeAnim {
	return timeVal;//[[self.timeCnt.label string] intValue];
}
@end
