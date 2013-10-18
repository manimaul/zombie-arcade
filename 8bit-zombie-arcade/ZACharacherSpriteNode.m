//
//  CharacterModel.m
//  8bit-zombie-arcade
//
//  Created by Jason Koceja on 10/14/13.
//  Copyright (c) 2013 Will Kamp. All rights reserved.
//

#import "ZACharacherSpriteNode.h"

@implementation ZACharacherSpriteNode

-(id)initWithCharachterType:(charachterType)type
{
    NSString *charachterAtlasPrefix;
    switch (type) {
        case hero:
            charachterAtlasPrefix = @"woman";
            break;
        case zombie:
            charachterAtlasPrefix = @"zombie";
            break;
        default:
            charachterAtlasPrefix = @"zombie";
            break;
    }
    
    SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:[NSString stringWithFormat:@"%@_walk_west", charachterAtlasPrefix]];
    self = [super initWithTexture:[atlas textureNamed:[NSString stringWithFormat:@"%@_walk_west_0", charachterAtlasPrefix]]];
    if (self) {
        _charachterAtlasPrefix = charachterAtlasPrefix;
        _frames = [ZACharachterAnimationFrames sharedFrames];
        [self actionLoop];
    }
    
    return self;
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

-(NSString*)getSequenceForCardinal:(fourtyFiveDegreeCardinal)cardinal forAction:(charachterActions)action
{
    NSString *sequenceKey = [NSString stringWithFormat:@"%@", self.charachterAtlasPrefix];
    switch (action) {
        case stance:
            sequenceKey = [sequenceKey stringByAppendingString:@"_stance"];
            break;
        case walk:
            sequenceKey = [sequenceKey stringByAppendingString:@"_walk"];
            break;
        case attack:
            sequenceKey = [sequenceKey stringByAppendingString:@"_attack"];
            break;
        case die:
            sequenceKey = [sequenceKey stringByAppendingString:@"_die"];
            break;
    }
    
    switch (cardinal) {
        case north:
            sequenceKey = [sequenceKey stringByAppendingString:@"_north"];
            break;
        case northeast:
            sequenceKey = [sequenceKey stringByAppendingString:@"_northeast"];
            break;
        case east:
            sequenceKey = [sequenceKey stringByAppendingString:@"_east"];
            break;
        case southeast:
            sequenceKey = [sequenceKey stringByAppendingString:@"_southeast"];
            break;
        case south:
            sequenceKey = [sequenceKey stringByAppendingString:@"_south"];
            break;
        case southwest:
            sequenceKey = [sequenceKey stringByAppendingString:@"_southwest"];
            break;
        case west:
            sequenceKey = [sequenceKey stringByAppendingString:@"_west"];
            break;
        case northwest:
            sequenceKey = [sequenceKey stringByAppendingString:@"_northwest"];
            break;
    }
    
    //NSLog(@"%@", sequenceKey);
    return sequenceKey;
}

-(void)actionLoop
{
    SKAction *animation = [self.frames animationForSequence:[self getSequenceForCardinal:self.cardinal forAction:self.action]];
    if (animation) {
        [self runAction:[SKAction sequence:@[animation, [SKAction runBlock:^{
            [self actionLoop];
        }]]]];
    } else {
        NSLog(@"error: nil animation %@", [self getSequenceForCardinal:self.cardinal forAction:self.action]);
        [self performSelector:@selector(actionLoop) withObject:nil afterDelay:1];
    }
}

@end
