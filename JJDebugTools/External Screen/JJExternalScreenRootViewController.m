//
// Created by Jacob Jennings on 1/26/13.
// Copyright (c) 2012 Jacob Jennings. All rights reserved.
//


#import "JJExternalScreenRootViewController.h"
#import "JJExternalScreenRootView.h"
#import "UIView+JJHotkeyViewTraverser.h"

@interface JJExternalScreenRootViewController()

@end

@implementation JJExternalScreenRootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
    }
    return self;
}

- (void)loadView
{
    self.view = [[JJExternalScreenRootView alloc] init];
}

- (JJExternalScreenRootView *)rootView
{
    return (JJExternalScreenRootView *)self.view;
}

- (void)reload;
{
#warning reload empty
}

- (void)setHierarchyView:(UIView *)hierarchyView
{
    _hierarchyView = hierarchyView;
    
    self.rootView.hierarchyView.hierarchyView = hierarchyView;
    self.rootView.viewDetailsView.detailsView = hierarchyView;
}

@end