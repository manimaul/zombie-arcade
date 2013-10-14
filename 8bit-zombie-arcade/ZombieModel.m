//
//  ZombieModel.m
//  8bit-zombie-arcade
//
//  Created by Jason Koceja on 10/14/13.
//  Copyright (c) 2013 Will Kamp. All rights reserved.
//

#import "ZombieModel.h"

@implementation ZombieModel

- (id)initWithImageNamed:(NSString *)name{
    self = [super initWithImageNamed:name];
    if (self) {
        //
    }
    return self;
}

+ (id)zombieWithSprite{
    return [[ZombieModel alloc] initWithImageNamed:@"zombie"];
}

// moving
// attacking
// dying

@end
