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
            
            _atlasActions = @{ @"woman" : @[@"die", @"stance", @"walk"] ,
                               @"zombie": @[@"attack", @"die", @"walk"] };
            
            NSDictionary *action_frames = @{@"die": @6, @"stance": @4, @"walk": @8, @"attack": @4};
            
            _subCardinals = @[@"east", @"north", @"northeast", @"northwest",
                                      @"south", @"southeast", @"southwest", @"west"];
            
            NSMutableDictionary *db = [[NSMutableDictionary alloc] init];
            
            //build frame arrays for each and every atlas
            for (NSString* charachter in [_atlasActions keyEnumerator]) {
                for (NSString *action in [_atlasActions objectForKey:charachter]) {
                    for (NSString *subC in _subCardinals) {
                        NSString *sequence = [NSString stringWithFormat:@"%@_%@_%@", charachter, action, subC];
                        //NSLog(@"%@_%@_%@", charachter, action, subC);
                        NSNumber *numFrames = [action_frames objectForKey:action];
                        NSArray *frames = [self loadFramesFromAtlas:sequence withNumberOfFrames:numFrames.integerValue];
                        
                        [db setObject:frames forKey:sequence];
                    }
                }
            }
            
            _animationFrames = [NSDictionary dictionaryWithDictionary:db];
            
            //put the completion block back on the mainQueue so UI stuff can happen
            [[NSOperationQueue mainQueue] addOperationWithBlock:completionBlock];
        });
    }
}

-(SKAction*)animationForSequence:(NSString*)sequence
{
    NSArray *textures = [_animationFrames objectForKey:sequence];
    
    if (textures)
        return [SKAction animateWithTextures:textures timePerFrame:12.5 resize:YES restore:NO];
    
    return nil;
}

-(NSArray*)loadFramesFromAtlas:(NSString*)atlasName withNumberOfFrames:(NSInteger)numFrames
{
    NSMutableArray *frames = [NSMutableArray arrayWithCapacity:numFrames];
    SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:atlasName];
    //NSLog(@"atlas: %@", atlas);
    for (int i = 0; i < numFrames; i++) {
        NSString *textureName = [NSString stringWithFormat:@"%@_%d.png", atlasName, i];
        //NSLog(@"texture name: %@", textureName);
        SKTexture *texture = [atlas textureNamed:textureName];
        [frames addObject:texture];
    }
    
    return frames;
}

@end
