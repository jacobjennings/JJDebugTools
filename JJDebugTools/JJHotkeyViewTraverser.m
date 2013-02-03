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
#import <QuartzCore/QuartzCore.h>
#import "CALayer+JJHotkeyViewTraverser.h"

static NSInteger const T = 23;      // Begin
static NSInteger const Up = 82;     // Superview
static NSInteger const Down = 81;   // Subview
static NSInteger const Left = 80;   // Peer below
static NSInteger const Right = 79;  // Peer above
static NSInteger const H = 11;      // Click to select
static NSInteger const R = 21;      // recursiveDescription
static NSInteger const P = 19;      // property list

@interface JJHotkeyViewTraverser ()

@property (nonatomic, strong) UIView *hitTestOverlay;
@property (nonatomic, strong) UITapGestureRecognizer *hitTestTapGestureRecognizer;

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
        
        self.highlightLayer = [CALayer layer];
        self.highlightLayer.backgroundColor = [[UIColor yellowColor] colorWithAlphaComponent:0.22].CGColor;
        
        self.hitTestOverlay = [[UIView alloc] init];
        self.hitTestTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
        [self.hitTestOverlay addGestureRecognizer:self.hitTestTapGestureRecognizer];
        
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
            if (self.highlightLayer.superlayer) {
                [self.highlightLayer removeFromSuperlayer];
            } else {
                self.selectedLayer = [self rootView].layer;
            }
            break;
        }
        case Up:
        {
            self.selectedLayer = [self.selectedLayer superlayer];
            break;
        }
        case Down:
        {
            self.selectedLayer = self.selectedLayer.jjSublayer;
            break;
        }
        case Left:
        {
            CALayer *layerBelow = self.selectedLayer.jjPeerLayerBelow;
            if (layerBelow)
            {
                self.selectedLayer = layerBelow;
            }
            break;
        }
        case Right:
        {
            CALayer *layerAbove = self.selectedLayer.jjPeerLayerAbove;
            if (layerAbove)
            {
                self.selectedLayer = layerAbove;
            }
            break;
        }
        case R:
        {
            NSString *recursiveDescription = [self.selectedLayer.jjViewForLayer performSelector:@selector(recursiveDescription)];
            NSLog(@"\n%@", recursiveDescription);
            break;
        }
        case P:
        {
            NSString *propertyListString = [self.selectedLayer.jjViewForLayer ?: self.selectedLayer propertyListWithValuesAsSingleString];
            NSLog(@"%@", propertyListString);
            break;
        }
        case H:
        {
            [[self rootView] addSubview:self.hitTestOverlay];
            self.hitTestOverlay.frame = [self rootView].bounds;
            break;
        }
        default:
            break;
    }
}

- (void)setSelectedLayer:(CALayer *)selectedLayer {
    if (!selectedLayer || selectedLayer == _selectedLayer) {
        return;
    }
    _selectedLayer = selectedLayer;
        
    [selectedLayer addSublayer:self.highlightLayer];
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    self.highlightLayer.frame = selectedLayer.bounds;
    [CATransaction commit];
    
    selectedLayer.superlayer.jjLastSelectedSublayer = selectedLayer;
   
    self.externalRootViewController.hierarchyLayer = self.selectedLayer;
}

- (UIView *)rootView {
    return [UIApplication sharedApplication].keyWindow.rootViewController.view;
}

- (void)tapped:(UITapGestureRecognizer *)tapGestureRecognizer
{
    [self.hitTestOverlay removeFromSuperview];
    UIView *hitView = [[self rootView] hitTest:[tapGestureRecognizer locationOfTouch:0 inView:[self rootView]] withEvent:nil];
    if (hitView)
    {
        self.selectedLayer = hitView.layer;
    }
}


@end
