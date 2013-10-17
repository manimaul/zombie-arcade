//
//  CharacterModel.h
//  8bit-zombie-arcade
//
//  Created by Jason Koceja on 10/14/13.
//  Copyright (c) 2013 Will Kamp. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

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
    hero,
    zombie
} charachterType;

@interface ZACharacherSpriteNode : SKSpriteNode

@property (nonatomic, strong, readonly) NSString* charachterAtlasPrefix;
-(id)initWithCharachterType:(charachterType)type;

@end
