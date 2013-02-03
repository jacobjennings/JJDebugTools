//
//  NSObject+JJAssociatedObjects.m
//  JJDebugTools
//
//  Created by Jacob Jennings on 10/10/12.
//  Copyright (c) 2012 Jacob Jennings. All rights reserved.
//

#import "NSObject+JJAssociatedObjects.h"
#import <objc/runtime.h>

static NSMutableDictionary * keyToConstKeyDictionary;

@implementation NSObject (JJAssociatedObjects)

- (id)associatedObjectWithKey:(NSString *)key {
    NSString *constKey = keyToConstKeyDictionary[key];
    return objc_getAssociatedObject(self, (__bridge const void *)(constKey));
}

- (void)setAssociatedObject:(id)object withKey:(NSString *)key {
    if (!keyToConstKeyDictionary)
    {
        keyToConstKeyDictionary = [[NSMutableDictionary alloc] init];
    }
    NSString *constKey = keyToConstKeyDictionary[key];
    if (!constKey)
    {
        keyToConstKeyDictionary[key] = key;
        constKey = keyToConstKeyDictionary[key];
    }
    objc_setAssociatedObject(self, (__bridge const void *)(constKey), object, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
