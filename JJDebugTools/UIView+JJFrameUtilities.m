//
//  UIView+JJFrameUtilities.m
//  JJDebugTools
//
//  Created by Jacob Jennings on 1/26/13.
//  Copyright (c) 2013 Jacob Jennings. All rights reserved.
//

#import "UIView+JJFrameUtilities.h"

@implementation UIView (JJFrameUtilities)

- (void)centerHorizontally;
{
    self.frame = (CGRect) {
        .origin = CGPointMake(round(self.superview.bounds.size.width / 2 - self.bounds.size.width / 2),
                              self.frame.origin.y),
        .size = self.bounds.size
    };
}

@end
