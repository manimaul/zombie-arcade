//
//  ZAEnemySpriteNode.h
//  8bit-zombie-arcade
//
//  Created by William Kamp on 10/25/13.
//  Copyright (c) 2013 Will Kamp. All rights reserved.
//

#import "ZACharacherSpriteNode.h"

static const NSInteger kMaxEnemies = 5;

@interface ZAEnemySpriteNode : ZACharacherSpriteNode

@property (nonatomic, weak) ZACharacherSpriteNode *attackTarget;
- (void)attackHero;

@end
