//
//  MyDelegate.m
//  Splitboard
//
//  Created by George Kravas on 3/30/10.
//  Copyright 2010 Protractor Games. All rights reserved.
//

#import "MyDelegate.h"


@implementation MyDelegate

@synthesize target, selector;

+ (id) initWithObj:(id)obj selector:(SEL)selector {
	MyDelegate *o = [[MyDelegate alloc] initWithObj:obj selector:selector];
	return [o autorelease];
}
- (id) initWithObj:(id)obj selector:(SEL)mySelector {
    if( (self = [super init] )) {
		self.target = obj;
        self.selector = mySelector;
	}
	return self;
}

- (void) invokeWithParams:(NSArray*)params {
    NSInvocation *inv = [NSInvocation invocationWithMethodSignature:[self.target methodSignatureForSelector:self.selector]];
	[inv setTarget:self.target];
	[inv setSelector:self.selector];
	if (params != nil) {
		for (int i = 0; i < [params count]; i++) {
			NSObject *param = [params objectAtIndex:i];
			[inv setArgument:&param atIndex:(i + 2)];
		}
		[inv retainArguments];
	}
	[inv invoke];
}

- (void) dealloc {
	[self.target release];
	//[self.inv release];
	[super dealloc];
}
@end
