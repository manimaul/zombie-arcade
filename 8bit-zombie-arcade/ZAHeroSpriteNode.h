//
//  ZAHeroSpriteNode.h
//  8bit-zombie-arcade
//
//  Created by William Kamp on 10/14/13.
//  Copyright (c) 2013 Will Kamp. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface ZAHeroSpriteNode : SKSpriteNode

@property (nonatomic, strong, readonly) SKAction *animateHeroWalk;
+ (instancetype)createHeroSprite;
//- (void)walkToX:(CGFloat)x duration:(NSTimeInterval)duration completion:(ZAHeroSpriteNode)completion;

@end
