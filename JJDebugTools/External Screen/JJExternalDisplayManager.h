//
// Created by Jacob Jennings on 1/26/13.
// Copyright (c) 2013 Jacob Jennings. All rights reserved.
//


#import <Foundation/Foundation.h>


@interface JJExternalDisplayManager : NSObject

@property (nonatomic, strong) UIWindow *secondWindow;
@property (nonatomic, strong) UIViewController *rootViewController;

+ (JJExternalDisplayManager *)shared;
- (BOOL)screenVisible;

@end