//
//  JJHotkeyViewTraverser.m
//  JJDebugTools
//
//  Created by Jacob Jennings on 10/10/12.
//  Copyright (c) 2012 Jacob Jennings. All rights reserved.
//

//  Hotkeys:
//  t - begin; highlight something to start with
//  up/down - move selection up to superview / down to subview
//  left/right move selection between other subviews of your superview (peers)

#import "JJHotkeyViewTraverser.h"
#import "UIView+JJHotkeyViewTraverser.h"
#import "NSObject+JJPropertyInspection.h"
#import "JJExternalDisplayManager.h"
#import "JJExternalScreenRootViewController.h"
#import <objc/runtime.h>

static NSInteger const T = 23;      // Begin
static NSInteger const Up = 82;     // Superview
static NSInteger const Down = 81;   // Subview
static NSInteger const Left = 80;   // Peer below
static NSInteger const Right = 79;  // Peer above
static NSInteger const C = 6;       // UIViewController associated
static NSInteger const H = 11;      // Click to select 
static NSInteger const R = 21;      // recursiveDescription
static NSInteger const P = 19;      // property list

@interface JJHotkeyViewTraverser ()


@end

@implementation JJHotkeyViewTraverser

+ (JJHotkeyViewTraverser *)shared
{
    static JJHotkeyViewTraverser *_shared;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shared = [[JJHotkeyViewTraverser alloc] init];
    });
    return _shared;
}

- (id)init
{
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hotkeyPressedNotification:) name:JJPrivateKeyEventFiredNotification object:nil];
        
        self.highlightView = [[UIView alloc] init];
        self.highlightView.backgroundColor = [[UIColor yellowColor] colorWithAlphaComponent:0.22];
        self.highlightView.userInteractionEnabled = NO;
        
#warning Hook after client's didFinishLaunching somehow instead of lazy delay
        [self performSelector:@selector(configureExternalScreen) withObject:nil afterDelay:2];
    }
    return self;
}

- (void)configureExternalScreen
{
    _externalRootViewController = [[JJExternalScreenRootViewController alloc] init];
    [JJExternalDisplayManager shared].rootViewController = _externalRootViewController;    
}

- (void)hotkeyPressedNotification:(NSNotification *)notification
{
    NSInteger keyPressedInteger = [notification.userInfo[JJPrivateKeyEventUserInfoKeyUnicodeKeyCode] integerValue];
    switch (keyPressedInteger) {
        case T:
        {
            if (self.highlightView.superview) {
                [self.highlightView removeFromSuperview];
            } else {
                self.selectedView = [[self rootView] findRootView];
            }
            break;
        }
        case Up:
        {
            self.selectedView = [self.selectedView superview];
            break;
        }
        case Down:
        {
            self.selectedView = [self.selectedView aSubview];
            break;
        }
        case Left:
        {
            UIView *viewBelow = [self.selectedView viewBelow];
            self.selectedView = viewBelow ? viewBelow : self.selectedView;
            break;
        }
        case Right:
        {
            UIView *viewAbove = [self.selectedView viewAbove];
            self.selectedView = viewAbove ? viewAbove : self.selectedView;
            break;
        }
        case C:
        {
            NSLog(@"\nCONTROLLER: %@", [self.selectedView findAssociatedController]);
            break;
        }
        case R:
        {
            NSString *recursiveDescription = [self.selectedView performSelector:@selector(recursiveDescription)];
            NSLog(@"\n%@", recursiveDescription);
            break;
        }
        case P:
        {
            NSString *propertyListString = [self.selectedView propertyListWithValuesAsSingleString];
            NSLog(@"%@", propertyListString);
            break;
        }
        default:
            break;
    }
}

- (void)setSelectedView:(UIView *)selectedView {
    if (!selectedView || selectedView == _selectedView) {
        return;
    }
    if (![selectedView isDescendantOfView:[[UIApplication sharedApplication] keyWindow]])
    {
        selectedView = [[UIApplication sharedApplication] keyWindow];
    }
    _selectedView = selectedView;
        
    [selectedView addSubview:self.highlightView];
    self.highlightView.frame = selectedView.bounds;
    selectedView.superview.lastSelectedSubview = selectedView;
//    NSLog(@"lastSelectedSub %@", selectedView.superview.lastSelectedSubview);
   
    self.externalRootViewController.hierarchyView = self.selectedView;
    
//    NSLog(@"\n\nVIEW: %@", selectedView);
}

- (UIView *)rootView {
    return [UIApplication sharedApplication].keyWindow.rootViewController.view;
}


@end
