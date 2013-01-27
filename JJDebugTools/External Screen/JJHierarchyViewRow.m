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

@interface JJHierarchyViewRow ()

@property (nonatomic, strong) NSArray *cells;

@end

@implementation JJHierarchyViewRow

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blueColor];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self reloadCells];
    
    CGFloat cellX = 0;
    for (JJHierarchyViewCell *cell in self.cells)
    {
        cell.frame = CGRectMake(cellX, 0, kHierarchyViewCellMinimumWidth, kHierarchyViewCellHeight);
    }
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
    
    NSUInteger numberOfCells = floor(self.bounds.size.width / kHierarchyViewCellMinimumWidth);
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
        }
        if (viewForCell)
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
