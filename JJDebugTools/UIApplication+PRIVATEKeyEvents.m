//
//  UIApplication+PRIVATEKeyEvents.m
//  JJPrivateKeyEvents
//
//  Created by Jacob Jennings on 10/5/12.
/*
 Copyright (c) 2012 Hotel Tonight
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import "UIApplication+PRIVATEKeyEvents.h"
#import "GraphicsServices.h"
#import <objc/runtime.h>

NSString * const JJPrivateKeyEventFiredNotification = @"JJPrivateKeyEventFiredNotification";
NSString * const JJPrivateKeyEventUserInfoKeyUnicodeKeyCode = @"JJPrivateKeyEventUserInfoKeyUnicodeKeyCode";
NSString * const JJPrivateKeyEventUserInfoKeyGSEventFlags = @"JJPrivateKeyEventUserInfoKeyGSEventFlags";

@implementation UIApplication (PRIVATEKeyEvents)

+ (void)load
{
    method_exchangeImplementations(class_getInstanceMethod(self, @selector(_handleKeyEvent:)), class_getInstanceMethod(self, @selector(customHandleKeyEvent:)));
}

- (void)customHandleKeyEvent:(GSEventRef)gsEvent
{
//    NSLog(@"%@, %d", gsEvent, GSEventGetKeyCode(gsEvent));

    NSNumber *unicodeKeyCodeNumber = [NSNumber numberWithInt:GSEventGetKeyCode(gsEvent)];
    NSNumber *gsEventFlagsNumber = [NSNumber numberWithInt:GSEventGetModifierFlags(gsEvent)];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:JJPrivateKeyEventFiredNotification
                                                        object:self
                                                      userInfo:@{ JJPrivateKeyEventUserInfoKeyUnicodeKeyCode : unicodeKeyCodeNumber,  JJPrivateKeyEventUserInfoKeyGSEventFlags : gsEventFlagsNumber }];
    [self customHandleKeyEvent:gsEvent];
}

@end
