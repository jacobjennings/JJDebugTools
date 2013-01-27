//
//  UIView+JJHotkeyViewTraverser.h
//  JJDebugTools
//
//  Created by Jacob Jennings on 10/10/12.
//  Copyright (c) 2012 Jacob Jennings. All rights reserved.
//

@interface UIView (JJHotkeyViewTraverser)

@property (nonatomic, strong) UIView *lastSelectedSubview;

- (UIView *)findRootView;
- (UIView *)viewBelow;
- (UIView *)viewAbove;
- (UIView *)aSubview;
- (UIViewController *)findAssociatedController;
- (void)rd;

@end
