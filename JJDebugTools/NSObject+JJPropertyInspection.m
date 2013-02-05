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
        propertyName = [NSString stringWithUTF8String:property_getName(property)];
        [propertyNames addObject:propertyName];
    }
    return [NSArray arrayWithArray:propertyNames];
}

- (NSDictionary *)propertyNameToAttributesDictionary {
    return [self propertyNameToAttributesDictionaryForClass:[self class]];
}

- (NSDictionary *)propertyNameToAttributesDictionaryForClass:(Class)aClass {
    NSString *propertyName;
    NSString *propertyAttributes;
    NSUInteger outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    NSMutableDictionary *propertyNameToAttributeDictionary = [NSMutableDictionary dictionaryWithCapacity:outCount];
    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        propertyName = [NSString stringWithUTF8String:property_getName(property)];
        propertyAttributes = [NSString stringWithUTF8String:property_getAttributes(property)];
        [propertyNameToAttributeDictionary setObject:propertyAttributes forKey:propertyName];
    }
    return [NSDictionary dictionaryWithDictionary:propertyNameToAttributeDictionary];
}

- (NSString *)propertyListWithValuesAsSingleString
{
    return [self propertyListWithValuesAsSingleStringForClass:[self class]];
}

- (NSString *)propertyListWithValuesAsSingleStringForClass:(Class)class {
    NSDictionary *propertyNameToAttributesDictionary = [self propertyNameToAttributesDictionaryForClass:class];
    NSMutableString *stringBuilder = [NSMutableString string];
    for (NSString *key in [propertyNameToAttributesDictionary allKeys]) {
        if ([key isEqualToString:@"action"] || [key hasPrefix:@"_"])
        {
            continue;
        }
        [stringBuilder appendFormat:@"%@: %@\n", key, [self valueForKey:key]];
    }
    return [stringBuilder copy];
}


- (NSDictionary *)classToPropertyListStringDictionary
{
    NSMutableDictionary *classToPropertyListStringDictionary = [[NSMutableDictionary alloc] init];
    for (Class classInChain in [self superclassChainListToNSObject])
    {
        [classToPropertyListStringDictionary setObject:[self propertyListWithValuesAsSingleStringForClass:classInChain] forKey:NSStringFromClass(classInChain)];
    }
    return classToPropertyListStringDictionary;
}

- (NSArray *)superclassNameChainListToNSObject
{
    NSMutableArray *classList = [[NSMutableArray alloc] init];
    Class classInChain = [self class];
    do {
        [classList addObject:NSStringFromClass(classInChain)];
        classInChain = [classInChain superclass];
    } while (classInChain != [NSObject class]);
    return [NSArray arrayWithArray:classList];
}

- (NSArray *)superclassChainListToNSObject
{
    NSMutableArray *classList = [[NSMutableArray alloc] init];
    Class classInChain = [self class];
    do {
        [classList addObject:classInChain];
        classInChain = [classInChain superclass];
    } while (classInChain != [NSObject class]);
    return [NSArray arrayWithArray:classList];
}


- (NSString *)propertyNameForObject:(id)object
{
    NSArray *propertyNames = [self arrayOfPropertyNames];
    for (NSString *key in propertyNames)
    {
        if ([key hasPrefix:@"jj"] || [key hasPrefix:@"action"])
        {
            continue;
        }
        id value = [self valueForKey:key];
        if (value == object)
        {
            return key;
        }
    }
    return nil;
}

@end
