//
//  MyDelegate.h
//  Splitboard
//
//  Created by George Kravas on 3/30/10.
//  Copyright 2010 Protractor Games. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MyDelegate : NSObject {
    //NSInvocation *inv;
    id target;
    SEL selector;
}
+ (id) initWithObj:(id)obj selector:(SEL)selector;
- (void) invokeWithParams:(NSArray*)params;

//@property (nonatomic, retain) NSInvocation *inv;
@property (nonatomic, retain) id target;
@property SEL selector;

@end
