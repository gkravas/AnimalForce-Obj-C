//
//  BoardLayer.h
//  Splitboard
//
//  Created by George Kravas on 3/26/10.
//  Copyright 2010 Protractor Games. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "ImageSlicer.h"
#import "BoardActionManager.h"
#import "Settings.h"
#import "Notifications.h"
#import "HelpingFunction.h"
#import "TileSprite.h"
#import "SwapTiles.h"
#import "ChangeEmptyTile.h"
#import "GameConfig.h"
#import "AssetUtil.h"

@interface BoardLayer : CCLayer {
    NSMutableArray *tiles;
    NSArray *draggingTiles;
    NSMutableArray *draggingTilesInitialCoords;
    int tileRows;
    int tileColumns;
    //CGSize size;
    BoardActionManager *boardActionManager;
    //Draging
    BOOL isDragEnabled;
    TileSprite *draggingTile;
    CGPoint lastTouchPoint;
    TileSprite *emptyTile;
    MyDelegate *isArrangedCB;
    //Helping functions
    HelpingFunction *currentHF;
    SwapTiles *swapTilesHF;
    ChangeEmptyTile *changeEmptyTileHF;
    //Tap
    BOOL isTapEnabled;
    TileSprite *tappedTile;
    TileSprite *touchedTile;
    //UI INFO
    int movesCounter;
    int tileMovementDirection;
    BOOL isTouching;
    CCSprite *bubble;
    int level;
    CGPoint draggingTileInitPos;
}

typedef enum
{
	tileMovingLeft = 0,
	tileMovingRight = 1,
	tileMovingUp = 2,
	tileMovingDown = 3,
} eTileMovementDirection;

//NOTIFICATIONS
-(void) prepareNotifications;
//HELPING FUNCTIONS
-(void) prepareHelpingFunctions;

-(void) prepareSceneWidth:(int)width height:(int)height rows:(int)rows columns:(int)columns;
-(void) prepareBoard;
-(void) clearBoard;
-(void) clearBoardAndRemoveTextures;
-(void) showBoardBeginingCallback:(MyDelegate*)callback;
-(void) hideBoardEndingCallback:(MyDelegate*)callback;
-(void) shuffleCallback:(MyDelegate*)callback;
-(NSMutableArray*) shuffleArray:(NSMutableArray*)array;
-(void) goToOriginalStateCallback:(MyDelegate*)callback;
-(void) goToCurrentStateCallback:(MyDelegate*)callback;
-(void) startGame;
-(void) endGame;
-(void) restartGame;
//GET CHILDREN
-(TileSprite*) getFirstSpriteUnderPoint:(CGPoint)point;
-(NSArray*) getChildrenOnRow:(int)row;
-(NSArray*) getChildrenOnColumn:(int)column;
//GENERATE DRAG RECTANGLE
-(CGRect) getDragRectangeForTile:(TileSprite*)tile;
//TAPS
-(void) allowTap;
-(void) dissallowTap;
-(void) tapBeganTile:(TileSprite*)tile;
-(void) tapUpdateDP:(CGPoint)dp;
-(void) tapEndedTile:(TileSprite*)tile;
//CALLBACK
-(void) tileTapped:(TileSprite*)tile;
//DRAG
-(void) allowDrag;
-(void) dissallowDrag;
-(BOOL) isValidForDraggingTile:(TileSprite*)tile;
-(BOOL) dragBeganTile:(TileSprite*)tile;
-(void) dragUpdateDP:(CGPoint)dp;
-(void) dragEndedTile:(TileSprite*)tile;
-(void) detectMovingDirection:(CGPoint)point;
//SNAPPING
-(void) onSnapComplete;
//CHECKS IF SOLVED
-(BOOL) isArranged;
-(void) checkMoves;
//NOTIFICATIONS
//SHOW BOARD
-(void) showBoardNotification:(NSNotification*)notification;
-(void) showBoardAlmostComplete;
-(void) notifyAfterShowBoard;
-(void) showEmptyTileCB:(MyDelegate*)callback;
//RESHUFFLE
-(void) reShuffleNotification:(NSNotification*)notification;
-(void) reShuffleAlmostComplete;
-(void) reShuffleComplete;
//SWAP TILES
-(void) swapTilesNotification:(NSNotification*)notification;
-(void) swapTilesStart;
-(void) swapTilesComplete;
//CHANGE EMPTY TILES
-(void) changeEmptyTileNotification:(NSNotification*)notification;
-(void) changeEmptyTileStart;
-(void) changeEmptyTileComplete;
//HELPING FUNCTIONS
-(void) engageHelpingFunctionNotification:(NSNotification*)notification;
-(void) cancelHelpingFunctionNotification:(NSNotification*)notification;
//END NOTIFICATIONS

@property (nonatomic, retain) NSMutableArray *tiles;
@property (nonatomic, retain) NSArray *draggingTiles;
@property (nonatomic, retain) NSMutableArray *draggingTilesInitialCoords;
@property int tileRows;
@property int tileColumns;
@property (nonatomic, retain) BoardActionManager *boardActionManager;
//Draging
@property BOOL isDragEnabled;
@property (nonatomic, retain) TileSprite *draggingTile;
@property CGPoint lastTouchPoint;
@property (nonatomic, retain) TileSprite *emptyTile;
@property (nonatomic, retain) MyDelegate *isArrangedCB;
//Helping functions
@property (nonatomic, retain) HelpingFunction *currentHF;
@property (nonatomic, retain) SwapTiles *swapTilesHF;
@property (nonatomic, retain) ChangeEmptyTile *changeEmptyTileHF;
//Tap
@property BOOL isTapEnabled;
@property (nonatomic, retain) TileSprite *tappedTile;
@property (nonatomic, retain) TileSprite *touchedTile;
//UI INFO
@property int movesCounter;
@property int tileMovementDirection;
@property BOOL isTouching;
@property (nonatomic, retain) CCSprite *bubble;
@property int level;
@property CGPoint draggingTileInitPos;

@end
