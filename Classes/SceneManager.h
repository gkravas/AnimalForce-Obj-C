//
//  SceneManager.h
//  AnimalForce
//
//  Created by George Kravas on 11/9/10.
//  Copyright 2010 Protractor Games. All rights reserved.
//

//#import <Foundation/Foundation.h>
#import "SplashScene.h"
#import "SplitboardScene.h"
#import "LoadingScene.h"
#import "LevelSelectionScene.h"
#import "IntroScene.h"

#include <libkern/OSAtomic.h>

@interface SceneManager : NSObject {
	SplashScene *splash;
	SplitboardScene *splitboard;
	LoadingScene *loading;
	LevelSelectionScene *levelSelection;
	IntroScene *intro;
}

@property (nonatomic, retain) SplashScene *splash;
@property (nonatomic, retain) SplitboardScene *splitboard;
@property (nonatomic, assign) LoadingScene *loading;
@property (nonatomic, assign) LevelSelectionScene *levelSelection;
@property (nonatomic, assign) IntroScene *intro;

+(SceneManager*) sharedInstance;

@end
