//
//  CALayer+JJHotkeyViewTraverser.h
//  JJDebugTools
//
//  Created by Jacob Jennings on 2/2/13.
//  Copyright (c) 2013 Jacob Jennings. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface CALayer (JJHotkeyViewTraverser)

@property (nonatomic, readonly) CALayer *jjSublayer;
@property (nonatomic, readonly) CALayer *jjPeerLayerAbove;
@property (nonatomic, readonly) CALayer *jjPeerLayerBelow;
@property (nonatomic, readonly) UIView *jjViewForLayer;

@property (nonatomic, strong) CALayer *jjLastSelectedSublayer;

- (NSString *)jjPropertyName;
- (BOOL)jjPropertyNameOwnerIsController;

@end
