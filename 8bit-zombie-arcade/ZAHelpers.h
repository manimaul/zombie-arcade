//
//  ZAHelpers.h
//  8bit-zombie-arcade
//
//  Created by William Kamp on 10/18/13.
//  Copyright (c) 2013 Will Kamp. All rights reserved.
//

#ifndef _bit_zombie_arcade_ZAHelpers_h
#define _bit_zombie_arcade_ZAHelpers_h

static inline fourtyFiveDegreeCardinal FortyFiveDegreeCardinalFromDegree(int degree)
{
    degree = degree % 360;
    
    if (degree >=0 && degree < 22) {
        return east;
    }
    if (degree >= 22 && degree < 67) {
        return northeast;
    }
    if (degree >= 67 && degree < 112) {
        return north;
    }
    if (degree >= 112 && degree < 157) {
        return northwest;
    }
    if (degree >= 157 && degree < 202) {
        return west;
    }
    if (degree >= 202 && degree < 247) {
        return southwest;
    }
    if (degree >= 247 && degree < 292) {
        return south;
    }
    if (degree >= 292 && degree < 337) {
        return southeast;
    }
    if (degree >= 337 && degree <= 360) {
        return east;
    }
    return north;
}

#endif
