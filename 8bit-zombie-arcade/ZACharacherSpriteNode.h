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
@property (nonatomic) CGPoint velocity; //x = vector(direction) and y = length (speed in points per second)
@property (nonatomic) CGFloat movementSpeed;
@property (nonatomic) CGFloat timePerframe;

-(id)initWithCharachterType:(charachterType)type;
- (void)setAnimationSequenceByCardinal:(fourtyFiveDegreeCardinal)newCardinal;
-(BOOL)isInBounds;

//call this every scene update
- (void)updateForDeltaTime:(NSTimeInterval)dt;

//charachter control methods
- (void)moveToward:(CGPoint)location;
- (void)moveTowardAngleRadians:(CGFloat)radians;

//charachter animation methods
- (void)setImmediateAction:(charachterActions)action;
- (void)performDeath:(NSMutableArray*)trackedNodes;

@end
