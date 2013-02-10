//
//  JJRecentAnimationsView.h
//  JJDebugTools
//
//  Created by Jacob Jennings on 2/9/13.
//  Copyright (c) 2013 Jacob Jennings. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JJArrowKeyReceiver.h"
#import "JJMacArrowKeysView.h"

@interface JJRecentAnimationsView : UIView <JJArrowKeyReceiver>

@property (nonatomic, strong) CALayer *hierarchyLayer;
@property (nonatomic, strong) JJMacArrowKeysView *arrowKeysView;

@end
