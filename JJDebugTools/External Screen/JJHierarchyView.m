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

@interface JJHierarchyView ()

@property (nonatomic, strong) NSArray *rows;
@property (nonatomic, assign) NSUInteger centerIndex;

@end

@implementation JJHierarchyView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
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

- (void)setHierarchyView:(UIView *)hierarchyView
{
    _hierarchyView = hierarchyView;
    
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
        UIView *viewForIndex = hierarchyView;

        if (idx < centerRow)
        {
            for (NSUInteger superviewsDeep = 0; superviewsDeep < centerRow - idx; superviewsDeep++)
            {
                viewForIndex = [viewForIndex superview];
            }
        }
        else if (idx > centerRow)
        {
            for (NSUInteger superviewsDeep = 0; superviewsDeep < idx - centerRow; superviewsDeep++)
            {
                viewForIndex = [viewForIndex aSubview];
            }
        }
        else
        {
            viewForIndex = hierarchyView;
            self.centerIndex = [rowsMutable count];
        }
        if (!viewForIndex)
        {
//            NSLog(@"NoRow for index: %u", idx);
        } else {
//            NSLog(@"TheresARow for index: %u", idx);
            JJHierarchyViewRow *row = [[JJHierarchyViewRow alloc] init];
            row.hierarchyView = viewForIndex;
            if (idx == centerRow)
            {
                row.backgroundColor = [[UIColor orangeColor] colorWithAlphaComponent:0.2];
            }
            [self addSubview:row];
            [rowsMutable addObject:row];
        }
    }
    self.rows = [NSArray arrayWithArray:rowsMutable];
    
    [self setNeedsLayout];
}


@end
