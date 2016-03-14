//
//  SceneManager.m
//  AnimalForce
//
//  Created by George Kravas on 11/9/10.
//  Copyright 2010 Protractor Games. All rights reserved.
//

#import "SceneManager.h"

@implementation SceneManager

@synthesize splash, splitboard, loading, levelSelection, intro;

static void * volatile sharedInstance = nil;

+(SceneManager*) sharedInstance {                                                                 
	while (!sharedInstance) {                                                                          
		SceneManager *temp = [[self alloc] init];                                                                 
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
		//self.splash = [SplashScene node];
		//self.splitboard = [SplitboardScene node];
		//self.loading = [LoadingScene node];
		//self.levelSelection = [LevelSelectionScene node];
		//self.intro = [IntroScene node];
	}
	
	return self;
}

@end
