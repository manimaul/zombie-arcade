//
//  ZAHeroSpriteNode.h
//  8bit-zombie-arcade
//
//  Created by William Kamp on 10/14/13.
//  Copyright (c) 2013 Will Kamp. All rights reserved.
//

#import "ZACharacherSpriteNode.h"

static const float HERO_MOVE_POINTS_PER_SEC = 120.;

@interface ZAHeroSpriteNode : ZACharacherSpriteNode

@property (nonatomic) fourtyFiveDegreeCardinal cardinal;

+ (instancetype)createHeroSprite;
- (void)setAnimationSequenceByCardinal:(fourtyFiveDegreeCardinal)newCardinal;

@end
