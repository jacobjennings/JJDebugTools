//
//  JJHierarchyView.m
//  JJDebugTools
//
//  Created by Jacob Jennings on 1/26/13.
//  Copyright (c) 2013 Jacob Jennings. All rights reserved.
//

#import "JJHierarchyView.h"
#import "JJHierarchyViewRow.h"
#import "UIView+JJHotkeyViewTraverser.h"
#import <QuartzCore/QuartzCore.h>
#import "CALayer+JJHotkeyViewTraverser.h"

@interface JJHierarchyView ()

@property (nonatomic, strong) NSArray *rows;
@property (nonatomic, assign) NSUInteger centerIndex;

@end

@implementation JJHierarchyView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat rowY = 0;
    
    
    
    for (JJHierarchyViewRow *row in self.rows)
    {
        row.frame = CGRectMake(0, rowY, self.bounds.size.width, kHierarchyViewCellHeight);
        rowY += kHierarchyViewCellHeight;
    }
//    [self rd];
}

- (void)setHierarchyLayer:(CALayer *)hierarchyLayer
{
    _hierarchyLayer = hierarchyLayer;
    for (UIView *view in self.rows)
    {
        [view removeFromSuperview];
    }
    self.rows = nil;
    
    NSUInteger numberOfRowsThatFit = floor(self.bounds.size.height / kHierarchyViewCellHeight);
    NSUInteger centerRow = floor(numberOfRowsThatFit / 2);

    NSMutableArray *rowsMutable = [NSMutableArray arrayWithCapacity:numberOfRowsThatFit];
    for (NSUInteger idx = 0; idx < numberOfRowsThatFit; idx++)
    {
        CALayer *layerForIndex = hierarchyLayer;

        if (idx < centerRow)
        {
            for (NSUInteger superlayersDeep = 0; superlayersDeep < centerRow - idx; superlayersDeep++)
            {
                layerForIndex = [layerForIndex superlayer];
            }
        }
        else if (idx > centerRow)
        {
            for (NSUInteger superlayersDeep = 0; superlayersDeep < idx - centerRow; superlayersDeep++)
            {
                layerForIndex = layerForIndex.jjSublayer;
            }
        }
        else
        {
            layerForIndex = hierarchyLayer;
            self.centerIndex = [rowsMutable count];
        }
        
        if (layerForIndex)
        {
            JJHierarchyViewRow *row = [[JJHierarchyViewRow alloc] init];
            row.hierarchyLayer = layerForIndex;
            if (idx == centerRow)
            {
                row.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.2];
            }
            [self addSubview:row];
            [rowsMutable addObject:row];
        }
    }
    self.rows = [NSArray arrayWithArray:rowsMutable];
    
    [self setNeedsLayout];
}


@end
