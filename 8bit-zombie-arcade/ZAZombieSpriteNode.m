//
//  ZAZombieSpriteNode.m
//  8bit-zombie-arcade
//
//  Created by William Kamp on 10/13/13.
//  Copyright (c) 2013 Will Kamp. All rights reserved.
//

#import "ZAZombieSpriteNode.h"
#import "ZAHeroSpriteNode.h"
#import "CGPointF.h"

//static NSString* kZombieName = @"zombie";

@implementation ZAZombieSpriteNode

+ (instancetype)createZombieSprite
{
    ZAZombieSpriteNode *zombieSprite = [[ZAZombieSpriteNode alloc] initWithCharachterType:zombie];
    zombieSprite.cardinal = east;
    zombieSprite.action = walk;
    zombieSprite.movementSpeed = 80.;
    zombieSprite.timePerframe = .125;
    zombieSprite.hitPoints = 2;
    zombieSprite.attackPower = 1;
    zombieSprite.zPosition = 2.;
    zombieSprite.meleeSpeed = .75;
    return zombieSprite;
}

#pragma mark - actions

- (void)attackHero
{
    [self faceTowards:self.attackTarget.position];
    
    if (self.action != attack) {
        [self setImmediateAction:attack];
        self.velocity = CGPointMake(0., 0.);
        self.physicsBody.mass = attackMass;
    }
    
    //if hero is in our range, extract hit points
    if ([self.physicsBody.allContactedBodies indexOfObject:self.attackTarget.physicsBody] != NSNotFound) {
        //NSLog(@"zombie attacking hero - in range... extracting hp");
        [self.attackTarget takeHit:self.attackPower withEnemies:nil];
        
        if (self.attackTarget.hitPoints <= 0 || !self.attackTarget)
            [self setImmediateAction:walk];
        else
            [self performSelector:@selector(attackHero) withObject:nil afterDelay:self.meleeSpeed];
    }
    
}

- (void)configurePhysicsBody
{
    //image is 128x128 but characther is 30x55 or .25x.45
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(self.frame.size.width * .25, self.frame.size.height * .45)];
    
    self.physicsBody.affectedByGravity = NO;
    self.physicsBody.allowsRotation = NO;
    self.physicsBody.mass = walkMass;
    
    // We want to react to the following types of physics bodies
    self.physicsBody.collisionBitMask = kHeroBitmask | kEnemyBitmask | kBulletBitmask; //7
    
    self.physicsBody.categoryBitMask = kEnemyBitmask;
    
    // Make sure we get told about these collisions
    self.physicsBody.contactTestBitMask = kHeroBitmask | kBulletBitmask;
    
}

@end
