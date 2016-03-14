//
//  SwapTiles.h
//  Splitboard
//
//  Created by George Kravas on 4/16/10.
//  Copyright 2010 Protractor Games. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HelpingFunction.h"

@interface SwapTiles : HelpingFunction {
    TileSprite *swapTile1;
    TileSprite *swapTile2;
    CCRepeatForever *anim1;
    CCRepeatForever *anim2;	
}

@property (nonatomic, retain) TileSprite *swapTile1;
@property (nonatomic, retain) TileSprite *swapTile2;
@property (nonatomic, retain) CCRepeatForever *anim1;
@property (nonatomic, retain) CCRepeatForever *anim2;

-(id) getExecutionAnimationPosition:(CGPoint)position callback:(SEL)callback;
@end
