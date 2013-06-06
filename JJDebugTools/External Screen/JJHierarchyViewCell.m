//
//  JJHierarchyViewCell.m
//  JJDebugTools
//
//  Created by Jacob Jennings on 1/26/13.
//  Copyright (c) 2013 Jacob Jennings. All rights reserved.
//

#import "JJHierarchyViewCell.h"
#import "UIView+JJHotkeyViewTraverser.h"
#import "NSObject+JJPropertyInspection.h"
#import "JJButton.h"
#import "JJLabel.h"
#import "JJHotkeyViewTraverser.h"
#import <QuartzCore/QuartzCore.h>
#import "CALayer+JJHotkeyViewTraverser.h"
#import "CALayer+JJRecentAnimations.h"

static UIEdgeInsets const kCellInsets = (UIEdgeInsets) { .top = 3, .left = 6, .bottom = 3, .right = 6 };
static CGFloat const kSpaceBetweenPropertyOrIvarNameAndRectLabel = 3;

#define CellFont [UIFont fontWithName:@"HelveticaNeue" size:15]

@interface JJHierarchyViewCell ()

@property (nonatomic, strong) JJLabel *classNameLabel;
@property (nonatomic, strong) JJLabel *propertyNameLabel;
@property (nonatomic, strong) JJLabel *rectLabel;
@property (nonatomic, strong) JJButton *buttonBackground;
@property (nonatomic, strong) JJLabel *recentAnimationCountLabel;

@end

@implementation JJHierarchyViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _buttonBackground = [[JJButton alloc] init];
        [self addSubview:_buttonBackground];
        
        _classNameLabel = [[JJLabel alloc] init];
        _classNameLabel.textAlignment = NSTextAlignmentCenter;
        _classNameLabel.font = CellFont;
        [self addSubview:_classNameLabel];
        
        _propertyNameLabel = [[JJLabel alloc] init];
        _propertyNameLabel.textAlignment = NSTextAlignmentCenter;
        _propertyNameLabel.font = CellFont;
        _propertyNameLabel.textColor = [UIColor colorWithRed:0.9 green:0.9 blue:1 alpha:1];
        [self addSubview:_propertyNameLabel];
        
        _rectLabel = [[JJLabel alloc] init];
        _rectLabel.textAlignment = NSTextAlignmentCenter;
        _rectLabel.font = CellFont;
        _rectLabel.textColor = [UIColor colorWithRed:0.9 green:1 blue:0.9 alpha:1];
        [self addSubview:_rectLabel];

        self.recentAnimationCountLabel = [[JJLabel alloc] init];
        self.recentAnimationCountLabel.textAlignment = NSTextAlignmentCenter;
        self.recentAnimationCountLabel.font = CellFont;
        self.recentAnimationCountLabel.textColor = [UIColor colorWithRed:1 green:0.5 blue:0.5 alpha:1];
        [self addSubview:self.recentAnimationCountLabel];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.buttonBackground.frame = self.bounds;
    
    CGSize classNameLabelSizeThatFits = [self.classNameLabel sizeThatFits:self.bounds.size];
    classNameLabelSizeThatFits = CGSizeMake(MIN(self.bounds.size.width, classNameLabelSizeThatFits.width),
                                            classNameLabelSizeThatFits.height);
    self.classNameLabel.frame = (CGRect) {
        .origin = CGPointMake(round(self.bounds.size.width / 2 - classNameLabelSizeThatFits.width / 2),
                              round(self.bounds.size.height / 2 - classNameLabelSizeThatFits.height)),
        .size = classNameLabelSizeThatFits };
    
    CGSize propertyNameLabelSizeThatFits = [self.propertyNameLabel sizeThatFits:self.bounds.size];
    propertyNameLabelSizeThatFits = CGSizeMake(MIN(propertyNameLabelSizeThatFits.width, self.bounds.size.width),
                                               propertyNameLabelSizeThatFits.height);
    self.propertyNameLabel.frame = (CGRect) {
        .origin = CGPointMake(kCellInsets.left,
                              CGRectGetMaxY(self.classNameLabel.frame)),
        .size = propertyNameLabelSizeThatFits };
    
    
    CGSize recentAnimationsCountLabelSize = [self.recentAnimationCountLabel sizeThatFits:self.bounds.size];
    self.recentAnimationCountLabel.frame = (CGRect) {
        .origin.x = self.bounds.size.width - recentAnimationsCountLabelSize.width - kCellInsets.right,
        .origin.y = CGRectGetMaxY(self.classNameLabel.frame),
        .size = recentAnimationsCountLabelSize
    };
    
    CGSize rectLabelSizeThatFits = [self.rectLabel sizeThatFits:self.bounds.size];
    self.rectLabel.frame = (CGRect) {
        .origin.x  = self.recentAnimationCountLabel.frame.origin.x - rectLabelSizeThatFits.width - kCellInsets.right,
        .origin.y = CGRectGetMaxY(self.classNameLabel.frame),
        .size = rectLabelSizeThatFits };
    
    if (!self.propertyNameLabel.text || ![self.propertyNameLabel.text length])
    {
        [self.rectLabel centerHorizontally];
    }
}

- (CGSize)sizeThatFits:(CGSize)size
{
    CGSize classNameLabelSizeThatFits = [self.classNameLabel sizeThatFits:size];
    CGSize propertyNameLabelSizeThatFits = [self.propertyNameLabel sizeThatFits:size];
    CGSize rectLabelSizeThatFits = [self.rectLabel sizeThatFits:size];
    CGSize recentAnimationsCountLabelSize = [self.recentAnimationCountLabel sizeThatFits:size];
    
    return CGSizeMake(MAX(classNameLabelSizeThatFits.width,
                          (propertyNameLabelSizeThatFits.width + rectLabelSizeThatFits.width + 4 + recentAnimationsCountLabelSize.width * 2))
                      + kCellInsets.left + kCellInsets.right
                      + kSpaceBetweenPropertyOrIvarNameAndRectLabel,
                      
                      classNameLabelSizeThatFits.height
                      + propertyNameLabelSizeThatFits.height
                      + kCellInsets.top + kCellInsets.bottom);
}

- (void)setHierarchyLayer:(CALayer *)hierarchyLayer
{
    _hierarchyLayer = hierarchyLayer;
    
    NSUInteger sublayerCount = [hierarchyLayer.sublayers count];
    if (hierarchyLayer == [JJHotkeyViewTraverser shared].selectedLayer)
    {
        sublayerCount--;
    }
    
    id layerOrView = hierarchyLayer.jjViewForLayer ?: hierarchyLayer;
    self.classNameLabel.text = [NSString stringWithFormat:@"%@: %u",
                                NSStringFromClass([layerOrView class]),
                                sublayerCount];
    NSString *rectString = NSStringFromCGRect(hierarchyLayer.frame);
    self.rectLabel.text = [rectString substringWithRange:NSMakeRange(1, rectString.length - 2)];
    NSString *propertyNameString = [hierarchyLayer jjPropertyName];
    self.propertyNameLabel.text = propertyNameString;
    NSUInteger animationCount = [[[hierarchyLayer dateToAnimationDetailsStringDictionary] allKeys] count];
    self.recentAnimationCountLabel.text = animationCount ? [NSString stringWithFormat:@"%u", animationCount] : nil;
    
    if (animationCount)
    {
        self.buttonBackground.topColor = [UIColor colorWithRed:0.5 green:0.2 blue:0.2 alpha:1];
        self.buttonBackground.bottomColor = [UIColor colorWithRed:0.24 green:0.07 blue:0.07 alpha:1];
    } else {
        self.buttonBackground.topColor = [UIColor colorWithWhite:0.2 alpha:1];
        self.buttonBackground.bottomColor = [UIColor colorWithWhite:0.1 alpha:1];
    }
    
    [self setNeedsLayout];
}

@end
