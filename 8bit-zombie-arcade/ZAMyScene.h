//
//  ZAMyScene.h
//  8bit-zombie-arcade
//

//  Copyright (c) 2013 Will Kamp. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "ZAButtonSpriteNode.h"

@class ZAHeroSpriteNode;

@interface ZAMyScene : SKScene <SKPhysicsContactDelegate>

-(void)heroDiedWithLives:(NSInteger)lives;
-(void)updateHudWithName:(NSString*)name withValue:(NSInteger)value;

@end
