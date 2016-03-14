//
//  AssetUtil.h
//  AnimalForce
//
//  Created by George Kravas on 11/11/10.
//  Copyright 2010 Protractor Games. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cocos2d.h"

@interface AssetUtil : NSObject {

}

+ (void) createAnimationForName:(NSString*)name withExtension:(NSString*)extension frames:(int)frames andDelay:(float)delay;
+ (void) createAnimationForName:(NSString*)name withExtension:(NSString*)extension pages:(int)pages sliceSize:(CGSize)sliceSize columns:(int)columns rows:(int)rows andDelay:(float)delay;
+ (void) createAnimationWithName:(NSString*)name atlasName:(NSString*)atlasName sheets:(int)sheets framesInSheets:(int)frames frameType:(NSString*)frameType andDelay:(float)delay;
+ (void) loadSpritePack:(NSString*)name sheets:(int)sheets;
+ (void) createAnimationFromPreloadedSpritesWithName:(NSString*)name withExtension:(NSString*)extension frames:(int)frames andDelay:(float)delay;
+ (void) unloadSpritePack:(NSString*)name sheets:(int)sheets;

+ (CCSprite*) createSpriteWithAnimation:(NSString*)animation andDuration:(ccTime)duration;
+ (CCSprite*) createSpriteWithOneCycleAnimation:(NSString*)animation andDuration:(ccTime)duration animation:(CCAnimation*)anim;
@end
