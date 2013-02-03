//
//  JJHierarchyViewRow.m
//  JJDebugTools
//
//  Created by Jacob Jennings on 1/26/13.
//  Copyright (c) 2013 Jacob Jennings. All rights reserved.
//

#import "JJHierarchyViewRow.h"
#import "JJHierarchyViewCell.h"
#import "UIView+JJHotkeyViewTraverser.h"
#import "JJHotkeyViewTraverser.h"
#import <QuartzCore/QuartzCore.h>

static CGFloat const kCellXInset = 6;
static CGFloat const kCellYInset = 6;

@interface JJHierarchyViewRow ()

@property (nonatomic, strong) NSArray *cells;
@property (nonatomic, assign) NSUInteger centerIndex;

@end

@implementation JJHierarchyViewRow

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.2];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self reloadCells];
    
    if (![self.cells count])
    {
        return;
    }
    
    JJHierarchyViewCell *centerCell = self.cells[self.centerIndex];
    CGSize centerCellSizeThatFits = [centerCell sizeThatFits:self.bounds.size];
    centerCell.frame = CGRectMake(round(self.bounds.size.width / 2 - centerCellSizeThatFits.width / 2),
                                  0,
                                  centerCellSizeThatFits.width,
                                  kHierarchyViewCellHeight);
    centerCell.frame = CGRectInset(centerCell.frame, 0, kCellYInset);
    
    CGFloat previousX = centerCell.frame.origin.x;
    for (NSInteger idx = self.centerIndex - 1; idx >= 0; idx--)
    {
        JJHierarchyViewCell *cell = self.cells[idx];
        CGSize cellSizeThatFits = [cell sizeThatFits:self.bounds.size];
        cell.frame = CGRectMake(previousX - cellSizeThatFits.width - kCellXInset,
                                0,
                                cellSizeThatFits.width,
                                kHierarchyViewCellHeight);
        cell.frame = CGRectInset(cell.frame, 0, kCellYInset);
        previousX = cell.frame.origin.x;
    }
    
    previousX = CGRectGetMaxX(centerCell.frame);
    for (NSInteger idx = self.centerIndex + 1; idx < [self.cells count]; idx++)
    {
        JJHierarchyViewCell *cell = self.cells[idx];
        CGSize cellSizeThatFits = [cell sizeThatFits:self.bounds.size];
        cell.frame = CGRectMake(previousX + kCellXInset,
                                0,
                                cellSizeThatFits.width,
                                kHierarchyViewCellHeight);
        cell.frame = CGRectInset(cell.frame, 0, kCellYInset);
        previousX = CGRectGetMaxX(cell.frame);
    }
    
//    [self rd];
}

- (void)setHierarchyLayer:(CALayer *)hierarchyLayer
{
    _hierarchyLayer = hierarchyLayer;
    [self reloadCells];
    [self setNeedsLayout];
}

- (void)reloadCells
{
    for (JJHierarchyViewCell *cell in self.cells)
    {
        [cell removeFromSuperview];
    }
    
    NSUInteger numberOfCells = self.hierarchyLayer.superlayer ? [self.hierarchyLayer.superlayer.sublayers count] : 1;
    
    NSMutableArray *cellsMutable = [NSMutableArray arrayWithCapacity:numberOfCells];
    for (NSUInteger idx = 0; idx < numberOfCells; idx++)
    {
        CALayer *layerForCell = self.hierarchyLayer.superlayer ? self.hierarchyLayer.superlayer.sublayers[idx] : self.hierarchyLayer;
        if (layerForCell && layerForCell != [JJHotkeyViewTraverser shared].highlightLayer)
        {
            JJHierarchyViewCell *cell = [[JJHierarchyViewCell alloc] init];
            cell.hierarchyLayer = layerForCell;
            if (layerForCell == self.hierarchyLayer)
            {
                self.centerIndex = [cellsMutable count];
            }
            [self addSubview:cell];
            [cellsMutable addObject:cell];
        }
    }
    self.cells = [NSArray arrayWithArray:cellsMutable];
}

@end
