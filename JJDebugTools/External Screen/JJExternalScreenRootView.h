//
// Created by Jacob Jennings on 1/26/13.
// Copyright (c) 2012 Jacob Jennings. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "JJHierarchyView.h"
#import "JJNotificationInfoView.h"
#import "JJShortcutsView.h"
#import "JJObjectPropertiesView.h"
#import "JJRecentAnimationsView.h"

@interface JJExternalScreenRootView : UIView

@property (nonatomic, strong) JJHierarchyView *hierarchyView;
@property (nonatomic, strong) JJObjectPropertiesView *viewDetailsView;
@property (nonatomic, strong) JJObjectPropertiesView *controllerDetailsView;
@property (nonatomic, strong) JJNotificationInfoView *notificationInfoView;
@property (nonatomic, strong) JJShortcutsView *shortcutsView;
@property (nonatomic, strong) JJRecentAnimationsView *recentAnimationsView;

@property (nonatomic, strong) CALayer *hierarchyLayer;

@end