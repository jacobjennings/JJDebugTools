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

static NSInteger const H = 11;      // Toggle highlight
static NSInteger const Up = 82;     // Superview
static NSInteger const Down = 81;   // Subview
static NSInteger const Left = 80;   // Peer below
static NSInteger const Right = 79;  // Peer above
static NSInteger const T = 23;      // Tap to select
static NSInteger const R = 21;      // recursiveDescription
static NSInteger const P = 19;      // Browse properties
//static NSInteger const C = 6;       // Switch detail view to Controller mode
static NSInteger const V = 25;      // Switch to view hierarchy navigation

@interface JJHotkeyViewTraverser () <JJArrowKeyReceiver>

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
        [self performSelector:@selector(configureExternalScreen) withObject:nil afterDelay:5];
        
        self.arrowKeyReciever = self;
    }
    return self;
}

- (void)configureExternalScreen
{
    self.externalRootViewController = [[JJExternalScreenRootViewController alloc] init];
    [JJExternalDisplayManager shared].rootViewController = _externalRootViewController;
    self.selectedLayer = [self rootView].layer;
    self.highlightLayer.hidden = YES;
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
            self.arrowKeyReciever = self.externalRootViewController.rootView.viewDetailsView;
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
        case P:
        {
            NSString *propertyListString = [self.selectedLayer.jjViewForLayer ?: self.selectedLayer propertyListWithValuesAsSingleString];
            NSLog(@"%@", propertyListString);
            
            break;
        }
        case T:
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


#pragma mark - JJArrowKeyReceiver

- (void)upPressed
{
    self.selectedLayer = [self.selectedLayer superlayer];
    
}

- (void)downPressed
{
    self.selectedLayer = self.selectedLayer.jjSublayer;
    
}

- (void)leftPressed
{
    CALayer *layerBelow = self.selectedLayer.jjPeerLayerBelow;
    if (layerBelow)
    {
        self.selectedLayer = layerBelow;
    }
    
}

- (void)rightPressed
{
    CALayer *layerAbove = self.selectedLayer.jjPeerLayerAbove;
    if (layerAbove)
    {
        self.selectedLayer = layerAbove;
    }
}


@end
