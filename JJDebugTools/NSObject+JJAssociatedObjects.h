//
//  NSObject+JJAssociatedObjects.h
//  JJDebugTools
//
//  Created by Jacob Jennings on 10/10/12.
//  Copyright (c) 2012 Jacob Jennings. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (JJAssociatedObjects)

- (void)setAssociatedObject:(id)object withKey:(NSString *)key;
- (id)associatedObjectWithKey:(NSString *)key;

@end
