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
#import "TTTAttributedLabel.h"

static UIEdgeInsets const kInsets = (UIEdgeInsets) { .top = 3, .left = 6, .bottom = 3, .right = 6 };

@interface JJShortcutsView ()

@property (nonatomic, strong) JJButton *backgroundButton;
@property (nonatomic, strong) JJLabel *titleLabel;
@property (nonatomic, strong) TTTAttributedLabel *highlightLabel;
@property (nonatomic, strong) TTTAttributedLabel *viewHierarchyLabel;
@property (nonatomic, strong) TTTAttributedLabel *tapToSelectLabel;
@property (nonatomic, strong) TTTAttributedLabel *propertyBrowserLabel;
// toggle between layouts?

@end

@implementation JJShortcutsView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _backgroundButton = [[JJButton alloc] init];
        [self addSubview:_backgroundButton];

        _titleLabel = [[JJLabel alloc] init];
        _titleLabel.text = @"Shortcuts";
        [self addSubview:_titleLabel];
        
        _highlightLabel = [self createAttributedLabel];
        NSMutableAttributedString *highlightAttributedString = [[NSMutableAttributedString alloc] initWithString:@"Highlight overlay toggle"];
        [highlightAttributedString addAttribute:(NSString *)kCTForegroundColorAttributeName
                                          value:[UIColor whiteColor]
                                          range:NSMakeRange(0, highlightAttributedString.length)];
        [highlightAttributedString addAttribute:(NSString *)kCTFontAttributeName
                                          value:[UIFont fontWithName:@"HelveticaNeue" size:16]
                                          range:NSMakeRange(0, 1)];
        _highlightLabel.attributedText = highlightAttributedString;
        _highlightLabel.shadowColor = [UIColor blackColor];
        _highlightLabel.shadowOffset = CGSizeMake(0, 1);
        _highlightLabel.shadowRadius = 1;
        [self addSubview:_highlightLabel];
        
        _viewHierarchyLabel = [self createAttributedLabel];
        [self addSubview:_viewHierarchyLabel];
        
        _tapToSelectLabel = [self createAttributedLabel];
        [self addSubview:_tapToSelectLabel];
        
        _propertyBrowserLabel = [self createAttributedLabel];
        [self addSubview:_propertyBrowserLabel];
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
    
    CGSize highlightLabelSize = [self.highlightLabel sizeThatFits:self.bounds.size];
    self.highlightLabel.frame = (CGRect) {
        .origin = CGPointMake(kInsets.left, CGRectGetMaxY(self.titleLabel.frame)),
        .size = highlightLabelSize
    };
    
    CGSize viewHierarchyLabelSize = [self.viewHierarchyLabel sizeThatFits:self.bounds.size];
    self.viewHierarchyLabel.frame = (CGRect) {
        .origin = CGPointMake(kInsets.left, CGRectGetMaxY(self.highlightLabel.frame)),
        .size = viewHierarchyLabelSize
    };
    
    CGSize tapToSelectLabelSize = [self.tapToSelectLabel sizeThatFits:self.bounds.size];
    self.tapToSelectLabel.frame = (CGRect) {
        .origin = CGPointMake(kInsets.left, CGRectGetMaxY(self.viewHierarchyLabel.frame)),
        .size = tapToSelectLabelSize
    };

    CGSize propertyBrowserLabelSize = [self.propertyBrowserLabel sizeThatFits:self.bounds.size];
    self.propertyBrowserLabel.frame = (CGRect) {
        .origin = CGPointMake(kInsets.left, CGRectGetMaxY(self.tapToSelectLabel.frame)),
        .size = propertyBrowserLabelSize
    };
}

- (TTTAttributedLabel *)createAttributedLabel
{
    TTTAttributedLabel *label = [[TTTAttributedLabel alloc] init];
    label.numberOfLines = 0;
    label.backgroundColor = [UIColor clearColor];
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
    return label;
}

@end
