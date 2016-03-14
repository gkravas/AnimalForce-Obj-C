//
//  BoardLoadingCommand.h
//  AnimalForce
//
//  Created by George Kravas on 11/9/10.
//  Copyright 2010 Protractor Games. All rights reserved.
//

#import "MyCommand.h"
#import "ImageSlicer.h"
#import "SceneManager.h"
#import "LoadingScene.h"
#import "GameConfig.h"
#import "Settings.h"

@interface BoardLoadingCommand : MyCommand {

}

+ (void) loadLevel:(NSArray*)params;

@end
