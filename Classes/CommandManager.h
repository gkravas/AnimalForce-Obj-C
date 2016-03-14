//
//  CommandManager.h
//  AnimalForce
//
//  Created by George Kravas on 11/29/10.
//  Copyright 2010 Protractor Games. All rights reserved.
//

//#import <Foundation/Foundation.h>
#import "Notifications.h"
#import "BoardLoadingCommand.h"
#import "CreateBoardCommand.h"
#import "InitialLoading.h"
#import "QuitCommand.h"
#import "NewGameCommand.h"
#import "ShowSplashCommand.h"

#include <libkern/OSAtomic.h>

@interface CommandManager : NSObject {

}

+(CommandManager*) sharedInstance;

@end
