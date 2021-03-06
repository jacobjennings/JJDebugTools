//
//  JJObjectPropertiesView.m
//  JJDebugTools
//
//  Created by Jacob Jennings on 2/9/13.
//  Copyright (c) 2013 Jacob Jennings. All rights reserved.
//

#import "JJObjectPropertiesView.h"
#import "UIView+JJHotkeyViewTraverser.h"
#import "NSObject+JJPropertyInspection.h"
#import "JJButton.h"
#import "JJLabel.h"
#import "CALayer+JJHotkeyViewTraverser.h"
#import <QuartzCore/QuartzCore.h>
#import "JJTTTAttributedLabel.h"
#import "JJTitledAttributedLabelView.h"
#import "NSString+JJHighlightColon.h"

#define DetailsLabelFont [UIFont fontWithName:@"HelveticaNeue" size:15]

static UIEdgeInsets const kInsets = (UIEdgeInsets) { .top = 3, .left = 6, .bottom = 3, .right = 6 };
static CGFloat const kSectionSpacing = 4;
static CGFloat const kScrollAmountAtATime = 90;

@interface JJObjectPropertiesView ()

@property (nonatomic, strong) JJLabel *titleLabel;
@property (nonatomic, strong) JJLabel *propertyNameLabel;
@property (nonatomic, strong) NSArray *titledAttributedViews;
@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation JJObjectPropertiesView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _backgroundButton = [[JJButton alloc] init];
        [self addSubview:_backgroundButton];
        
        self.arrowKeysView = [[JJMacArrowKeysView alloc] init];
        [self addSubview:self.arrowKeysView];
        
        _titleLabel = [[JJLabel alloc] init];
        _titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18];
        [self addSubview:_titleLabel];
        
        _propertyNameLabel = [[JJLabel alloc] init];
        _propertyNameLabel.font = DetailsLabelFont;
        _propertyNameLabel.textColor = [UIColor colorWithRed:0.9 green:0.9 blue:1 alpha:1];
        [self addSubview:_propertyNameLabel];
        
        self.scrollView = [[UIScrollView alloc] init];
        [self addSubview:self.scrollView];
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
    
    CGSize propertyNameLabelSize = [self.propertyNameLabel sizeThatFits:self.bounds.size];
    self.propertyNameLabel.frame = (CGRect) {
        .origin = CGPointMake(kInsets.left, CGRectGetMaxY(self.titleLabel.frame)),
        .size = propertyNameLabelSize
    };
    [self.propertyNameLabel centerHorizontally];
    
    self.scrollView.frame = (CGRect) {
        .origin.x = 0,
        .origin.y = CGRectGetMaxY(self.propertyNameLabel.frame),
        .size.width = self.bounds.size.width,
        .size.height = self.bounds.size.height - CGRectGetMaxY(self.propertyNameLabel.frame) - kInsets.bottom
    };
    
    CGFloat lastY = 0;
    for (UIView *titledAttributedLabelView in self.titledAttributedViews)
    {
        CGSize titledAttributedLabelViewSize = [titledAttributedLabelView sizeThatFits:insetSize];
        titledAttributedLabelView.frame = CGRectMake(kInsets.left, lastY, insetSize.width, titledAttributedLabelViewSize.height);
        lastY = CGRectGetMaxY(titledAttributedLabelView.frame) + kSectionSpacing;
    }
    self.scrollView.contentSize = CGSizeMake(self.bounds.size.width, lastY);
    
    CGSize arrowKeysSize = [self.arrowKeysView sizeThatFits:self.bounds.size];
    self.arrowKeysView.frame = (CGRect) {
        .origin.x = self.bounds.size.width - arrowKeysSize.width - kInsets.right,
        .origin.y = kInsets.top,
        .size = arrowKeysSize
    };
}

- (void)setObject:(NSObject *)object
{
    _object = object;

    [self performSelector:@selector(configureForObject) withObject:nil afterDelay:0.26];
}

- (void)configureForObject
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(configureForObject) object:nil];
    if ([self.object isKindOfClass:[CALayer class]])
    {
        CALayer *detailsLayer = (CALayer *)self.object;
        UIView *viewForLayer = detailsLayer.jjViewForLayer;
        self.titleLabel.text = NSStringFromClass([viewForLayer ?: detailsLayer class]);
        
        NSString *propertyNameString = [detailsLayer jjPropertyName];
        self.propertyNameLabel.text = propertyNameString ? [NSString stringWithFormat:@"Property %@ %@", propertyNameString, [detailsLayer jjPropertyNameOwnerIsController] ? @"on controller" : @""] : nil;
        if (viewForLayer)
        {
            self.object = viewForLayer;
        }
    } else {
        self.titleLabel.text = NSStringFromClass([self.object class]);
        self.propertyNameLabel.text = nil;
    }
    
    for (UIView *view in self.titledAttributedViews)
    {
        [view removeFromSuperview];
    }
    NSDictionary *classNameToPropertyListString = [self.object classToPropertyListStringDictionary];
    NSMutableArray *titledAttributedLabelViewsMutable = [[NSMutableArray alloc] init];
    NSUInteger depth = 0;
    for (NSString *className in [self.object superclassNameChainListToNSObject])
    {
        JJTitledAttributedLabelView *titleAttributedLabelView = [[JJTitledAttributedLabelView alloc] init];
        titleAttributedLabelView.titleLabel.text = depth > 0 ?
        [NSString stringWithFormat:@"Superclass #%u: %@", depth, className] :
        [NSString stringWithFormat:@"Class #%u: %@", depth, className];
        titleAttributedLabelView.attributedLabel.attributedText = [classNameToPropertyListString[className] attributedStringHighlightingNameColon];
        [titledAttributedLabelViewsMutable addObject:titleAttributedLabelView];
        [self.scrollView addSubview:titleAttributedLabelView];
        depth++;
    }
    self.titledAttributedViews = [NSArray arrayWithArray:titledAttributedLabelViewsMutable];
    
    [self setNeedsLayout];
}

- (void)upPressed
{
    [self.scrollView setContentOffset:CGPointMake(0, MAX(self.scrollView.contentOffset.y - kScrollAmountAtATime, 0)) animated:YES];
}

- (void)downPressed
{
    [self.scrollView setContentOffset:CGPointMake(0, MIN(self.scrollView.contentOffset.y + kScrollAmountAtATime, self.scrollView.contentSize.height - self.scrollView.bounds.size.height)) animated:YES];
}

@end
