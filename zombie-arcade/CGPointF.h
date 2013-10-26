//
//  CGPointF.h
//  8bit-zombie-arcade
//
//  Created by William Kamp on 10/16/13.
//  Copyright (c) 2013 Will Kamp. All rights reserved.
//

/*
 http://tigcc.ticalc.org/doc/gnuexts.html#SEC93
 By declaring a function inline, you can direct GCC to integrate that function's code into the code for its callers. This makes execution faster by eliminating the function-call overhead; in addition, if any of the actual argument values are constant, their known values may permit simplifications at compile time so that not all of the inline function's code needs to be included. The effect on code size is less predictable; object code may be larger or smaller with function inlining, depending on the particular case. Inlining of functions is an optimization and it really "works" only in optimizing compilation. If you don't use '-O', no function is really inline.
 
 These functions are in the header on purpose because they are static inline.
 */

#ifndef _bit_zombie_arcade_CGPointF_h
#define _bit_zombie_arcade_CGPointF_h

static inline CGFloat ScalarSign(CGFloat a)
{
    return a >= 0 ? 1 : -1;
}

// Returns shortest angle between two angles,
// between -M_PI and M_PI
static inline CGFloat ScalarShortestAngleBetween(const CGFloat a, const CGFloat b)
{
    CGFloat difference = b - a;
    CGFloat angle = fmodf(difference, M_PI * 2);
    if (angle >= M_PI) {
        angle -= M_PI * 2;
    }
    return angle;
}

static inline CGPoint CGPointAdd(const CGPoint a, const CGPoint b)
{
    return CGPointMake(a.x + b.x, a.y + b.y);
}

static inline CGPoint CGPointSubtract(const CGPoint a, const CGPoint b)
{
    return CGPointMake(a.x - b.x, a.y - b.y);
}

static inline CGPoint CGPointMultiplyScalar(const CGPoint a, const CGFloat b)
{
    return CGPointMake(a.x * b, a.y * b);
}

static inline CGFloat CGPointLength(const CGPoint a)
{
    return sqrtf(a.x * a.x + a.y * a.y);
}

static inline CGPoint CGPointNormalize(const CGPoint a)
{
    CGFloat length = CGPointLength(a);
    return CGPointMake(a.x / length, a.y / length);
}

static inline CGFloat CGPointToAngleRadians(const CGPoint a)
{
    return atan2f(a.y, a.x);
}

static inline CGFloat DegreesToRadians(const CGFloat d)
{
    CGFloat radians = d * (M_PI / 180.);
    return radians;
}

static inline CGFloat RadiansToDegrees(const CGFloat r)
{
    CGFloat degrees = r * (180. / M_PI);
    
    if (degrees < 0)
        degrees = 360 + degrees;
    
    return degrees;
}

static inline CGPoint ProjectPoint(const CGPoint point, const CGFloat distance, const CGFloat radians)
{
    CGFloat x = point.x + distance * cosf(radians);
    CGFloat y = point.y + distance * sinf(radians);
    return CGPointMake(x, y);
}

static inline CGFloat CGPointToAngleDegrees(const CGPoint a)
{
    return (RadiansToDegrees(CGPointToAngleRadians(a)));
}

#endif