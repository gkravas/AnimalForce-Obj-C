//
//  AssetUtil.m
//  AnimalForce
//
//  Created by George Kravas on 11/11/10.
//  Copyright 2010 Protractor Games. All rights reserved.
//

#import "AssetUtil.h"


@implementation AssetUtil

+ (void) createAnimationForName:(NSString*)name withExtension:(NSString*)extension frames:(int)frames andDelay:(float)delay {
	CCTextureCache *texMgr = [CCTextureCache sharedTextureCache];
	CCSpriteFrameCache *spriteFrameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
	CCAnimationCache *animationCache = [CCAnimationCache sharedAnimationCache];
	CCAnimation *animation = [CCAnimation animation];
	
	for (int i = 1; i <= frames; i++) {
		//NSLog(@"%@%d-HD.%@", name, i, extension, nil)
		CCTexture2D *texture = [texMgr addImage:[NSString stringWithFormat:@"%@%d-HD.%@", name, i, extension, nil]];
		CGRect rect = CGRectMake(0, 0, texture.contentSizeInPixels.width, texture.contentSizeInPixels.height);
		CCSpriteFrame *frame = [CCSpriteFrame frameWithTexture:texture
												  rectInPixels:rect
													   rotated:NO
														offset:CGPointZero
												  originalSize:CGSizeMake(texture.contentSizeInPixels.width, texture.contentSizeInPixels.height)];
		[spriteFrameCache addSpriteFrame:frame name:[NSString stringWithFormat:@"%@%d", name, i, nil]];
		[animation addFrame:frame];
	}
	animation.delay = delay;
	[animationCache addAnimation:animation name:name];
}

+ (void) createAnimationForName:(NSString*)name withExtension:(NSString*)extension pages:(int)pages sliceSize:(CGSize)sliceSize columns:(int)columns rows:(int)rows andDelay:(float)delay {
	CCTextureCache *texMgr = [CCTextureCache sharedTextureCache];
	CCSpriteFrameCache *spriteFrameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
	CCAnimationCache *animationCache = [CCAnimationCache sharedAnimationCache];
	CCAnimation *animation = [CCAnimation animation];
	
	int sliceIndex = 0;
	int sliceX = 0;
	int sliceY = 0;
	for (int index = 1; index <= pages; index++) {
		//NSLog(@"%@%d-HD.%@", name, i, extension, nil)
		CCTexture2D *texture = [texMgr addImage:[NSString stringWithFormat:@"%@%d-HD.%@", name, index, extension, nil]];
		for (int i = 0; i < rows ; i++) {
			for (int j = 0; j < columns ; j++) {
				sliceX =  j * sliceSize.width;
				sliceY =  i * sliceSize.height;
				CGRect rect = CGRectMake(sliceX, sliceY, sliceSize.width, sliceSize.height);
				CCSpriteFrame *frame = [CCSpriteFrame frameWithTexture:texture rectInPixels:rect rotated:NO offset:CGPointZero originalSize:sliceSize];
				[spriteFrameCache addSpriteFrame:frame name:[NSString stringWithFormat:@"%@%d", name, sliceIndex]];
				[animation addFrame:frame];
				sliceIndex++;
			}
		}
	}
	animation.delay = delay;
	[animationCache addAnimation:animation name:name];
}

+ (void) createAnimationWithName:(NSString*)name atlasName:(NSString*)atlasName sheets:(int)sheets framesInSheets:(int)frames frameType:(NSString*)frameType andDelay:(float)delay {
	CCSpriteFrameCache *spriteFrameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
	CCAnimation *animation = [CCAnimation animation];
	
	for (int sheet = 1; sheet <= sheets; sheet++) {
		if (sheets > 1) 
			[spriteFrameCache addSpriteFramesWithFile:[NSString stringWithFormat:@"%@%d%@", atlasName, sheet, @".plist", nil]];
		else
			[spriteFrameCache addSpriteFramesWithFile:[NSString stringWithFormat:@"%@%@", atlasName, @".plist", nil]];
		for (int frame = (1 + (sheet - 1) * frames); frame <= sheet * frames; frame++) {
			[animation addFrame:[spriteFrameCache spriteFrameByName:[NSString stringWithFormat:@"%@%d%@.%@", name, frame, @"-HD", frameType, nil]]];
		}
	}

	CCAnimationCache *animationCache = [CCAnimationCache sharedAnimationCache];
	[animationCache addAnimation:animation name:name];
}

+ (CCSprite*) createSpriteWithAnimation:(NSString*)animation andDuration:(ccTime)duration {
	CCSprite *sprite = [CCSprite node];
	CCAnimation *anim = [[CCAnimationCache sharedAnimationCache] animationByName:animation];
	[sprite runAction:[CCRepeatForever actionWithAction:[CCAnimate actionWithDuration:duration animation:anim restoreOriginalFrame:YES]]];
	return sprite;
}

+ (CCSprite*) createSpriteWithOneCycleAnimation:(NSString*)animation andDuration:(ccTime)duration animation:(CCAnimation*)anim {
	CCSprite *sprite = [CCSprite node];
	//anim = [[CCAnimationCache sharedAnimationCache] animationByName:animation];
	//[sprite runAction:[[CCAnimate actionWithDuration:duration animation:anim restoreOriginalFrame:YES] retain]];
	return sprite;
}

+ (void) loadSpritePack:(NSString*)name sheets:(int)sheets {
	CCSpriteFrameCache *spriteFrameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
	if (sheets == 1) {
		[spriteFrameCache addSpriteFramesWithFile:[NSString stringWithFormat:@"%@%@", name, @".plist", nil]];
		return;
	}
	
	for (int sheet = 1; sheet <= sheets; sheet++) {
		[spriteFrameCache addSpriteFramesWithFile:[NSString stringWithFormat:@"%@%d%@", name, sheet, @".plist", nil]];
	}
}

+ (void) createAnimationFromPreloadedSpritesWithName:(NSString*)name withExtension:(NSString*)extension frames:(int)frames andDelay:(float)delay {
	CCSpriteFrameCache *spriteFrameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
	CCAnimation *animation = [CCAnimation animation];
	for (int frame = 1; frame <= frames; frame++) {
		NSLog(@"%@%d%@.%@", name, frame, @"-HD", extension);
		[animation addFrame:[spriteFrameCache spriteFrameByName:[NSString stringWithFormat:@"%@%d%@.%@", name, frame, @"-HD", extension, nil]]];
	}
	CCAnimationCache *animationCache = [CCAnimationCache sharedAnimationCache];
	[animationCache addAnimation:animation name:name];
}

+ (void) unloadSpritePack:(NSString*)name sheets:(int)sheets {
	CCSpriteFrameCache *spriteFrameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
	CCTextureCache *textureCache = [CCTextureCache sharedTextureCache];
	if (sheets == 1) {
		[spriteFrameCache removeSpriteFramesFromFile:[NSString stringWithFormat:@"%@%@", name, @".plist", nil]];
		[textureCache removeTextureForKey:[NSString stringWithFormat:@"%@%@", name, @".pvr.ccz", nil]];
		return;
	}
	
	for (int sheet = 1; sheet <= sheets; sheet++) {
		[spriteFrameCache removeSpriteFramesFromFile:[NSString stringWithFormat:@"%@%d%@", name, sheet, @".plist", nil]];
		[textureCache removeTextureForKey:[NSString stringWithFormat:@"%@%d%@", name, sheet, @".pvr.ccz", nil]];
	}
    [textureCache removeUnusedTextures];
}

- (void)dealloc {
    [super dealloc];
}


@end
