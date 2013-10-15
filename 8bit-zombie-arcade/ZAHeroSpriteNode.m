//
//  ZAHeroSpriteNode.m
//  8bit-zombie-arcade
//
//  Created by William Kamp on 10/14/13.
//  Copyright (c) 2013 Will Kamp. All rights reserved.
//

#import "ZAHeroSpriteNode.h"

static const int kDefaultNumberOfFrames = 8;
static const float kShowCharacterFramesOverOneSecond = 1.0f/(float) kDefaultNumberOfFrames;

@interface ZAHeroSpriteNode ()
@property (nonatomic, strong, readwrite) SKAction *animateLurch;
@property (nonatomic, strong) NSArray *lurchFrames;
@end

@implementation ZAHeroSpriteNode

+ (instancetype)createHeroSprite
{
    ZAHeroSpriteNode *heroSprite = [[self class] spriteNodeWithImageNamed:@"woman_walk_west_0.png"];
    
    return heroSprite;
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

- (SKAction *)animateHeroWalk
{
    if (self.animateLurch == nil) {
        self.lurchFrames = [[self class] animationFramesForImageNamePrefix:@"woman_walk_west_" frameCount:kDefaultNumberOfFrames];
        self.animateLurch = [SKAction animateWithTextures:self.lurchFrames timePerFrame:kShowCharacterFramesOverOneSecond resize:YES restore:NO];
    }
    
    return self.animateLurch;
}
@end
