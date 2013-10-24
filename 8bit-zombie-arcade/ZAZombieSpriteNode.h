//
//  ZAZombieSpriteNode.h
//  8bit-zombie-arcade
//
//  Created by William Kamp on 10/13/13.
//  Copyright (c) 2013 Will Kamp. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "ZACharacherSpriteNode.h"

@class ZAHeroSpriteNode;

static const NSInteger kMaxZombies = 5;

@interface ZAZombieSpriteNode : ZACharacherSpriteNode

@property (nonatomic, weak) ZACharacherSpriteNode *attackTarget;

+ (instancetype)createZombieSprite;
- (void)attackHero;

@end
