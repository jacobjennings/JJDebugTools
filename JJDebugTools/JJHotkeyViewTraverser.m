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

static NSString * const JJAssociatedObjectKeyLastSelectedSubview = @"JJAssociatedObjectKeyLastSelectedSubview";

@interface JJHotkeyViewTraverser ()

@property (nonatomic, strong) UIView *selectedView;
@property (nonatomic, strong) UIView *highlightView;

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
    }
    return self;
}

- (void)hotkeyPressedNotification:(NSNotification *)notification
{
    switch ([notification.userInfo[JJPrivateKeyEventUserInfoKeyUnicodeKeyCode] integerValue]) {
        case T:
        {
            if (self.highlightView.superview) {
                [self.highlightView removeFromSuperview];
            } else {
                self.selectedView = [[self rootView] findTheHippestViewOfThemAll];
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
            UIView *lastSelectedSubview = objc_getAssociatedObject(self, &JJAssociatedObjectKeyLastSelectedSubview);
            if (lastSelectedSubview) {
                self.selectedView = lastSelectedSubview;
            } else {
                UIView *downView;
                if ([self.selectedView.subviews count]) {
                    downView = self.selectedView.subviews[0];
                }
                if (downView && downView != self.highlightView) {
                    self.selectedView = downView;
                }
            }
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
    _selectedView = selectedView;
    
    selectedView.superview.lastSelectedSubview = selectedView;
    
    [selectedView addSubview:self.highlightView];
    self.highlightView.frame = selectedView.bounds;
   
    NSLog(@"\n\nVIEW: %@", selectedView);
}

- (UIView *)rootView {
    return [UIApplication sharedApplication].keyWindow.rootViewController.view;
}



@end
