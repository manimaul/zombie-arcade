//
//  ZAMyScene.m
//  8bit-zombie-arcade
//
//  Created by William Kamp on 10/12/13.
//  Copyright (c) 2013 Will Kamp. All rights reserved.
//

#import "ZAMyScene.h"
#import "ZAZombieSpriteNode.h"
#import "ZAHeroSpriteNode.h"
#import "CGPointF.h"
#import "ZACharachterAnimationFrames.h"
#import "ZACharacherSpriteNode.h"

@implementation ZAMyScene {
    NSTimeInterval lastUpdateTime;
    NSTimeInterval deltaTime;
    NSMutableArray *zombieNodes;
    ZAHeroSpriteNode *heroSpriteNode;
}

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        self.scaleMode = SKSceneScaleModeAspectFit;
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        
        SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        
        myLabel.text = @"Zombie Arcade!";
        myLabel.fontSize = 30;
        myLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                       CGRectGetMidY(self.frame));
        [self addChild:myLabel];
        
        zombieNodes = [NSMutableArray arrayWithCapacity:kMaxZombies];
        
        ZACharachterAnimationFrames *frames = [ZACharachterAnimationFrames sharedFrames];
        [frames loadAsyncWithCallback:^{
            heroSpriteNode = [ZAHeroSpriteNode createHeroSprite];
            heroSpriteNode.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
            [self addChild:heroSpriteNode];
            
            [self zombieLoop];
        }];
    }
    return self;
}

-(void)spawnZombie
{
    if ([zombieNodes count] < kMaxZombies) {
        ZAZombieSpriteNode *zombie = [ZAZombieSpriteNode createZombieSprite];
        zombie.position = CGPointMake(64., 64.);
    
        [self addChild:zombie];
        [zombieNodes addObject:zombie];
        [zombie moveToward:heroSpriteNode.position];
    }
}

-(void)zombieLoop
{
    [self spawnZombie];
    
    if (zombieNodes.count && heroSpriteNode.isInBounds) {
        ZAZombieSpriteNode *randomZombie = [zombieNodes objectAtIndex:(arc4random() % zombieNodes.count)];
        [randomZombie moveToward:heroSpriteNode.position];
        
        //kill a random zombie and spawn 2 more
        ZAZombieSpriteNode *randomZombie2 = [zombieNodes objectAtIndex:(arc4random() % zombieNodes.count)];
        if ([randomZombie2 isInBounds] && zombieNodes.count > 3) {
            [randomZombie2 performDeath:zombieNodes];
            [self spawnZombie];
            [self spawnZombie];
        }
        
        ZAZombieSpriteNode *randomZombie3 = [zombieNodes objectAtIndex:(arc4random() % zombieNodes.count)];
        if ([randomZombie3 isInBounds] && zombieNodes.count > 2) {
            [randomZombie3 attack];
        }
    }
    
    [self performSelector:@selector(zombieLoop) withObject:nil afterDelay:3];
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    if (lastUpdateTime) {
        deltaTime = currentTime - lastUpdateTime;
    } else {
        deltaTime = 0;
    }
    
    lastUpdateTime = currentTime;
    [heroSpriteNode updateForDeltaTime:deltaTime];
    for (ZAZombieSpriteNode *zombie in zombieNodes) {
        [zombie updateForDeltaTime:deltaTime];
    }
}

#pragma mark - touches

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInNode:self.scene];
    [heroSpriteNode moveToward:touchLocation];
    
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInNode:self.scene];
    [heroSpriteNode moveToward:touchLocation];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInNode:self.scene];
    [heroSpriteNode moveToward:touchLocation];
}

@end
