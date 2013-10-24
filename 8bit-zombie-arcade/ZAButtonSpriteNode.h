//
//  ZAButtonSpriteNode.h
//  8bit-zombie-arcade
//
//  Created by William Kamp on 10/23/13.
//  Copyright (c) 2013 Will Kamp. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@protocol ZAButtonClickDelegate <NSObject>

-(void)buttonClicked;

@end

@interface ZAButtonSpriteNode : SKSpriteNode

+ (instancetype)createButtonWithTextLabel:(NSString*)label;
@property (nonatomic, weak) id <ZAButtonClickDelegate> delegate;

@end
