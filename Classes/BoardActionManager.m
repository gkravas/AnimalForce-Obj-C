//
//  BoardActionManager.m
//  Splitboard
//
//  Created by George Kravas on 3/30/10.
//  Copyright 2010 Protractor Game. All rights reserved.
//

#import "BoardActionManager.h"


@implementation BoardActionManager
@synthesize tiles;
@synthesize actionCompleteCnt;
@synthesize emptyTile;
@synthesize showBoardCompleteCB;
@synthesize hideBoardCompleteCB;
@synthesize shuffleBoardCompleteCB;
@synthesize goToOriginalStateCompleteCB;
@synthesize goToCurrentStateCompleteCB;
@synthesize shuffledIndeces;

+(id) initWithTiles:(NSMutableArray*)tiles {
	BoardActionManager *obj = [BoardActionManager new];
	obj.tiles = tiles;
	return obj;
}
//SHOWING
-(void) showBoardBegining {
	self.actionCompleteCnt = 0;
	[self markTileForShowIndex:self.actionCompleteCnt callback:[MyDelegate initWithObj:self selector:@selector(showTileComplete)]];
}

-(void) showTileComplete {
	self.actionCompleteCnt++;
	if (([self.tiles count] - 1) > self.actionCompleteCnt)
		[self markTileForShowIndex:self.actionCompleteCnt callback:[MyDelegate initWithObj:self selector:@selector(showTileComplete)]];
	else {
		[self markTileForShowIndex:self.actionCompleteCnt callback:self.showBoardCompleteCB];
	}

}
//END SHOWING
//HIDING
-(void) hideBoardEnding {
	self.actionCompleteCnt = 11;
	[self markTileForHideIndex:self.actionCompleteCnt callback:[MyDelegate initWithObj:self selector:@selector(hideTileComplete)]];
}

-(void) hideTileComplete {
	self.actionCompleteCnt--;
	if (0 < self.actionCompleteCnt)
		[self markTileForHideIndex:self.actionCompleteCnt callback:[MyDelegate initWithObj:self selector:@selector(hideTileComplete)]];
	else {
		[self markTileForHideIndex:self.actionCompleteCnt callback:self.hideBoardCompleteCB];
	}
	
}
//END HIDING
//TILE ACTION MARKING
-(void) markTileForShowIndex:(int)index callback:(MyDelegate*)callback {
	TileSprite *tile = [self.tiles objectAtIndex:index];
	[tile showCallback:callback];
}

-(void) markTileForHideIndex:(int)index callback:(MyDelegate*)callback {
	TileSprite *tile = [self.tiles objectAtIndex:index];
	[tile hideCallback:callback];
}

-(void) markTileForMovementIndex:(int)index position:(CGPoint)position callback:(MyDelegate*)callback {
	TileSprite *tile = [self.tiles objectAtIndex:index];
	[tile goToPosition:position callback:callback];
}
-(void) markTileForMovementToOriginalPositionIndex:(int)index callback:(MyDelegate*)callback {
	TileSprite *tile = [self.tiles objectAtIndex:index];
	[tile goToOriginalPositionCallback:callback];
}
-(void) markTileForMovementToCurrentPositionIndex:(int)index callback:(MyDelegate*)callback {
	TileSprite *tile = [self.tiles objectAtIndex:index];
	[tile goToPosition:tile.currentPosition callback:callback];
}
//SHUFFLING
-(void) initialShuffleArray:(NSMutableArray*)array {
	self.shuffledIndeces = array;
	[self markTileForHideIndex:([self.tiles indexOfObject:self.emptyTile]) callback:[MyDelegate initWithObj:self selector:@selector(initialShuffleFirstTileHidden)]];
}

-(void) initialShuffleFirstTileHidden {
	int i;
	for (i = 0; i < [self.tiles count] - 2; i++) {
		[self markTileForMovementIndex:i position:(CGPointFromString([self.shuffledIndeces objectAtIndex:i])) callback:nil];
	}
	[self markTileForMovementIndex:i position:(CGPointFromString([self.shuffledIndeces objectAtIndex:i])) callback:[MyDelegate initWithObj:self selector:@selector(initialShuffleComplete)]];
}
-(void) initialShuffleComplete {
	//[self.shuffledIndeces release];
	[self.shuffleBoardCompleteCB invokeWithParams:nil];
}
//END SHUFFLING
//BOARD GO TO ORIGINAL STATE
-(void) goToOriginalState {
	for (int i = 0; i < [self.tiles count]; i++) {
		if ([[self.tiles objectAtIndex:i] isEqual:self.emptyTile])
			continue;
		[self markTileForMovementToOriginalPositionIndex:i callback:nil];
	}
	[self markTileForMovementToOriginalPositionIndex:([self.tiles indexOfObject:self.emptyTile]) callback:[MyDelegate initWithObj:self selector:@selector(allTilesWentToOriginalPosition)]];
}
-(void) allTilesWentToOriginalPosition {
	[self markTileForShowIndex:([self.tiles indexOfObject:self.emptyTile]) callback:[MyDelegate initWithObj:self selector:@selector(goToOriginalStateComplete)]];
}
	
-(void) goToOriginalStateComplete {
	[self.goToOriginalStateCompleteCB invokeWithParams:nil];
}
//END BOARD GO TO ORIGINAL STATE

//RETURN TO CURRENT STATE
-(void) goToCurrentState {
	int i;
	for (i = 0; i < [tiles count] - 1; i++) {
		[self markTileForMovementToCurrentPositionIndex:i callback:nil];
	}
	[self markTileForMovementToCurrentPositionIndex:i callback:[MyDelegate initWithObj:self selector:@selector(goToCurrentStateAlmostComplete)]];
}
-(void) goToCurrentStateAlmostComplete {
	[self markTileForHideIndex:([tiles indexOfObject:emptyTile]) callback:[MyDelegate initWithObj:self selector:@selector(goToCurrentStateComplete)]];
}
-(void) goToCurrentStateComplete {
	if (self.goToCurrentStateCompleteCB == nil) return;
	[self.goToCurrentStateCompleteCB invokeWithParams:nil];
}

-(void) dealloc {
	[self.tiles release];
	[super dealloc];
}
@end
