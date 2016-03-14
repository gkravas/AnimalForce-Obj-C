//
//  StylesUtil.m
//  AnimalForce
//
//  Created by George Kravas on 12/6/10.
//  Copyright 2010 Protractor Games. All rights reserved.
//

#import "StylesUtil.h"


@implementation StylesUtil

+ (Label*) createLabelWithFont:(NSString*)font text:(NSString*)text position:(CGPoint)position target:(id)target selector:(SEL)selector {
	CCLabelBMFont *label = [CCLabelBMFont labelWithString:text fntFile:[NSString stringWithFormat:@"%@.fnt", font, nil]];
	//target = ([target isEqual:nil]) ? self : target;
	Label *mLabel = [Label itemWithLabel:label target:target selector:selector];
	mLabel.position = position;
	return mLabel;
}

@end
