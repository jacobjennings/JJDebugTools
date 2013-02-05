//
//  JJHierarchyView.h
//  JJDebugTools
//
//  Created by Jacob Jennings on 1/26/13.
//  Copyright (c) 2013 Jacob Jennings. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JJHierarchyViewCell.h"

@interface JJHierarchyView : UIScrollView

@property (nonatomic, strong) CALayer *hierarchyLayer;

@end
