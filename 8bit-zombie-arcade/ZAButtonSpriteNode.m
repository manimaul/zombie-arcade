//
//  ZAButtonSpriteNode.m
//  8bit-zombie-arcade
//
//  Created by William Kamp on 10/23/13.
//  Copyright (c) 2013 Will Kamp. All rights reserved.
//

#import "ZAButtonSpriteNode.h"

@implementation ZAButtonSpriteNode

+ (instancetype)createButtonWithTextLabel:(NSString*)label
{
    ZAButtonSpriteNode *button = [[ZAButtonSpriteNode alloc] init];
    
    SKLabelNode *textNode = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    textNode.text = label;
    textNode.fontSize = 16;
    textNode.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    [button addChild:textNode];
    
    return button;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"node touches ended");
    [self.delegate buttonClicked];
}

@end
