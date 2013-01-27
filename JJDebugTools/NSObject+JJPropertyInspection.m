//
//  NSObject+JJPropertyInspection.m
//  JJDebugTools
//
//  Created by Jacob Jennings on 10/11/12.
//  Copyright (c) 2012 Jacob Jennings. All rights reserved.
//

#import "NSObject+JJPropertyInspection.h"
#import <objc/runtime.h>

@implementation NSObject (JJPropertyInspection)

- (NSArray *)arrayOfPropertyNames {
    NSString *propertyName;
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    NSMutableArray *propertyNames = [NSMutableArray arrayWithCapacity:outCount];
    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        propertyName = [NSString stringWithCString:property_getName(property)];
        [propertyNames addObject:propertyName];
    }
    return [NSArray arrayWithArray:propertyNames];
}

- (NSDictionary *)propertyNameToAttributesDictionary {
    NSString *propertyName;
    NSString *propertyAttributes;
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    NSMutableDictionary *propertyNameToAttributeDictionary = [NSMutableDictionary dictionaryWithCapacity:outCount];
    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        propertyName = [NSString stringWithCString:property_getName(property)];
        propertyAttributes = [NSString stringWithCString:property_getAttributes(property)];
        [propertyNameToAttributeDictionary setObject:propertyAttributes forKey:propertyName];
    }
    return [NSDictionary dictionaryWithDictionary:propertyNameToAttributeDictionary];
}

- (NSString *)propertyListWithValuesAsSingleString {
    NSDictionary *propertyNameToAttributesDictionary = [self propertyNameToAttributesDictionary];
    NSMutableString *stringBuilder = [NSMutableString string];
    for (NSString *key in [propertyNameToAttributesDictionary allKeys]) {
        [stringBuilder appendFormat:@"%@: %@\n", key, [self valueForKey:key]];
    }
    return [stringBuilder copy];
}

- (NSString *)propertyNameForObject:(id)object
{
    NSArray *propertyNames = [self arrayOfPropertyNames];
    for (NSString *key in propertyNames)
    {
        id value = [self valueForKey:key];
        if (value == object)
        {
            return key;
        }
    }
    return nil;
}

@end
