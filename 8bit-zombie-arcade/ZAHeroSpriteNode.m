//
//  ZAHeroSpriteNode.m
//  8bit-zombie-arcade
//
//  Created by William Kamp on 10/14/13.
//  Copyright (c) 2013 Will Kamp. All rights reserved.
//

#import "ZAHeroSpriteNode.h"
#import "ZACharachterAnimationFrames.h"
#import "CGPointF.h"
#import "ZAMyScene.h"
#import "ZABulletSpriteNode.h"

@implementation ZAHeroSpriteNode {
    BOOL continuousFire;
    BOOL characterStopped;
}

static NSArray* actions = nil;

+ (instancetype)createHeroSprite
{
    ZAHeroSpriteNode *heroSprite = [[ZAHeroSpriteNode alloc] initWithCharachterType:hero withHitPoints:5.];
    heroSprite.cardinal = west;
    heroSprite.action = stance;
    heroSprite.movementSpeed = 120.;
    heroSprite.timePerframe = .095;
    heroSprite.attackPower = 1;
    heroSprite.name = kHeroName;
    heroSprite.zPosition = 1.;
    [heroSprite runAction:[[ZACharachterAnimationFrames sharedFrames] getSoundActionForFile:@"level_up.caf"]];
    return heroSprite;
}

#pragma mark - actions

- (void)takeHit:(NSInteger)points withEnemies:(NSMutableArray*)trackedNodes
{
    [super takeHit:points withEnemies:trackedNodes];
    ZAMyScene *scene = (ZAMyScene*) self.scene;
    [scene updateHudWithName:@"energy" withValue:self.hitPoints];
}

- (void)performDeath:(NSMutableArray*)trackedNodes
{
    ZAMyScene *scene = (ZAMyScene*) self.scene;
    [scene heroDiedWithLives:self.lives];
    
    //super called last on purpose here
    [super performDeath:nil];
}

- (void)stop
{
    if (self.action == die)
        return;
    
    self.lastVelocity = self.velocity;
    self.velocity = CGPointMake(0., 0.);
    [self setImmediateAction:stance];
}

- (void)setContinuousFire:(BOOL)on
{
    if (self.action == die)
        return;
    
    CGPoint velocity;
    if (self.velocity.x == 0 && self.velocity.y == 0)
        velocity = self.lastVelocity;
    else
        velocity = self.velocity;
    
    if (on) {
        NSLog(@"Continuous fire is on");
        CGFloat newRadian = CGPointToAngleRadians(velocity);
        ZABulletSpriteNode *bullet = [ZABulletSpriteNode createBulletSprite];
        [self runAction:[[ZACharachterAnimationFrames sharedFrames] getSoundActionForFile:@"shoot.caf"]];
        
        
        
        if (bullet) {
            [self.scene addChild:bullet];
            bullet.position = self.position;
            CGPoint destination = ProjectPoint(self.position, self.scene.size.width, newRadian);
            
            SKAction *bulletAction = [SKAction sequence:@[
                                                   [SKAction moveTo:destination duration:2.0],
                                                   [SKAction fadeInWithDuration:0.5],
                                                   [SKAction removeFromParent]
                                                   ]];
//            [self.scene addChild:bullet];

            [bullet runAction:bulletAction];
            
//            [SKAction repeatActionForever:bulletAction];
            
        }
//        [self fireBulletTowardAngleRadians:newRadian];
    }
}

- (void)addChild:(SKNode *)node
{
    
}

//- (void)fireBulletTowardAngleRadians:(CGFloat)radians
//{
//    ZABulletSpriteNode *bullet = [ZABulletSpriteNode createBulletSprite];
//    if (bullet) {
//        [self.scene addChild:bullet];
//        bullet.position = self.position;
//        CGPoint destination = ProjectPoint(self.position, self.scene.size.width, radians);
//        [bullet runAction:[SKAction sequence:@[
//                                               [SKAction moveTo:destination duration:2.0],
//                                               [SKAction fadeInWithDuration:0.5],
//                                               [SKAction removeFromParent]
//                                               ]]];
//    }
//}



- (void)configurePhysicsBody
{
    //image is 128x128 but characther is 30x55 or .25x.45
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(self.frame.size.width * .25, self.frame.size.height * .45)];
    
    self.physicsBody.affectedByGravity = NO;
    self.physicsBody.allowsRotation = NO;
    self.physicsBody.mass = walkMass;
    
    // We want to react to the following types of physics bodies
    self.physicsBody.collisionBitMask = kEnemyBitmask;
    
    self.physicsBody.categoryBitMask = kHeroBitmask;
    
    // Make sure we get told about these collisions
    self.physicsBody.contactTestBitMask = kNullBitmask;
    
}

@end
