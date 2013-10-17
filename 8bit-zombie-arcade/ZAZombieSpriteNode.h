//
//  ZAZombieSpriteNode.h
//  8bit-zombie-arcade
//
//  Created by William Kamp on 10/13/13.
//  Copyright (c) 2013 Will Kamp. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "ZACharacherSpriteNode.h"

static const float ZOMBIE_MOVE_POINTS_PER_SEC = 90.;

@interface ZAZombieSpriteNode : ZACharacherSpriteNode

@property (nonatomic, strong, readonly) SKAction *animateZombieLurch;
+ (instancetype)createZombieSprite;

@end
