//
//  JJButton.m
//  Rest Client
//
//  Created by Jacob Jennings on 4/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "JJButton.h"
#import <QuartzCore/QuartzCore.h>
#import "UIBezierPath+JJUtilities.h"

@interface JJButton ()

@property (nonatomic, strong) CAGradientLayer *gradientLayer;
@property (nonatomic, strong) CAShapeLayer *highlightLayer;
@property (nonatomic, strong) CALayer *maskedLayer;
@property (nonatomic, strong) CAShapeLayer *maskLayer;
@property (nonatomic, strong) CAShapeLayer *borderLayer;

@property (nonatomic) CGSize previousSize;

- (void)configureBackgroundGradient;

@end

@implementation JJButton

@synthesize previousSize = _previousSize;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.maskedLayer = [[CALayer alloc] init];
        [self.layer addSublayer:self.maskedLayer];
        
        self.gradientLayer = [CAGradientLayer layer];
        [self.maskedLayer addSublayer:self.gradientLayer];
        
        self.topColor = [UIColor colorWithWhite:0.2 alpha:1];
        self.bottomColor = [UIColor colorWithWhite:0.1 alpha:1];
        
        self.highlightLayer = [[CAShapeLayer alloc] init];
        self.highlightLayer.fillColor = [UIColor clearColor].CGColor;
        self.highlightColor = [UIColor colorWithWhite:1 alpha:0.2];
        [self.maskedLayer addSublayer:self.highlightLayer];
        
        self.borderLayer = [[CAShapeLayer alloc] init];
        self.borderLayer.fillColor = [UIColor clearColor].CGColor;
        [self.layer addSublayer:self.borderLayer];
        
        self.maskLayer = [[CAShapeLayer alloc] init];
        
        self.maskedLayer.mask = self.maskLayer;
                
        self.layer.shadowOffset = CGSizeMake(0, 2);
        self.layer.shadowRadius = 1;
        self.layer.shadowOpacity = 0.2;
        
        self.corners = UIRectCornerAllCorners;
        self.cornerRadius = 6;
        self.highlightedColor = [UIColor colorWithRed:0 green:0 blue:0.24 alpha:1];
        
        self.opaque = YES;
        self.previousSize = CGSizeZero;
        
        self.label = [[JJLabel alloc] init];
        self.label.textAlignment = NSTextAlignmentCenter;
        self.label.layer.shouldRasterize = YES;
        self.label.shadowOffset = CGSizeMake(0, -1);
        self.label.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        self.label.textColor = [UIColor colorWithWhite:0.9 alpha:1];
        self.label.layer.shouldRasterize = YES;
        self.label.layer.rasterizationScale = [UIScreen mainScreen].scale;
        [self addSubview:self.label];
        
        self.gradientLayer.opaque = YES;
        
        self.layer.shouldRasterize = YES;
        self.layer.contentsScale = [UIScreen mainScreen].scale;
        self.layer.rasterizationScale = [UIScreen mainScreen].scale;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.label.frame = self.bounds;
}

- (void)layoutSublayersOfLayer:(CALayer *)layer {
    [super layoutSublayersOfLayer:layer];
    if (layer == self.layer) {
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        self.previousSize = self.bounds.size;
        self.gradientLayer.frame = self.bounds;
        self.maskedLayer.frame = self.bounds;
        
        UIBezierPath *maskLayerPath = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(self.bounds, 1, 1) byRoundingCorners:self.corners cornerRadii:CGSizeMake(self.cornerRadius, self.cornerRadius)];
        self.maskLayer.frame = self.bounds;
        self.maskLayer.path = maskLayerPath.CGPath;
        
        UIBezierPath *borderLayerPath = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(self.bounds, 0.5, 0.5) byRoundingCorners:self.corners cornerRadii:CGSizeMake(self.cornerRadius, self.cornerRadius)];        
        self.borderLayer.frame = self.bounds;
        self.borderLayer.path = borderLayerPath.CGPath;
        
        self.highlightLayer.frame = self.bounds;
        self.highlightLayer.path = [UIBezierPath bezierPathTopOfRect:CGRectInset(self.bounds, 0.4, 1.5) roundedCorners:self.corners radius:self.cornerRadius].CGPath;
        [CATransaction commit];
    }
}

- (void)configureBackgroundGradient {
    self.gradientLayer.colors = [NSArray arrayWithObjects:(id)self.topColor.CGColor, (id)self.bottomColor.CGColor, nil];
}

- (void)setTopColor:(UIColor *)topColor {
    _topColor = topColor;
    [self configureBackgroundGradient];
}

- (void)setBottomColor:(UIColor *)bottomColor {
    _bottomColor = bottomColor;
    [self configureBackgroundGradient];
}

- (void)setBorderColor:(UIColor *)borderColor {
    _borderColor = borderColor;
    self.borderLayer.strokeColor = borderColor.CGColor;
}

- (void)setHighlightColor:(UIColor *)highlightColor {
    _highlightColor = highlightColor;
    self.highlightLayer.strokeColor = highlightColor.CGColor;
}

- (void)setHighlightedColor:(UIColor *)highlightedColor
{
    _highlightedColor = highlightedColor;
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    _cornerRadius = cornerRadius;
    [self setNeedsLayout];
}

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    
    [CATransaction begin];
    [CATransaction setAnimationDuration:highlighted ? 0 : 0.25];
    
    if (highlighted) {
        self.gradientLayer.colors = [NSArray arrayWithObjects:(id)self.highlightedColor.CGColor, self.highlightedColor.CGColor, nil];
    } else {
        [self configureBackgroundGradient];
    }
    [CATransaction commit];
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    if (selected) {
        self.gradientLayer.colors = [NSArray arrayWithObjects:(id)[UIColor blueColor].CGColor, [UIColor blueColor].CGColor, nil];
    } else {
        [self configureBackgroundGradient];
    }
}

@end
