//
//  JJShapeView.m
//  JJDebugTools
//
//  Created by Jacob Jennings on 2/10/13.
//  Copyright (c) 2013 Jacob Jennings. All rights reserved.
//

#import "JJCAShapeView.h"

@implementation JJCAShapeView

+ (Class)layerClass
{
    return [CAShapeLayer class];
}

- (CAShapeLayer *)shapeLayer
{
    return (CAShapeLayer *)self.layer;
}

@end
