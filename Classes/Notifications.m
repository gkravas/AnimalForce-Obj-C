//
//  Notifications.m
//  Splitboard
//
//  Created by George Kravas on 4/15/10.
//  Copyright 2010 Protractor Games. All rights reserved.
//

#import "Notifications.h"

@implementation Notifications

+(NSString*) swapTiles {return @"swapTile";}
+(NSString*) changeEmptyTile {return @"changeEmptyTile";}
+(NSString*) showBoard {return @"showBoard";}
+(NSString*) reshuffle {return @"reshuffle";}
+(NSString*) helpingFunctionCanBeEngaged {return @"helpingFunctionCanBeEngaged";}
+(NSString*) helpingFunctionCanNotBeEngaged {return @"helpingFunctionCanNotBeEngaged";}
+(NSString*) cancelHelpingFunction {return @"cancelHelpingFunction";}
+(NSString*) engageHelpingFunction {return @"engageHelpingFunction";}
+(NSString*) updateStageTime {return @"updateStageTime";}
+(NSString*) updateMovesCounter {return @"updateMovesCounter";}
+(NSString*) pauseGame {return @"pauseGame";}
+(NSString*) resumeGame {return @"resumeGame";}
+(NSString*) quitGame {return @"quitGame";}
+(NSString*) nextBoard {return @"nextBoard";}
+(NSString*) showOptions {return @"showOptions";}
+(NSString*) setActiveSubMenuEnabled {return @"enableActiveSubMenu";}
+(NSString*) signalCommand {return @"signalCommand";}
+(NSString*) movesToZero {return @"movesToZero";}

+(void) notifyForName:(NSString*)name object:(id)object userInfo:(NSDictionary*)userInfo {
	[[NSNotificationCenter defaultCenter] postNotificationName:name object:object userInfo:userInfo];
}
//NOTIFICATIONS
+(void) addNotificationName:(NSString*)name object:(id)object selector:(SEL)selector {
	[[NSNotificationCenter defaultCenter] addObserver:object selector:selector name:name  object:nil];
}
@end
