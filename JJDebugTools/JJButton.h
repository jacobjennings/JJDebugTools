//
//  JJButton.h
//  Rest Client
//
//  Created by Jacob Jennings on 4/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JJLabel.h"

@interface JJButton : UIButton

@property (nonatomic, strong) UIColor *topColor;
@property (nonatomic, strong) UIColor *bottomColor;
@property (nonatomic, strong) UIColor *borderColor;
@property (nonatomic, strong) UIColor *highlightColor;
@property (nonatomic, strong) UIColor *highlightedColor;

@property (nonatomic) UIRectCorner corners;
@property (nonatomic) CGFloat cornerRadius;

@property (nonatomic, strong) JJLabel *label;

@end
