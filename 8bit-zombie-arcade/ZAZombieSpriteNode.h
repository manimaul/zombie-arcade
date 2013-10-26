//
//  ZAZombieSpriteNode.h
//  8bit-zombie-arcade
//
//  Created by William Kamp on 10/13/13.
//  Copyright (c) 2013 Will Kamp. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "ZAEnemySpriteNode.h"

@class ZAHeroSpriteNode;

@interface ZAZombieSpriteNode : ZAEnemySpriteNode

+ (instancetype)createSprite;

@end
