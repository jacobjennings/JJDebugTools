//
// Created by Jacob Jennings on 1/26/13.
// Copyright (c) 2012 Jacob Jennings. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "JJHierarchyView.h"
#import "JJViewDetailsView.h"
#import "JJNotificationInfoView.h"

@interface JJExternalScreenRootView : UIView

@property (nonatomic, strong) JJHierarchyView *hierarchyView;
@property (nonatomic, strong) JJViewDetailsView *viewDetailsView;
@property (nonatomic, strong) JJNotificationInfoView *notificationInfoView;

@end