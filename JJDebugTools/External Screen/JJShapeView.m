//
//  JJShapeView.m
//  JJDebugTools
//
//  Created by Jacob Jennings on 2/10/13.
//  Copyright (c) 2013 Jacob Jennings. All rights reserved.
//

#import "JJShapeView.h"

@implementation JJShapeView

+ (Class)layerClass
{
    return [CAShapeLayer class];
}

- (CAShapeLayer *)shapeLayer
{
    return (CAShapeLayer *)self.layer;
}

@end
