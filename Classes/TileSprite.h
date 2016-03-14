//
//  TileSprite.h
//  Splitboard
//
//  Created by George Kravas on 3/29/10.
//  Copyright 2010 Protractor Games. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "MyDelegate.h"

@interface TileSprite : CCSprite {
	@public
		CGPoint originalPosition;
		CGPoint currentPosition;
		CGPoint totalTiles;
		MyDelegate *showCompleteCB;
		MyDelegate *hideCompleteCB;
		MyDelegate *goToOriginalPositionCB;
		MyDelegate *goToPositionCB;
		MyDelegate *tryToSnapCB;
		MyDelegate *SnapToNearestCB;
	@private
		CGRect dragArea;
		int lastDX;
		int lastDY;
}
-(void) confingureAnimationForIndex:(int)index;
-(void) stopAnimation;
-(BOOL) isInOriginalPosition;
-(void) defineTotalTilesTilesOnX:(int)tilesOnX tilesOnY:(int)tilesOnY;
-(void) defineOriginalPostion:(CGPoint)position;
-(void) setToOriginalPosition;
-(void) goToOriginalPositionCallback:(MyDelegate*)callback;
-(void) setToPosition:(CGPoint)position;
-(void) goToPosition:(CGPoint)position callback:(MyDelegate*)callback;
-(CGPoint) defineCurrentPostion;
-(BOOL) isInPosition:(CGPoint)position;
-(CGPoint) transformPoint:(CGPoint)point;
-(CGPoint) transformPointBB:(CGPoint)point;
-(BOOL) collidesWithTile:(TileSprite*)tile;
	
-(void) showComplete;
-(void) hideComplete;
-(void) goToOriginalPositionComplete;
-(void) goToPositionComplete;
	
-(void) showCallback:(MyDelegate*)callback;
-(void) hideCallback:(MyDelegate*)callback;
//DRAGGING
-(void) startDragArea:(CGRect)area;
-(int) isTileSnapped;
-(void) updateDragDX:(int)dx dy:(int)dy;
//SNAPPING
-(void) tryToSnapCallback:(MyDelegate*)callback;
-(void) tryToSnapComplete;
-(void) snapToNearestCallback:(MyDelegate*)callback;
-(void) snapToNearestComplete;

@property CGPoint originalPosition;
@property CGPoint currentPosition;
@property CGPoint totalTiles;
@property (nonatomic, retain) MyDelegate *showCompleteCB;
@property (nonatomic, retain) MyDelegate *hideCompleteCB;
@property (nonatomic, retain) MyDelegate *goToOriginalPositionCB;
@property (nonatomic, retain) MyDelegate *goToPositionCB;
@property (nonatomic, retain) MyDelegate *tryToSnapCB;
@property (nonatomic, retain) MyDelegate *SnapToNearestCB;

@end

