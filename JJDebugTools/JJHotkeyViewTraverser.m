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
#import "JJExternalScreenRootView.h"
#import "JJTransformAdjusterView.h"

static NSInteger const H = 11;      // Toggle highlight
static NSInteger const Up = 82;     // Superview
static NSInteger const Down = 81;   // Subview
static NSInteger const Left = 80;   // Peer below
static NSInteger const Right = 79;  // Peer above
static NSInteger const T = 23;      // Tap to select
static NSInteger const R = 21;      // recursiveDescription
//static NSInteger const P = 19;      // Browse properties
static NSInteger const A = 4;       // Switch arrows to recent animations
static NSInteger const C = 6;       // Switch arrows to controller details
static NSInteger const D = 7;       // Switch arrows to view details
static NSInteger const G = 10;       // Transform adjuster
static NSInteger const V = 25;      // Switch to view hierarchy navigation
//static NSInteger const W = 26;      // cycle windows

@interface JJHotkeyViewTraverser () <JJArrowKeyReceiver>

@property (nonatomic, strong) UIView *hitTestOverlay;
@property (nonatomic, strong) UITapGestureRecognizer *hitTestTapGestureRecognizer;
@property (nonatomic, strong) JJTransformAdjusterView *transformAdjusterView;

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
        
        [self performSelector:@selector(configureExternalScreen) withObject:nil afterDelay:0.25];
        
        self.arrowKeyReciever = self;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(animationCommitted) name:@"UIViewAnimationDidCommitNotification" object:nil];
    }
    return self;
}

- (void)configureExternalScreen
{
    if (![UIApplication sharedApplication].keyWindow || [UIApplication sharedApplication].keyWindow.hidden)
    {
        [self performSelector:@selector(configureExternalScreen) withObject:nil afterDelay:0.25];
    }
    self.externalRootViewController = [[JJExternalScreenRootViewController alloc] init];
    [JJExternalDisplayManager shared].rootViewController = self.externalRootViewController;
    self.highlightLayer.hidden = YES;
    [self performSelector:@selector(selectRootLayer) withObject:nil afterDelay:0.25];
    self.transformAdjusterView = [[JJTransformAdjusterView alloc] init];
}

- (void)selectRootLayer
{
    if (![self rootView]) {
        [self performSelector:@selector(selectRootLayer) withObject:nil afterDelay:0.25];
    }
    self.selectedLayer = [self rootView].layer;
}

- (void)hotkeyPressedNotification:(NSNotification *)notification
{
    NSInteger keyPressedInteger = [notification.userInfo[JJPrivateKeyEventUserInfoKeyUnicodeKeyCode] integerValue];
    switch (keyPressedInteger) {
        case H:
        {
            if (!self.selectedLayer) {
                self.selectedLayer = [self rootView].layer;
            }
            self.highlightLayer.hidden = !self.highlightLayer.hidden;
            break;
        }
        case V:
        {
            if (!self.selectedLayer) {
                self.selectedLayer = [self rootView].layer;
            }
            self.highlightLayer.hidden = NO;
            self.arrowKeyReciever = self;
            self.externalRootViewController.rootView.recentAnimationsView.arrowKeysView.hidden = YES;
            self.externalRootViewController.rootView.viewDetailsView.arrowKeysView.hidden = YES;
            self.externalRootViewController.rootView.controllerDetailsView.arrowKeysView.hidden = YES;
            self.externalRootViewController.rootView.hierarchyView.arrowKeysView.hidden = NO;
            break;
        }
        case Up:
        {
            if ([self.arrowKeyReciever respondsToSelector:@selector(upPressed)])
            {
                [self.arrowKeyReciever upPressed];
            }
            break;
        }
        case Down:
        {
            if ([self.arrowKeyReciever respondsToSelector:@selector(downPressed)])
            {
                [self.arrowKeyReciever downPressed];
            }
            break;
        }
        case Left:
        {
            if ([self.arrowKeyReciever respondsToSelector:@selector(leftPressed)])
            {
                [self.arrowKeyReciever leftPressed];
            }
            break;
        }
        case Right:
        {
            if ([self.arrowKeyReciever respondsToSelector:@selector(rightPressed)])
            {
                [self.arrowKeyReciever rightPressed];
            }
            break;
        }
        case R:
        {
            NSString *recursiveDescription = [self.selectedLayer.jjViewForLayer performSelector:@selector(recursiveDescription)];
            NSLog(@"\n%@", recursiveDescription);
            break;
        }
        case A:
        {
            self.arrowKeyReciever = self.externalRootViewController.rootView.recentAnimationsView;
            self.externalRootViewController.rootView.recentAnimationsView.arrowKeysView.hidden = NO;
            self.externalRootViewController.rootView.viewDetailsView.arrowKeysView.hidden = YES;
            self.externalRootViewController.rootView.controllerDetailsView.arrowKeysView.hidden = YES;
            self.externalRootViewController.rootView.hierarchyView.arrowKeysView.hidden = YES;
            break;
        }
        case D:
        {
            self.externalRootViewController.rootView.recentAnimationsView.arrowKeysView.hidden = YES;
            self.externalRootViewController.rootView.viewDetailsView.arrowKeysView.hidden = NO;
            self.externalRootViewController.rootView.controllerDetailsView.arrowKeysView.hidden = YES;
            self.externalRootViewController.rootView.hierarchyView.arrowKeysView.hidden = YES;
            self.arrowKeyReciever = self.externalRootViewController.rootView.viewDetailsView;
            break;
        }
        case C:
        {
            self.externalRootViewController.rootView.recentAnimationsView.arrowKeysView.hidden = YES;
            self.externalRootViewController.rootView.viewDetailsView.arrowKeysView.hidden = YES;
            self.externalRootViewController.rootView.controllerDetailsView.arrowKeysView.hidden = NO;
            self.externalRootViewController.rootView.hierarchyView.arrowKeysView.hidden = YES;
            self.arrowKeyReciever = self.externalRootViewController.rootView.controllerDetailsView;
            break;
        }
        case T:
        {
            [[self rootView] addSubview:self.hitTestOverlay];
            self.hitTestOverlay.frame = [self rootView].bounds;
            break;
        }
        case G:
        {
            [[self rootView] addSubview:self.transformAdjusterView];
            self.transformAdjusterView.adjustLayer = self.selectedLayer;
            break;
        }
//        case W:
//        {
//            static NSUInteger windowIndex = 0;
//            NSArray *windows = [[UIApplication sharedApplication] windows];
//            if (windowIndex + 1 == [windows count])
//            {
//                windowIndex++;
//            }
//            else
//            {
//                windowIndex = 0;
//            }
//            self.selectedLayer = [windows[windowIndex] layer];
//        }
        default:
            break;
    }
}

- (void)setSelectedLayer:(CALayer *)selectedLayer {
    if (!selectedLayer || selectedLayer == _selectedLayer) {
        return;
    }
    _selectedLayer = selectedLayer;
    [self configureSelectedLayer];
}

- (void)configureSelectedLayer;
{
    [self.selectedLayer addSublayer:self.highlightLayer];
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    self.highlightLayer.frame = self.selectedLayer.bounds;
    [CATransaction commit];
    
    self.selectedLayer.superlayer.jjLastSelectedSublayer = self.selectedLayer;
   
    self.externalRootViewController.hierarchyLayer = self.selectedLayer;
}

- (UIView *)rootView {
    return [UIApplication sharedApplication].keyWindow;
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


#pragma mark - JJArrowKeyReceiver

- (void)upPressed
{
    self.selectedLayer = [self.selectedLayer superlayer];
    self.highlightLayer.hidden = NO;
    
}

- (void)downPressed
{
    self.selectedLayer = self.selectedLayer.jjSublayer;
    self.highlightLayer.hidden = NO;
}

- (void)leftPressed
{
    CALayer *layerBelow = self.selectedLayer.jjPeerLayerBelow;
    if (layerBelow)
    {
        self.selectedLayer = layerBelow;
    }
    self.highlightLayer.hidden = NO;
}

- (void)rightPressed
{
    CALayer *layerAbove = self.selectedLayer.jjPeerLayerAbove;
    if (layerAbove)
    {
        self.selectedLayer = layerAbove;
    }
    self.highlightLayer.hidden = NO;
}

- (void)animationCommitted
{
    [self configureSelectedLayer];
}

@end
