//
//  ZAGunModel.m
//  8bit-zombie-arcade
//
//  Created by Christian Hansen on 10/16/13.
//  Copyright (c) 2013 Will Kamp. All rights reserved.
//

#import "ZAGunModel.h"

@implementation ZAGunModel

//- (SKEmitterNode *)bulletEmitterNodeWithSpeed:(float)speed lifetime:(float)lifetime scale:(float)scale birthRate:(float)birthRate color:(SKColor*)color
//{
//    SKLabelNode *star =
//    [SKLabelNode labelNodeWithFontNamed:@"Helvetica"];
//    star.fontSize = 80.0f; star.text = @"+";
//    SKTexture *texture;
//    SKView *textureView = [SKView new];
//    texture = [textureView textureFromNode:star]; texture.filteringMode = SKTextureFilteringNearest;
//}


- (SKEmitterNode *)bulletEmitterNode
{
    NSString *bulletPath = [[NSBundle mainBundle] pathForResource:@"BulletParticle" ofType:@"sks"];
    SKEmitterNode *bulletParticle = [NSKeyedUnarchiver unarchiveObjectWithFile:bulletPath];
    bulletParticle.particlePosition = CGPointMake(0, 0);
    bulletParticle.particleBirthRate = 5;
    return bulletParticle;
    
    [self addChild:bulletParticle];
    
}

@end
