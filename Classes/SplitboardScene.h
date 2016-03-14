
// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "BoardLayer.h"
#import "InGameMenu.h"
#import "YesNoPanel.h"
#import "ScoreLayer.h"
#import "OptionsLayer.h"
#import "Notifications.h"
#import "GameConfig.h"
#import "TopBoardLayer.h"
#import "Settings.h"

// HelloWorld Layer
@interface SplitboardScene : CCScene {
	BoardLayer *board;
	InGameMenu *inGameMenu;
	YesNoPanel *yesNoPanel;
	ScoreLayer *scoreLayer;
	OptionsLayer *options;
	int sceneState;
	TopBoardLayer *topBoardLayer;
	int timePassed;
}

typedef enum {
	QUIT,
	BOARD_ARRANGED,
	NEXT_BOARD
} SplitboardSceneState;

-(void) createNotifications;
// returns a Scene that contains the Splitboard as the only child
-(void) createBoard;
-(void) createInGameMenu;
-(void) createYesNoPanel;
-(void) createTopBoardLayer;
-(void) createOptionsLayer;
-(void) createScoreLayer;
-(void) preInit;
-(void) initBoard;
-(void) restartLevel;
-(void) shuffle;
-(void) goToOriginalState;
-(void) hide;
#pragma mark Inner Callbacks
-(void) quitInner:(NSString*)result;
-(void) nextBoardInner:(NSString*)result;
#pragma mark Game States
-(void) startGame;
-(void) restartGame;
-(void) onBoardArranged;
-(void) pauseGame;
-(void) resumeGame;
-(void) quitGame;
-(void) nextBoard;
-(void) movesToZero;
-(void) timeToZero;
-(void) playerLostLevel;
-(void) lostScoreBoardShown;
-(void) showScore;
#pragma mark Final Callbaks
- (void) quitReal;
- (void) boardArrangedReal;
- (void) nextBoardReal;
#pragma mark Animated Cat
- (void) showAnimatedCat;
- (void) hideAnimatedCat;
#pragma mark Misc
- (void) onSecondPassed;
- (int) calculateScore;

#pragma mark SETTERS
-(void) setLevel:(int)value;

#pragma mark GETTERS
-(int) level;
@property (nonatomic, retain) BoardLayer *board;
@property (nonatomic, retain) InGameMenu *inGameMenu;
@property (nonatomic, retain) YesNoPanel *yesNoPanel;
@property (nonatomic, retain) ScoreLayer *scoreLayer;
@property (nonatomic, retain) OptionsLayer *options;
@property int sceneState;
@property int timePassed;
@property (nonatomic, retain) TopBoardLayer *topBoardLayer;

@end
