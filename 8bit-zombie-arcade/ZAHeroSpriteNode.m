//
//  ZAHeroSpriteNode.m
//  8bit-zombie-arcade
//
//  Created by William Kamp on 10/14/13.
//  Copyright (c) 2013 Will Kamp. All rights reserved.
//

#import "ZAHeroSpriteNode.h"
#import "ZACharachterAnimationFrames.h"

@implementation ZAHeroSpriteNode

static NSArray* actions = nil;


+ (instancetype)createHeroSprite
{
    ZAHeroSpriteNode *heroSprite = [[ZAHeroSpriteNode alloc] initWithCharachterType:hero];
    heroSprite.cardinal = west;
    heroSprite.action = stance;
    heroSprite.movementSpeed = 120.;
    return heroSprite;
}

#pragma mark - actions

- (void)stop
{
    self.velocity = CGPointMake(0., 0.);
    [self setImmediateAction:stance];
}


@end
