//
//  JJViewDetailsViewTitledAttributedLabelView.h
//  JJDebugTools
//
//  Created by Jacob Jennings on 2/4/13.
//  Copyright (c) 2013 Jacob Jennings. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JJTTTAttributedLabel.h"
#import "JJLabel.h"

@interface JJTitledAttributedLabelView : UIView

@property (nonatomic, strong) JJLabel *titleLabel;
@property (nonatomic, strong) JJTTTAttributedLabel *attributedLabel;

@end
