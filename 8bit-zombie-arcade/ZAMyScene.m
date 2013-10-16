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

@implementation ZAMyScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        
        SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        
        myLabel.text = @"Zombie Arcade!";
        myLabel.fontSize = 30;
        myLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                       CGRectGetMidY(self.frame));
        [self addChild:myLabel];
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        
        if ([[self children] count] % 2) {
            ZAZombieSpriteNode *sprite = [ZAZombieSpriteNode createZombieSprite];
            
            sprite.position = location;
            
            SKAction *action = [sprite animateZombieLurch];
            
            [sprite runAction:[SKAction repeatActionForever:action]];
            
            [self addChild:sprite];
        } else {
            ZAHeroSpriteNode *sprite = [ZAHeroSpriteNode createHeroSprite];
            
            sprite.position = location;
            
            SKAction *action = [sprite animateHeroWalk];
            
            [sprite runAction:[SKAction repeatActionForever:action]];
            
            [self addChild:sprite];
        }
        
    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
