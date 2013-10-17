//
//  ZAZombieSpriteNode.m
//  8bit-zombie-arcade
//
//  Created by William Kamp on 10/13/13.
//  Copyright (c) 2013 Will Kamp. All rights reserved.
//

#import "ZAZombieSpriteNode.h"

@implementation ZAZombieSpriteNode

+ (instancetype)createZombieSprite
{
    ZAZombieSpriteNode *zombieSprite = [[ZAZombieSpriteNode alloc] initWithCharachterType:zombie];
    return zombieSprite;
}

@end
