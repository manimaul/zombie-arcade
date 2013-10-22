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



@implementation ZAHeroSpriteNode {
    BOOL continuousFire;
    BOOL characterStopped;
    
}

static NSArray* actions = nil;


+ (instancetype)createHeroSprite
{
    ZAHeroSpriteNode *heroSprite = [[ZAHeroSpriteNode alloc] initWithCharachterType:hero];
    heroSprite.cardinal = west;
    heroSprite.action = stance;
    heroSprite.movementSpeed = 120.;
    heroSprite.timePerframe = .095;
    return heroSprite;
}

#pragma mark - actions

- (void)stop
{
    self.lastVelocity = self.velocity;
    self.velocity = CGPointMake(0., 0.);
    [self setImmediateAction:stance];

}

- (void)setCharacterStopped:(BOOL)on
{
    
}

- (void)setContinuousFire:(BOOL)on
{
//    continuousFire = on;
    CGPoint velocity;
    if (self.velocity.x == 0 && self.velocity.y == 0)
        velocity = self.lastVelocity;
    else
        velocity = self.velocity;
    
    if (on) {
        CGFloat newRadian = CGPointToAngleRadians(velocity);
        [self fireBulletTowardAngleRadians:newRadian];
        NSLog(@"Continuous fire is on! %d", on);
    }

}

- (void)fireBulletTowardAngleRadians:(CGFloat)radians
{
    SKEmitterNode *bullet = [self shootBullet];
    
    if (bullet) {
        [self.scene addChild:bullet];
        bullet.particleBirthRate = 5;
        bullet.position = self.position;
        CGPoint destination = ProjectPoint(self.position, self.scene.size.width, radians);
        [bullet runAction:[SKAction sequence:@[[SKAction moveTo:destination duration:1.0],
                                               
                                               
                                               
                                               [SKAction removeFromParent],
//                                               [SKAction runBlock:^{
//            if (continuousFire) {
//                NSLog(@"Firing");
//                [self shootBullet];
//            }
//        } queue:dispatch_get_main_queue()]
                                               ]]];
    }
}

- (SKEmitterNode *)shootBullet
{
    SKEmitterNode *bullet;
    NSString *bulletPath = [[NSBundle mainBundle] pathForResource:@"bullet" ofType:@"sks"];
    bullet = [NSKeyedUnarchiver unarchiveObjectWithFile:bulletPath];
    
    return bullet;
}

@end
