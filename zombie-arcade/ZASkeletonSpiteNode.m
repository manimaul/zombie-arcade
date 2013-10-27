//
//  ZASkeletonSpiteNode.m
//  8bit-zombie-arcade
//
//  Created by William Kamp on 10/25/13.
//  Copyright (c) 2013 Will Kamp. All rights reserved.
//

#import "ZASkeletonSpiteNode.h"

@implementation ZASkeletonSpiteNode

+ (instancetype)createSprite
{
    ZASkeletonSpiteNode *s = [[ZASkeletonSpiteNode alloc] initWithCharachterType:skeleton withHitPoints:4.];
    s.cardinal = east;
    s.movementSpeed = 60.;
    s.timePerframe = .125;
    s.attackPower = 1.5;
    s.zPosition = 2.;
    s.meleeSpeed = .75;
    [s setImmediateAction:walk];
    return s;
}

- (void)configurePhysicsBody
{
    //image is 128x128 but characther is 30x55 or .25x.45
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(self.frame.size.width * .25, self.frame.size.height * .45)];
    
    self.physicsBody.affectedByGravity = NO;
    self.physicsBody.allowsRotation = NO;
    self.physicsBody.mass = walkMass;
    
    // We want to react to the following types of physics bodies
    self.physicsBody.collisionBitMask = kHeroBitmask | kEnemyBitmask | kBulletBitmask;
    
    self.physicsBody.categoryBitMask = kEnemyBitmask;
    
    // Make sure we get told about these collisions
    self.physicsBody.contactTestBitMask = kHeroBitmask | kBulletBitmask;
    
}

@end
