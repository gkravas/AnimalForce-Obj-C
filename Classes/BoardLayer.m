//
//  BoardLayer.m
//  Splitboard
//
//  Created by George Kravas on 3/26/10.
//  Copyright 2010 Protractor Games. All rights reserved.
//

#import "BoardLayer.h"

@implementation BoardLayer

@synthesize tiles, tileRows, tileColumns, draggingTilesInitialCoords, boardActionManager, isArrangedCB, emptyTile, bubble, level, draggingTiles, isDragEnabled, draggingTile, lastTouchPoint, currentHF, swapTilesHF, changeEmptyTileHF, isTapEnabled, tappedTile, touchedTile, movesCounter, tileMovementDirection, isTouching, draggingTileInitPos;

#pragma mark Basic Staff
-(id) init {
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self = [super init] )) {
		self.isTouchEnabled = YES;
		//imgSlicer = [ImageSlicer new];
		self.tiles =[NSMutableArray array];
		self.boardActionManager = [BoardActionManager initWithTiles:tiles];
		//NOTIFICATIONS
		[self prepareNotifications];
		//HELPING FUNCTIONS
		[self prepareHelpingFunctions];
	}
	return self;
}
//NOTIFICATIONS
-(void) prepareNotifications {
	[Notifications addNotificationName:[Notifications showBoard] object:self selector:@selector(showBoardNotification:)];
	[Notifications addNotificationName:[Notifications reshuffle] object:self selector:@selector(reShuffleNotification:)];
	[Notifications addNotificationName:[Notifications swapTiles] object:self selector:@selector(swapTilesNotification:)];
	[Notifications addNotificationName:[Notifications changeEmptyTile] object:self selector:@selector(changeEmptyTileNotification:)];
	
	[Notifications addNotificationName:[Notifications engageHelpingFunction] object:self selector:@selector(engageHelpingFunctionNotification:)];
	[Notifications addNotificationName:[Notifications cancelHelpingFunction] object:self selector:@selector(cancelHelpingFunctionNotification:)];
}
//HELPING FUNCTIONS
-(void) prepareHelpingFunctions {
	self.swapTilesHF = [SwapTiles initWithCallbacksOnStart:[MyDelegate initWithObj:self selector:@selector(swapTilesStart)]
											    onEnd:[MyDelegate initWithObj:self selector:@selector(swapTilesComplete)]];
	self.changeEmptyTileHF = [ChangeEmptyTile initWithCallbacksOnStart:[MyDelegate initWithObj:self selector:@selector(changeEmptyTileStart)]
											    onEnd:[MyDelegate initWithObj:self selector:@selector(changeEmptyTileComplete)]];
}

-(void) prepareSceneWidth:(int)width height:(int)height rows:(int)rows columns:(int)columns {
	//size = CGSizeMake(width, height);
	self.isTouching = NO;
	self.tileRows = rows;
	self.tileColumns = columns;
	
	for (int i = 0; i < rows ; i++) {
		for (int j = 0; j < columns ; j++) {
			TileSprite *tile = [TileSprite node];
			[tile defineTotalTilesTilesOnX:columns tilesOnY:rows];
			[tile defineOriginalPostion:CGPointMake(j, i)];
			[self addChild:tile];
			//[tile goToOriginalPositionCallback:nil];
			[self.tiles addObject:tile];
		}
	}
}

-(void) prepareBoard {
	for (int i = 0; i < [self.tiles count] ; i++) {
		TileSprite *tile = [self.tiles objectAtIndex:i];
		//Both arrays point to the accordinate objects without the need to search
		[tile confingureAnimationForIndex:i];
		[tile setToOriginalPosition];
		[tile setOpacity:0];
	}
	self.emptyTile = [self.tiles objectAtIndex:[self.tiles count] - 1];
	self.boardActionManager.emptyTile = self.emptyTile;
	//[changeEmptyTileHF setBoardEmptyTile:self.emptyTile];
    Settings *set = [Settings sharedInstance];
	self.movesCounter = (set.isSurvival) ? SURVIVAL_MOVES : [set getCurrentMaxMoves];
}

-(void) clearBoard {
	for (int i = 0; i < [self.tiles count] ; i++) {
		TileSprite *tile = [self.tiles objectAtIndex:i];
		[tile stopAnimation];
		[tile removeAllChildrenWithCleanup:YES];
        [self removeChild:tile cleanup:YES];
	}
    [self.tiles removeAllObjects];
}

-(void) clearBoardAndRemoveTextures {
	NSLog(@"clear textures");
	CCAnimationCache *animationCache = [CCAnimationCache sharedAnimationCache];
	for (int i = 0; i < [self.tiles count] ; i++) {
		TileSprite *tile = [self.tiles objectAtIndex:i];
		[tile stopAnimation];
        [tile removeAllChildrenWithCleanup:YES];
		[animationCache removeAnimationByName:[NSString stringWithFormat:@"%@%d", DEFAULT_ANIM, i]];
        [self removeChild:tile cleanup:YES];
	}
	[self.tiles removeAllObjects];
    
	int sheets = (self.level > 1 && level != 7) ? 3 : 2;
	[AssetUtil unloadSpritePack:[NSString stringWithFormat:@"level%d_", self.level, nil] sheets:sheets];
}

-(void) shuffleCallback:(MyDelegate*)callback {
	self.boardActionManager.shuffleBoardCompleteCB = callback;
	NSMutableArray *arr = [NSMutableArray array];
	for (int i = 0; i < self.tileColumns; i++)
		for (int j = 0; j < self.tileRows; j++)
			[arr addObject:[NSString stringWithFormat:@"{%i,%i}", i, j]];
	[arr removeLastObject];
	[self.boardActionManager initialShuffleArray:[self shuffleArray:arr]];
}

-(NSMutableArray*) shuffleArray:(NSMutableArray*)array {
	NSMutableArray* arrFinal = [NSMutableArray array];
	int index;
	while ([array count] > 0) {
		index = arc4random()%[array count];
		id obj = [array objectAtIndex:index];
		[array removeObjectAtIndex:index];
		[arrFinal addObject:obj];
	}
	return arrFinal;
}

#pragma mark Callbacks
-(void) showBoardBeginingCallback:(MyDelegate*)callback {
	self.boardActionManager.showBoardCompleteCB = callback;
	[self.boardActionManager showBoardBegining];
}
-(void) hideBoardEndingCallback:(MyDelegate*)callback {
	self.boardActionManager.hideBoardCompleteCB = callback;
	[self.boardActionManager hideBoardEnding];
}
-(void) goToOriginalStateCallback:(MyDelegate*)callback {
	self.boardActionManager.goToOriginalStateCompleteCB = callback;
	[self.boardActionManager goToOriginalState];
}
-(void) goToCurrentStateCallback:(MyDelegate*)callback {
	self.boardActionManager.goToCurrentStateCompleteCB = callback;
	[self.boardActionManager goToCurrentState];
}

#pragma mark Start End Game
-(void) startGame {
	[self allowDrag];
}
-(void) endGame {
	[self dissallowDrag];
	[self.isArrangedCB invokeWithParams:nil];
}
-(void) restartGame {
    Settings *set = [Settings sharedInstance];
	self.movesCounter = (set.isSurvival) ? SURVIVAL_MOVES : [set getCurrentMaxMoves];
    [self allowDrag];
}

#pragma mark Get childrer functions
-(TileSprite*) getFirstSpriteUnderPoint:(CGPoint)point {
	CCArray *arr = self.children;
	TileSprite *tile;
	CGRect bbox;
	NSUInteger i, count = [arr count];
	for (i = 0; i < count; i++) {
		tile = [arr objectAtIndex:i];
		bbox = tile.boundingBox;
		//NSLog(@"Tile %i from %f,%f to %f,%f", i, bbox.origin.x, bbox.origin.y, bbox.origin.x + bbox.size.width, bbox.origin.y + bbox.size.height);
		if (CGRectContainsPoint(bbox, point))
			return tile;
	}
	return nil;
}
-(NSArray*) getChildrenOnRow:(int)row {
	//[self.draggingTilesInitialCoords release];
	self.draggingTilesInitialCoords = [NSMutableArray array];
	NSMutableArray *arr = [NSMutableArray array];
	TileSprite *tile;
	
	for (tile in self.tiles) {
		if (tile.currentPosition.y == row) {
			[self.draggingTilesInitialCoords addObject:[NSValue valueWithCGPoint:tile.currentPosition]];
			if (![tile isEqual:self.emptyTile] && ![tile isEqual:self.draggingTile]) 
				[arr addObject:tile];
		}
	}
	return [NSArray arrayWithArray:arr];
}

-(NSArray*) getChildrenOnColumn:(int)column {
	//[self.draggingTilesInitialCoords release];
	self.draggingTilesInitialCoords = [NSMutableArray array];
	NSMutableArray *arr = [NSMutableArray array];
	TileSprite *tile;
	
	for (tile in tiles) {
		if (tile.currentPosition.x == column) {
			[self.draggingTilesInitialCoords addObject:[NSValue valueWithCGPoint:tile.currentPosition]];
			if (![tile isEqual:self.emptyTile] && ![tile isEqual:self.draggingTile]) 
				[arr addObject:tile];
		}
	}
	return [NSArray arrayWithArray:arr];
}

//GENERATE DRAG RECTANGLE
-(CGRect) getDragRectangeForTile:(TileSprite*)tile {
	CGRect rect;
	int dx, dy;
	dx = tile.currentPosition.x - emptyTile.currentPosition.x;
	dy = tile.currentPosition.y - emptyTile.currentPosition.y;
	//if (dx == -1) {
	if (dx < 0) {
		//NSLog(@"Move to right");
		rect = CGRectMake(tile.boundingBox.origin.x, tile.boundingBox.origin.y, tile.boundingBox.size.width + 0.5, 0);
	//} else if(dx == 1) {
	} else if(dx > 0) {
		//NSLog(@"Move to left");
		//rect = CGRectMake(emptyTile.boundingBox.origin.x, emptyTile.boundingBox.origin.y, draggingTile.boundingBox.size.width + 0.5, 0);
		rect = CGRectMake(tile.boundingBox.origin.x - tile.boundingBox.size.width - 0.5, tile.boundingBox.origin.y, tile.boundingBox.size.width, 0);
	//} else if(dy == 1) {
	} else if(dy > 0) {
		//NSLog(@"Move to up");
		rect = CGRectMake(tile.boundingBox.origin.x, tile.boundingBox.origin.y, 0, tile.boundingBox.size.height + 0.5);
	//} else if(dy == -1) {
	} else if(dy < 0) {
		//NSLog(@"Move to down");
		//rect = CGRectMake(emptyTile.boundingBox.origin.x, emptyTile.boundingBox.origin.y, 0, draggingTile.boundingBox.size.height + 0.5);
		rect = CGRectMake(tile.boundingBox.origin.x, tile.boundingBox.origin.y - tile.boundingBox.size.height - 0.5, 0, tile.boundingBox.size.height);
	}
	//NSLog(@"Drag rect from %f,%f to %f,%f", rect.origin.x, rect.origin.y, rect.origin.x + rect.size.width, rect.origin.y + rect.size.height);
	return rect;
}


//DRAG AND TAP MANAGEMENT
-(void) onEnter {
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
	[super onEnter];
}
-(void) onExit {
	[[CCTouchDispatcher sharedDispatcher] removeDelegate:self];
	[super onExit];
}
#pragma mark Touch
-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
	if (self.isTouching)
		return NO;
	
	CGPoint point = [self convertTouchToNodeSpace:touch];
	self.touchedTile = [self getFirstSpriteUnderPoint:point];
    
    //NSLog(@"%f, %f", self.touchedTile.currentPosition.x, self.touchedTile.currentPosition.y);
    //NSLog(@"%f, %f", self.touchedTile.originalPosition.x, self.touchedTile.originalPosition.y);
	self.lastTouchPoint = point;
	if ([self.touchedTile isEqual:self.emptyTile])
		return NO;
	if (self.isTapEnabled)
		[self tapBeganTile:self.touchedTile];
	if (self.isDragEnabled)
		return [self dragBeganTile:self.touchedTile];
	
	self.isTouching = (self.touchedTile != nil);
	return self.isTouching;
}

-(void) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
	CGPoint point = [self convertTouchToNodeSpace:touch];
	CCSprite *tile = [self getFirstSpriteUnderPoint:point];
	//check if moved tile is tha same as touched tile
	if ([tile isEqual:nil]) {//![draggingTile isEqual:tile] || 
		NSLog(@"draggingTile != tile");
		return;
	}
    
	[self detectMovingDirection:point];
	
	//dx and dy for movement update
	CGPoint dp = CGPointMake(point.x - self.lastTouchPoint.x, point.y - self.lastTouchPoint.y);
	self.lastTouchPoint = point;
	if (self.isTapEnabled)
		[self tapUpdateDP:dp];
	if (self.isDragEnabled)
		[self dragUpdateDP:dp];
}
-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
	CGPoint point = [self convertTouchToNodeSpace:touch];
	TileSprite *touchedTileNow = [self getFirstSpriteUnderPoint:point];
	//Finger my stay on the same position
	//if (isTapEnabled && CGPointEqualToPoint(firstTouchPoint, point))
	if (self.isTapEnabled && [touchedTileNow isEqual:self.touchedTile])
		[self tapEndedTile:touchedTile];
	else if (self.isDragEnabled)
		[self dragEndedTile:touchedTile];
	self.isTouching = NO;
}

#pragma mark Drag
-(void) allowDrag {
	self.isDragEnabled = YES;
}

-(void) dissallowDrag {
	self.isDragEnabled = NO;
}

-(BOOL) dragBeganTile:(TileSprite*)tile {
	if (tile == nil) return NO;
	if (self.draggingTile == nil) {
		NSLog(@"New tile");
		if (![self isValidForDraggingTile:tile]) return NO;
		self.draggingTile = tile;
		CGRect dragArea = [self getDragRectangeForTile:self.draggingTile];
		[self.draggingTile startDragArea:dragArea];
        self.draggingTileInitPos = CGPointMake(touchedTile.position.x, touchedTile.position.y);
	} else if (self.draggingTile != tile) {
		NSLog(@"Old tile not touched");
		return NO;
	} else if (self.draggingTile == tile) {
		NSLog(@"Old tile touched");
		return YES;
	}
    
	//Get the tiles in column or row
	if (self.touchedTile.currentPosition.y == self.emptyTile.currentPosition.y)//same row
		self.draggingTiles = [[self getChildrenOnRow:self.touchedTile.currentPosition.y] retain];
	else if (self.touchedTile.currentPosition.x == self.emptyTile.currentPosition.x)//same column
		self.draggingTiles = [[self getChildrenOnColumn:self.touchedTile.currentPosition.x] retain];

	TileSprite *tileSprite;
	for (tileSprite in self.draggingTiles)
		[tileSprite startDragArea:[self getDragRectangeForTile:tileSprite]];
	return YES;
}
-(void) dragUpdateDP:(CGPoint)dp {
	if (self.draggingTile == nil)
		return;//May BUG
	[self.draggingTile updateDragDX:dp.x dy:dp.y];
    
    if (!CGPointEqualToPoint(self.draggingTileInitPos, CGPointZero) && !CGPointEqualToPoint(self.draggingTileInitPos, self.draggingTile.position)) {
        self.draggingTileInitPos = CGPointZero;
        [[SimpleAudioEngine sharedEngine] playEffect:@"slide.mp3"];
    }
    
	NSMutableArray *arr = [NSMutableArray arrayWithArray:self.draggingTiles];
	[arr addObject:self.draggingTile];//some times null BUG
	
	TileSprite *tile1, *tile2, *tile3;
	for (tile1 in arr) {
		for (tile2 in self.draggingTiles) {
			//If it is the same tile continue
			if ([tile1 isEqual:tile2])
				continue;
			//If it collides, update position
			if ([tile1 collidesWithTile:tile2]) {
				[tile2 updateDragDX:dp.x dy:dp.y];
				for (tile3 in draggingTiles) {
					//Two collisions max
					if ([tile2 isEqual:tile3])
						continue;
					if ([tile2 collidesWithTile:tile3]) {
						[tile3 updateDragDX:dp.x dy:dp.y];
						return;
					}
				}
			}
		}
	}
}
-(void) dragEndedTile:(TileSprite*)tile {
	if (self.draggingTile == nil)
        return;
    
    if (!CGPointEqualToPoint(self.draggingTileInitPos, CGPointZero))
        return;
    
    [[SimpleAudioEngine sharedEngine] playEffect:@"snap.mp3"];
	if ([Settings sharedInstance].helpSnapping == YES) {
		TileSprite *tile;
		for (tile in self.draggingTiles)
			[tile snapToNearestCallback:nil];
		[self.draggingTile snapToNearestCallback:[MyDelegate initWithObj:self selector:@selector(onSnapComplete)]];
	} else
		[self.draggingTile tryToSnapCallback:[MyDelegate initWithObj:self selector:@selector(onSnapComplete)]];
}

-(void) detectMovingDirection:(CGPoint)point {
	//Calculate the movement direction
	//if (CGPointEqualToPoint(lastTouchPoint, firstTouchPoint)) {
		//moves on horizontal axis
		if (self.touchedTile.currentPosition.y == self.emptyTile.currentPosition.y) {
			if(point.x > self.lastTouchPoint.x)//moving right
				self.tileMovementDirection = tileMovingRight;
			else if (point.x <= lastTouchPoint.x)//moving left
				self.tileMovementDirection = tileMovingLeft;
			//moves on vertical axis
		} else if (touchedTile.currentPosition.x == emptyTile.currentPosition.x) {
			if (point.y > lastTouchPoint.y)//moving up
				self.tileMovementDirection = tileMovingUp;
			else if (point.y <= lastTouchPoint.y)//moving down
				self.tileMovementDirection = tileMovingDown;
		}
	//}
}

#pragma mark Tap
-(void) allowTap {
	self.isTapEnabled = YES;
}

-(void) dissallowTap {
	self.isTapEnabled = NO;
}

-(void) tapBeganTile:(TileSprite*)tile {
	self.tappedTile = tile;
}
-(void) tapUpdateDP:(CGPoint)dp {
}
-(void) tapEndedTile:(TileSprite*)tile {
	[self tileTapped:tile];
}
//CALLBACK
-(void) tileTapped:(TileSprite*)tile {
	if ([self.currentHF isEqual:nil]) return;
	if ([self.currentHF validateTile:tile])
		[Notifications notifyForName:[Notifications helpingFunctionCanBeEngaged] object:self userInfo:nil];
	else
		[Notifications notifyForName:[Notifications helpingFunctionCanNotBeEngaged] object:self userInfo:nil];
}
//END TAP


-(void) onSnapComplete {
	NSMutableArray *arr = [NSMutableArray arrayWithArray:self.draggingTiles];
	[arr addObject:self.draggingTile];
	
	//To update counter
	BOOL atLeastOneTileMoved = NO;
	
	TileSprite *tile;
	NSValue *vPosition;
	CGPoint position;
	for (tile in arr) {
		for (vPosition in self.draggingTilesInitialCoords) {
			position = [vPosition CGPointValue];
			if ([tile isInPosition:position]) {
				//NSLog(@"tile (%0.f, %0.f) to (%0.f, %0.f)", tile.currentPosition.x, tile.currentPosition.y, position.x, position.y);
				[tile setToPosition:position];
				[self.draggingTilesInitialCoords removeObject:vPosition];
				atLeastOneTileMoved = YES;
				break;
			}
		}
	}
	[self.emptyTile setToPosition:[(NSValue*)[self.draggingTilesInitialCoords objectAtIndex:0] CGPointValue]];
	//NSLog(@"Empty tile is in position: %f, %f", emptyTile.currentPosition.x, emptyTile.currentPosition.y);
	
	self.draggingTile = nil;
	//[self.draggingTiles release];
	self.draggingTiles = nil;
	
	//Notifies the coutner
	if (atLeastOneTileMoved) {
		self.movesCounter--;
		[Notifications notifyForName:[Notifications updateMovesCounter] object:self userInfo:
		 [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:self.movesCounter] forKey:@"moves"]];
	}
	
	if ([self isArranged])
		[self endGame];
    else
        [self checkMoves];
}

-(BOOL) isValidForDraggingTile:(TileSprite*)tile {
	int dx, dy;
	dx = abs(tile.currentPosition.x - self.emptyTile.currentPosition.x);
	dy = abs(tile.currentPosition.y - self.emptyTile.currentPosition.y);
	//if ( ((dx == 1) && (dy == 0)) || (dx == 0) && (dy == 1))
	if (dx == 0 || dy == 0)
		return YES;
	else
		return NO;
}

//CHECKS IF SOLVED
-(BOOL) isArranged {
	TileSprite *tile;
	for (tile in self.tiles) {
		if (![tile isInOriginalPosition])
			return NO;
	}
	return YES;
}
-(void) checkMoves {
    if (self.movesCounter == 0) {
        [Notifications notifyForName:[Notifications movesToZero] object:self userInfo:nil];
    }
}
//SHOW BOARD
-(void) showBoardNotification:(NSNotification*)notification {
	[self dissallowDrag];
	[self goToOriginalStateCallback:[MyDelegate initWithObj:self selector:@selector(showBoardAlmostComplete)]];
}
-(void) showBoardAlmostComplete {
	MyDelegate *delegate = [MyDelegate initWithObj:self selector:@selector(notifyAfterShowBoard)];
	[self performSelector:@selector(goToCurrentStateCallback:) withObject:delegate afterDelay:([Settings sharedInstance].showBoardTime)];
	[self performSelector:@selector(allowDrag) withObject:nil afterDelay:([Settings sharedInstance].showBoardTime)];
}

-(void) notifyAfterShowBoard {
	[Notifications notifyForName:[Notifications setActiveSubMenuEnabled] object:self userInfo:
	 [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:@"enabled"]];
}

-(void) showEmptyTileCB:(MyDelegate*)callback {
	[self.boardActionManager markTileForShowIndex:[tiles indexOfObject:emptyTile] callback:callback];
}

//RE SHUFFLE
-(void) reShuffleNotification:(NSNotification*)notification {
	[self dissallowDrag];
	[self goToOriginalStateCallback:[MyDelegate initWithObj:self selector:@selector(reShuffleAlmostComplete)]];
}
-(void) reShuffleAlmostComplete{
	[self shuffleCallback:[MyDelegate initWithObj:self selector:@selector(reShuffleComplete)]];
}
-(void) reShuffleComplete {
	[self allowDrag];
	[Notifications notifyForName:[Notifications setActiveSubMenuEnabled] object:self userInfo:
	 [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:@"enabled"]];
}

//SWAP TILES
-(void) swapTilesNotification:(NSNotification*)notification {
	[self allowTap];
	[self dissallowDrag];
	self.currentHF = self.swapTilesHF;
}
-(void) swapTilesStart {
	[self dissallowTap];
}
-(void) swapTilesComplete {
	[self allowDrag];
	
	if ([self isArranged])
		[self endGame];
}

//CHANGE EMPTY TILE
-(void) changeEmptyTileNotification:(NSNotification*)notification {
	[self allowTap];
	[self dissallowDrag];
	self.currentHF = self.changeEmptyTileHF;
	[self.changeEmptyTileHF setBoardEmptyTile:self.emptyTile];
}
-(void) changeEmptyTileStart {
	[self dissallowTap];
}
-(void) changeEmptyTileComplete {
	[self allowDrag];
	self.emptyTile = self.changeEmptyTileHF.newEmptyTile;
	self.boardActionManager.emptyTile = emptyTile;
}
//HELPING FUNCTIONS
-(void) engageHelpingFunctionNotification:(NSNotification*)notification {
	[self.currentHF start];
}
-(void) cancelHelpingFunctionNotification:(NSNotification*)notification {
	[self.currentHF cancel];
	[self dissallowTap];
	[self allowDrag];
	self.currentHF = nil;
}
//END NOTIFICATIONS
//DEALLOC
-(void) dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[super dealloc];
}
@end
