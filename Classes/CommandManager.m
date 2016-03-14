//
//  CommandManager.m
//  AnimalForce
//
//  Created by George Kravas on 11/29/10.
//  Copyright 2010 Protractor Games. All rights reserved.
//

#import "CommandManager.h"


@implementation CommandManager

static void * volatile sharedInstance = nil;

+(CommandManager*) sharedInstance {                                                                 
	while (!sharedInstance) {                                                                          
		CommandManager *temp = [[self alloc] init];                                                                 
		if(!OSAtomicCompareAndSwapPtrBarrier(0x0, temp, &sharedInstance)) {
			[temp release];                                                                                   
		}                                                                                                    
	}                                                                                                        
	return sharedInstance;                                                                        
}

-(id) init {
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if ( (self = [super init] )) {
		[Notifications addNotificationName:[Notifications signalCommand] object:self selector:@selector(executeCommandFromNotification:)];
	}
	
	return self;
}

- (void) executeCommandFromNotification:(NSNotification*)notification {
	NSString *name = [notification.userInfo objectForKey:@"name"];
	NSArray *params = [notification.userInfo objectForKey:@"params"];
	
	if ([name isEqualToString:@"BoardLoadingCommand"]) {
		[BoardLoadingCommand executeWithParams:params];
	} else if ([name isEqualToString:@"CreateBoardCommand"]) {
		[CreateBoardCommand executeWithParams:params];
	} else if ([name isEqualToString:@"InitialLoading"]) {
		[InitialLoading executeWithParams:params];
	} else if ([name isEqualToString:@"QuitCommand"]) {
		[QuitCommand executeWithParams:params];
	} else if ([name isEqualToString:@"NewGameCommand"]) {
		[NewGameCommand executeWithParams:params];
	} else if ([name isEqualToString:@"ShowSplash"]) {
		[ShowSplashCommand executeWithParams:params];
	}
}

@end
