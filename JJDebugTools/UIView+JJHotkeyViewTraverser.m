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
#import "JJHotkeyViewTraverser.h"
#import "NSObject+JJPropertyInspection.h"

@implementation UIView (JJHotkeyViewTraverser)

+ (void)load {
    [JJHotkeyViewTraverser shared];
}

- (NSString *)debugDescription
{
    return nil;
}

- (UIView *)findRootView
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

- (UIView *)aSubview
{
    UIView *lastSelectedSubview = objc_getAssociatedObject(self, &JJAssociatedObjectKeyLastSelectedSubview);
    if (lastSelectedSubview) {
        return lastSelectedSubview;
    }
    if ([self.subviews count] && self.subviews[0] && self.subviews[0] != [JJHotkeyViewTraverser shared].highlightView) {
        return self.subviews[0];
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

- (void)rd;
{
    NSLog(@"%@", [self performSelector:@selector(recursiveDescription)]);
}

- (NSString *)propertyOfSuperName
{
    UIViewController *controller = [self findAssociatedController];
    if (controller)
    {
        return [controller propertyNameForObject:self];
    }
    if (self.superview)
    {
        return [self.superview propertyNameForObject:self];
    }
    
    return nil;
}

@end
