//
//  Label.h
//  Splitboard
//
//  Created by George Kravas on 4/20/10.
//  Copyright 2010 Protractor Games. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "MyDelegate.h"

@interface Label : CCMenuItemLabel {
	MyDelegate *showCompleteCB;
	MyDelegate *hideCompleteCB;
}

@property (nonatomic, retain) MyDelegate *showCompleteCB;
@property (nonatomic, retain) MyDelegate *hideCompleteCB;

-(void) showComplete;
-(void) hideComplete;

-(void) fadeOutCallback:(MyDelegate*)callback;
-(void) fadeInCallback:(MyDelegate*)callback;

@end
