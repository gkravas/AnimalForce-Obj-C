//
//  LevelSelectionScene.m
//  AnimalForce
//
//  Created by George Kravas on 12/5/10.
//  Copyright 2010 Protractor Games. All rights reserved.
//

#import "LevelSelectionScene.h"
#define INITIAL_POS ccp(148, 138.5)
#define OFFSET_POS ccp(170, 170)
#define LEVEL_COLUMNS 3

@implementation LevelSelectionScene

@synthesize bg, menu, selectStage,
level1, level2, level3, level4, level5, level6, level7, level8, level9, level10, level11, level12, level13, level14;

// on "init" you need to initialize your instance
-(id) init {
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self = [super init] )) {
		[self createBG];
		[self createButtons];
	}
	return self;
}

- (void) dealloc {
	[super dealloc];
}

//#==================================================================================================================================
#pragma mark Scene creation
- (void) createBG {
	bg = [[CCSprite spriteWithSpriteFrameName:@"levelSelectionBG-HD.png"] retain];
	//bg.anchorPoint = ccp(0, 0);
	bg.position = myp(320, 480);
	[self addChild:bg];
}

- (void) createButtons {
	menu = [CCMenu menuWithItems:level1, level2, level3, level4, level5, level6, level7, level8, level9, level10, level11, level12, level13, level14, nil];
	//menu.anchorPoint = ccp(0, 0);
	menu.position = mypChild(0, 960);
	[self addChild:menu];
	
	level1 = [self createButtonForLevel:1];
	level2 = [self createButtonForLevel:2];
	level3 = [self createButtonForLevel:3];
	level4 = [self createButtonForLevel:4];
	level5 = [self createButtonForLevel:5];
	level6 = [self createButtonForLevel:6];
	level7 = [self createButtonForLevel:7];
	level8 = [self createButtonForLevel:8];
	level9 = [self createButtonForLevel:9];
	level10 = [self createButtonForLevel:10];
	level11 = [self createButtonForLevel:11];
	level12 = [self createButtonForLevel:12];
	level13 = [self createButtonForLevel:13];
	level14 = [self createButtonForLevel:14];
	
	selectStage = [StylesUtil createLabelWithFont:@"levelSelect" text:@"SELECT\n STAGE" position:[self getLevelButtonPositionFromIndex:0] target:nil selector:nil];
	[self addChild:selectStage];
}

- (Button*) createButtonForLevel:(int)level {
	CCSprite *spriteNormal = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"level%dA-HD.png", level,  nil]];
	CCSprite *spriteSelected = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"level%dA-HD.png", level]];
    spriteSelected.color = ccc3(255, 229, 3);
	CCSprite *spriteDisabled = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"level%dD-HD.png", level, nil]];
	Button *button = [Button itemFromNormalSprite:spriteNormal selectedSprite:spriteSelected disabledSprite:spriteDisabled target:self selector:@selector(levelSelected:)];
	button.position = [self getLevelButtonPositionFromIndex:level];
    button.num = -1;
	[menu addChild:button z:1 tag:level];
	return button;
}

- (CGPoint) getLevelButtonPositionFromIndex:(int)index {
	int column = index % LEVEL_COLUMNS;
	int row = index / LEVEL_COLUMNS;
	return myp(INITIAL_POS.x + column * OFFSET_POS.x, INITIAL_POS.y + row * OFFSET_POS.y);
}

- (void) levelSelected:(id)sender {
    [[SimpleAudioEngine sharedEngine] playEffect:@"selection.mp3"];
	NSNumber *level = [NSNumber numberWithInt:((Button*)sender).tag];
	NSDictionary *dic = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"BoardLoadingCommand", [NSArray arrayWithObject:level], nil]
													forKeys:[NSArray arrayWithObjects:@"name", @"params", nil]];
	[Notifications notifyForName:[Notifications signalCommand] object:self userInfo:dic];
}

- (void) markAvailableLevels {
	Button *button;
	for (int i = 1; i <= 14; i++) {
		button = (Button*)[menu getChildByTag:i];
		[button setIsEnabled:(i <= [Settings sharedInstance].maxLevelReached)];
	}
}
@end
