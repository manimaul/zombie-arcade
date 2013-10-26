//
//  HeroModel.m
//  8bit-zombie-arcade
//
//  Created by Jason Koceja on 10/14/13.
//  Copyright (c) 2013 Will Kamp. All rights reserved.
//

#import "HeroModel.h"

@implementation HeroModel

- (id)initWithImageNamed:(NSString *)name{
    self = [super initWithImageNamed:name];
    if (self) {
        //
    }
    return self;
}

+ (id)heroWithSprite{
    return [[HeroModel alloc] initWithImageNamed:@"hero"];
}

// moving
// attacking

@end
