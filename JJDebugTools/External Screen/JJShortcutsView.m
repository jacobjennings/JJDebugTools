//
//  JJShortcutsView.m
//  JJDebugTools
//
//  Created by Jacob Jennings on 2/3/13.
//  Copyright (c) 2013 Jacob Jennings. All rights reserved.
//

#import "JJShortcutsView.h"
#import "JJButton.h"
#import "JJLabel.h"
#import "JJTTTAttributedLabel.h"

static UIEdgeInsets const kInsets = (UIEdgeInsets) { .top = 3, .left = 6, .bottom = 3, .right = 6 };

@interface JJShortcutsView ()

@property (nonatomic, strong) JJButton *backgroundButton;
@property (nonatomic, strong) JJLabel *titleLabel;
@property (nonatomic, strong) JJTTTAttributedLabel *highlightLabel;
@property (nonatomic, strong) JJTTTAttributedLabel *viewHierarchyLabel;
@property (nonatomic, strong) JJTTTAttributedLabel *tapToSelectLabel;
@property (nonatomic, strong) JJTTTAttributedLabel *viewDetailsLabel;
@property (nonatomic, strong) JJTTTAttributedLabel *controllerDetailsLabel;
@property (nonatomic, strong) JJTTTAttributedLabel *recentAnimationsLabel;
@property (nonatomic, strong) JJTTTAttributedLabel *transformAdjusterLabel;
@property (nonatomic, strong) JJTTTAttributedLabel *colorAdjusterLabel;

@end

@implementation JJShortcutsView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundButton = [[JJButton alloc] init];
        [self addSubview:self.backgroundButton];
        
        self.titleLabel = [[JJLabel alloc] init];
        self.titleLabel.text = @"Shortcuts";
        self.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18];
        [self addSubview:self.titleLabel];
        
        self.highlightLabel = [self createAttributedLabel];
        NSMutableAttributedString *highlightAttributedString = [[NSMutableAttributedString alloc] initWithString:@"Highlight overlay toggle"];
        [highlightAttributedString addAttribute:(NSString *)kCTForegroundColorAttributeName
                                          value:[UIColor whiteColor]
                                          range:NSMakeRange(0, highlightAttributedString.length)];
        [highlightAttributedString addAttribute:(NSString *)kCTFontAttributeName
                                          value:[UIFont fontWithName:@"HelveticaNeue" size:16]
                                          range:NSMakeRange(0, highlightAttributedString.length)];
        [highlightAttributedString addAttribute:(NSString *)kCTFontAttributeName
                                          value:[UIFont fontWithName:@"HelveticaNeue-Bold" size:20]
                                          range:NSMakeRange(0, 1)];
        self.highlightLabel.attributedText = highlightAttributedString;
        [self addSubview:self.highlightLabel];
        
        self.viewHierarchyLabel = [self createAttributedLabel];
        NSMutableAttributedString *viewHierarchyAttributedString = [[NSMutableAttributedString alloc] initWithString:@"View hierarchy (arrows to move)"];
        [viewHierarchyAttributedString addAttribute:(NSString *)kCTForegroundColorAttributeName
                                              value:[UIColor whiteColor]
                                              range:NSMakeRange(0, viewHierarchyAttributedString.length)];
        [viewHierarchyAttributedString addAttribute:(NSString *)kCTFontAttributeName
                                              value:[UIFont fontWithName:@"HelveticaNeue" size:16]
                                              range:NSMakeRange(0, viewHierarchyAttributedString.length)];
        [viewHierarchyAttributedString addAttribute:(NSString *)kCTFontAttributeName
                                              value:[UIFont fontWithName:@"HelveticaNeue-Bold" size:20]
                                              range:NSMakeRange(0, 1)];
        self.viewHierarchyLabel.attributedText = viewHierarchyAttributedString;
        [self addSubview:self.viewHierarchyLabel];
        
        self.tapToSelectLabel = [self createAttributedLabel];
        NSMutableAttributedString *tapToSelectAttributedString = [[NSMutableAttributedString alloc] initWithString:@"Tap to select a view"];
        [tapToSelectAttributedString addAttribute:(NSString *)kCTForegroundColorAttributeName
                                            value:[UIColor whiteColor]
                                            range:NSMakeRange(0, tapToSelectAttributedString.length)];
        [tapToSelectAttributedString addAttribute:(NSString *)kCTFontAttributeName
                                            value:[UIFont fontWithName:@"HelveticaNeue" size:16]
                                            range:NSMakeRange(0, tapToSelectAttributedString.length)];
        [tapToSelectAttributedString addAttribute:(NSString *)kCTFontAttributeName
                                            value:[UIFont fontWithName:@"HelveticaNeue-Bold" size:20]
                                            range:NSMakeRange(0, 1)];
        self.tapToSelectLabel.attributedText = tapToSelectAttributedString;
        [self addSubview:self.tapToSelectLabel];
        
        self.viewDetailsLabel = [self createAttributedLabel];
        NSMutableAttributedString *viewDetailsAttributedString = [[NSMutableAttributedString alloc] initWithString:@"View Details (arrows to move)"];
        [viewDetailsAttributedString addAttribute:(NSString *)kCTForegroundColorAttributeName
                                            value:[UIColor whiteColor]
                                            range:NSMakeRange(0, viewDetailsAttributedString.length)];
        [viewDetailsAttributedString addAttribute:(NSString *)kCTFontAttributeName
                                            value:[UIFont fontWithName:@"HelveticaNeue" size:16]
                                            range:NSMakeRange(0, viewDetailsAttributedString.length)];
        [viewDetailsAttributedString addAttribute:(NSString *)kCTFontAttributeName
                                            value:[UIFont fontWithName:@"HelveticaNeue-Bold" size:20]
                                            range:NSMakeRange(5, 1)];
        self.viewDetailsLabel.attributedText = viewDetailsAttributedString;
        [self addSubview:self.viewDetailsLabel];
        
        self.controllerDetailsLabel = [self createAttributedLabel];
        NSMutableAttributedString *controllerDetailsAttributedString = [[NSMutableAttributedString alloc] initWithString:@"Controller Details (arrows to move)"];
        [controllerDetailsAttributedString addAttribute:(NSString *)kCTForegroundColorAttributeName
                                                  value:[UIColor whiteColor]
                                                  range:NSMakeRange(0, controllerDetailsAttributedString.length)];
        [controllerDetailsAttributedString addAttribute:(NSString *)kCTFontAttributeName
                                                  value:[UIFont fontWithName:@"HelveticaNeue" size:16]
                                                  range:NSMakeRange(0, controllerDetailsAttributedString.length)];
        [controllerDetailsAttributedString addAttribute:(NSString *)kCTFontAttributeName
                                                  value:[UIFont fontWithName:@"HelveticaNeue-Bold" size:20]
                                                  range:NSMakeRange(0, 1)];
        self.controllerDetailsLabel.attributedText = controllerDetailsAttributedString;
        [self addSubview:self.controllerDetailsLabel];
        
        self.recentAnimationsLabel = [self createAttributedLabel];
        NSMutableAttributedString *recentAnimationsAttributedString = [[NSMutableAttributedString alloc] initWithString:@"Recent Animations (arrows to move)"];
        [recentAnimationsAttributedString addAttribute:(NSString *)kCTForegroundColorAttributeName
                                                 value:[UIColor whiteColor]
                                                 range:NSMakeRange(0, recentAnimationsAttributedString.length)];
        [recentAnimationsAttributedString addAttribute:(NSString *)kCTFontAttributeName
                                                 value:[UIFont fontWithName:@"HelveticaNeue" size:16]
                                                 range:NSMakeRange(0, recentAnimationsAttributedString.length)];
        [recentAnimationsAttributedString addAttribute:(NSString *)kCTFontAttributeName
                                                 value:[UIFont fontWithName:@"HelveticaNeue-Bold" size:20]
                                                 range:NSMakeRange(7, 1)];
        self.recentAnimationsLabel.attributedText = recentAnimationsAttributedString;
        [self addSubview:self.recentAnimationsLabel];
        
        self.transformAdjusterLabel = [self createAttributedLabel];
        NSMutableAttributedString *transformAdjusterAttributedString = [[NSMutableAttributedString alloc] initWithString:@"F: Transform adjuster"];
        [transformAdjusterAttributedString addAttribute:(NSString *)kCTForegroundColorAttributeName
                                                 value:[UIColor whiteColor]
                                                 range:NSMakeRange(0, transformAdjusterAttributedString.length)];
        [transformAdjusterAttributedString addAttribute:(NSString *)kCTFontAttributeName
                                                 value:[UIFont fontWithName:@"HelveticaNeue" size:16]
                                                 range:NSMakeRange(0, transformAdjusterAttributedString.length)];
        [transformAdjusterAttributedString addAttribute:(NSString *)kCTFontAttributeName
                                                 value:[UIFont fontWithName:@"HelveticaNeue-Bold" size:20]
                                                 range:NSMakeRange(0, 1)];
        self.transformAdjusterLabel.attributedText = transformAdjusterAttributedString;
        [self addSubview:self.transformAdjusterLabel];
        
        self.colorAdjusterLabel = [self createAttributedLabel];
        NSMutableAttributedString *colorAdjusterAttributedString = [[NSMutableAttributedString alloc] initWithString:@"G: Color adjuster for selected"];
        [colorAdjusterAttributedString addAttribute:(NSString *)kCTForegroundColorAttributeName
                                                 value:[UIColor whiteColor]
                                                 range:NSMakeRange(0, colorAdjusterAttributedString.length)];
        [colorAdjusterAttributedString addAttribute:(NSString *)kCTFontAttributeName
                                                 value:[UIFont fontWithName:@"HelveticaNeue" size:16]
                                                 range:NSMakeRange(0, colorAdjusterAttributedString.length)];
        [colorAdjusterAttributedString addAttribute:(NSString *)kCTFontAttributeName
                                                 value:[UIFont fontWithName:@"HelveticaNeue-Bold" size:20]
                                                 range:NSMakeRange(0, 1)];
        self.colorAdjusterLabel.attributedText = colorAdjusterAttributedString;
        [self addSubview:self.colorAdjusterLabel];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.backgroundButton.frame = self.bounds;
    
    CGSize titleLabelSize = [self.titleLabel sizeThatFits:self.bounds.size];
    self.titleLabel.frame = (CGRect) {
        .origin = CGPointMake(kInsets.left, kInsets.top),
        .size = titleLabelSize
    };
    [self.titleLabel centerHorizontally];
    
    CGSize highlightLabelSize = [self.highlightLabel sizeThatFits:self.bounds.size];
    self.highlightLabel.frame = (CGRect) {
        .origin = CGPointMake(kInsets.left, CGRectGetMaxY(self.titleLabel.frame)),
        .size = highlightLabelSize
    };
    [self.highlightLabel centerHorizontally];
    
    CGSize viewHierarchyLabelSize = [self.viewHierarchyLabel sizeThatFits:self.bounds.size];
    self.viewHierarchyLabel.frame = (CGRect) {
        .origin = CGPointMake(kInsets.left, CGRectGetMaxY(self.highlightLabel.frame)),
        .size = viewHierarchyLabelSize
    };
    [self.viewHierarchyLabel centerHorizontally];
    
    CGSize tapToSelectLabelSize = [self.tapToSelectLabel sizeThatFits:self.bounds.size];
    self.tapToSelectLabel.frame = (CGRect) {
        .origin = CGPointMake(kInsets.left, CGRectGetMaxY(self.viewHierarchyLabel.frame)),
        .size = tapToSelectLabelSize
    };
    [self.tapToSelectLabel centerHorizontally];
    
    CGSize viewDetailsLabelSize = [self.viewDetailsLabel sizeThatFits:self.bounds.size];
    self.viewDetailsLabel.frame = (CGRect) {
        .origin = CGPointMake(kInsets.left, CGRectGetMaxY(self.tapToSelectLabel.frame)),
        .size = viewDetailsLabelSize
    };
    [self.viewDetailsLabel centerHorizontally];
    
    CGSize controllerDetailsLabelSize = [self.controllerDetailsLabel sizeThatFits:self.bounds.size];
    self.controllerDetailsLabel.frame = (CGRect) {
        .origin = CGPointMake(kInsets.left, CGRectGetMaxY(self.viewDetailsLabel.frame)),
        .size = controllerDetailsLabelSize
    };
    [self.controllerDetailsLabel centerHorizontally];
    
    CGSize recentAnimationsLabelSize = [self.recentAnimationsLabel sizeThatFits:self.bounds.size];
    self.recentAnimationsLabel.frame = (CGRect) {
        .origin = CGPointMake(kInsets.left, CGRectGetMaxY(self.controllerDetailsLabel.frame)),
        .size = recentAnimationsLabelSize
    };
    [self.recentAnimationsLabel centerHorizontally];
    
    CGSize transformAdjusterLabelSize = [self.transformAdjusterLabel sizeThatFits:self.bounds.size];
    self.transformAdjusterLabel.frame = (CGRect) {
        .origin = CGPointMake(kInsets.left, CGRectGetMaxY(self.recentAnimationsLabel.frame)),
        .size = transformAdjusterLabelSize
    };
    [self.transformAdjusterLabel centerHorizontally];
    
    CGSize colorAdjusterLabelSize = [self.colorAdjusterLabel sizeThatFits:self.bounds.size];
    self.colorAdjusterLabel.frame = (CGRect) {
        .origin = CGPointMake(kInsets.left, CGRectGetMaxY(self.transformAdjusterLabel.frame)),
        .size = colorAdjusterLabelSize
    };
    [self.colorAdjusterLabel centerHorizontally];
}

- (JJTTTAttributedLabel *)createAttributedLabel
{
    JJTTTAttributedLabel *label = [[JJTTTAttributedLabel alloc] init];
    label.numberOfLines = 0;
    label.backgroundColor = [UIColor clearColor];
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
    label.shadowColor = [UIColor blackColor];
    label.shadowOffset = CGSizeMake(0, -1);
    label.shadowRadius = 1;
    return label;
}

@end
