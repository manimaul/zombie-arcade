//
//  ZAEntity.m
//  8bit-zombie-arcade
//
//  Created by Christian Hansen on 10/16/13.
//  Copyright (c) 2013 Will Kamp. All rights reserved.
//

#import "ZAEntity.h"

@implementation ZAEntity

- (instancetype)initWithPosition:(CGPoint)position
{
    if (self = [super init]) {
        self.position = position;
        _direction = CGPointZero;
    }
    return self;
}

- (void)update:(CFTimeInterval)delta
{
    // Overridden by subclasses
}

+ (SKTexture *)generateTexture
{
    // Overridden by subclasses
    return nil;
}

- (void)configureCollisionBody
{
    // Overridden by a subclass
}

- (void)collidedWith:(SKPhysicsBody *)body contact:(SKPhysicsContact*)contact
{
    // Overridden by a subclass
}

@end
