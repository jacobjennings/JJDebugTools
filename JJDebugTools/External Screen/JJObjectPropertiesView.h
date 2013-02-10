//
//  JJObjectPropertiesView.h
//  JJDebugTools
//
//  Created by Jacob Jennings on 2/9/13.
//  Copyright (c) 2013 Jacob Jennings. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JJArrowKeyReceiver.h"
#import "JJButton.h"

@interface JJObjectPropertiesView : UIView <JJArrowKeyReceiver>

@property (nonatomic, strong) JJButton *backgroundButton;
@property (nonatomic, strong) NSObject *object;

@end
