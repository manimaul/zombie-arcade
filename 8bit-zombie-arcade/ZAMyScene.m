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
#import "ZAHelpers.h"
#import "ZACharachterAnimationFrames.h"
#import "ZACharacherSpriteNode.h"

@implementation ZAMyScene {
    NSTimeInterval lastUpdateTime;
    NSTimeInterval deltaTime;
    NSMutableArray *zombieNodes;
    ZAHeroSpriteNode *heroSpriteNode;
    SKSpriteNode *controller;
    UITouch *firstTouch;
    NSInteger touchCount; //touches.count is unreliable
    //BOOL haveFirstTouch; //touches.count is unreliable in touchesBegan
    CGPoint firstTouchLocation;
}

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        self.scaleMode = SKSceneScaleModeAspectFit;
        //self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        
        SKTextureAtlas *tileAtlas = [SKTextureAtlas atlasNamed:@"tiles"];
        SKSpriteNode *tileNode = [SKSpriteNode spriteNodeWithTexture:[tileAtlas textureNamed:@"stone_tiles.png"]];
        for (int x = 0; x < self.size.width; x += tileNode.size.width) {
            for (int y = 0; y < self.size.height; y += tileNode.size.height) {
                tileNode = [tileNode copy];
                tileNode.position = CGPointMake(x,y);
                tileNode.zPosition = -1.0f;
                tileNode.blendMode = SKBlendModeReplace;
                tileNode.anchorPoint = CGPointMake(0., 0.);
                [self addChild:tileNode];
            }
        }
        
        controller = [SKSpriteNode spriteNodeWithTexture:[tileAtlas textureNamed:@"controller.png"]];
        controller.zPosition = 0.f;
        controller.hidden = YES;
        [self addChild:controller];
        
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
        
        touchCount = 0;
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
    if (!touchCount) {
        UITouch *touch = [touches anyObject];
        firstTouch = touch;
        firstTouchLocation = [firstTouch locationInNode:self.scene];
        controller.position = firstTouchLocation;
        controller.hidden = NO;
    } else {
        //call method to start weapon fire here
        [self fireBulletTowardAngleRadians:CGPointToAngleRadians(heroSpriteNode.velocity)];
    }
    
    touchCount++;
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    //firstTouch has move to a newLocation
    CGPoint touchLocation = [firstTouch locationInNode:self.scene];
    
    //calculate angle of first touch location and new location
    [heroSpriteNode moveTowardAngleRadians:CGPointToAngleRadians(CGPointSubtract(touchLocation, firstTouchLocation))];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (touchCount <= 2) {
        //call method to stop continuous weapon fire here
    }
    if (touchCount <= 1) {
        //stop hero motion
        [heroSpriteNode stop];
        controller.hidden = YES;
    }
    
    touchCount--;
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (touchCount <= 2) {
        //call method to stop continuous weapon fire here
    }
    if (touchCount <= 1) {
        //stop hero motion
        [heroSpriteNode stop];
        controller.hidden = YES;
    }
    touchCount--;
}

- (void)fireBulletTowardAngleRadians:(CGFloat)radians
{
    SKEmitterNode *bullet = [self shootBullet];
    if (bullet) {
        [self addChild:bullet];
        bullet.particleBirthRate = 5;
        bullet.position = heroSpriteNode.position;
        CGPoint destination = ProjectPoint(heroSpriteNode.position, self.size.width, radians);
        [bullet runAction:[SKAction sequence:@[[SKAction moveTo:destination duration:1.0],
                                               [SKAction removeFromParent]]]];
    }
}

- (SKEmitterNode *)shootBullet
{
    SKEmitterNode *bullet;
    NSString *bulletPath = [[NSBundle mainBundle] pathForResource:@"bullet" ofType:@"sks"];
    bullet = [NSKeyedUnarchiver unarchiveObjectWithFile:bulletPath];
    
    return bullet;
}

@end
