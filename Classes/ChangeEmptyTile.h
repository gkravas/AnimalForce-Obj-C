//
//  ChangeEmptyTile.h
//  Splitboard
//
//  Created by George Kravas on 4/16/10.
//  Copyright 2010 Protractor Games. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HelpingFunction.h"

@interface ChangeEmptyTile : HelpingFunction {
	TileSprite *newEmptyTile;
	TileSprite *boardEmptyTile;
	CCRepeatForever *anim;
}

-(id) getExecutionAnimationOpacity:(GLubyte)opacity callback:(SEL)callback;

@property (nonatomic, retain) TileSprite *boardEmptyTile;
@property (nonatomic, retain) TileSprite *newEmptyTile;
@property (nonatomic, retain) CCRepeatForever *anim;
@end
