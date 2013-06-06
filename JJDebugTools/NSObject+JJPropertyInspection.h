//
//  NSObject+JJPropertyInspection.h
//  JJDebugTools
//
//  Created by Jacob Jennings on 10/11/12.
//  Copyright (c) 2012 Jacob Jennings. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (JJPropertyInspection)

- (NSArray *)arrayOfPropertyNames;
- (NSArray *)arrayOfIvarNames;
- (NSDictionary *)propertyNameToAttributesDictionary;
- (NSString *)propertyListWithValuesAsSingleString;
- (NSString *)propertyOrIvarNameForObject:(id)object;
- (NSArray *)superclassNameChainListToNSObject;
- (NSDictionary *)classToPropertyListStringDictionary;
- (id)safeValueForKey:(NSString *)key;

@end
