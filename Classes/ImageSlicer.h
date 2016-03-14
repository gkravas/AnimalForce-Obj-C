//
//  ImageSlicer.h
//  Splitboard
//
//  Created by George Kravas on 3/24/10.
//  Copyright 2010 Protractor Games. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "MyDelegate.h"
#import "GameConfig.h"

@interface ImageSlicer : NSObject {
	@private
		NSString *currentBoardName;
		int totalFrames;
		int totalSheets;
		int currentBoardColumns;
		int currentBoardRows;
		int sheetsLoaded;
		int currentSheet;
		NSMutableArray *currentBoardTextures;
		MyDelegate *onProgressUpdateCB;
		MyDelegate *onCompleteCB;
		//NSMutableArray *spriteFrames;
		//NSString *textureBaseName;
}

@property (nonatomic, retain) NSString *currentBoardName;
@property int totalFrames;
@property int totalSheets;
@property int currentBoardColumns;
@property int currentBoardRows;
@property int sheetsLoaded;
@property int currentSheet;
@property (nonatomic, retain) NSMutableArray *currentBoardTextures;
@property (nonatomic, retain) MyDelegate *onProgressUpdateCB;
@property (nonatomic, retain) MyDelegate *onCompleteCB;
@property (nonatomic, retain) NSMutableArray *spriteFrames;
//@property (nonatomic, retain) NSString *textureBaseName;

+ (id) slicer;

- (void) sliceTexturesAndCreateAnimation:(NSString*)name sheets:(int)sheets frames:(int)frames columns:(int)columns rows:(int)rows
							   scaleSize:(CGSize)scaleSize onProgressUpdate:(MyDelegate*)onProgressUpdate
							  onComplete:(MyDelegate*)onComplete;

- (void) clearTexturesAndAnimation;
- (void) textureLoaded:(CCTexture2D*)texture;
@end
