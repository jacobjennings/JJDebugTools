//
//  UIView+JJHotkeyViewTraverser.m
//  JJDebugTools
//
//  Created by Jacob Jennings on 10/10/12.
//  Copyright (c) 2012 Jacob Jennings. All rights reserved.
//

#import "UIView+JJHotkeyViewTraverser.h"
#import "NSObject+JJAssociatedObjects.h"
#import "JJHotkeyViewTraverser.h"
#import <objc/runtime.h>

@implementation UIView (JJHotkeyViewTraverser)

+ (void)load {
    [JJHotkeyViewTraverser shared];
}

- (NSString *)debugDescription
{
    return nil;
}

- (UIView *)findTheHippestViewOfThemAll
{
    return [UIApplication sharedApplication].keyWindow.rootViewController.view;
}

- (UIView *)viewBelow
{
    NSUInteger indexOfView = [self.superview.subviews indexOfObject:self];
    NSUInteger indexOfViewBelow = indexOfView - 1;
    if (indexOfViewBelow < [self.superview.subviews count]) {
        return self.superview.subviews[indexOfViewBelow];
    }
    return nil;
}

- (UIView *)viewAbove
{
    NSUInteger indexOfView = [self.superview.subviews indexOfObject:self];
    NSUInteger indexOfViewAbove = indexOfView + 1;
    if (indexOfViewAbove < [self.superview.subviews count]) {
        return self.superview.subviews[indexOfViewAbove];
    }
    return nil;
}

#pragma mark - Properties

static NSString * const JJAssociatedObjectKeyLastSelectedSubview = @"JJAssociatedObjectKeyLastSelectedSubview";
- (UIView *)lastSelectedSubview {
    return [self associatedObjectWithKey:JJAssociatedObjectKeyLastSelectedSubview];
}

- (void)setLastSelectedSubview:(UIView *)lastSelectedSubview {
    [self setAssociatedObject:lastSelectedSubview withKey:JJAssociatedObjectKeyLastSelectedSubview];
}

- (UIViewController *)findAssociatedController {
    Ivar ivar = class_getInstanceVariable([UIView class], "_viewDelegate");
    UIViewController *controller = object_getIvar(self, ivar);
    
    if (controller) {
        return controller;
    }
    return [self.superview findAssociatedController];
}

@end
