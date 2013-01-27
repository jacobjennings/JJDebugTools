//
// Created by Jacob Jennings on 1/26/13.
// Copyright (c) 2012 Jacob Jennings. All rights reserved.
//

#import "JJExternalScreenRootView.h"

@interface JJExternalScreenRootView()

@property (nonatomic, strong) UILabel *currentRectLabel;

@end

@implementation JJExternalScreenRootView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        _currentRectLabel = [[UILabel alloc] init];
        [self addSubview:_currentRectLabel];
        
        _hierarchyView = [[JJHierarchyView alloc] init];
        [self addSubview:_hierarchyView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.hierarchyView.frame = self.bounds;

    CGSize currentRectLabelSizeThatFits = [self.currentRectLabel sizeThatFits:self.bounds.size];
    self.currentRectLabel.frame = (CGRect) { .origin = CGPointZero, .size = currentRectLabelSizeThatFits };
}

@end