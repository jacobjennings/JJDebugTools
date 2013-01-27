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

@interface JJHierarchyViewRow ()

@property (nonatomic, strong) NSArray *cells;
@property (nonatomic, assign) NSUInteger centerIndex;

@end

@implementation JJHierarchyViewRow

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.2];
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
    centerCell.frame = CGRectMake(self.bounds.size.width / 2 - kHierarchyViewCellMinimumWidth / 2,
                                                    0,
                                                    kHierarchyViewCellMinimumWidth,
                                                    kHierarchyViewCellHeight);
    
    CGFloat previousX = centerCell.frame.origin.x;
    for (NSInteger idx = self.centerIndex - 1; idx >= 0; idx--)
    {
        JJHierarchyViewCell *cell = self.cells[idx];
        cell.frame = CGRectMake(previousX - kHierarchyViewCellMinimumWidth, 0, kHierarchyViewCellMinimumWidth, kHierarchyViewCellHeight);
        previousX = cell.frame.origin.x;
    }
    
    previousX = CGRectGetMaxX(centerCell.frame);
    for (NSInteger idx = self.centerIndex + 1; idx < [self.cells count]; idx++)
    {
        JJHierarchyViewCell *cell = self.cells[idx];
        cell.frame = CGRectMake(previousX, 0, kHierarchyViewCellMinimumWidth, kHierarchyViewCellHeight);
        previousX = CGRectGetMaxX(cell.frame);
    }
    
//    [self rd];
}

- (void)setHierarchyView:(UIView *)hierarchyView
{
    _hierarchyView = hierarchyView;
    [self reloadCells];
    [self setNeedsLayout];
}

- (void)reloadCells
{
    for (JJHierarchyViewCell *cell in self.cells)
    {
        [cell removeFromSuperview];
    }
    
    NSUInteger numberOfCells = floor(self.bounds.size.width / kHierarchyViewCellMinimumWidth) + 2;
    NSUInteger centerCell = floor(numberOfCells / 2);
    
    NSMutableArray *cellsMutable = [NSMutableArray arrayWithCapacity:numberOfCells];
    for (NSUInteger idx = 0; idx < numberOfCells; idx++)
    {
        UIView *viewForCell = nil;
        if (idx < centerCell)
        {
            UIView *leftView = self.hierarchyView;
            for (NSUInteger leftBy = 0; leftBy < centerCell - idx; leftBy++)
            {
                leftView = [leftView viewBelow];
            }
            viewForCell = leftView;
        }
        else if (idx > centerCell)
        {
            UIView *rightView = self.hierarchyView;
            for (NSUInteger rightBy = 0; rightBy < idx - centerCell; rightBy++)
            {
//                NSLog(@"\n\nCenter cell: %u \n\nrightBy: %u idx: %u \n\nIterating right view: %@", centerCell, rightBy, idx, rightView);
                rightView = [rightView viewAbove];
            }
            viewForCell = rightView;
        }
        else
        {
            viewForCell = self.hierarchyView;
            self.centerIndex = [cellsMutable count];
        }
        if (viewForCell && viewForCell != [JJHotkeyViewTraverser shared].highlightView)
        {
            JJHierarchyViewCell *cell = [[JJHierarchyViewCell alloc] init];
            cell.hierarchyView = viewForCell;
            [self addSubview:cell];
            [cellsMutable addObject:cell];
        }
    }
    self.cells = [NSArray arrayWithArray:cellsMutable];
}

@end
