//
// Created by Jacob Jennings on 1/26/13.
// Copyright (c) 2012 Jacob Jennings. All rights reserved.
//

#import "JJExternalScreenRootView.h"

static CGFloat const kLeftColumnWidth = 340;
static CGFloat const kNotificationsWidth = 340;

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
        
        _notificationInfoView = [[JJNotificationInfoView alloc] init];
        [self addSubview:_notificationInfoView];
        
        _shortcutsView = [[JJShortcutsView alloc] init];
        [self addSubview:_shortcutsView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.hierarchyView.frame = CGRectMake(kLeftColumnWidth,
                                          0,
                                          self.bounds.size.width - kLeftColumnWidth,
                                          kHierarchyViewCellHeight * 7);
    
    self.viewDetailsView.frame = CGRectMake(0, 0, kLeftColumnWidth, self.bounds.size.height);
    
    self.notificationInfoView.frame = (CGRect) {
        .origin = CGPointMake(self.bounds.size.width - kNotificationsWidth, CGRectGetMaxY(self.hierarchyView.frame)),
        .size = CGSizeMake(kNotificationsWidth, self.bounds.size.height - CGRectGetMaxY(self.hierarchyView.frame))
    };
    
    self.shortcutsView.frame = (CGRect) {
        .origin = CGPointMake(CGRectGetMaxX(self.viewDetailsView.frame), CGRectGetMaxY(self.hierarchyView.frame)),
        .size = CGSizeMake(340, self.bounds.size.height - CGRectGetMaxY(self.hierarchyView.frame))
    };
}

@end