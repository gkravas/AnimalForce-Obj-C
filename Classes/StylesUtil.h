//
//  StylesUtil.h
//  AnimalForce
//
//  Created by George Kravas on 12/6/10.
//  Copyright 2010 Protractor Games. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Label.h"

@interface StylesUtil : NSObject {

}

+ (Label*) createLabelWithFont:(NSString*)font text:(NSString*)text position:(CGPoint)position target:(id)target selector:(SEL)selector;
	
@end
