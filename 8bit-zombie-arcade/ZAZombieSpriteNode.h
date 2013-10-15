//
//  ZAZombieSpriteNode.h
//  8bit-zombie-arcade
//
//  Created by William Kamp on 10/13/13.
//  Copyright (c) 2013 Will Kamp. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface ZAZombieSpriteNode : SKSpriteNode

@property (nonatomic, strong, readonly) SKAction *animateZombieLurch;
+ (instancetype)createZombieSprite;
//- (void)walkToX:(CGFloat)x duration:(NSTimeInterval)duration completion:(ZAZombieSpriteNode)completion;


@end
