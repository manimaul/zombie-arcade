//
//  ZAMyScene.m
//  8bit-zombie-arcade
//
//  Created by William Kamp on 10/12/13.
//  Copyright (c) 2013 Will Kamp. All rights reserved.
//

#import "ZAMyScene.h"
#import "ZAEnemySpriteNode.h"
#import "ZAZombieSpriteNode.h"
#import "ZASkeletonSpiteNode.h"
#import "ZAGoblinSpriteNode.h"
#import "ZAHeroSpriteNode.h"
#import "CGPointF.h"
#import "ZAHelpers.h"
#import "ZACharachterAnimationFrames.h"
#import "ZACharacherSpriteNode.h"
#import "ZAButtonSpriteNode.h"
#import "ZABulletSpriteNode.h"

@interface ZAMyScene()

@property (nonatomic) ZAHeroSpriteNode *heroSpriteNode;
@property (nonatomic) SKLabelNode *gameOverNode;
@property (nonatomic) BOOL isGameOver;

@end

@implementation ZAMyScene {
    NSTimeInterval lastUpdateTime;
    NSTimeInterval deltaTime;
    NSMutableArray *enemyNodes;
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
        
        enemyNodes = [NSMutableArray arrayWithCapacity:kMaxEnemies];
        
        ZACharachterAnimationFrames *frames = [ZACharachterAnimationFrames sharedFrames];
        [frames loadAsyncWithCallback:^{
            self.zombieKills = 0;
            [self buildHud];
            [self spawnHeroWithLives:@3];
            [self zombieLoop];
        }];
        
        //[self runAction:[SKAction repeatActionForever:[SKAction playSoundFileNamed:@"wind_loop.m4a" waitForCompletion:YES]]];
        
        secondTouchDown = NO;
        self.isGameOver = NO;
        
    }
    return self;
}

-(void)setZombieKills:(NSInteger)zombieKills {
    _zombieKills = zombieKills;
    
    if ( !(self.zombieKills % 10) && self.zombieKills > 0 )
        [self runAction:[[ZACharachterAnimationFrames sharedFrames] getSoundActionForFile:@"warcry.caf"]];
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
    energy.text = [NSString stringWithFormat:@"ENERGY: %d",(int) self.heroSpriteNode.hitPoints];
    energy.fontSize = fontSize;
    energy.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    energy.position = CGPointMake(currX, currY);
    [hud addChild:energy];
    
    currX += hudD;
    
    SKLabelNode *lives = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    lives.name = @"lives";
    lives.text = [NSString stringWithFormat:@"LIVES: %ld", (long)self.heroSpriteNode.lives];
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
    for (ZAEnemySpriteNode *enemy in enemyNodes) {
        enemy.attackTarget = self.heroSpriteNode;
        //[zombie moveToward:self.heroSpriteNode.position];
    }
}

-(void)updateHudWithName:(NSString*)name withValue:(NSInteger)value
{
    SKLabelNode *node = (SKLabelNode*) [[self childNodeWithName:@"hud"] childNodeWithName:name];
    if (node) {
        node.text = [NSString stringWithFormat:@"%@: %d", [name uppercaseString], (int) MAX(value, 0)];
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
    [self runAction:[[ZACharachterAnimationFrames sharedFrames] getSoundActionForFile:@"female_die.caf"]];
    
    for (ZAEnemySpriteNode *enemy in enemyNodes) {
        [enemy moveToward:[self randomScreenPoint]];
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
    [self setZombieKills:0];
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
    
    [enemyNodes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        ZAEnemySpriteNode *enemy = obj;
        [enemy removeFromParent];
    }];
    [enemyNodes removeAllObjects];
}

-(void)spawnZombie
{
    if ( ([enemyNodes count] < kMaxEnemies)  && !self.isGameOver && (self.heroSpriteNode.action != die) ) {
        ZAEnemySpriteNode *enemy;
        
        NSInteger lowerBound = zombie;
        NSInteger upperBound = goblin + 1;
        NSInteger randBetween = lowerBound + arc4random() % (upperBound - lowerBound);
        switch (randBetween) {
            case zombie:
                enemy = [ZAZombieSpriteNode createSprite];
                [self runAction:[[ZACharachterAnimationFrames sharedFrames] getSoundActionForFile:@"zombie_ment.caf"]];
                break;
            case skeleton:
                enemy = [ZASkeletonSpiteNode createSprite];
                [self runAction:[[ZACharachterAnimationFrames sharedFrames] getSoundActionForFile:@"skeleton_ment.caf"]];
                break;
            case goblin:
                enemy = [ZAGoblinSpriteNode createSprite];
                [self runAction:[[ZACharachterAnimationFrames sharedFrames] getSoundActionForFile:@"goblin_ment.caf"]];
                break;
                
        }
//        if (arc4random() % 2) {
//            enemy = [ZAZombieSpriteNode createSprite];
//        } else {
//            enemy = [ZASkeletonSpiteNode createSprite];
//        }
        enemy.position = CGPointMake(64., 64.);
        
        [self addChild:enemy];
        [enemyNodes addObject:enemy];
        enemy.attackTarget = self.heroSpriteNode;
        [enemy moveToward:self.heroSpriteNode.position];
    }
}

-(void)zombieLoop
{
    if (self.isGameOver)
        return;
    
    [self spawnZombie];
    
    if (enemyNodes.count && self.heroSpriteNode.isInBounds) {
        
        ZAEnemySpriteNode *randomEnemy = [enemyNodes objectAtIndex:(arc4random() % enemyNodes.count)];
        if (randomEnemy.action == walk && randomEnemy.isInBounds) {
            CGPoint vector = CGPointSubtract(randomEnemy.attackTarget.position, randomEnemy.position);
            CGFloat distFromHero = CGPointLength(vector);
            CGFloat maxDist = CGPointLength(CGPointMake(0., randomEnemy.scene.size.height));
            CGFloat accuracy = distFromHero / maxDist;
            
            CGFloat deviance = 22.;
            if (arc4random() % 2)
                deviance = -deviance;
            
            deviance = deviance * accuracy + CGPointToAngleDegrees(vector);
            
            [randomEnemy moveTowardAngleRadians:DegreesToRadians(deviance)];
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
    
    for (ZAEnemySpriteNode *enemy in enemyNodes) {
        [enemy updateForDeltaTime:deltaTime];
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
    ZAHeroSpriteNode *hero;
    ZAEnemySpriteNode *enemy;
    ZABulletSpriteNode *bullet;
    
    switch (contact.bodyA.categoryBitMask) {
        case kHeroBitmask:
            hero = (ZAHeroSpriteNode*) contact.bodyA.node;
            break;
        case kEnemyBitmask:
            enemy = (ZAEnemySpriteNode*) contact.bodyA.node;
            break;
        case kBulletBitmask:
            bullet = (ZABulletSpriteNode*) contact.bodyA.node;
            break;
    }

    switch (contact.bodyB.categoryBitMask) {
        case kHeroBitmask:
            hero = (ZAHeroSpriteNode*) contact.bodyB.node;
            break;
        case kEnemyBitmask:
            enemy = (ZAEnemySpriteNode*) contact.bodyB.node;
            break;
        case kBulletBitmask:
            bullet = (ZABulletSpriteNode*) contact.bodyB.node;
            break;
    }
    
    if (bullet && zombie) {
        [enemy takeHit:self.heroSpriteNode.attackPower withEnemies:enemyNodes];
        [bullet removeFromParent];
    } else if (hero && zombie) {
        [enemy attackHero];
    }
}


- (void)didEndContact:(SKPhysicsContact *)contact
{
    ZAZombieSpriteNode *zombie;
    ZAHeroSpriteNode *hero;
    
    switch (contact.bodyA.categoryBitMask) {
        case kHeroBitmask:
            hero = (ZAHeroSpriteNode*) contact.bodyA.node;
            break;
        case kEnemyBitmask:
            zombie = (ZAZombieSpriteNode*) contact.bodyA.node;
            break;
    }
    
    switch (contact.bodyB.categoryBitMask) {
        case kHeroBitmask:
            hero = (ZAHeroSpriteNode*) contact.bodyB.node;
            break;
        case kEnemyBitmask:
            zombie = (ZAZombieSpriteNode*) contact.bodyB.node;
            break;
    }
    
    if (zombie && hero) {
        [zombie moveToward:hero.position];
    }
}


@end
