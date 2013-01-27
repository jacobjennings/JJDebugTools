//
//  JJHierarchyViewCell.h
//  JJDebugTools
//
//  Created by Jacob Jennings on 1/26/13.
//  Copyright (c) 2013 Jacob Jennings. All rights reserved.
//

#import <UIKit/UIKit.h>

static CGFloat const kHierarchyViewCellHeight = 64;
static CGFloat const kHierarchyViewCellMinimumWidth = 128;

@interface JJHierarchyViewCell : UIView

@property (nonatomic, strong) UIView *hierarchyView;

@end
