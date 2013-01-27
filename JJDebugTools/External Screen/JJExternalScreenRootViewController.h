//
// Created by Jacob Jennings on 1/26/13.
// Copyright (c) 2012 Jacob Jennings. All rights reserved.
//


#import <Foundation/Foundation.h>

@class JJExternalScreenRootView;


@interface JJExternalScreenRootViewController : UIViewController

@property (nonatomic, readonly) JJExternalScreenRootView *rootView;
@property (nonatomic, assign) UIView *hierarchyView;

- (void)reload;

@end