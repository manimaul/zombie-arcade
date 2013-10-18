//
//  ZAHeroAnimationFrames.m
//  8bit-zombie-arcade
//
//  Created by William Kamp on 10/16/13.
//  Copyright (c) 2013 Will Kamp. All rights reserved.
//

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

+(ZACharachterAnimationFrames *)sharedFrames
{
    static dispatch_once_t predicate;
    static ZACharachterAnimationFrames *shared = nil;
    dispatch_once(&predicate, ^{
        shared = [[ZACharachterAnimationFrames alloc] init];
    });
    return shared;
}

-(void)loadAsyncWithCallback:(void(^)(void))completionBlock
{
    if (!self.loaded) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            self.loaded = YES;
            
//            int frameCount = 8;
//            float framesPerSecond = 1.0f/(float) frameCount;
            
            NSDictionary * atlas_actions = @{@"woman" : @[@"die", @"stance", @"walk"] ,
                                             @"zombie": @[@"attack", @"die", @"walk"] };
            
            NSArray *subCardinals = @[@"east", @"north", @"northeast", @"northwest",
                                   @"south", @"southeast", @"southwest", @"west"];
            
            //build frame arrays for each and every atlas
            for (NSString* charachter in [atlas_actions keyEnumerator]) {
                for (NSString *action in [atlas_actions objectForKey:charachter]) {
                    for (NSString *subC in subCardinals) {
                        NSString *sequence = [NSString stringWithFormat:@"%@_%@_%@", charachter, action, subC];
                        NSLog(@"%@_%@_%@", charachter, action, subC);
                    }
                }
            }
            
            
            //populate all the animation sequence frames for hero
//            
//            self.walkNorthFrames = [self animationFramesForImageNamePrefix:[NSString stringWithFormat:@"%@_walk_north_", charachter] frameCount:frameCount];
//            _animateWalkNorth = [SKAction animateWithTextures:self.walkNorthFrames timePerFrame:framesPerSecond resize:YES restore:NO];;
//            
//            
//            self.walkNorthEastFrames = [self animationFramesForImageNamePrefix:[NSString stringWithFormat:@"%@_walk_northeast_", charachter] frameCount:frameCount];
//            _animateWalkNorthEast = [SKAction animateWithTextures:self.walkNorthEastFrames timePerFrame:framesPerSecond resize:YES restore:NO];;
//            
//            self.walkEastFrames = [self animationFramesForImageNamePrefix:[NSString stringWithFormat:@"%@_walk_east_", charachter] frameCount:frameCount];
//            _animateWalkEast = [SKAction animateWithTextures:self.walkEastFrames timePerFrame:framesPerSecond resize:YES restore:NO];;
//            
//            self.walkSouthEastFrames = [self animationFramesForImageNamePrefix:[NSString stringWithFormat:@"%@_walk_southeast_", charachter] frameCount:frameCount];
//            _animateWalkSouthEast = [SKAction animateWithTextures:self.walkSouthEastFrames timePerFrame:framesPerSecond resize:YES restore:NO];;
//            
//            self.walkSouthFrames = [self animationFramesForImageNamePrefix:[NSString stringWithFormat:@"%@_walk_south_", charachter] frameCount:frameCount];
//            _animateWalkSouth = [SKAction animateWithTextures:self.walkSouthFrames timePerFrame:framesPerSecond resize:YES restore:NO];;
//            
//            
//            self.walkSouthWestFrames = [self animationFramesForImageNamePrefix:[NSString stringWithFormat:@"%@_walk_southwest_", charachter] frameCount:frameCount];
//            _animateWalkSouthWest = [SKAction animateWithTextures:self.walkSouthWestFrames timePerFrame:framesPerSecond resize:YES restore:NO];;
//            
//            self.walkWestFrames = [self animationFramesForImageNamePrefix:[NSString stringWithFormat:@"%@_walk_west_", charachter] frameCount:frameCount];
//            _animateWalkWest = [SKAction animateWithTextures:self.walkWestFrames timePerFrame:framesPerSecond resize:YES restore:NO];
//            self.walkNorthWestFrames = [self animationFramesForImageNamePrefix:[NSString stringWithFormat:@"%@_walk_northwest_", charachter] frameCount:frameCount];
//            _animateWalkNorthWest = [SKAction animateWithTextures:self.walkNorthWestFrames timePerFrame:framesPerSecond resize:YES restore:NO];;
            
            //put the completion block back on the mainQueue so UI stuff can happen
            [[NSOperationQueue mainQueue] addOperationWithBlock:completionBlock];
        });
    }
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
