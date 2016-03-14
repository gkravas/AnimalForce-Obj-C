//
//  BoardActionManager.h
//  Splitboard
//
//  Created by George Kravas on 3/30/10.
//  Copyright 2010 Protractor Games. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TileSprite.h"
#import "MyDelegate.h"

@interface BoardActionManager : NSObject {
		NSMutableArray *tiles;
		TileSprite *emptyTile;
		int actionCompleteCnt;
		MyDelegate *showBoardCompleteCB;
		MyDelegate *hideBoardCompleteCB;
		MyDelegate *shuffleBoardCompleteCB;
		MyDelegate *goToOriginalStateCompleteCB;
		MyDelegate *goToCurrentStateCompleteCB;
		NSMutableArray *shuffledIndeces;
}

+(id) initWithTiles:(NSMutableArray*)tiles;
//HIDE
-(void) showBoardBegining;
-(void) showTileComplete;
//SHOW
-(void) hideBoardEnding;
-(void) hideTileComplete;
//ACTION MARKING
-(void) markTileForShowIndex:(int)index callback:(MyDelegate*)callback;
-(void) markTileForHideIndex:(int)index callback:(MyDelegate*)callback;
-(void) markTileForMovementIndex:(int)index position:(CGPoint)position callback:(MyDelegate*)callback;
//SHUFFLE
-(void) initialShuffleArray:(NSMutableArray*)array;
-(void) initialShuffleFirstTileHidden;
-(void) initialShuffleComplete;
//GO TO ORIGINAL STATE
-(void) goToOriginalState;
-(void) goToOriginalStateComplete;
//RETURN TO CURRENT STATE
-(void) goToCurrentState;
-(void) goToCurrentStateAlmostComplete;
-(void) goToCurrentStateComplete;

@property (nonatomic, retain) NSMutableArray *tiles;
@property (nonatomic, retain) TileSprite *emptyTile;
@property int actionCompleteCnt;
@property (nonatomic, retain) MyDelegate *showBoardCompleteCB;
@property (nonatomic, retain) MyDelegate *hideBoardCompleteCB;
@property (nonatomic, retain) MyDelegate *shuffleBoardCompleteCB;
@property (nonatomic, retain) MyDelegate *goToOriginalStateCompleteCB;
@property (nonatomic, retain) MyDelegate *goToCurrentStateCompleteCB;
@property (nonatomic, retain) NSMutableArray *shuffledIndeces;

@end
