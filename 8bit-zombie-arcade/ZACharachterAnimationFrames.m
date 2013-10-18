//
//  ZAHeroAnimationFrames.m
//  8bit-zombie-arcade
//
//  Created by William Kamp on 10/16/13.
//  Copyright (c) 2013 Will Kamp. All rights reserved.
//

/*
 Note!!! this is not a singleton: however, this class is inteded to be a superclass of individual singletons
 who hold animation frames for a particular type of node.
 */

#import "ZACharachterAnimationFrames.h"

static const int kDefaultNumberOfFrames = 8;
static const float kShowCharacterFramesOverOneSecond = 1.0f/(float) kDefaultNumberOfFrames;

@interface ZACharachterAnimationFrames ()

@property (nonatomic, strong) NSArray *walkNorthFrames;

@property (nonatomic, strong) NSArray *walkNorthEastFrames;

@property (nonatomic, strong) NSArray *walkEastFrames;

@property (nonatomic, strong) NSArray *walkSouthEastFrames;

@property (nonatomic, strong) NSArray *walkSouthFrames;

@property (nonatomic, strong) NSArray *walkSouthWestFrames;

@property (nonatomic, strong) NSArray *walkWestFrames;

@property (nonatomic, strong) NSArray *walkNorthWestFrames;

@property (nonatomic) BOOL loaded;

@end

@implementation ZACharachterAnimationFrames
int frameCount = 8;

-(void)loadAsyncCharachter:(NSString*)charachter withCallback:(void(^)(void))completionBlock
{
    if (!self.loaded) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            self.loaded = YES;
            [self populateTextures:charachter];
            
            //populate all the animation sequence frames for hero
            
            float framesPerSecond = 1.0f/(float) frameCount;
            
            _animateWalkNorth = [SKAction animateWithTextures:self.walkNorthFrames timePerFrame:framesPerSecond resize:YES restore:NO];;
            
            _animateWalkNorthEast = [SKAction animateWithTextures:self.walkNorthEastFrames timePerFrame:framesPerSecond resize:YES restore:NO];;
            
            _animateWalkEast = [SKAction animateWithTextures:self.walkEastFrames timePerFrame:framesPerSecond resize:YES restore:NO];;
            
            _animateWalkSouthEast = [SKAction animateWithTextures:self.walkSouthEastFrames timePerFrame:framesPerSecond resize:YES restore:NO];;
            
            _animateWalkSouth = [SKAction animateWithTextures:self.walkSouthFrames timePerFrame:framesPerSecond resize:YES restore:NO];;
            
            _animateWalkSouthWest = [SKAction animateWithTextures:self.walkSouthWestFrames timePerFrame:framesPerSecond resize:YES restore:NO];;
            
            _animateWalkWest = [SKAction animateWithTextures:self.walkWestFrames timePerFrame:framesPerSecond resize:YES restore:NO];
            
            _animateWalkNorthWest = [SKAction animateWithTextures:self.walkNorthWestFrames timePerFrame:framesPerSecond resize:YES restore:NO];;
            
            //put the completion block back on the mainQueue so UI stuff can happen
            [[NSOperationQueue mainQueue] addOperationWithBlock:completionBlock];
        });
    }
}

- (NSArray *)loadTextures:(NSString*)direction character:(NSString*)charachter{
    
    SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:[NSString stringWithFormat:@"%@",charachter]];
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < frameCount; i++) {
        NSString *string = [NSString stringWithFormat:@"%@_walk_%@_%d",charachter,direction,i];
        SKTexture *texture = [atlas textureNamed:string];
        [array addObject:texture];
    }
    
    return array;
}

- (void)populateTextures:(NSString*)charachter{
    
    self.walkNorthFrames = [self loadTextures:@"north" character:charachter];
    self.walkNorthEastFrames = [self loadTextures:@"northeast" character:charachter];
    self.walkEastFrames = [self loadTextures:@"east" character:charachter];
    self.walkSouthEastFrames = [self loadTextures:@"southeast" character:charachter];
    self.walkSouthFrames = [self loadTextures:@"south" character:charachter];
    self.walkSouthWestFrames = [self loadTextures:@"southwest" character:charachter];
    self.walkWestFrames = [self loadTextures:@"west" character:charachter];
    self.walkNorthWestFrames = [self loadTextures:@"northwest" character:charachter];
}

-(NSArray *)animationFramesForImageNamePrefix:(NSString *)baseImageName frameCount:(int)count
{
    NSMutableArray *frames = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i < count; ++i) {
        NSString *imageName = [NSString stringWithFormat:@"%@%d.png", baseImageName, i];
        //NSLog(@"%@", imageName);
        SKTexture *texture = [SKTexture textureWithImageNamed:imageName];
        
        [frames addObject:texture];
    }
    
    return frames;
}

@end
