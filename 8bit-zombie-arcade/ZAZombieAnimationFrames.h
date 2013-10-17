//
//  ZAZombieAnimationFrames.h
//  8bit-zombie-arcade
//
//  Created by William Kamp on 10/16/13.
//  Copyright (c) 2013 Will Kamp. All rights reserved.
//

#import "ZACharachterAnimationFrames.h"

@interface ZAZombieAnimationFrames : ZACharachterAnimationFrames

+(ZAZombieAnimationFrames *)sharedFrames;
-(void)buildFramesAsyncWithCallback:(void(^)(void))completionBlock;

@end
