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
    if ([self.subviews count] && self.subviews[0]) {
        return self.subviews[0];
    }
    return nil;
}

#pragma mark - Properties

- (void)rd;
{
    NSLog(@"%@", [self performSelector:@selector(recursiveDescription)]);
}

- (BOOL)propertyOfSuperNameIsController
{
    UIViewController *controller = [self findAssociatedController];
    NSString *propertyName = nil;
    if (controller)
    {
        propertyName = [controller propertyNameForObject:self];
        if (propertyName) return YES;
    }
    return NO;
}


- (UIViewController *)findAssociatedController {
    Ivar ivar = class_getInstanceVariable([UIView class], "_viewDelegate");
    UIViewController *controller = object_getIvar(self, ivar);
    
    if (controller) {
        return controller;
    }
    return [self.superview findAssociatedController];
}

- (NSString *)propertyOfSuperName
{
    UIViewController *controller = [self findAssociatedController];
    NSString *propertyName = nil;
    if (controller)
    {
        propertyName = [controller propertyNameForObject:self];
    }
    UIView *superview = [self superview];
    for (NSUInteger idx = 0; idx < 4; idx++)
    {
        if (!propertyName)
        {
            propertyName = [superview propertyNameForObject:self];
        }
        superview = [superview superview];
    }
    
    return propertyName;
}

@end
