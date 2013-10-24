//
//  ZAEntity.h
//  8bit-zombie-arcade
//
//  Created by Christian Hansen on 10/16/13.
//  Copyright (c) 2013 Will Kamp. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

//physics body bitmasks
static const uint8_t kNullBitmask   = 0b0000;
static const uint8_t kHeroBitmask   = 0b0001;
static const uint8_t kEnemyBitmask  = 0b0010;
static const uint8_t kBulletBitmask = 0b0100;

@interface ZANode : SKSpriteNode

@end
