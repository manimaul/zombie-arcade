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
#import "ZAButtonSpriteNode.h"

@interface ZAMyScene()

@property (nonatomic) ZAHeroSpriteNode *heroSpriteNode;
@property (nonatomic) SKLabelNode *gameOverNode;
@property (nonatomic) BOOL isGameOver;
@property (nonatomic) NSInteger zombieKills;

@end

@implementation ZAMyScene {
    NSTimeInterval lastUpdateTime;
    NSTimeInterval deltaTime;
    NSMutableArray *zombieNodes;
    SKSpriteNode *controller;
    UITouch *firstTouch;
    UITouch *secondTouch;
    BOOL secondTouchDown;
    CGPoint firstTouchLocation;
}

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        self.scaleMode = SKSceneScaleModeAspectFit;
        self.physicsWorld.contactDelegate = self;
        
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
        controller.zPosition = 0.;
        controller.hidden = YES;
        [self addChild:controller];
        
        zombieNodes = [NSMutableArray arrayWithCapacity:kMaxZombies];
        
        ZACharachterAnimationFrames *frames = [ZACharachterAnimationFrames sharedFrames];
        [frames loadAsyncWithCallback:^{
            self.zombieKills = 0;
            [self buildHud];
            [self spawnHeroWithLives:@3];
            [self zombieLoop];
        }];
        
        secondTouchDown = NO;
        self.isGameOver = NO;
        
    }
    return self;
}

-(void)buildHud
{
    CGFloat hudD = self.frame.size.width / 3;
    CGFloat currX = 0.;
    CGFloat currY = 0.;
    CGFloat fontSize = 16;
    
    SKNode *hud = [[SKNode alloc] init];
    hud.zPosition = 0.;
    hud.position = CGPointMake(fontSize, self.size.height - fontSize * 2);
    hud.name = @"hud";
    
    SKLabelNode *kills = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    kills.name = @"kills";
    kills.text = [NSString stringWithFormat:@"KILLS: %d", 0];
    kills.fontSize = fontSize;
    kills.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    kills.position = CGPointMake(currX, currY);
    [hud addChild:kills];
    
    currX += hudD;
    
    SKLabelNode *energy = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    energy.name = @"energy";
    energy.text = [NSString stringWithFormat:@"ENERGY: %d", self.heroSpriteNode.hitPoints];
    energy.fontSize = fontSize;
    energy.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    energy.position = CGPointMake(currX, currY);
    [hud addChild:energy];
    
    currX += hudD;
    
    SKLabelNode *lives = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    lives.name = @"lives";
    lives.text = [NSString stringWithFormat:@"LIVES: %d", self.heroSpriteNode.lives];
    lives.fontSize = fontSize;
    lives.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    lives.position = CGPointMake(currX, currY);
    [hud addChild:lives];
    
    [self addChild:hud];
}

-(void)updateHud
{
    [self updateHudWithName:@"kills" withValue:self.zombieKills];
    [self updateHudWithName:@"energy" withValue:self.heroSpriteNode.hitPoints];
    [self updateHudWithName:@"lives" withValue:self.heroSpriteNode.lives];
}

-(void)spawnHeroWithLives:(NSNumber*)lives
{
    self.heroSpriteNode = [ZAHeroSpriteNode createHeroSprite];
    self.heroSpriteNode.lives = lives.intValue;
    self.heroSpriteNode.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    [self updateHud];
    [self addChild:self.heroSpriteNode];
    for (ZAZombieSpriteNode *zombie in zombieNodes) {
        zombie.attackTarget = self.heroSpriteNode;
        //[zombie moveToward:self.heroSpriteNode.position];
    }
}

-(void)updateHudWithName:(NSString*)name withValue:(NSInteger)value
{
    SKLabelNode *node = (SKLabelNode*) [[self childNodeWithName:@"hud"] childNodeWithName:name];
    if (node) {
        node.text = [NSString stringWithFormat:@"%@: %d", [name uppercaseString], MAX(value, 0)];
    }
}

-(CGPoint) randomScreenPoint
{
    CGFloat x = (CGFloat) (arc4random() % (int) (self.size.width));
    CGFloat y = (CGFloat) (arc4random() % (int) (self.size.height));
    return CGPointMake(x, y);
}

-(void)heroDiedWithLives:(NSInteger)lives
{
    for (ZAZombieSpriteNode *zombie in zombieNodes) {
        [zombie moveToward:[self randomScreenPoint]];
    }
    
    if (lives > 1) {
        NSLog(@"spawning new hero");
        [self performSelector:@selector(spawnHeroWithLives:) withObject:@(lives - 1) afterDelay:2];
    } else {
        [self gameOver];
    }
}

-(void)restartLevel
{
    [self.gameOverNode removeFromParent];
    self.isGameOver = NO;
    [self spawnHeroWithLives:@3];
    self.zombieKills = 0;
    [self updateHud];
    [self zombieLoop];
}

-(void)gameOver
{
    self.gameOverNode = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    self.gameOverNode.color = [UIColor redColor];
    self.gameOverNode.text = @"Game Over!";
    self.gameOverNode.fontSize = 44;
    self.gameOverNode.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    self.gameOverNode.position = CGPointMake(CGRectGetMidX(self.frame),
                                    CGRectGetMidY(self.frame));
    self.gameOverNode.alpha = 0.;
    [self addChild:self.gameOverNode];
    [self.gameOverNode runAction:[SKAction sequence:@[[SKAction fadeInWithDuration:2], [SKAction runBlock:^{
        self.isGameOver = YES;
    }]]]];
    
    [zombieNodes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        ZAZombieSpriteNode *zombie = obj;
        [zombie removeFromParent];
    }];
    [zombieNodes removeAllObjects];
}

-(void)spawnZombie
{
    if ( ([zombieNodes count] < kMaxZombies)  && !self.isGameOver && (self.heroSpriteNode.action != die) ) {
        ZAZombieSpriteNode *zombie = [ZAZombieSpriteNode createZombieSprite];
        zombie.position = CGPointMake(64., 64.);
        
        [self addChild:zombie];
        [zombieNodes addObject:zombie];
        zombie.attackTarget = self.heroSpriteNode;
        [zombie moveToward:self.heroSpriteNode.position];
    }
}

-(void)zombieLoop
{
    if (self.isGameOver || (self.heroSpriteNode.action == die) )
        return;
    
    [self spawnZombie];
    
    if (zombieNodes.count && self.heroSpriteNode.isInBounds) {
        
        ZAZombieSpriteNode *randomZombie = [zombieNodes objectAtIndex:(arc4random() % zombieNodes.count)];
        if (randomZombie.action == walk && randomZombie.isInBounds) {
            CGPoint vector = CGPointSubtract(randomZombie.attackTarget.position, randomZombie.position);
            CGFloat distFromHero = CGPointLength(vector);
            CGFloat maxDist = CGPointLength(CGPointMake(0., randomZombie.scene.size.height));
            CGFloat accuracy = distFromHero / maxDist;
            
            CGFloat deviance = 22.;
            if (arc4random() % 2)
                deviance = -deviance;
            
            deviance = deviance * accuracy + CGPointToAngleDegrees(vector);
            
            [randomZombie moveTowardAngleRadians:DegreesToRadians(deviance)];
        }
    }
    
    [self performSelector:@selector(zombieLoop) withObject:nil afterDelay:1];
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    if (lastUpdateTime) {
        deltaTime = currentTime - lastUpdateTime;
    } else {
        deltaTime = 0;
    }
    
    lastUpdateTime = currentTime;
    [self.heroSpriteNode updateForDeltaTime:deltaTime];
    
    for (ZAZombieSpriteNode *zombie in zombieNodes) {
        [zombie updateForDeltaTime:deltaTime];
    }
}

#pragma mark - touches

-(BOOL)isTouchLeftHemisphere:(CGPoint)touchLocation
{
    if (touchLocation.x <= self.scene.size.width / 2.)
        return YES;
    
    return NO;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.isGameOver || self.heroSpriteNode.action == die) {
        return;
    }
    
    
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInNode:self.scene];
    
    if ([self isTouchLeftHemisphere:touchLocation]) {
        if (controller.hidden) {
            firstTouch = touch;
            firstTouchLocation = touchLocation;
            controller.position = firstTouchLocation;
            controller.hidden = NO;
        }
    } else if (!secondTouchDown) {
        secondTouch = touch;
        [self.heroSpriteNode setContinuousFire:YES];
        secondTouchDown = YES;
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.isGameOver) {
        return;
    }
    
    if ([touches containsObject:firstTouch]) {
        
        //firstTouch has move to a newLocation
        CGPoint touchLocation = [firstTouch locationInNode:self.scene];
        
        //calculate angle of first touch location and new location
        [self.heroSpriteNode moveTowardAngleRadians:CGPointToAngleRadians(CGPointSubtract(touchLocation, firstTouchLocation))];
    }
    
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.isGameOver) {
        [self restartLevel];
    }
    
    if ([touches containsObject:firstTouch]) {
        controller.hidden = YES;
        [self.heroSpriteNode stop];
    }
    
    if ([touches containsObject:secondTouch]) {
        [self.heroSpriteNode setContinuousFire:NO];
        secondTouchDown = NO;
    }
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([touches containsObject:firstTouch]) {
        controller.hidden = YES;
        [self.heroSpriteNode stop];
    }
    
    if ([touches containsObject:secondTouch]) {
        [self.heroSpriteNode setContinuousFire:NO];
        secondTouchDown = NO;
    }
}


#pragma mark - SKPhysicsContactDelegate

- (void)didBeginContact:(SKPhysicsContact *)contact
{
    if (contact.bodyB.categoryBitMask == kEnemyBitmask) {
        ZAZombieSpriteNode *zombie = (ZAZombieSpriteNode*)contact.bodyB.node;
        if (contact.bodyA.categoryBitMask == kHeroBitmask) {
            [zombie attackHero];
        } else if (contact.bodyA.categoryBitMask == kBulletBitmask) {
            //[zombie takeHit:zombie.attackPower withEnemies:zombieNodes];
        }
    }
}


- (void)didEndContact:(SKPhysicsContact *)contact
{
    //right now only zombie sprite nodes are registered to be notified of contact (contactTestBitMask)
    ZAZombieSpriteNode *zombie;
    NSUInteger n = [zombieNodes indexOfObject:contact.bodyB.node];
    if (n != NSNotFound) {
        zombie = [zombieNodes objectAtIndex:n];
        [zombie moveToward:contact.bodyA.node.position];
    }
}

@end
