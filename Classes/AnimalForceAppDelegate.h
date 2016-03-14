//
//  BattleAnimalsAppDelegate.h
//  BattleAnimals
//
//  Created by George Kravas on 10/28/10.
//  Copyright Protractor Games 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Notifications.h"
#import "CommandManager.h"

@class RootViewController;

@interface AnimalForceAppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
}

@property (nonatomic, retain) UIWindow *window;

@end
