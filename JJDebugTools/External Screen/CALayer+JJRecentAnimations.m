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
static NSUInteger const JJNumberOfAnimationsToRemember = 10;

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
        CAAnimation *animation = [self animationForKey:key];
        NSString *valueString = nil;
        if ([animation isKindOfClass:[CABasicAnimation class]])
        {
            valueString = [self descriptionForBasicAnimation:((CABasicAnimation *) animation)];
        } else {
            valueString = [animation propertyListWithValuesAsSingleString];
        }
        [animationDetailsString appendFormat:@"%@: \n  toValue: %@%@", key, [self valueForKey:key], valueString];
    }
    NSMutableDictionary *dateToAnimationDetailsDictionary = [self dateToAnimationDetailsStringDictionary];
    if (!dateToAnimationDetailsDictionary)
    {
        dateToAnimationDetailsDictionary = [[NSMutableDictionary alloc] init];
        objc_setAssociatedObject(self, (__bridge const void *)(JJDateToAnimationStringDictionaryKey), dateToAnimationDetailsDictionary, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    dateToAnimationDetailsDictionary[[NSDate date]] = animationDetailsString;
    if ([[dateToAnimationDetailsDictionary allKeys] count] > 10)
    {
        [dateToAnimationDetailsDictionary removeObjectForKey:[[dateToAnimationDetailsDictionary allKeys] sortedArrayUsingSelector:@selector(compare:)][0]];
    }
}

- (NSMutableDictionary *)dateToAnimationDetailsStringDictionary;
{
    return objc_getAssociatedObject(self, (__bridge const void *)JJDateToAnimationStringDictionaryKey);
}

- (NSString *)descriptionForBasicAnimation:(CABasicAnimation *)basicAnimation
{
    NSMutableString *descriptionStringMutable = [[NSMutableString alloc] init];
    if (basicAnimation.fromValue)
    {
        [descriptionStringMutable appendFormat:@"\n  fromValue: %@", basicAnimation.fromValue];
    }
    if (basicAnimation.toValue)
    {
        [descriptionStringMutable appendFormat:@"\n  toValue: %@", basicAnimation.toValue];
    }
    if (basicAnimation.byValue)
    {
        [descriptionStringMutable appendFormat:@"\n  byValue: %@", basicAnimation.byValue];
    }
    NSNumber *startAngle = [basicAnimation valueForKey:@"startAngle"];
    NSNumber *endAngle = [basicAnimation valueForKey:@"endAngle"];
    if ([startAngle doubleValue] > 0 || [endAngle doubleValue] > 0)
    {
        [descriptionStringMutable appendFormat:@"\n  startAngle: %@", startAngle];
        [descriptionStringMutable appendFormat:@"\n  endAngle: %@", endAngle];
    }
    [descriptionStringMutable appendString:@"\n"];
    return [NSString stringWithString:descriptionStringMutable];
}

@end
