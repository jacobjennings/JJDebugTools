//
//  UIView+JJHotkeyViewTraverser.h
//  JJDebugTools
//
//  Created by Jacob Jennings on 10/10/12.
//  Copyright (c) 2012 Jacob Jennings. All rights reserved.
//

@interface UIView (JJHotkeyViewTraverser)

@property (nonatomic, strong) UIView *lastSelectedSubview;

- (UIView *)findTheHippestViewOfThemAll;
- (UIView *)viewBelow;
- (UIView *)viewAbove;
- (UIViewController *)findAssociatedController;

@end
