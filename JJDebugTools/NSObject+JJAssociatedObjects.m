//
//  NSObject+JJAssociatedObjects.m
//  JJDebugTools
//
//  Created by Jacob Jennings on 10/10/12.
//  Copyright (c) 2012 Jacob Jennings. All rights reserved.
//

#import "NSObject+JJAssociatedObjects.h"
#import <objc/runtime.h>

@implementation NSObject (JJAssociatedObjects)

- (id)associatedObjectWithKey:(NSString *)key {
    return objc_getAssociatedObject(self, &key);
}

- (void)setAssociatedObject:(id)object withKey:(NSString *)key {
    objc_setAssociatedObject(self, &key, object, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
