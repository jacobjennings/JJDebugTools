//
// Created by Jacob Jennings on 1/26/13.
// Copyright (c) 2012 Jacob Jennings. All rights reserved.
//

#import "JJExternalScreenRootView.h"
#import "CALayer+JJHotkeyViewTraverser.h"
#import "UIView+JJHotkeyViewTraverser.h"

static CGFloat const kLeftColumnWidth = 340;
static CGFloat const kNotificationsWidth = 340;

@interface JJExternalScreenRootView()

@end

@implementation JJExternalScreenRootView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor blackColor];
        
        self.hierarchyView = [[JJHierarchyView alloc] init];
        [self addSubview:self.hierarchyView];
        
        self.viewDetailsView = [[JJObjectPropertiesView alloc] init];
        [self addSubview:self.viewDetailsView];

        self.controllerDetailsView = [[JJObjectPropertiesView alloc] init];
        [self addSubview:self.controllerDetailsView];
        
        self.notificationInfoView = [[JJNotificationInfoView alloc] init];
        [self addSubview:self.notificationInfoView];
        
        self.shortcutsView = [[JJShortcutsView alloc] init];
        [self addSubview:self.shortcutsView];
        
        self.recentAnimationsView = [[JJRecentAnimationsView alloc] init];
        [self addSubview:self.recentAnimationsView];
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
    
    if (self.controllerDetailsView.object)
    {
        self.viewDetailsView.frame = CGRectMake(0,
                                                0,
                                                kLeftColumnWidth,
                                                round(self.bounds.size.height / 2));
        self.controllerDetailsView.frame = CGRectMake(0,
                                                      CGRectGetMaxY(self.viewDetailsView.frame),
                                                      kLeftColumnWidth,
                                                      round(self.bounds.size.height / 2));
        self.controllerDetailsView.hidden = NO;
    } else {
        self.viewDetailsView.frame = CGRectMake(0, 0, kLeftColumnWidth, self.bounds.size.height);
        self.controllerDetailsView.hidden = YES;
    }
    
    self.notificationInfoView.frame = (CGRect) {
        .origin = CGPointMake(self.bounds.size.width - kNotificationsWidth, CGRectGetMaxY(self.hierarchyView.frame)),
        .size = CGSizeMake(kNotificationsWidth, self.bounds.size.height - CGRectGetMaxY(self.hierarchyView.frame))
    };
    
    self.shortcutsView.frame = (CGRect) {
        .origin = CGPointMake(CGRectGetMaxX(self.viewDetailsView.frame), CGRectGetMaxY(self.hierarchyView.frame)),
        .size = CGSizeMake(300, self.bounds.size.height - CGRectGetMaxY(self.hierarchyView.frame))
    };
    
    self.recentAnimationsView.frame = (CGRect) {
        .origin.x = CGRectGetMaxX(self.shortcutsView.frame),
        .origin.y = self.shortcutsView.frame.origin.y,
        .size = self.shortcutsView.frame.size
    };
}

- (void)setHierarchyLayer:(CALayer *)hierarchyLayer
{
    _hierarchyLayer = hierarchyLayer;
    
    self.viewDetailsView.object = hierarchyLayer;
    self.controllerDetailsView.object = [hierarchyLayer.jjViewForLayer findAssociatedController];
    self.recentAnimationsView.hierarchyLayer = hierarchyLayer;
    
    [self setNeedsLayout];
}

@end