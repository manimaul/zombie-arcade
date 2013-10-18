//
//  ZAHeroAnimationFrames.m
//  8bit-zombie-arcade
//
//  Created by William Kamp on 10/16/13.
//  Copyright (c) 2013 Will Kamp. All rights reserved.
//

#import "ZAHeroAnimationFrames.h"

@implementation ZAHeroAnimationFrames

+(ZAHeroAnimationFrames *)sharedFrames
{
    static dispatch_once_t predicate;
    static ZAHeroAnimationFrames *shared = nil;
    dispatch_once(&predicate, ^{
        shared = [[ZAHeroAnimationFrames alloc] init];
    });
    return shared;
}

-(void)buildFramesAsyncWithCallback:(void(^)(void))completionBlock
{
    //[self loadAsyncCharachter:@"woman" withCallback:completionBlock];
}

@end
