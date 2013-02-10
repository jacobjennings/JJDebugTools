//
//  JJArrowKeyReceiver.h
//  JJDebugTools
//
//  Created by Jacob Jennings on 2/9/13.
//  Copyright (c) 2013 Jacob Jennings. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol JJArrowKeyReceiver <NSObject>

@optional
- (void)upPressed;
- (void)downPressed;
- (void)leftPressed;
- (void)rightPressed;

@end
