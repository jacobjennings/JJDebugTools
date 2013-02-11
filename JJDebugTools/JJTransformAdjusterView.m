//
//  JJTransformAdjusterView.m
//  JJDebugTools
//
//  Created by Jacob Jennings on 2/10/13.
//  Copyright (c) 2013 Jacob Jennings. All rights reserved.
//

#import "JJTransformAdjusterView.h"
#import "JJButton.h"
#import <QuartzCore/QuartzCore.h>
#import "UIView+JJHotkeyViewTraverser.h"

static CGSize const kButtonSize = (CGSize) { .width = 110, .height = 30 };
static UIEdgeInsets const kInsets = (UIEdgeInsets) { .top = 6, .left = 6, .bottom = 6, .right = 6 };

@interface JJTransformAdjusterView ()

@property (nonatomic, strong) UIView *toolboxBackgroundView;
@property (nonatomic, strong) JJButton *modeButton;
@property (nonatomic, strong) JJButton *axisButton;
@property (nonatomic, strong) JJButton *logButton;
@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic) JJTransformAdjusterViewMode mode;
@property (nonatomic) JJTransformAdjusterViewAxis axis;

@end

@implementation JJTransformAdjusterView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        self.toolboxBackgroundView = [[UIView alloc] init];
        self.toolboxBackgroundView.layer.cornerRadius = 6;
        self.toolboxBackgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
        [self addSubview:self.toolboxBackgroundView];
        
        self.modeButton = [[JJButton alloc] init];
        [self.modeButton addTarget:self action:@selector(modeTapped) forControlEvents:UIControlEventTouchDown];
        [self addSubview:self.modeButton];
        
        self.axisButton = [[JJButton alloc] init];
        [self.axisButton addTarget:self action:@selector(axisTapped) forControlEvents:UIControlEventTouchDown];
        [self addSubview:self.axisButton];
        
        self.logButton = [[JJButton alloc] init];
        [self.logButton addTarget:self action:@selector(logTapped) forControlEvents:UIControlEventTouchDown];
        [self addSubview:self.logButton];
        
        self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizerChanged)];
        [self addGestureRecognizer:self.panGestureRecognizer];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize overlaySize = CGSizeMake(kButtonSize.width + kInsets.left + kInsets.right,
                                    kButtonSize.height * 3 + kInsets.top * 3 + kInsets.bottom);
    
    CGRect adjustLayerRectInSelfBounds = [self.adjustLayer convertRect:self.adjustLayer.bounds toLayer:self.layer];
    
    CGRect topPositionRect = CGRectCenter(overlaySize, self.bounds);
    topPositionRect.origin.y = kInsets.top;
    
    CGRect bottomPositionRect = CGRectCenter(overlaySize, self.bounds);
    topPositionRect.origin.y = self.bounds.size.height - overlaySize.height - kInsets.bottom;
    
    BOOL topIntersects = CGRectIntersectsRect(adjustLayerRectInSelfBounds, topPositionRect);
    BOOL bottomIntersects = CGRectIntersectsRect(adjustLayerRectInSelfBounds, bottomPositionRect);
    if (topIntersects && !bottomIntersects)
    {
        self.toolboxBackgroundView.frame = bottomPositionRect;
    } else {
        self.toolboxBackgroundView.frame = topPositionRect;
    }
    
    self.modeButton.frame = (CGRect) {
        .origin.x = self.toolboxBackgroundView.frame.origin.x + kInsets.left,
        .origin.y = self.toolboxBackgroundView.frame.origin.y + kInsets.top,
        .size = kButtonSize
    };
    
    self.axisButton.frame = CGRectOffset(self.modeButton.frame, 0, kButtonSize.height + kInsets.top);
    self.logButton.frame = CGRectOffset(self.axisButton.frame, 0, kButtonSize.height + kInsets.top);
    
    [self rd];
}

- (void)setAdjustLayer:(CALayer *)adjustLayer
{
    _adjustLayer = adjustLayer;
    
    [self setNeedsLayout];
}

- (void)setMode:(JJTransformAdjusterViewMode)mode
{
    _mode = mode;
    
    [self configureLabels];
}

- (void)setAxis:(JJTransformAdjusterViewAxis)axis
{
    _axis = axis;

    [self configureLabels];
}

- (void)configureLabels
{
    switch (self.mode) {
        case JJTransformAdjusterViewModeTranslation:
            self.modeButton.label.text = @"Translation";
            break;
            
        case JJTransformAdjusterViewModeRotation:
            self.modeButton.label.text = @"Rotation";
            break;
            
        case JJTransformAdjusterViewModeScale:
            self.modeButton.label.text = @"Scale";
            break;
    }
    
    switch (self.axis) {
        case JJTransformAdjusterViewAxisX:
            self.axisButton.label.text = self.mode == JJTransformAdjusterViewModeRotation ? @"About X axis" : @"X axis";
            break;
            
        case JJTransformAdjusterViewAxisY:
            self.axisButton.label.text = self.mode == JJTransformAdjusterViewModeRotation ? @"About Y axis" : @"Y axis";
            break;
            
        case JJTransformAdjusterViewAxisZ:
            self.axisButton.label.text = self.mode == JJTransformAdjusterViewModeRotation ? @"About Z axis" : @"Z axis";
            break;
            
        default:
            break;
    }
}

- (void)modeTapped
{
    switch (self.mode) {
        case JJTransformAdjusterViewModeTranslation:
            self.mode = JJTransformAdjusterViewModeRotation;
            break;
            
        case JJTransformAdjusterViewModeRotation:
            self.mode = JJTransformAdjusterViewModeScale;
            break;
            
        case JJTransformAdjusterViewModeScale:
            self.mode = JJTransformAdjusterViewModeTranslation;
            break;
    }
}

- (void)axisTapped
{
    switch (self.axis) {
        case JJTransformAdjusterViewAxisX:
            self.axis = JJTransformAdjusterViewAxisY;
            break;
            
        case JJTransformAdjusterViewAxisY:
            self.axis = JJTransformAdjusterViewAxisZ;
            break;
            
        case JJTransformAdjusterViewAxisZ:
            self.axis = JJTransformAdjusterViewAxisX;
            break;
            
        default:
            break;
    }
}

- (void)logTapped
{
    switch (self.mode) {
        case JJTransformAdjusterViewModeTranslation:
            
            break;
            
        case JJTransformAdjusterViewModeRotation:
            
            break;
            
        case JJTransformAdjusterViewModeScale:
            
            break;
    }
}

- (void)panGestureRecognizerChanged
{
    switch (self.panGestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:
            
            break;
            
        case UIGestureRecognizerStateChanged:
            
            break;
            
        case UIGestureRecognizerStateEnded:
            
            break;
            
        default:
            break;
    }
}

- (void)upPressed
{
    
}

- (void)downPressed
{
    
}

- (void)leftPressed
{
    
}

- (void)rightPressed
{
    
}

- (void)didMoveToWindow
{
    self.frame = self.window.bounds;
}

@end
