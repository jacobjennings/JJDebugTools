//
//  JJColorAdjusterView.m
//  JJDebugTools
//
//  Created by Jacob Jennings on 2/10/13.
//  Copyright (c) 2013 Jacob Jennings. All rights reserved.
//

#import "JJColorAdjusterView.h"

@implementation JJColorAdjusterView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)setAdjustLayer:(CALayer *)adjustLayer
{
    _adjustLayer = adjustLayer;
    
}

@end
