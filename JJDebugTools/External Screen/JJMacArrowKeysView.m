//
//  JJMacArrowKeysView.m
//  JJDebugTools
//
//  Created by Jacob Jennings on 2/10/13.
//  Copyright (c) 2013 Jacob Jennings. All rights reserved.
//

#import "JJMacArrowKeysView.h"
#import "JJButton.h"
#import "JJShapeView.h"
#import "UIView+JJHotkeyViewTraverser.h"

static CGSize const kKeySize = (CGSize) { .width = 72, .height = 42 };
static CGSize const kArrowSizeHorizontal = (CGSize) { .width = 9, .height = 7 };
static CGSize const kArrowSizeVertical = (CGSize) { .width = 7, .height = 9 };
static CGFloat const kUpDownArrowsOffset = 3;
static CGFloat const kDistanceBetweenKeys = 7;
static CGFloat const kScale = 0.25;

#define kArrowColor [UIColor colorWithRed:0.45 green:0.45 blue:0.47 alpha:1.0]

@interface JJMacArrowKeysView ()

@property (nonatomic, strong) JJButton *upButton;
@property (nonatomic, strong) JJButton *downButton;
@property (nonatomic, strong) JJButton *leftButton;
@property (nonatomic, strong) JJButton *rightButton;

@property (nonatomic, strong) JJShapeView *upShapeView;
@property (nonatomic, strong) JJShapeView *downShapeView;
@property (nonatomic, strong) JJShapeView *leftShapeView;
@property (nonatomic, strong) JJShapeView *rightShapeView;

@end

@implementation JJMacArrowKeysView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.transform = CGAffineTransformMakeScale(kScale, kScale);
        self.hidden = YES;
        
        self.upButton = [self createBaseButton];
        self.upButton.corners = UIRectCornerTopLeft | UIRectCornerTopRight;
        [self addSubview:self.upButton];
        
        self.downButton = [self createBaseButton];
        self.downButton.corners = UIRectCornerBottomLeft | UIRectCornerBottomRight;
        [self addSubview:self.downButton];
        
        self.leftButton = [self createBaseButton];
        [self addSubview:self.leftButton];
        
        self.rightButton = [self createBaseButton];
        [self addSubview:self.rightButton];
        
        UIBezierPath *rightBezierPath = [[UIBezierPath alloc] init];
        [rightBezierPath moveToPoint:CGPointMake(0, 0)];
        [rightBezierPath addLineToPoint:CGPointMake(kArrowSizeHorizontal.width, kArrowSizeHorizontal.height / 2)];
        [rightBezierPath addLineToPoint:CGPointMake(0, kArrowSizeHorizontal.height)];
        [rightBezierPath closePath];
                
        self.upShapeView = [[JJShapeView alloc] init];
        self.upShapeView.shapeLayer.fillColor = kArrowColor.CGColor;
        self.upShapeView.shapeLayer.path = rightBezierPath.CGPath;
        self.upShapeView.transform = CGAffineTransformMakeRotation(3 * M_PI_2);
        [self addSubview:self.upShapeView];
        
        self.downShapeView = [[JJShapeView alloc] init];
        self.downShapeView.shapeLayer.fillColor = kArrowColor.CGColor;
        self.downShapeView.shapeLayer.path = rightBezierPath.CGPath;
        self.downShapeView.transform = CGAffineTransformMakeRotation(M_PI_2);
        [self addSubview:self.downShapeView];
        
        self.leftShapeView = [[JJShapeView alloc] init];
        self.leftShapeView.shapeLayer.fillColor = kArrowColor.CGColor;
        self.leftShapeView.shapeLayer.path = rightBezierPath.CGPath;
        self.leftShapeView.transform = CGAffineTransformMakeRotation(M_PI);
        [self addSubview:self.leftShapeView];
        
        self.rightShapeView = [[JJShapeView alloc] init];
        self.rightShapeView.shapeLayer.fillColor = kArrowColor.CGColor;
        self.rightShapeView.shapeLayer.path = rightBezierPath.CGPath;
        [self addSubview:self.rightShapeView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.upButton.frame = (CGRect) {
        .origin = CGPointZero,
        .size = kKeySize
    };
    [self.upButton centerHorizontally];
    
    self.downButton.frame = (CGRect) {
        .origin.x = self.upButton.frame.origin.x,
        .origin.y = CGRectGetMaxY(self.upButton.frame),
        .size = kKeySize
    };
    
    self.leftButton.frame = (CGRect) {
        .origin.x = self.upButton.frame.origin.x - kKeySize.width - kDistanceBetweenKeys,
        .origin.y = self.downButton.frame.origin.y,
        .size = kKeySize
    };
    
    self.rightButton.frame = (CGRect) {
        .origin.x = self.upButton.frame.origin.x + kKeySize.width + kDistanceBetweenKeys,
        .origin.y = self.downButton.frame.origin.y,
        .size = kKeySize
    };
    
    self.upShapeView.frame = CGRectOffset(CGRectCenter(kArrowSizeVertical, self.upButton.frame), 0, -kUpDownArrowsOffset);
    self.downShapeView.frame = CGRectOffset(CGRectCenter(kArrowSizeVertical, self.downButton.frame), 0, kUpDownArrowsOffset);
    self.leftShapeView.frame = CGRectCenter(kArrowSizeHorizontal, self.leftButton.frame);
    self.rightShapeView.frame = CGRectCenter(kArrowSizeHorizontal, self.rightButton.frame);
}

- (CGSize)sizeThatFits:(CGSize)size
{
    return CGSizeMake(kScale * (kKeySize.width * 3 + kDistanceBetweenKeys * 2),
                      kScale * (kKeySize.height * 2));
}

- (JJButton *)createBaseButton
{
    JJButton *button = [[JJButton alloc] init];
    button.topColor = [UIColor colorWithWhite:0.9 alpha:1];
    button.bottomColor = [UIColor colorWithWhite:0.9 alpha:1];
    button.highlightColor = [UIColor whiteColor];
    button.borderColor = [UIColor blackColor];
    button.cornerRadius = 10;
    return button;
}

@end
