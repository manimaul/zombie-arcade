//
//  ZAHelpers.h
//  8bit-zombie-arcade
//
//  Created by William Kamp on 10/18/13.
//  Copyright (c) 2013 Will Kamp. All rights reserved.
//

#ifndef _bit_zombie_arcade_ZAHelpers_h
#define _bit_zombie_arcade_ZAHelpers_h

static inline int getVector(CGPoint point)
{
    // Provides a directional bearing from (0,0) to the given point.
    // standard cartesian plain coords: X goes up, Y goes right
    // result returns degrees, -180 to 180 ish: 0 degrees = up, -90 = left, 90 = right
    CGFloat radians = atan2f(point.y, point.x);
    int degrees = radians * (180. / M_PI);
    
    if (degrees < 0)
        degrees = 360 + degrees;
    
    return degrees;
}

static inline fourtyFiveDegreeCardinal getFortyFiveDegreeCardinalFromDegree(int degree)
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
