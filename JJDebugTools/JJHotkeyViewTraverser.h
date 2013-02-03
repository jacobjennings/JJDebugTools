//
//  JJHotkeyViewTraverser.h
//  JJDebugTools
//
//  Created by Jacob Jennings on 10/10/12.
//  Copyright (c) 2012 Jacob Jennings. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIApplication+PRIVATEKeyEvents.h"
#import "JJExternalScreenRootViewController.h"

@interface JJHotkeyViewTraverser : NSObject

@property (nonatomic, strong) CALayer *selectedLayer;
@property (nonatomic, strong) CALayer *highlightLayer;
@property (nonatomic, strong) JJExternalScreenRootViewController *externalRootViewController;

+ (JJHotkeyViewTraverser *)shared;

@end
