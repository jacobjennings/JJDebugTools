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

static UIEdgeInsets const kDetailsViewInsets = (UIEdgeInsets) { .top = 3, .left = 6, .bottom = 3, .right = 6 };

#define DetailsLabelFont [UIFont fontWithName:@"HelveticaNeue" size:15]

@interface JJViewDetailsView ()

@property (nonatomic, strong) JJButton *backgroundButton;
@property (nonatomic, strong) JJLabel *titleLabel;
@property (nonatomic, strong) JJLabel *controllerLabel;
@property (nonatomic, strong) JJLabel *propertyNameLabel;
@property (nonatomic, strong) JJLabel *propertiesLabel;

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
        
        _propertiesLabel = [[JJLabel alloc] init];
        _propertiesLabel.font = [DetailsLabelFont fontWithSize:11];
        [self addSubview:_propertiesLabel];
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.backgroundButton.frame = self.bounds;
    
    CGSize titleLabelSize = [self.titleLabel sizeThatFits:self.bounds.size];
    self.titleLabel.frame = (CGRect) {
        .origin = CGPointMake(kDetailsViewInsets.left, kDetailsViewInsets.top),
        .size = titleLabelSize
    };
    [self.titleLabel centerVertically];
    
    CGSize controllerLabelSize = [self.controllerLabel sizeThatFits:self.bounds.size];
    self.controllerLabel.frame = (CGRect) {
        .origin = CGPointMake(kDetailsViewInsets.left, CGRectGetMaxY(self.titleLabel.frame)),
        .size = controllerLabelSize
    };
    
    CGSize propertyNameLabelSize = [self.propertyNameLabel sizeThatFits:self.bounds.size];
    self.propertyNameLabel.frame = (CGRect) {
        .origin = CGPointMake(kDetailsViewInsets.left, CGRectGetMaxY(self.controllerLabel.frame)),
        .size = propertyNameLabelSize
    };
    
    CGSize propertiesLabelSize = [self.propertiesLabel sizeThatFits:self.bounds.size];
    propertiesLabelSize.height = MIN(propertiesLabelSize.height, self.bounds.size.height - CGRectGetMaxY(self.propertyNameLabel.frame) - kDetailsViewInsets.bottom);
    self.propertiesLabel.frame = (CGRect) {
        .origin = CGPointMake(kDetailsViewInsets.left, CGRectGetMaxY(self.propertyNameLabel.frame)),
        .size = propertiesLabelSize
    };
}

- (void)setDetailsView:(UIView *)detailsView
{
    _detailsView = detailsView;
    
    self.titleLabel.text = NSStringFromClass([detailsView class]);
    
    NSString *controllerString = NSStringFromClass([[detailsView findAssociatedController] class]);
    self.controllerLabel.text = [NSString stringWithFormat:@"Controller: %@", controllerString ?: @"Unknown"];
    NSString *propertyNameString = [detailsView propertyOfSuperName];
    self.propertyNameLabel.text = [NSString stringWithFormat:@"Property %@ %@",
                                   propertyNameString,
                                   [detailsView propertyOfSuperNameIsController] ? @"on controller" : @""];
    self.propertiesLabel.text = [detailsView propertyListWithValuesAsSingleString];
    
    [self setNeedsLayout];
}

@end
