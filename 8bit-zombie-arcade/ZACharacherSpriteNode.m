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
    
    self = [super initWithImageNamed:[NSString stringWithFormat:@"%@_walk_west_0.png", charachterAtlasPrefix]];
    if (self) {
        _charachterAtlasPrefix = charachterAtlasPrefix;
    }
    
    return self;
}

@end
