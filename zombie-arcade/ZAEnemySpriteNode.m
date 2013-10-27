//
//  ZAEnemySpriteNode.m
//  8bit-zombie-arcade
//
//  Created by William Kamp on 10/25/13.
//  Copyright (c) 2013 Will Kamp. All rights reserved.
//

#import "ZAEnemySpriteNode.h"
#import "ZAMyScene.h"

@implementation ZAEnemySpriteNode

#pragma mark - actions

- (void)takeHit:(NSInteger)points withEnemies:(NSMutableArray *)trackedNodes
{
    NSString *sound = [self.charachterAtlasPrefix stringByAppendingString:@"_hit.caf"];
    [self.scene runAction:[[ZACharachterAnimationFrames sharedFrames] getSoundActionForFile:sound]];
    [super takeHit:points withEnemies:trackedNodes];
}

- (void)performDeath:(NSMutableArray*)trackedNodes
{
    NSString *sound;
    if (arc4random() %2)
        sound = @"_die.caf";
    else
        sound = @"_critdie.caf";
    
    sound = [self.charachterAtlasPrefix stringByAppendingString:sound];
    
    [self.scene runAction:[[ZACharachterAnimationFrames sharedFrames] getSoundActionForFile:sound]];
    
    ZAMyScene *scene = (ZAMyScene*) self.scene;
    [scene setZombieKills:scene.zombieKills + 1];
    [scene updateHud];
    
    //super called last on purpose here
    [super performDeath:trackedNodes];
}

- (void)attackHero
{
    if (self.action == die)
        return;
    
    NSString *sound = [self.charachterAtlasPrefix stringByAppendingString:@"_phys.caf"];
    [self.scene runAction:[[ZACharachterAnimationFrames sharedFrames] getSoundActionForFile:sound]];
    
    [self faceTowards:self.attackTarget.position];
    
    if (self.action != attack) {
        [self setImmediateAction:attack];
        self.velocity = CGPointMake(0., 0.);
        self.physicsBody.mass = attackMass;
    }
    
    //if hero is in our range, extract hit points
    if ([self.physicsBody.allContactedBodies indexOfObject:self.attackTarget.physicsBody] != NSNotFound) {
        //NSLog(@"zombie attacking hero - in range... extracting hp");
        [self.attackTarget takeHit:self.attackPower withEnemies:nil];
        
        if (self.attackTarget.hitPoints <= 0 || !self.attackTarget)
            [self setImmediateAction:walk];
        else
            [self performSelector:@selector(attackHero) withObject:nil afterDelay:self.meleeSpeed];
    }
    
}

@end
