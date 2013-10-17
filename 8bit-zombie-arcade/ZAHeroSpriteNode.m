//
//  ZAHeroSpriteNode.m
//  8bit-zombie-arcade
//
//  Created by William Kamp on 10/14/13.
//  Copyright (c) 2013 Will Kamp. All rights reserved.
//

#import "ZAHeroSpriteNode.h"
#import "ZAHeroAnimationFrames.h"

@implementation ZAHeroSpriteNode

+ (instancetype)createHeroSprite
{
    ZAHeroSpriteNode *heroSprite = [[ZAHeroSpriteNode alloc] initWithCharachterType:hero];
    heroSprite.cardinal = west;
    [heroSprite actionLoop];
    return heroSprite;
}

- (void)setAnimationSequenceByCardinal:(fourtyFiveDegreeCardinal)newCardinal
{
    if (self.cardinal != newCardinal) {
        [self removeAllActions];
        self.cardinal = newCardinal;
        [self actionLoop];
    } else
        self.cardinal = newCardinal;
}

-(void)actionLoop
{
    ZAHeroAnimationFrames *frames = [ZAHeroAnimationFrames sharedFrames];
    SKAction *action;
    switch (self.cardinal) {
        case north:
            action = [frames animateWalkNorth];
            break;
        case northeast:
            action = [frames animateWalkNorthEast];
            break;
        case east:
            action = [frames animateWalkEast];
            break;
        case southeast:
            action = [frames animateWalkSouthEast];
            break;
        case south:
            action = [frames animateWalkSouth];
            break;
        case southwest:
            action = [frames animateWalkSouthWest];
            break;
        case west:
            action = [frames animateWalkWest];
            break;
        case northwest:
            action = [frames animateWalkNorthWest];
            break;
            
        default:
            break;
    }
    [self runAction:[SKAction sequence:@[action, [SKAction runBlock:^{
        [self actionLoop];
    }]]]];
}


@end
