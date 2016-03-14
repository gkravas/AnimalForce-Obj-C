//
//  Button.h
//  Splitboard
//
//  Created by George Kravas on 4/13/10.
//  Copyright 2010 Protractor Games. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyDelegate.h"
#import "cocos2d.h"
#import "StylesUtil.h"
#import "GameConfig.h"

@interface Button : CCMenuItemSprite {
    MyDelegate *showCompleteCB;
    MyDelegate *hideCompleteCB;
    MyDelegate *moveByCompleteCB;
    CCSprite *badge;
    CCMenuItemLabel *badgeNum;
    int num;
}

@property (nonatomic, retain) MyDelegate *showCompleteCB;
@property (nonatomic, retain) MyDelegate *hideCompleteCB;
@property (nonatomic, retain) MyDelegate *moveByCompleteCB;
@property (nonatomic, retain) CCSprite *badge;
@property (nonatomic, retain) CCMenuItemLabel *badgeNum;
@property int num;

-(void) resetWithNumber:(int)number;
-(void) createBadgeWithNumber:(int)number;
-(void) setBadgeNumber:(int)number;
-(void) decreaseBadgeNumber;
    
-(void) moveByPosition:(CGPoint)position duration:(double)duration callback:(MyDelegate*)callback;

-(void) showComplete;
-(void) hideComplete;

-(void) fadeOutCallback:(MyDelegate*)callback;
-(void) fadeInCallback:(MyDelegate*)callback;
-(void) hideBadgeComplete;
@end
