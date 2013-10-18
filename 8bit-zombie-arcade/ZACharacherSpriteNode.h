//
//  CharacterModel.h
//  8bit-zombie-arcade
//
//  Created by Jason Koceja on 10/14/13.
//  Copyright (c) 2013 Will Kamp. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "ZACharachterAnimationFrames.h"

typedef enum {
    north,
    northeast,
    east,
    southeast,
    south,
    southwest,
    west,
    northwest
} fourtyFiveDegreeCardinal;

typedef enum {
    stance,
    walk,
    attack,
    die    
} charachterActions;

typedef enum {
    hero,
    zombie
} charachterType;

@interface ZACharacherSpriteNode : SKSpriteNode

@property (nonatomic, strong, readonly) NSString* charachterAtlasPrefix;
@property (nonatomic, strong, readonly) ZACharachterAnimationFrames *frames;
@property (nonatomic) fourtyFiveDegreeCardinal cardinal;
@property (nonatomic) charachterActions action;

-(id)initWithCharachterType:(charachterType)type;
- (void)setAnimationSequenceByCardinal:(fourtyFiveDegreeCardinal)newCardinal;

@end
