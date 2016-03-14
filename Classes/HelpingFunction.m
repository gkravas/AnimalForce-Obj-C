//
//  HelpingFunction.m
//  Splitboard
//
//  Created by George Kravas on 4/16/10.
//  Copyright 2010 Protractor Games. All rights reserved.
//

#import "HelpingFunction.h"


@implementation HelpingFunction

@synthesize onStartCB, onEndCB;

+(id) initWithCallbacksOnStart:(MyDelegate*)onStart onEnd:(MyDelegate*)onEnd {
	HelpingFunction *o = [HelpingFunction new];
	o.onStartCB = onStart;
	o.onEndCB = onEnd;
	return [o autorelease];
}
-(BOOL) validateTile:(TileSprite*)tile {return NO;}
-(void) start {
	[[SimpleAudioEngine sharedEngine] playEffect:@"help.mp3"];//play a sound
	[self.onStartCB invokeWithParams:nil];
}
-(void) end {
	[self.onEndCB invokeWithParams:nil];
}
-(void) cancel {}
-(void) applyFxTile:(TileSprite*)tile {}
-(void) removeFxTile:(TileSprite*)tile {}
-(void) resetFxTile:(TileSprite*)tile {}

-(id) getFX {return nil;}
-(id) getResetFX {return nil;}
@end
