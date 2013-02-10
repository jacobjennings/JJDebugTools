//
//  CALayer+JJRecentAnimations.m
//  JJDebugTools
//
//  Created by Jacob Jennings on 2/9/13.
//  Copyright (c) 2013 Jacob Jennings. All rights reserved.
//

#import "CALayer+JJRecentAnimations.h"
#import <objc/runtime.h>
#import "NSObject+JJPropertyInspection.h"

static NSString * const JJDateToAnimationStringDictionaryKey = @"JJDateToAnimationStringDictionaryKey";

@implementation CALayer (JJRecentAnimations)

- (void)saveSnapshotOfAnimationStateRecursive;
{
    [self saveSnapshotOfAnimationState];
    for (CALayer *layer in self.sublayers)
    {
        [layer saveSnapshotOfAnimationStateRecursive];
    }
}

- (void)saveSnapshotOfAnimationState
{
    if (!self.animationKeys)
    {
        return;
    }
    NSMutableString *animationDetailsString = [[NSMutableString alloc] init];
    for (NSString *key in self.animationKeys)
    {
        NSString *valueString = [[self animationForKey:key] propertyListWithValuesAsSingleString];
        [animationDetailsString appendFormat:@"%@: \ntoValue: %@\n%@\n", key, [self valueForKey:key], valueString];
    }
    NSMutableDictionary *dateToAnimationDetailsDictionary = [self dateToAnimationDetailsStringDictionary];
    if (!dateToAnimationDetailsDictionary)
    {
        dateToAnimationDetailsDictionary = [[NSMutableDictionary alloc] init];
        objc_setAssociatedObject(self, (__bridge const void *)(JJDateToAnimationStringDictionaryKey), dateToAnimationDetailsDictionary, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    dateToAnimationDetailsDictionary[[NSDate date]] = animationDetailsString;
}

- (NSMutableDictionary *)dateToAnimationDetailsStringDictionary;
{
    return objc_getAssociatedObject(self, (__bridge const void *)JJDateToAnimationStringDictionaryKey);
}

@end
