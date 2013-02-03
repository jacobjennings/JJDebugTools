//
//  CALayer+JJHotkeyViewTraverser.m
//  JJDebugTools
//
//  Created by Jacob Jennings on 2/2/13.
//  Copyright (c) 2013 Jacob Jennings. All rights reserved.
//

#import "CALayer+JJHotkeyViewTraverser.h"
#import "NSObject+JJPropertyInspection.h"
#import "NSObject+JJAssociatedObjects.h"
#import "UIView+JJHotkeyViewTraverser.h"
#import "JJHotkeyViewTraverser.h"

@interface CALayer ()

@end

@implementation CALayer (JJHotkeyViewTraverser)

- (CALayer *)jjSublayer;
{
    if (self.lastSelectedSublayer) {
        return self.lastSelectedSublayer;
    }
    if ([self.sublayers count] && self.sublayers[0] && self.sublayers[0] != [JJHotkeyViewTraverser shared].highlightLayer) {
        return self.sublayers[0];
    }
    return nil;
}

- (CALayer *)jjPeerLayerAbove;
{
    NSInteger indexOfLayer = [self.superlayer.sublayers indexOfObject:self];
    NSInteger indexOfLayerAbove = indexOfLayer + 1;
    if (indexOfLayerAbove > 0 && indexOfLayerAbove < [self.superlayer.sublayers count]) {
        return self.superlayer.sublayers[indexOfLayerAbove];
    }
    return nil;
}

- (CALayer *)jjPeerLayerBelow;
{
    NSInteger indexOfLayer = [self.superlayer.sublayers indexOfObject:self];
    NSInteger indexOfLayerAbove = indexOfLayer - 1;
    if (indexOfLayerAbove > 0 && indexOfLayerAbove < [self.superlayer.sublayers count]) {
        return self.superlayer.sublayers[indexOfLayerAbove];
    }
    return nil;
}

- (NSString *)jjPropertyName;
{
    NSString *propertyName = nil;
    if (self.jjViewForLayer)
    {
        propertyName = [self.jjViewForLayer propertyOfSuperName];
    }
    CALayer *superlayer = [self superlayer];
    for (NSUInteger idx = 0; idx < 4; idx++)
    {
        if (!propertyName)
        {
            propertyName = [superlayer propertyNameForObject:self];
        }
        superlayer = [superlayer superlayer];
    }
    return propertyName;
}

- (BOOL)jjPropertyNameOwnerIsController;
{
    if (self.jjViewForLayer)
    {
        return [self.jjViewForLayer propertyOfSuperNameIsController];
    }
    return NO;
}

- (UIView *)jjViewForLayer;
{
    if ([self.delegate isKindOfClass:[UIView class]] && ((UIView *)self.delegate).layer == self)
    {
        return self.delegate;
    }
    return nil;
}

#pragma mark - Private

static NSString * const JJAssociatedObjectKeyLastSelectedSublayer = @"JJAssociatedObjectKeyLastSelectedSublayer";

- (UIView *)lastSelectedSublayer {
    return [self associatedObjectWithKey:JJAssociatedObjectKeyLastSelectedSublayer];
}

- (void)setLastSelectedSublayer:(CALayer *)lastSelectedSublayer
{
    [self setAssociatedObject:lastSelectedSublayer withKey:JJAssociatedObjectKeyLastSelectedSublayer];
}


@end
