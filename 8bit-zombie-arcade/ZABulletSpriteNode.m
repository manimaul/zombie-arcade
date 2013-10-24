//
//  ZABulletNode.m
//  8bit-zombie-arcade
//
//  Created by Christian Hansen on 10/16/13.
//  Copyright (c) 2013 Will Kamp. All rights reserved.
//

#import "ZABulletSpriteNode.h"

@implementation ZABulletSpriteNode

+ (ZABulletSpriteNode *)createBulletSprite
{
    ZABulletSpriteNode *bulletSprite = [ZABulletSpriteNode spriteNodeWithImageNamed:@"bullet"];
    
    [bulletSprite configurePhysicsBody];
    
    return bulletSprite;
}

//- (SKNode *)shootBullet
//{
//    SKSpriteNode * bullet = [SKSpriteNode spriteNodeWithImageNamed:@"bullet"];
//    
//    return bullet;
//}

- (void)configurePhysicsBody
{
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(self.frame.size.width * 2, self.frame.size.height *2)];
    self.physicsBody.affectedByGravity = NO;
    self.physicsBody.allowsRotation = NO;
    self.physicsBody.mass = 40;
    
    // We want to react to the following types of physics bodies
    self.physicsBody.collisionBitMask =  kEnemyBitmask;
    
    self.physicsBody.categoryBitMask = kBulletBitmask;
    
    // Make sure we get told about these collisions
    self.physicsBody.contactTestBitMask = kEnemyBitmask;
    
    
}

@end
