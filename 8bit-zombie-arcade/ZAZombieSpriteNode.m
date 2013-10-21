//
//  ZAZombieSpriteNode.m
//  8bit-zombie-arcade
//
//  Created by William Kamp on 10/13/13.
//  Copyright (c) 2013 Will Kamp. All rights reserved.
//

#import "ZAZombieSpriteNode.h"
#import "ZAEntity.h"
#import "ZAGunModel.h"

@implementation ZAZombieSpriteNode

+ (instancetype)createZombieSprite
{
    ZAZombieSpriteNode *zombieSprite = [[ZAZombieSpriteNode alloc] initWithCharachterType:zombie];
    zombieSprite.cardinal = east;
    zombieSprite.action = walk;
    zombieSprite.movementSpeed = 80.;
    zombieSprite.timePerframe = .125;
    return zombieSprite;
}

#pragma mark - actions

- (void)attack
{
    self.action = attack;
    self.velocity = CGPointMake(0., 0.);
}

#pragma mark Physics and Collision

- (void)configureCollisionBody
{
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.frame.size];
    
    self.physicsBody.affectedByGravity = NO;
    
    // Set the category of the physics object that will be used for collisions
    self.physicsBody.categoryBitMask = ColliderTypeZombie;
    
    // We want to know when a collision happens but we dont want the bodies to actually react to each other so we
    // set the collisionBitMask to 0
    self.physicsBody.collisionBitMask = 0;
    
    // Make sure we get told about these collisions
    self.physicsBody.contactTestBitMask = ColliderTypeHero | ColliderTypeBullet;
    
}

@end
