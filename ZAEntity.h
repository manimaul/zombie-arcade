//
//  ZAEntity.h
//  8bit-zombie-arcade
//
//  Created by Christian Hansen on 10/16/13.
//  Copyright (c) 2013 Will Kamp. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef enum : uint8_t {
    ColliderTypeHero  = 1,
    ColliderTypeZombie  = 2,
    ColliderTypeBullet  = 4,
} ColliderType;

@interface ZAEntity : SKSpriteNode

@property (assign,nonatomic) CGPoint direction;
@property (assign,nonatomic) float   health;

- (instancetype)initWithPosition:(CGPoint)position;
- (void)update:(CFTimeInterval)delta;

- (void)configureCollisionBody;
- (void)collidedWith:(SKPhysicsBody *)body contact:(SKPhysicsContact*)contact;

@end
