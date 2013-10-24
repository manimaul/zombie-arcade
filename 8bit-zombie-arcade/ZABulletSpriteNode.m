//
//  ZABulletNode.m
//  8bit-zombie-arcade
//
//  Created by Christian Hansen on 10/16/13.
//  Copyright (c) 2013 Will Kamp. All rights reserved.
//

#import "ZABulletSpriteNode.h"

@implementation ZABulletSpriteNode

//- (instancetype)initWithPosition:(CGPoint)position
//{
//    if (self = [super initWithPosition:position]) {
//        self.name = @"bullet";
//        [self configureCollisionBody];
//    }
//    return self;
//}

//+ (SKTexture *)generateTexture
//{
//    static SKTexture *texture = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        
//        SKLabelNode *bullet =
//        [SKLabelNode labelNodeWithFontNamed:@"Arial"];
//        bullet.name = @"bullet";
//        bullet.fontSize = 20.0f;
//        bullet.fontColor = [SKColor whiteColor];
//        bullet.text = @"•";
//        
//        SKView *textureView = [SKView new];
//        texture = [textureView textureFromNode:bullet];
//        texture.filteringMode = SKTextureFilteringNearest;
//    });
//    
//    return texture;
//}
//
//- (void)configureCollisionBody
//{
//    self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:5];
//    self.physicsBody.affectedByGravity = NO;
//    self.physicsBody.categoryBitMask = ColliderTypeBullet;
//    self.physicsBody.collisionBitMask = 0;
//    self.physicsBody.contactTestBitMask = ColliderTypeZombie;
//}
//
//- (void)collidedWith:(SKPhysicsBody *)body contact:(SKPhysicsContact*)contact
//{
//    [self removeFromParent];
//}

@end
