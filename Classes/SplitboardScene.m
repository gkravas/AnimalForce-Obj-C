//
// cocos2d Hello World example
// http://www.cocos2d-iphone.org
//

// Import the interfaces
#import "SplitboardScene.h"

@implementation SplitboardScene


@synthesize board, inGameMenu, yesNoPanel, sceneState, topBoardLayer, scoreLayer, timePassed, options;

// on "init" you need to initialize your instance
-(id) init {
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self = [super init] )) {
		//scene = [CCScene node];
		//create the board
		[self createBoard];
		//create the in game menu
		[self createInGameMenu];
		[self createNotifications];
		[self createYesNoPanel];
		[self createTopBoardLayer];
		[self createOptionsLayer];
		[self createScoreLayer];
	}
	return self;
}

-(void) createNotifications {
	[Notifications addNotificationName:[Notifications pauseGame] object:self selector:@selector(pauseGame)];
	[Notifications addNotificationName:[Notifications resumeGame] object:self selector:@selector(resumeGame)];
	[Notifications addNotificationName:[Notifications quitGame] object:self selector:@selector(quitGame)];
	[Notifications addNotificationName:[Notifications nextBoard] object:self selector:@selector(nextBoard)];
	[Notifications addNotificationName:[Notifications showOptions] object:self selector:@selector(showOptions)];
    [Notifications addNotificationName:[Notifications movesToZero] object:self selector:@selector(movesToZero)];
}
/*
-(void) onExit
{
	[self removeChild:topBoardLayer cleanup:YES];
}
*/

-(void) createBoard {
	self.board = [BoardLayer node];
	[self addChild:board];
	//[self.board prepareSceneWidth:(STD_RESOLUTION_WIDTH * SCALE_FACTOR) height:(STD_RESOLUTION_HEIGHT * SCALE_FACTOR) rows:BOARD_ROWS columns:BOARD_COLUMNS];
}

-(void) createInGameMenu {
	self.inGameMenu = [InGameMenu node];
	[self addChild:self.inGameMenu];
	[self.inGameMenu initMenu];
}

-(void) createYesNoPanel {
	self.yesNoPanel = [YesNoPanel node];
	[self addChild:yesNoPanel];
}

-(void) createTopBoardLayer {
	self.topBoardLayer = [TopBoardLayer node];
	self.topBoardLayer.hideBubbleCompleteCB = [MyDelegate initWithObj:self selector:@selector(showScore)];
	[self addChild:self.topBoardLayer];
}

-(void) createOptionsLayer {
	self.options = [OptionsLayer node];
	[self addChild:self.options];
	self.options.scale = 0;
}

-(void) createScoreLayer {
	self.scoreLayer = [ScoreLayer node];
	self.scoreLayer.onNextLevel = [MyDelegate initWithObj:self selector:@selector(nextLevel)];
    self.scoreLayer.onHideComplete = [MyDelegate initWithObj:self selector:@selector(restartLevel)];
	[self addChild:self.scoreLayer];
}

- (void) preInit {
    Settings *set = [Settings sharedInstance];
	self.timePassed = (set.isSurvival) ? SURVIVAL_TIME : [set getCurrentMinTime];
    [self.board prepareSceneWidth:(STD_RESOLUTION_WIDTH * SCALE_FACTOR) height:(STD_RESOLUTION_HEIGHT * SCALE_FACTOR) rows:BOARD_ROWS columns:BOARD_COLUMNS];
	[self.board prepareBoard];
	[self.inGameMenu resetMenu];
	[self.topBoardLayer createBubble];
	[self.scoreLayer resetScoreWithHide:YES];
}

-(void) initBoard {
	[self unschedule:@selector(initBoard)];
	self.board.isArrangedCB = [MyDelegate initWithObj:self selector:@selector(onBoardArranged)];
	[self.board showBoardBeginingCallback:[MyDelegate initWithObj:self selector:@selector(shuffle)]];
}

-(void) restartLevel {
    [self initBoard];
}

-(void) shuffle {
	[self.board shuffleCallback:[MyDelegate initWithObj:self selector:@selector(startGame)]];
}

-(void) goToOriginalState {
	[self.board goToOriginalStateCallback:[MyDelegate initWithObj:self selector:@selector(hide)]];
}
-(void) goToCurrentState {
	[self.board goToCurrentStateCallback:[MyDelegate initWithObj:self selector:@selector(goToOriginalState)]];
}
-(void) hide {
	MyDelegate *callback = nil;
	if (sceneState == QUIT) {
		callback = [MyDelegate initWithObj:self selector:@selector(quitReal)];
	} else if (sceneState == BOARD_ARRANGED) {
		callback = [MyDelegate initWithObj:self selector:@selector(boardArrangedReal)];
	} else if (sceneState == NEXT_BOARD) {
		callback = [MyDelegate initWithObj:self selector:@selector(nextBoardReal)];
	}
	[self.board hideBoardEndingCallback:callback];
}

#pragma mark Inner Callbacks
-(void) quitInner:(NSString*)result {
	if ([result isEqualToString:@"no"]) {
		[self.inGameMenu showMe];
		return;
	}
	self.sceneState = QUIT;
	[self.inGameMenu resetMenu];
	[self goToOriginalState];
}

-(void) nextBoardInner:(NSString*)result {
	if ([result isEqualToString:@"no"]) {
		[self.inGameMenu showMe];
		return;
	}
	self.sceneState = NEXT_BOARD;
	[self goToOriginalState];
}

#pragma mark Game States
-(void) startGame {
    //[[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume:1.0];
    //[[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"stage1.mp3" loop:YES];
    [self.board startGame];
	[self.inGameMenu showMe];
	[self schedule:@selector(onSecondPassed) interval:1];
}
-(void) restartGame {
    [self.board restartGame];
    [self.inGameMenu showMe];
	[self schedule:@selector(onSecondPassed) interval:1];
}

-(void) onBoardArranged {
    if (![Settings sharedInstance].isSurvival)
        [[Settings sharedInstance] setMaxLevelReached:([Settings sharedInstance].currentLevel + 1)];
	self.sceneState = BOARD_ARRANGED;
	[self unschedule:@selector(onSecondPassed)];
	[self.board showEmptyTileCB:[MyDelegate initWithObj:self selector:@selector(boardArrangedReal)]];
}

-(void) pauseGame {
	[self unschedule:@selector(onSecondPassed)];
	//[pauseLayer showCallback:nil];
}

-(void) resumeGame {
	[self schedule:@selector(onSecondPassed) interval:1];
	//[pauseLayer hideCallback:nil];
}

-(void) quitGame {
	[self.inGameMenu hideMe];
	self.yesNoPanel.closeCallBack = [MyDelegate initWithObj:self selector:@selector(quitInner:)];
	[self.yesNoPanel initInfoText:@" Do you\nwant to\n  quit?" scaleText:0.8];
	[self.yesNoPanel open];
}

-(void) showOptions {
	[self.options open];
	self.options.isTouchEnabled = YES;
	[self.inGameMenu hideMe];
}

- (void) optionsClosed {
	self.options.isTouchEnabled = NO;
	[self.inGameMenu showMe];
}

-(void) nextBoard {
	[self.inGameMenu hideMe];
	self.yesNoPanel.closeCallBack = [MyDelegate initWithObj:self selector:@selector(nextBoardInner:)];
	if (![[Settings sharedInstance] survivalModeEnded])
		[self.yesNoPanel initInfoText:@"Skip \nthis\nboard?" scaleText:0.8];
	else
		[self.yesNoPanel initInfoText:@"This was the\n  last board.\nAre you sure\nyou want to\n      guit?" scaleText:0.5];
	[self.yesNoPanel open];
}

-(void) showScore {
    self.scoreLayer.playerLost = NO;
	self.scoreLayer.time = self.timePassed;
	self.scoreLayer.moves = self.board.movesCounter;
	int score = [self calculateScore];
	
	self.scoreLayer.score = score;
	
	Settings *settings = [Settings sharedInstance];
	
	if (settings.isSurvival)
		settings.survivalScore += score;

	[self.scoreLayer show];
}

-(void) nextLevel {
	Settings *settings = [Settings sharedInstance];
	NSNumber *levelNum = nil;
    int score = [self calculateScore];
    
    [self.inGameMenu resetMenu];
    
    if (self.board.movesCounter > 0) {
        if (!settings.isSurvival) {
            if (score >= [settings getCurrentMinScore])
                levelNum = [NSNumber numberWithInt:settings.currentLevel + 1];
            else
                levelNum = [NSNumber numberWithInt:-1];
        } else
            levelNum = [settings getNextSurvivalLevel];
        
        
        if ([levelNum intValue] <=  MAX_LEVELS && [levelNum intValue] > 0) {
            [self.board clearBoardAndRemoveTextures];
            //[self.scoreLayer resetScoreWithHide:NO];
            NSDictionary *dic = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"BoardLoadingCommand", [NSArray arrayWithObject:levelNum], nil]
                                                            forKeys:[NSArray arrayWithObjects:@"name", @"params", nil]];
            [Notifications notifyForName:[Notifications signalCommand] object:self userInfo:dic];
        } else {
            if ([levelNum intValue] == -1) {//replay level
                [self.inGameMenu hideMe];
                self.timePassed = [settings getCurrentMinTime];
                [self.scoreLayer resetScoreWithHide:NO];
                [self.scoreLayer hide];
            } else if ([levelNum intValue] == -2) {//survival end
                NSDictionary *dic = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"QuitCommand", nil]
                                                                forKeys:[NSArray arrayWithObjects:@"name", nil]];
                [Notifications notifyForName:[Notifications signalCommand] object:self userInfo:dic];
                    
            } else {//Game final
                NSDictionary *dic = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"QuitCommand", nil]
                                                                forKeys:[NSArray arrayWithObjects:@"name", nil]];
                [Notifications notifyForName:[Notifications signalCommand] object:self userInfo:dic];
            }
        }
    } else {
        if (settings.isSurvival) {
            levelNum = [settings getNextSurvivalLevel];
            if ([levelNum intValue] <=  MAX_LEVELS && [levelNum intValue] > 0) {
                [self.board clearBoardAndRemoveTextures];
                //[self.scoreLayer resetScoreWithHide:NO];
                NSDictionary *dic = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"BoardLoadingCommand", [NSArray arrayWithObject:levelNum], nil]
                                                                forKeys:[NSArray arrayWithObjects:@"name", @"params", nil]];
                [Notifications notifyForName:[Notifications signalCommand] object:self userInfo:dic];
             } else if ([levelNum intValue] == -2) {//survival end
                 NSDictionary *dic = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"QuitCommand", nil]
                                                                 forKeys:[NSArray arrayWithObjects:@"name", nil]];
                 [Notifications notifyForName:[Notifications signalCommand] object:self userInfo:dic];
             }
        } else {//replay
            [self.board prepareSceneWidth:(STD_RESOLUTION_WIDTH * SCALE_FACTOR) height:(STD_RESOLUTION_HEIGHT * SCALE_FACTOR) rows:BOARD_ROWS columns:BOARD_COLUMNS];
            [self.board prepareBoard];
            [self.inGameMenu hideMe];
            self.timePassed = [settings getCurrentMinTime];
            [self.scoreLayer resetScoreWithHide:NO];
            [self.scoreLayer hide];
        }
    }
}

- (void) movesToZero {
    [self playerLostLevel];
}

- (void) timeToZero {
    [self playerLostLevel];
}

-(void) playerLostLevel {
    [[SimpleAudioEngine sharedEngine] playEffect:@"stageFail.mp3"];
    [self.inGameMenu hideMe];
    [self.board dissallowDrag];
    [self.board cancelHelpingFunctionNotification:nil];
    self.scoreLayer.playerLost = YES;
    [self unschedule:@selector(onSecondPassed)];
    [self.scoreLayer show];
    [self schedule:@selector(lostScoreBoardShown) interval:0.89];
}

-(void) lostScoreBoardShown {
    [self unschedule:@selector(lostScoreBoardShown)];
    [self.board clearBoard];
}

#pragma mark Final Callbaks
- (void) quitReal {
	[self.board clearBoardAndRemoveTextures];
	NSDictionary *dic = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"QuitCommand", nil]
													forKeys:[NSArray arrayWithObjects:@"name", nil]];
	[Notifications notifyForName:[Notifications signalCommand] object:self userInfo:dic];
}
- (void) boardArrangedReal {
	if (self.topBoardLayer.isCatAnimating)
		[self hideAnimatedCat];
	[self.topBoardLayer showBubble];
    [[SimpleAudioEngine sharedEngine] playEffect:@"stageComplete.mp3"];
	[self.inGameMenu hideMe];
}

- (void) nextBoardReal {
	[self.board clearBoardAndRemoveTextures];
	[self nextLevel];
}

#pragma mark Animated Cat
- (void) showAnimatedCat {
	[self schedule:@selector(hideAnimatedCat) interval:3.2];
	[self.topBoardLayer showAnimatedCat];
}

- (void) hideAnimatedCat {
	[self unschedule:@selector(hideAnimatedCat)];
	[self.topBoardLayer hideAnimatedCat];
}

#pragma mark Misc
-(void) onSecondPassed {
	self.timePassed--;
	
	[Notifications notifyForName:[Notifications updateStageTime] object:self userInfo:
	 [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:timePassed] forKey:@"timePassed"]];
    
    if (self.timePassed == 0) {
        [self timeToZero];
    } else if (self.timePassed % ANIMATED_CAT_INTERVAL == 0)
            [self showAnimatedCat];
}

-(void) setLevel:(int)value {
	self.board.level = value;
	self.topBoardLayer.level = value;
}
-(int) level {
	return self.board.level;
}

- (int) calculateScore {
	int timeScore = (int)(timePassed * SCORE_PER_SEC);
	int movesScore = (int)(board.movesCounter * SCORE_PER_MOVE);
    int totalScore = timeScore + movesScore;
    
	return totalScore;
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	[self.board release];
	[self.inGameMenu release];
	[self.yesNoPanel release];
	[self.topBoardLayer release];
    [self.scoreLayer release];
    [self.options release];
     
	[super dealloc];
}
@end
