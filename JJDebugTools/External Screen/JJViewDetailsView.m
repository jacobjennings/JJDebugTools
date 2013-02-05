//
//  JJViewDetailsView.m
//  JJDebugTools
//
//  Created by Jacob Jennings on 1/26/13.
//  Copyright (c) 2013 Jacob Jennings. All rights reserved.
//

#import "JJViewDetailsView.h"
#import "UIView+JJHotkeyViewTraverser.h"
#import "NSObject+JJPropertyInspection.h"
#import "JJButton.h"
#import "JJLabel.h"
#import "CALayer+JJHotkeyViewTraverser.h"
#import <QuartzCore/QuartzCore.h>
#import "TTTAttributedLabel.h"
#import "JJViewDetailsViewTitledAttributedLabelView.h"

static UIEdgeInsets const kInsets = (UIEdgeInsets) { .top = 3, .left = 6, .bottom = 3, .right = 6 };
static CGFloat const kSectionSpacing = 4;

#define DetailsLabelFont [UIFont fontWithName:@"HelveticaNeue" size:15]

@interface JJViewDetailsView ()

@property (nonatomic, strong) JJButton *backgroundButton;
@property (nonatomic, strong) JJLabel *titleLabel;
@property (nonatomic, strong) JJLabel *controllerLabel;
@property (nonatomic, strong) JJLabel *propertyNameLabel;
@property (nonatomic, strong) NSArray *titledAttributedViews;

@end

@implementation JJViewDetailsView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _backgroundButton = [[JJButton alloc] init];
        [self addSubview:_backgroundButton];
        
        _titleLabel = [[JJLabel alloc] init];
        _titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18];
        [self addSubview:_titleLabel];
        
        _controllerLabel = [[JJLabel alloc] init];
        _controllerLabel.font = DetailsLabelFont;
        [self addSubview:_controllerLabel];
        
        _propertyNameLabel = [[JJLabel alloc] init];
        _propertyNameLabel.font = DetailsLabelFont;
        _propertyNameLabel.textColor = [UIColor colorWithRed:0.9 green:0.9 blue:1 alpha:1];
        [self addSubview:_propertyNameLabel];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.backgroundButton.frame = self.bounds;
    CGSize insetSize = CGSizeMake(self.bounds.size.width - kInsets.left - kInsets.right, self.bounds.size.height);
    
    CGSize titleLabelSize = [self.titleLabel sizeThatFits:self.bounds.size];
    self.titleLabel.frame = (CGRect) {
        .origin = CGPointMake(kInsets.left, kInsets.top),
        .size = titleLabelSize
    };
    [self.titleLabel centerHorizontally];
    
    CGSize controllerLabelSize = [self.controllerLabel sizeThatFits:self.bounds.size];
    self.controllerLabel.frame = (CGRect) {
        .origin = CGPointMake(kInsets.left, CGRectGetMaxY(self.titleLabel.frame)),
        .size = controllerLabelSize
    };
    [self.controllerLabel centerHorizontally];
    
    CGSize propertyNameLabelSize = [self.propertyNameLabel sizeThatFits:self.bounds.size];
    self.propertyNameLabel.frame = (CGRect) {
        .origin = CGPointMake(kInsets.left, CGRectGetMaxY(self.controllerLabel.frame)),
        .size = propertyNameLabelSize
    };
    [self.propertyNameLabel centerHorizontally];
    
    CGFloat lastY = CGRectGetMaxY(self.propertyNameLabel.frame) + kSectionSpacing;
    for (UIView *titledAttributedLabelView in self.titledAttributedViews)
    {
        CGSize titledAttributedLabelViewSize = [titledAttributedLabelView sizeThatFits:insetSize];
        titledAttributedLabelView.frame = CGRectMake(kInsets.left, lastY, insetSize.width, titledAttributedLabelViewSize.height);
        lastY = CGRectGetMaxY(titledAttributedLabelView.frame) + kSectionSpacing;
    }
}

- (void)setDetailsLayer:(CALayer *)detailsLayer
{
    _detailsLayer = detailsLayer;

    UIView *viewForLayer = detailsLayer.jjViewForLayer;
    self.titleLabel.text = NSStringFromClass([viewForLayer ?: detailsLayer class]);
    
    NSString *controllerString = NSStringFromClass([[viewForLayer findAssociatedController] class]);
    self.controllerLabel.text = [NSString stringWithFormat:@"Controller: %@", controllerString ?: @"Unknown"];
    NSString *propertyNameString = [detailsLayer jjPropertyName];
    self.propertyNameLabel.text = [NSString stringWithFormat:@"Property %@ %@",
                                   propertyNameString,
                                   [detailsLayer jjPropertyNameOwnerIsController] ? @"on controller" : @""];
    
    for (UIView *view in self.titledAttributedViews)
    {
        [view removeFromSuperview];
    }
    NSDictionary *classNameToPropertyListString = [viewForLayer ?: detailsLayer classToPropertyListStringDictionary];
    NSMutableArray *titledAttributedLabelViewsMutable = [[NSMutableArray alloc] init];
    NSUInteger depth = 0;
    for (NSString *className in [viewForLayer ?: detailsLayer superclassNameChainListToNSObject])
    {
        JJViewDetailsViewTitledAttributedLabelView *titleAttributedLabelView = [[JJViewDetailsViewTitledAttributedLabelView alloc] init];
        titleAttributedLabelView.titleLabel.text = depth > 0 ? [NSString stringWithFormat:@"Superclass #%u: %@", depth, className] : className;
        titleAttributedLabelView.attributedLabel.attributedText = [self attributedStringHighlightingNameColonWithString:classNameToPropertyListString[className]];
        [titledAttributedLabelViewsMutable addObject:titleAttributedLabelView];
        [self addSubview:titleAttributedLabelView];
        depth++;
    }
    self.titledAttributedViews = [NSArray arrayWithArray:titledAttributedLabelViewsMutable];
    
    [self setNeedsLayout];
}

- (NSAttributedString *)attributedStringHighlightingNameColonWithString:(NSString *)string
{
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"(^|\n)[^[:\t ]]*:" options:0 error:&error];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    NSRange searchRange = NSMakeRange(0, [string length]);
    [attributedString addAttribute:(NSString *)kCTForegroundColorAttributeName value:[UIColor whiteColor] range:searchRange];
    [regex enumerateMatchesInString:string options:0 range:searchRange usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        [attributedString addAttribute:(NSString *)kCTForegroundColorAttributeName value:[UIColor colorWithRed:0.9 green:0.8 blue:1 alpha:1] range:result.range];
    }];
    NSLog(@"%@", error);
    return attributedString;
}

@end
