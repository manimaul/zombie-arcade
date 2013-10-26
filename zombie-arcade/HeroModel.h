//
//  HeroModel.h
//  8bit-zombie-arcade
//
//  Created by Jason Koceja on 10/14/13.
//  Copyright (c) 2013 Will Kamp. All rights reserved.
//

#import "CharacterModel.h"

@interface HeroModel : CharacterModel

+ (id)heroWithSprite;
- (id)initWithImageNamed:(NSString *)name;

@end
