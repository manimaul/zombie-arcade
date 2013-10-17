//
//  ZAHeroAnimationFrames.h
//  8bit-zombie-arcade
//
//  Created by William Kamp on 10/16/13.
//  Copyright (c) 2013 Will Kamp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

@interface ZACharachterAnimationFrames : NSObject

@property (nonatomic, strong, readonly) SKAction *animateWalkNorth;

@property (nonatomic, strong, readonly) SKAction *animateWalkNorthEast;

@property (nonatomic, strong, readonly) SKAction *animateWalkEast;

@property (nonatomic, strong, readonly) SKAction *animateWalkSouthEast;

@property (nonatomic, strong, readonly) SKAction *animateWalkSouth;

@property (nonatomic, strong, readonly) SKAction *animateWalkSouthWest;

@property (nonatomic, strong, readonly) SKAction *animateWalkWest;

@property (nonatomic, strong, readonly) SKAction *animateWalkNorthWest;

-(void)loadAsyncCharachter:(NSString*)charachter withCallback:(void(^)(void))completionBlock;

@end
