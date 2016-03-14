//
//  TileSprite.m
//  Splitboard
//
//  Created by George Kravas on 3/29/10.
//  Copyright 2010 Protractor Games. All rights reserved.
//

#import "TileSprite.h"
#include "GameConfig.h"

//static int const TOTAL_BOARD_HEIGHT = 427;
//static int const PIXEL_OFFSET_SNAP = 10;
static double const SNAP_TIME = 0.05;

@implementation TileSprite

@synthesize originalPosition, currentPosition, totalTiles, showCompleteCB, hideCompleteCB, goToOriginalPositionCB, goToPositionCB, tryToSnapCB, SnapToNearestCB;

-(id) init {
	if( (self = [super init] )) {
		
	}
	return self;
}

-(void) confingureAnimationForIndex:(int)index {
	NSString *animName = [NSString stringWithFormat:@"%@%d", DEFAULT_ANIM, index];
	[self setDisplayFrameWithAnimationName:animName index:0];
	CCAnimation *anim = [[CCAnimationCache sharedAnimationCache] animationByName:animName];
	anim.delay = ANIMATION_DELAY;
	CCRepeatForever *animAction = [CCRepeatForever actionWithAction:[CCAnimate actionWithDuration:2.0 animation:anim restoreOriginalFrame:NO]];
	[animAction setTag:0];
	[self runAction:animAction];
}

-(void) stopAnimation {
	[self stopActionByTag:0];
}

-(BOOL) isInOriginalPosition {
	return CGPointEqualToPoint(originalPosition, currentPosition);
}

-(void) defineTotalTilesTilesOnX:(int)tilesOnX tilesOnY:(int)tilesOnY {
	self.totalTiles = CGPointMake(tilesOnX, tilesOnY);
}

-(void) defineOriginalPostion:(CGPoint)position {
	self.originalPosition = CGPointMake(position.x, position.y);
	self.currentPosition = position;
}

-(void) setToOriginalPosition {
	self.position = [self transformPoint:self.originalPosition];
}

-(void) goToOriginalPositionCallback:(MyDelegate*)callback  {
	CGPoint newPos = [self transformPoint:self.originalPosition];
	self.goToOriginalPositionCB = callback;
	CCSequence *seq = [CCSequence actions:
					   [CCMoveTo actionWithDuration:0.4 position:newPos],
					   [CCCallFunc actionWithTarget:self selector:@selector(goToOriginalPositionComplete)],
					   nil];
	[self runAction:seq];
}

-(void) setToPosition:(CGPoint)position {
	self.currentPosition = position;
	self.position = [self transformPoint:position];
}

-(void) goToPosition:(CGPoint)position callback:(MyDelegate*)callback {
	self.currentPosition = position;
	CGPoint newPos = [self transformPoint:currentPosition];
	self.goToPositionCB = callback;
	CCSequence *seq = [CCSequence actions:
					   [CCMoveTo actionWithDuration:0.4 position:newPos],
					   [CCCallFunc actionWithTarget:self selector:@selector(goToPositionComplete)],
					   nil];
	[self runAction:seq];
}

-(CGPoint) defineCurrentPostion {
	for (int j = 0; j < 4; j++) {
		for (int i = 0; i < 3; i++) {
			CGPoint p = [self transformPointBB:CGPointMake(i, j)];
			if (CGRectContainsPoint(CGRectMake(p.x, p.y, self.boundingBox.size.width, self.boundingBox.size.height), self.position)) {
				return CGPointMake(i, j);
			}
		}
	}
	return self.currentPosition;
}

-(BOOL) isInPosition:(CGPoint)position {
	CGPoint p = [self transformPointBB:CGPointMake(position.x, position.y)];
	CGRect rect = CGRectMake(p.x, p.y, self.boundingBox.size.width, self.boundingBox.size.height);
	//NSLog(@"For point %0.f, %0.f", position.x, position.y);
	//NSLog(@"%0.f,%0.f :: %0.f,%0.f->%0.f,%0.f", self.position.x, self.position.y, rect.origin.x, rect.origin.y, rect.origin.x + rect.size.width, rect.origin.y + rect.size.height);
	return CGRectContainsPoint(rect, self.position);
}

//Transform tile cell position to point position
-(CGPoint) transformPoint:(CGPoint)point {
	CGRect rect = self.boundingBox;
	GLfloat x = (rect.size.width * (point.x + self.anchorPoint.x) + point.x);
	GLfloat y = (rect.size.height * (totalTiles.y - point.y) - point.y + 1);
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        x += 64;
        y += 32;
    }
	return CGPointMake(x, y);
}

-(CGPoint) transformPointBB:(CGPoint)point {
	CGRect rect = self.boundingBox;
	GLfloat x = (rect.size.width * point.x + point.x);
	GLfloat y = (rect.size.height * (totalTiles.y - point.y - self.anchorPoint.y) - point.y + 1);
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        x += 64;
        y += 32;
    }
	return CGPointMake(x, y);
}

- (BOOL) collidesWithTile:(TileSprite*)tile {
	CGRect rect1 = self.boundingBox;
	CGRect rect2 = tile.boundingBox;
	return !CGRectIsNull(CGRectIntersection(rect1, rect2));
}

-(void) showCallback:(MyDelegate*)callback {
	self.showCompleteCB = callback;
	CCSequence *seq = [CCSequence actions:
					   [CCFadeIn actionWithDuration:0.3],
					   [CCCallFunc actionWithTarget:self selector:@selector(showComplete)],
					   nil];
	[self runAction:seq];
}

-(void) hideCallback:(MyDelegate*)callback {
	self.hideCompleteCB = callback;
	CCSequence *seq = [CCSequence actions:
					   [CCFadeOut actionWithDuration:0.3],
					   [CCCallFunc actionWithTarget:self selector:@selector(hideComplete)],
					   nil];
	[self runAction:seq];
}

-(void) showComplete {
	if (self.showCompleteCB == nil) return;
	[self.showCompleteCB invokeWithParams:nil];
	//[self.showCompleteCB release];
	//self.showCompleteCB = nil;
}

-(void) hideComplete {
	if (self.hideCompleteCB == nil) return;
	[self.hideCompleteCB invokeWithParams:nil];
	//[self.hideCompleteCB release];
	//self.hideCompleteCB = nil;
}

-(void) goToOriginalPositionComplete {
	if (self.goToOriginalPositionCB == nil) return;
	[self.goToOriginalPositionCB invokeWithParams:nil];
	//[self.goToOriginalPositionCB release];
	//self.goToOriginalPositionCB = nil;
}

-(void) goToPositionComplete {
	if (self.goToPositionCB == nil) return;
	[self.goToPositionCB invokeWithParams:nil];
	//[self.goToPositionCB release];
	//self.goToPositionCB = nil;
}

//DRAGGING
-(void) startDragArea:(CGRect)area {
	//if (!CGRectIsNull(area))
		dragArea = area;
	
}
//FOR SNAPPING
//SNAPPED ON DIFFERENT POSITION = 1
//SNAPPED ON SAME POSITION = 0
//NOT SNAPPED = -1
//DEPRECATED_ATTRIBUTE
-(int) isTileSnapped {

	CGRect bbox = [self boundingBox];
	
	CGPoint ld = dragArea.origin;
	CGPoint rd = CGPointMake(dragArea.origin.x + dragArea.size.width, dragArea.origin.y);
	CGPoint lu = CGPointMake(dragArea.origin.x, dragArea.origin.y + dragArea.size.height);
	CGPoint ru = CGPointMake(dragArea.origin.x + dragArea.size.width, dragArea.origin.y + dragArea.size.height);
	CGPoint currentBB = [self transformPointBB:currentPosition];
	
	if (CGPointEqualToPoint(bbox.origin, currentBB))
		return 0;
	else if (CGPointEqualToPoint(bbox.origin, ld) | CGPointEqualToPoint(bbox.origin, rd) | CGPointEqualToPoint(bbox.origin, lu) | CGPointEqualToPoint(bbox.origin, ru))
		return 1;
	else
		return -1;
}

-(void) updateDragDX:(int)dx dy:(int)dy {
	CGPoint oldPos = self.position;	
	CGRect bbox = [self boundingBox];
	//lower left
	CGPoint lowerLimit = dragArea.origin;
	//upper Right
	CGPoint upperLimit = CGPointMake(dragArea.origin.x + dragArea.size.width, dragArea.origin.y + dragArea.size.height);
	//LOWER
	
	if (lowerLimit.x > (bbox.origin.x + dx)) {
		dx = (lowerLimit.x - bbox.origin.x);
	} 
	if (upperLimit.x < (bbox.origin.x + dx)) {
		dx = (upperLimit.x - bbox.origin.x);
	} 
	if (lowerLimit.y > (bbox.origin.y + dy)) {
		dy = (lowerLimit.y - bbox.origin.y);
	} 
	if (upperLimit.y < (bbox.origin.y + dy)) {
		dy = (upperLimit.y - bbox.origin.y);
	}
	
	//if ((lowerLimit.x <= (bbox.origin.x + dx)) && (upperLimit.x >= (bbox.origin.x + dx))) {
		oldPos.x += dx;
	//}else if ((lowerLimit.y <= (bbox.origin.y + dy)) && (upperLimit.y >= (bbox.origin.y + dy))) {
		oldPos.y += dy;
	//}
	
	lastDX = dx;
	lastDY = dy;
	//NSLog(@"lastD %i,%i", )
	//else if (lowerLimit.y > (bbox.origin.y + dy))
	//	oldPos.y = lowerLimit.x;
	//else if (upperLimit.y < (bbox.origin.y + dy))
	//	oldPos.y = upperLimit.y;
	self.position = oldPos;
}

//SMAPPING
-(void) tryToSnapCallback:(MyDelegate*)callback {
	CGPoint newPos = CGPointMake(lastDX, lastDY);
	double dur = (lastDX == 0) ? abs(0.03*lastDY) : abs(0.03*lastDX);
	self.SnapToNearestCB = callback;
	CCSequence *seq = [CCSequence actions:
					   [CCMoveBy actionWithDuration:dur position:newPos],
					   [CCCallFunc actionWithTarget:self selector:@selector(snapToNearestComplete)],
					   nil];
	[self runAction:seq];
}
-(void) tryToSnapComplete {
	if (self.tryToSnapCB == nil) return;
	[self.tryToSnapCB invokeWithParams:nil];
	//[self.tryToSnapCB release];
	//self.tryToSnapCB = nil;
}

-(void) snapToNearestCallback:(MyDelegate*)callback {
	int dx = 0;
	int dy = 0;
	//lower left
	CGPoint lowerLimit = dragArea.origin;
	//upper Right
	CGPoint upperLimit = CGPointMake(dragArea.origin.x + dragArea.size.width, dragArea.origin.y + dragArea.size.height);
	CGRect bbox = [self boundingBox];
	
	if (lowerLimit.y == upperLimit.y)
		dx = ( abs(lowerLimit.x - bbox.origin.x) < abs(upperLimit.x - bbox.origin.x)) ? lowerLimit.x - bbox.origin.x : upperLimit.x - bbox.origin.x;
	else if (lowerLimit.x == upperLimit.x)
		dy = ( abs(lowerLimit.y - bbox.origin.y) < abs(upperLimit.y - bbox.origin.y)) ? lowerLimit.y - bbox.origin.y : upperLimit.y - bbox.origin.y;
	
	CGPoint newPos = CGPointMake(dx, dy);
	double dur = SNAP_TIME;//(dx == 0) ? abs(0.03*dy) : abs(0.03*dx);
	self.SnapToNearestCB = callback;
	CCSequence *seq = [CCSequence actions:
					   [CCMoveBy actionWithDuration:dur position:newPos],
					   [CCCallFunc actionWithTarget:self selector:@selector(snapToNearestComplete)],
					   nil];
	[self runAction:seq];
}

-(void) snapToNearestComplete {
	if (self.SnapToNearestCB == nil) return;
	[self.SnapToNearestCB invokeWithParams:nil];
	//[self.SnapToNearestCB release];
	//self.SnapToNearestCB = nil;
}

-(void) dealloc {
	[self.hideCompleteCB release];
    [self.goToOriginalPositionCB release];
	[self.goToPositionCB release];
    [self.tryToSnapCB release];
	[self.SnapToNearestCB release];
    
	[super dealloc];
}
@end
