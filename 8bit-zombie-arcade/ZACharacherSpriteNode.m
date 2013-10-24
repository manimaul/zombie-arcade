//
//  CharacterModel.m
//  8bit-zombie-arcade
//
//  Created by Jason Koceja on 10/14/13.
//  Copyright (c) 2013 Will Kamp. All rights reserved.
//

#import "ZACharacherSpriteNode.h"
#import "ZAHelpers.h"
#import "CGPointF.h"

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
        [self configurePhysicsBody];
        [self actionLoop];
    }
    return self;
}

- (void)updateForDeltaTime:(NSTimeInterval)dt
{
    CGPoint amountToMove = CGPointMultiplyScalar(self.velocity, dt);
    self.position = CGPointAdd(self.position, amountToMove);
    [self boundsCheck];
}

-(BOOL)isInBounds
{
    if (self.position.x <= CGPointZero.x) {
        return NO;
    }
    if (self.position.x >= self.scene.size.width) {
        return NO;
    }
    if (self.position.y <= CGPointZero.y) {
        return NO;
    }
    if (self.position.y >= self.scene.size.height) {
        return NO;
    }
    
    return YES;
}

- (void)boundsCheck
{
    if (self.action == walk) {
        CGPoint newPosition = self.position;
        CGPoint newVelocity = self.velocity;
        CGPoint bottomLeft = CGPointZero;
        CGPoint topRight = CGPointMake(self.scene.size.width, self.scene.size.height);
        if (newPosition.x <= bottomLeft.x) {
            newPosition.x = bottomLeft.x;
            newVelocity.x = -newVelocity.x;
        }
        if (newPosition.x >= topRight.x) {
            newPosition.x = topRight.x;
            newVelocity.x = -newVelocity.x;
        }
        if (newPosition.y <= bottomLeft.y) {
            newPosition.y = bottomLeft.y;
            newVelocity.y = -newVelocity.y;
        }
        if (newPosition.y >= topRight.y) {
            newPosition.y = topRight.y;
            newVelocity.y = -newVelocity.y;
        }
        self.position = newPosition;
        if (!CGPointEqualToPoint(self.velocity, newVelocity)) {
            self.cardinal = FortyFiveDegreeCardinalFromDegree(CGPointToAngleDegrees(newVelocity));
        }
        self.velocity = newVelocity;
    }
    
}

- (void) setAction:(charachterActions)action
{
    switch (action) {
        case stance:
            self.physicsBody.mass = stanceMass;
            break;
        case walk:
            self.physicsBody.mass = walkMass;
            break;
        case attack:
            self.physicsBody.mass = attackMass;
            break;
        case die:
            self.physicsBody.mass = dieMass;
            break;
        default:
            break;
    }
    _action = action;
}

#pragma mark - actions

- (void)moveToward:(CGPoint)location
{
    if (self.action == die) {
        return;
    }
    
    CGPoint offset = CGPointSubtract(location, self.position);
    CGFloat length = CGPointLength(offset);
    CGPoint direction = CGPointMake(offset.x / length, offset.y / length);
    self.velocity = CGPointMultiplyScalar(direction, self.movementSpeed);
    self.action = walk;
    [self setAnimationSequenceByCardinal:FortyFiveDegreeCardinalFromDegree(CGPointToAngleDegrees(self.velocity))];
}

- (void)moveTowardAngleRadians:(CGFloat)radians
{
    [self moveToward:ProjectPoint(self.position, 1., radians)];
}

- (void)faceTowards:(CGPoint)location
{
    self.cardinal = FortyFiveDegreeCardinalFromDegree(CGPointToAngleDegrees(CGPointSubtract(location, self.position)));
}

- (void)performDeath:(NSMutableArray*)trackedNodes
{
    [self removeAllActions];
    self.velocity = CGPointMake(0., 0.);
    self.physicsBody = nil;
    self.action = die;
    //SKAction *animation = [self.frames animationForSequence:[self getSequenceForCardinal:self.cardinal forAction:self.action]];
    SKAction *animation = [self.frames animationForSequence:[self getSequenceForCardinal:self.cardinal forAction:self.action] withTimePerFrame:self.timePerframe];
    if (animation) {
        [self runAction:[SKAction sequence:@[animation, [SKAction fadeOutWithDuration:1.25],[SKAction removeFromParent]]]];
    } else {
        [self removeFromParent];
    }
    if (trackedNodes)
        [trackedNodes removeObject:self];
}

- (void)takeHit:(NSInteger)points withEnemies:(NSMutableArray*)trackedNodes
{
    self.hitPoints -= points;
    if (self.hitPoints < 0)
        [self performDeath:trackedNodes];
}

#pragma mark - animation

- (void)setImmediateAction:(charachterActions)action
{
    if (self.action != action) {
        self.action = action;
        [self removeAllActions];
        [self actionLoop];
    }
}

- (void)setAnimationSequenceByCardinal:(fourtyFiveDegreeCardinal)newCardinal
{
    if (self.cardinal != newCardinal) {
        [self removeAllActions];
        self.cardinal = newCardinal;
        [self actionLoop];
    }
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
    if (self.action == die)
        return;
    
    //[self boundsCheck];
    SKAction *animation = [self.frames animationForSequence:[self getSequenceForCardinal:self.cardinal forAction:self.action] withTimePerFrame:self.timePerframe];
    if (animation) {
        [self runAction:[SKAction sequence:@[animation, [SKAction runBlock:^{
            [self actionLoop];
        }]]]];
    } else {
        //NSLog(@"error: nil animation %@", [self getSequenceForCardinal:self.cardinal forAction:self.action]);
        [self performSelector:@selector(actionLoop) withObject:nil afterDelay:1];
    }
}

#pragma mark - Physics and Collision

- (void)configurePhysicsBody
{
    //overridden in subclass
}

@end
