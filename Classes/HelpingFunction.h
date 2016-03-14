//
//  HelpingFunction.h
//  Splitboard
//
//  Created by George Kravas on 4/16/10.
//  Copyright 2010 Protractor Games. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TileSprite.h"
#import "MyDelegate.h"
#import "SimpleAudioEngine.h"

@interface HelpingFunction : NSObject {
	MyDelegate *onStartCB;
	MyDelegate *onEndCB;
}

@property (nonatomic, retain) MyDelegate *onStartCB;
@property (nonatomic, retain) MyDelegate *onEndCB;

+(id) initWithCallbacksOnStart:(MyDelegate*)onStart onEnd:(MyDelegate*)onEnd;
-(BOOL) validateTile:(TileSprite*)tile;
-(void) start;
-(void) end;
-(void) cancel;
-(void) applyFxTile:(TileSprite*)tile;
-(void) removeFxTile:(TileSprite*)tile;
-(void) resetFxTile:(TileSprite*)tile;

-(id) getFX;
-(id) getResetFX;
@end
