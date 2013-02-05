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
                                          value:[UIFont fontWithName:@"HelveticaNeue" size:20]
                                          range:NSMakeRange(0, 1)];
        self.highlightLabel.attributedText = highlightAttributedString;
        self.highlightLabel.shadowColor = [UIColor blackColor];
        self.highlightLabel.shadowOffset = CGSizeMake(0, 1);
        self.highlightLabel.shadowRadius = 1;
        [self addSubview:self.highlightLabel];
        
        self.viewHierarchyLabel = [self createAttributedLabel];
        NSMutableAttributedString *viewHierarchyAttributedString = [[NSMutableAttributedString alloc] initWithString:@"View hierarchy (then arrows to move)"];
        [viewHierarchyAttributedString addAttribute:(NSString *)kCTForegroundColorAttributeName
                                              value:[UIColor whiteColor]
                                              range:NSMakeRange(0, viewHierarchyAttributedString.length)];
        [viewHierarchyAttributedString addAttribute:(NSString *)kCTFontAttributeName
                                          value:[UIFont fontWithName:@"HelveticaNeue" size:16]
                                          range:NSMakeRange(0, viewHierarchyAttributedString.length)];
        [viewHierarchyAttributedString addAttribute:(NSString *)kCTFontAttributeName
                                              value:[UIFont fontWithName:@"HelveticaNeue" size:20]
                                              range:NSMakeRange(0, 1)];
        self.viewHierarchyLabel.attributedText = viewHierarchyAttributedString;
        self.viewHierarchyLabel.shadowColor = [UIColor blackColor];
        self.viewHierarchyLabel.shadowOffset = CGSizeMake(0, 1);
        self.viewHierarchyLabel.shadowRadius = 1;
        [self addSubview:self.viewHierarchyLabel];
        
        self.tapToSelectLabel = [self createAttributedLabel];
        [self addSubview:self.tapToSelectLabel];
        
        self.propertyBrowserLabel = [self createAttributedLabel];
        [self addSubview:self.propertyBrowserLabel];
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
