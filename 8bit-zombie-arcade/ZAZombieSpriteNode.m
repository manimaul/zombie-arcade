//
//  ZAZombieSpriteNode.m
//  8bit-zombie-arcade
//
//  Created by William Kamp on 10/13/13.
//  Copyright (c) 2013 Will Kamp. All rights reserved.
//

#import "ZAZombieSpriteNode.h"

static const int kDefaultNumberOfFrames = 8;
static const float kShowCharacterFramesOverOneSecond = 1.0f/(float) kDefaultNumberOfFrames;

@interface ZAZombieSpriteNode ()
@property (nonatomic, strong, readwrite) SKAction *animateLurch;
@property (nonatomic, strong) NSArray *lurchFrames;
@end

@implementation ZAZombieSpriteNode

+ (instancetype)createZombieSprite
{
    ZAZombieSpriteNode *zombieSprite = [[self class] spriteNodeWithImageNamed:@"zombie_lurch_west_0.png"];
    zombieSprite.size = CGSizeMake(32., 32.);
    return zombieSprite;
}

+ (NSArray *)animationFramesForImageNamePrefix:(NSString *)baseImageName frameCount:(NSInteger)count
{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:count];
    for (NSInteger index = 0; index < count; ++index) {
        NSString *imageName = [NSString stringWithFormat:@"%@%d.png", baseImageName, index];
        
        SKTexture *texture = [SKTexture textureWithImageNamed:imageName];
        
        [array addObject:texture];
    }
    
    return [NSArray arrayWithArray:array];
}


#pragma mark - [Accessor Overrides]

- (SKAction *)animateZombieLurch
{
    if (self.animateLurch == nil) {
        self.lurchFrames = [[self class] animationFramesForImageNamePrefix:@"zombie_lurch_west_" frameCount:kDefaultNumberOfFrames];
        self.animateLurch = [SKAction animateWithTextures:self.lurchFrames timePerFrame:kShowCharacterFramesOverOneSecond resize:NO restore:NO];
    }
    
    return self.animateLurch;
}

@end
