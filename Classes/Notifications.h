//
//  Notifications.h
//  Splitboard
//
//  Created by George Kravas on 4/15/10.
//  Copyright 2010 Protractor Games. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Notifications : NSObject {
}

+(NSString*) swapTiles;
+(NSString*) changeEmptyTile;
+(NSString*) showBoard;
+(NSString*) reshuffle;
+(NSString*) helpingFunctionCanBeEngaged;
+(NSString*) helpingFunctionCanNotBeEngaged;
+(NSString*) cancelHelpingFunction;
+(NSString*) engageHelpingFunction;
+(NSString*) updateStageTime;
+(NSString*) updateMovesCounter;
+(NSString*) pauseGame;
+(NSString*) resumeGame;
+(NSString*) quitGame;
+(NSString*) nextBoard;
+(NSString*) showOptions;
+(NSString*) setActiveSubMenuEnabled;
+(NSString*) signalCommand;
+(NSString*) movesToZero;

+(void) notifyForName:(NSString*)name object:(id)object userInfo:(NSDictionary*)userInfo;
+(void) addNotificationName:(NSString*)name object:(id)object selector:(SEL)selector;
@end
