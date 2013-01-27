//
//  UIBezierPath+JJ.h
//  Rest Client
//
//  Created by Jacob Jennings on 4/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBezierPath (JJUtilities)

+ (UIBezierPath *)bezierPathTopOfRoundedRectWithWidth:(CGFloat)width cornerRadius:(CGFloat)cornerRadius;

+ (UIBezierPath*)bezierPathBottomOfRect:(CGRect)rect roundedCorners:(UIRectCorner)corners radius:(CGFloat)radius;
+ (UIBezierPath*)bezierPathTopOfRect:(CGRect)rect roundedCorners:(UIRectCorner)corners radius:(CGFloat)radius;

@end
