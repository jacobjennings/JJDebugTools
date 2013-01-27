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
    
    self.hierarchyView.frame = CGRectMake(0,
                                          0,
                                          self.bounds.size.width,
                                          kHierarchyViewCellHeight * 7);
}

@end