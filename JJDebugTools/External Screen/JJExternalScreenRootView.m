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
        self.backgroundColor = [UIColor blackColor];
        _currentRectLabel = [[UILabel alloc] init];
        [self addSubview:_currentRectLabel];
        
        _hierarchyView = [[JJHierarchyView alloc] init];
        [self addSubview:_hierarchyView];
        
        _viewDetailsView = [[JJViewDetailsView alloc] init];
        [self addSubview:_viewDetailsView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.hierarchyView.frame = CGRectMake(0,
                                          0,
                                          self.bounds.size.width,
                                          kHierarchyViewCellHeight * 7);
    
    self.viewDetailsView.frame = (CGRect) {
        .origin = CGPointMake(self.bounds.size.width / 2, CGRectGetMaxY(self.hierarchyView.frame)),
        .size = CGSizeMake(self.bounds.size.width / 2, self.bounds.size.height - CGRectGetMaxY(self.hierarchyView.frame))
    };
}

@end