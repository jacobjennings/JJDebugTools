//
//  UIBezierPath+JJ.m
//  Rest Client
//
//  Created by Jacob Jennings on 4/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UIBezierPath+JJUtilities.h"

@implementation UIBezierPath (JJUtilities)

+ (UIBezierPath *)bezierPathTopOfRoundedRectWithWidth:(CGFloat)width cornerRadius:(CGFloat)cornerRadius;
{
    UIBezierPath *path = [[UIBezierPath alloc] init];
    [path moveToPoint:CGPointMake(0, cornerRadius)];
    [path addArcWithCenter:CGPointMake(cornerRadius, cornerRadius) radius:cornerRadius startAngle:M_PI endAngle:3 * M_PI_2 clockwise:YES];
    [path addLineToPoint:CGPointMake(width - cornerRadius, 0)];
    [path addArcWithCenter:CGPointMake(width - cornerRadius, cornerRadius) radius:cornerRadius startAngle:3 * M_PI_2 endAngle:2 * M_PI clockwise:YES];
    return path;
}

+ (UIBezierPath*)bezierPathBottomOfRect:(CGRect)rect roundedCorners:(UIRectCorner)corners radius:(CGFloat)radius {
    UIBezierPath *path = [[UIBezierPath alloc] init];
    
    if (corners & UIRectCornerBottomRight) {
        [path moveToPoint:CGPointMake(CGRectGetMaxX(rect), CGRectGetMaxY(rect) - radius)];
        [path addArcWithCenter:CGPointMake(CGRectGetMaxX(rect) - radius, CGRectGetMaxY(rect) - radius) radius:radius startAngle:0 endAngle:M_PI_2 clockwise:YES];
    } else {
        [path moveToPoint:CGPointMake(rect.origin.x + rect.size.width, rect.origin.y + rect.size.height)];
    }
    
    if (corners & UIRectCornerBottomLeft) {
        [path addLineToPoint:CGPointMake(rect.origin.x + radius, CGRectGetMaxY(rect))];
        [path addArcWithCenter:CGPointMake(rect.origin.x + radius, CGRectGetMaxY(rect) - radius) radius:radius startAngle:M_PI_2 endAngle:M_PI clockwise:YES];
    } else {
        [path addLineToPoint:CGPointMake(rect.origin.x, CGRectGetMaxY(rect))];
    }
    
//    [path closePath];
    
    return path;    
}

+ (UIBezierPath*)bezierPathTopOfRect:(CGRect)rect roundedCorners:(UIRectCorner)corners radius:(CGFloat)radius {
    UIBezierPath *path = [[UIBezierPath alloc] init];
    
    if (corners & UIRectCornerTopLeft) {
        [path moveToPoint:CGPointMake(rect.origin.x, rect.origin.y + radius)];
        [path addArcWithCenter:CGPointMake(rect.origin.x + radius, rect.origin.y + radius) radius:radius startAngle:M_PI endAngle:M_PI + M_PI_2 clockwise:YES];
    } else {
        [path moveToPoint:rect.origin];
    }
    
    if (corners & UIRectCornerTopRight) {
        [path addLineToPoint:CGPointMake(CGRectGetMaxX(rect) - radius, rect.origin.y)];
        [path addArcWithCenter:CGPointMake(CGRectGetMaxX(rect) - radius, rect.origin.y + radius) radius:radius startAngle:M_PI + M_PI_2 endAngle:0 clockwise:YES];
    } else {
        [path addLineToPoint:CGPointMake(CGRectGetMaxX(rect), rect.origin.y)];
    }
    
//    [path closePath];
    
    return path;    
}

@end
