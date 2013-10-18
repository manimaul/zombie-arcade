//
//  ZAZombieAnimationFrames.m
//  8bit-zombie-arcade
//
//  Created by William Kamp on 10/16/13.
//  Copyright (c) 2013 Will Kamp. All rights reserved.
//

#import "ZAZombieAnimationFrames.h"

@implementation ZAZombieAnimationFrames

+(ZAZombieAnimationFrames *)sharedFrames
{
    static dispatch_once_t predicate;
    static ZAZombieAnimationFrames *shared = nil;
    dispatch_once(&predicate, ^{
        shared = [[ZAZombieAnimationFrames alloc] init];
    });
    return shared;
}

-(void)buildFramesAsyncWithCallback:(void(^)(void))completionBlock
{
    //[self loadAsyncCharachter:@"zombie" withCallback:completionBlock];
}


@end
