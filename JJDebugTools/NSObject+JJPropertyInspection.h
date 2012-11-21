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
- (NSDictionary *)propertyNameToAttributesDictionary;
- (NSString *)propertyListWithValuesAsSingleString;

@end
