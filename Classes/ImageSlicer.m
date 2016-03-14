//
//  ImageSlicer.m
//  Splitboard
//
//  Created by George Kravas on 3/24/10.
//  Copyright 2010 Protractor Games. All rights reserved.
//

#import "ImageSlicer.h"

@implementation ImageSlicer

@synthesize currentBoardName, totalFrames, totalSheets, currentBoardColumns, currentBoardRows,
			sheetsLoaded, currentSheet, currentBoardTextures, onProgressUpdateCB, spriteFrames,
			onCompleteCB;

+ (id) slicer {
	return [[[ImageSlicer alloc] init]autorelease];
}

- (void) dealloc {
	[currentBoardName release];
	[currentBoardTextures release];
	[onProgressUpdateCB release];
	[onCompleteCB release];
	[spriteFrames release];
	[super dealloc];
}
//Create all tiles of the board, sets the position too
-(void) sliceTexturesAndCreateAnimation:(NSString*)name sheets:(int)sheets frames:(int)frames columns:(int)columns rows:(int)rows
							  scaleSize:(CGSize)scaleSize onProgressUpdate:(MyDelegate*)onProgressUpdate
							  onComplete:(MyDelegate*)onComplete {
	
	totalFrames = frames;
	totalSheets = sheets;
	//[onProgressUpdateCB release];
	self.onProgressUpdateCB = onProgressUpdate;
	//[onCompleteCB release];
	self.onCompleteCB = onComplete;
	//[currentBoardName release];
	self.currentBoardName = name;
	self.currentBoardRows = rows;
	self.currentBoardColumns = columns;
	self.sheetsLoaded = 0;

	
	CCTextureCache *textureMgr = [CCTextureCache sharedTextureCache];
	
	for (int sheet = 1; sheet <= totalSheets; sheet++)
		[textureMgr addImageAsync:[NSString stringWithFormat:@"%@_%d.pvr.ccz", name, sheet, nil] target:self selector:@selector(textureLoaded:)];
}

-(void) clearTexturesAndAnimation {
	/*CCTextureCache *textureMgr = [CCTextureCache sharedTextureCache];
	for (NSMutableArray *arr in currentBoardTextures) {
		for (CCTexture2D *tileTexture in arr) {
			//CCTexture2D *tileTexture = [currentBoardTextures objectAtIndex:i];
			NSLog(@"texture %f removed from texture cache", tileTexture.name);
			[textureMgr removeTexture:tileTexture];
		}
	}*/
	[[CCSpriteFrameCache sharedSpriteFrameCache] removeUnusedSpriteFrames];
}

- (void) textureLoaded:(CCTexture2D*)texture {
	sheetsLoaded++;
	[onProgressUpdateCB invokeWithParams:[NSArray arrayWithObjects:[NSNumber numberWithInteger:sheetsLoaded], [NSNumber numberWithInteger:totalSheets], nil]];
	CCSpriteFrameCache *spriteFrameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
	[spriteFrameCache addSpriteFramesWithFile:[NSString stringWithFormat:@"%@_%d.plist", currentBoardName, sheetsLoaded, nil]];
	/*GLfloat sliceWidth = floor(texture.contentSizeInPixels.width / currentBoardColumns);
	GLfloat sliceHeight = floor(texture.contentSizeInPixels.height / currentBoardRows);
	CGSize sliceSize = CGSizeMake(sliceWidth, sliceHeight);
	
	GLfloat tileX;
	GLfloat tileY;
	
	int index = 0;//index for SpriteFrame Array
	for (int i = 0; i < currentBoardRows ; i++) {
		for (int j = 0; j < currentBoardColumns ; j++) {
			tileX =  j * sliceWidth;
			tileY =  i * sliceHeight;
			CGRect rect = CGRectMake(tileX, tileY, sliceWidth, sliceHeight);
			CCSpriteFrame *frame = [CCSpriteFrame frameWithTexture:texture rectInPixels:rect rotated:NO offset:CGPointZero originalSize:sliceSize];
			[spriteFrameCache addSpriteFrame:frame name:[NSString stringWithFormat:@"%@%d", currentBoardName, index]];
			[(CCAnimation*)[spriteFrames objectAtIndex:index] addFrame:frame];
			index++;
		}
	}
	
	spritesLoaded++;*/
	//When all
	if (sheetsLoaded == totalSheets) {
		CCAnimationCache *animationCache = [CCAnimationCache sharedAnimationCache];
		NSMutableArray *anims = [NSMutableArray array];
		
		for (int tile = 0; tile < (currentBoardColumns * currentBoardRows); tile++) {
			CCAnimation *anim = [CCAnimation animation];
			[anims addObject:anim];
			[animationCache addAnimation:anim name:[NSString stringWithFormat:@"%@%d", DEFAULT_ANIM, tile]];
			NSLog(@"%@%d", DEFAULT_ANIM, tile);
		}
		
		//create an array for each tile
		for (int frame = 1; frame <= totalFrames; frame++) {
			for (int i = 1; i <= (currentBoardColumns * currentBoardRows); i++) {
				NSLog(@"%@_%d_%02d-HD.png", currentBoardName, frame, i);
				[((CCAnimation*)[anims objectAtIndex:i - 1]) addFrame:[spriteFrameCache spriteFrameByName:[NSString stringWithFormat:@"%@_%d_%02d-HD.png", currentBoardName, frame, i, nil]]];
			}
		}
		
		[onCompleteCB invokeWithParams:[NSArray arrayWithObject:currentBoardName]];
	}
	//if (spritesLoaded == totalFrames)
	//	[self cleanLoadingSession];
}

@end