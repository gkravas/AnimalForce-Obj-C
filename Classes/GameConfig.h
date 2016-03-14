//
//  GameConfig.h
//  BattleAnimals
//
//  Created by George Kravas on 10/28/10.
//  Copyright Protractor Games 2010. All rights reserved.
//

#ifndef __GAME_CONFIG_H
#define __GAME_CONFIG_H

//
// Supported Autorotations:
//		None,
//		UIViewController,
//		CCDirector
//
#define kGameAutorotationNone 0
#define kGameAutorotationCCDirector 1
#define kGameAutorotationUIViewController 2
//TO BE REMOVED
#define STD_RESOLUTION_WIDTH 320
#define STD_RESOLUTION_HEIGHT 427
//

#define UI_SCREENS_MULT 0.5
#define SCREEN_WIDTH 640
#define SCREEN_HEIGHT 960

#define BOARD_COLUMNS 3
#define BOARD_ROWS 4
#define TOTAL_TEXTURES_PER_BOARD 18
#define SCALE_FACTOR [[UIScreen mainScreen] scale]

#define DEFAULT_ANIM @"default"
#define ANIMATION_DELAY 0.085
#define MAX_LEVELS 14
//#define AVG_TIME 160
#define SCORE_PER_SEC 10
#define SCORE_PER_MOVE 10
#define ANIMATED_CAT_INTERVAL 60
#define SURVIVAL_TIME 300
#define SURVIVAL_MOVES 500
//
// Define here the type of autorotation that you want for your game
//
#define GAME_AUTOROTATION kCCDeviceOrientationPortrait

static inline CGPoint myp(CGFloat x, CGFloat y) {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return ccp(x + 64, (SCREEN_HEIGHT - y) + 32);
    } else
        return ccp(x * UI_SCREENS_MULT, (SCREEN_HEIGHT - y) * UI_SCREENS_MULT);
}

static inline CGPoint mypChild(CGFloat x, CGFloat y) {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return ccp(x, (SCREEN_HEIGHT - y));
    } else
        return ccp(x * UI_SCREENS_MULT, (SCREEN_HEIGHT - y) * UI_SCREENS_MULT);
}

#endif // __GAME_CONFIG_H