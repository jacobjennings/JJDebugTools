//
//  CALayer+JJRecentAnimations.h
//  JJDebugTools
//
//  Created by Jacob Jennings on 2/9/13.
//  Copyright (c) 2013 Jacob Jennings. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface CALayer (JJRecentAnimations)

- (void)saveSnapshotOfAnimationStateRecursive;
- (NSMutableDictionary *)dateToAnimationDetailsStringDictionary;

@end
