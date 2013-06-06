//
//  NSObject+JJPropertyInspection.m
//  JJDebugTools
//
//  Created by Jacob Jennings on 10/11/12.
//  Copyright (c) 2012 Jacob Jennings. All rights reserved.
//

#import "NSObject+JJPropertyInspection.h"
#import <objc/runtime.h>
#import "NSObject+JJAssociatedObjects.h"

static NSString * const JJPropertyInspectionPropertyNamesArrayCacheKey = @"JJPropertyInspectionPropertyNamesArrayCacheKey";

@implementation NSObject (JJPropertyInspection)

- (NSArray *)arrayOfPropertyNames {
    NSArray *propertyNames = [self associatedObjectWithKey:JJPropertyInspectionPropertyNamesArrayCacheKey];
    if (propertyNames)
    {
        return propertyNames;
    }
    NSString *propertyName;
    NSMutableArray *propertyNamesMutable = [NSMutableArray arrayWithCapacity:10];
    
    for (Class clazz in [self superclassChainListToNSObject])
    {
        unsigned int outCount, i;
        objc_property_t *properties = class_copyPropertyList(clazz, &outCount);
        for (i = 0; i < outCount; i++) {
            objc_property_t property = properties[i];
            propertyName = [NSString stringWithUTF8String:property_getName(property)];
            [propertyNamesMutable addObject:propertyName];
        }
    }
    
    propertyNames = [NSArray arrayWithArray:propertyNamesMutable];
    [self setAssociatedObject:propertyNames withKey:JJPropertyInspectionPropertyNamesArrayCacheKey];
    return propertyNames;
}

- (NSArray *)arrayOfIvarNames {
    unsigned int varCount;
    Ivar *vars = class_copyIvarList([self class], &varCount);
    NSMutableArray *ivarNamesMutable = [NSMutableArray arrayWithCapacity:varCount];
    for (int i = 0; i < varCount; i++) {
        Ivar var = vars[i];

        const char* name = ivar_getName(var);
        [ivarNamesMutable addObject:@(name)];
    }

    free(vars);
    return [ivarNamesMutable copy];
}

- (NSDictionary *)propertyNameToAttributesDictionary {
    return [self propertyNameToAttributesDictionaryForClass:[self class]];
}

- (NSDictionary *)propertyNameToAttributesDictionaryForClass:(Class)aClass {
    NSString *propertyName;
    NSString *propertyAttributes;
    NSUInteger outCount, i;
    objc_property_t *properties = class_copyPropertyList(aClass, &outCount);
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
        if (![self keyIsValid:key])
        {
            continue;
        }
        id value = [self safeValueForKey:key];
        if (value)
        {
            [stringBuilder appendFormat:@"%@: %@\n", key, value];
        }
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
    while (classInChain != [NSObject class]) {
        [classList addObject:NSStringFromClass(classInChain)];
        classInChain = [classInChain superclass];
    }
    [classList addObject:NSStringFromClass([NSObject class])];
    return [NSArray arrayWithArray:classList];
}

- (NSArray *)superclassChainListToNSObject
{
    NSMutableArray *classList = [[NSMutableArray alloc] init];
    Class classInChain = [self class];
    while (classInChain != [NSObject class]) {
        [classList addObject:classInChain];
        classInChain = [classInChain superclass];
    }
    [classList addObject:[NSObject class]];
    return [NSArray arrayWithArray:classList];
}


- (NSString *)propertyOrIvarNameForObject:(id)object
{
    NSArray *propertyNames = [self arrayOfPropertyNames];
    NSArray *ivarNames = [self arrayOfIvarNames];
    for (NSString *key in [propertyNames arrayByAddingObjectsFromArray:ivarNames])
    {
        if (![self keyIsValid:key])
        {
            continue;
        }
        id value = [self safeValueForKey:key];
//        if ([NSStringFromClass([self class]) isEqualToString:@"T1SlideshowStatusView"])
//        {
//            NSLog(@"KEY: %@", key);
////            NSLog(@"FIRST IVAR CLASS: %@", [ivarNames[0] class]);
//            if ([key isEqualToString:@"_summaryHostView"])
//            {
//                NSLog(@"%@: %@", NSStringFromClass([self class]), value);
//            }
//        }
        if (value == object)
        {
            return key;
        }
    }
//    for (NSString *key in ivarNames)
//    {
//        if (![self keyIsValid:key])
//        {
//            continue;
//        }
//
//        const char * keyCString = [key cString];
//        id value = nil;
//
//        if (value == object)
//        {
//            return key;
//        }
//    }
    return nil;
}

- (id)safeValueForKey:(NSString *)key;
{
    id value = nil;
    @try {
        value = [self valueForKey:key];
    }
    @catch (NSException *exception) {
        //no-op
    }
    return value;
}

- (BOOL)keyIsValid:(NSString *)key
{
    BOOL valid = YES;
    if ([key hasPrefix:@"jj"]
        || [key isEqualToString:@"selectedTextRange"]
//        || [key hasPrefix:@"_"]
        || [key isEqualToString:@"caretRect"])
    {
        valid = NO;
    }
    return valid;
}

@end
