//
//  CharacterModel.h
//  8bit-zombie-arcade
//
//  Created by Jason Koceja on 10/14/13.
//  Copyright (c) 2013 Will Kamp. All rights reserved.
//

#import "ZANode.h"
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
    zombie,
    skeleton,
    goblin
} charachterType;

static const CGFloat walkMass = 10.;
static const CGFloat attackMass = 100.;
static const CGFloat dieMass = 1000.;
static const CGFloat stanceMass = 200.;

@interface ZACharacherSpriteNode : ZANode

@property (nonatomic, strong, readonly) NSString* charachterAtlasPrefix;
@property (nonatomic, strong, readonly) ZACharachterAnimationFrames *frames;
@property (nonatomic) fourtyFiveDegreeCardinal cardinal;
@property (nonatomic) charachterActions action;
@property (nonatomic) CGPoint velocity; //x = vector(direction) and y = length (speed in points per second)
@property (nonatomic) CGPoint lastVelocity;
@property (nonatomic) CGFloat movementSpeed;
@property (nonatomic) CGFloat timePerframe;
@property (nonatomic) CGFloat meleeSpeed;
@property (nonatomic) CGFloat hitPoints;
@property (nonatomic) NSInteger attackPower;

-(id)initWithCharachterType:(charachterType)type withHitPoints:(CGFloat)hitPoints;
- (void)setAnimationSequenceByCardinal:(fourtyFiveDegreeCardinal)newCardinal;
- (BOOL)isInBounds;

//call this every scene update
- (void)updateForDeltaTime:(NSTimeInterval)dt;

//charachter control methods
- (void)moveToward:(CGPoint)location;
- (void)moveTowardAngleRadians:(CGFloat)radians;
- (void)faceTowards:(CGPoint)location;
- (void)takeHit:(NSInteger)points withEnemies:(NSMutableArray*)trackedNodes;

//charachter animation methods
- (void)setImmediateAction:(charachterActions)action;
- (void)performDeath:(NSMutableArray*)trackedNodes;

@end
