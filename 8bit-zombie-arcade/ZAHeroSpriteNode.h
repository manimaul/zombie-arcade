//
//  ZAHeroSpriteNode.h
//  8bit-zombie-arcade
//
//  Created by William Kamp on 10/14/13.
//  Copyright (c) 2013 Will Kamp. All rights reserved.
//

#import "ZACharacherSpriteNode.h"

@interface ZAHeroSpriteNode : ZACharacherSpriteNode

+ (instancetype)createHeroSprite;
- (void)stop;

@end
