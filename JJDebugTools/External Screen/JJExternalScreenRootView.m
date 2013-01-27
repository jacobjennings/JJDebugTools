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
    
    CGSize hierarchyViewSize = CGSizeMake(kHierarchyViewCellMinimumWidth * 5, kHierarchyViewCellHeight * 5);
    self.hierarchyView.frame = CGRectMake(self.bounds.size.width - hierarchyViewSize.width,
                                          0,
                                          hierarchyViewSize.width,
                                          hierarchyViewSize.height);
}

@end