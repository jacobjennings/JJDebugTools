//
//  JJTransformAdjusterView.h
//  JJDebugTools
//
//  Created by Jacob Jennings on 2/10/13.
//  Copyright (c) 2013 Jacob Jennings. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JJArrowKeyReceiver.h"

typedef NS_ENUM(NSInteger, JJTransformAdjusterViewMode)
{
    JJTransformAdjusterViewModeTranslation,
    JJTransformAdjusterViewModeScale,
    JJTransformAdjusterViewModeRotation
};

typedef NS_ENUM(NSInteger, JJTransformAdjusterViewAxis)
{
    JJTransformAdjusterViewAxisX,
    JJTransformAdjusterViewAxisY,
    JJTransformAdjusterViewAxisZ
};

@interface JJTransformAdjusterView : UIView <JJArrowKeyReceiver>

@property (nonatomic, strong) CALayer *adjustLayer;

@end
