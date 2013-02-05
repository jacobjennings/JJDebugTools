//
//  JJViewDetailsViewTitledAttributedLabelView.m
//  JJDebugTools
//
//  Created by Jacob Jennings on 2/4/13.
//  Copyright (c) 2013 Jacob Jennings. All rights reserved.
//

#import "JJViewDetailsViewTitledAttributedLabelView.h"
#import <QuartzCore/QuartzCore.h>

@interface JJViewDetailsViewTitledAttributedLabelView ()

@end

@implementation JJViewDetailsViewTitledAttributedLabelView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel = [[JJLabel alloc] init];
        self.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.titleLabel];

        self.attributedLabel = [[TTTAttributedLabel alloc] init];
        self.attributedLabel.numberOfLines = 0;
        self.attributedLabel.backgroundColor = [UIColor clearColor];
        self.attributedLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.attributedLabel.shadowColor = [UIColor blackColor];
        self.attributedLabel.shadowOffset = CGSizeMake(0, -1);
        self.attributedLabel.shadowRadius = 1;
        [self addSubview:self.attributedLabel];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGSize titleLabelSize = [self.titleLabel sizeThatFits:self.bounds.size];
    self.titleLabel.frame = CGRectMake(round(CGRectGetMidX(self.bounds) - titleLabelSize.width / 2),
                                       0,
                                       titleLabelSize.width,
                                       titleLabelSize.height);
    
    CGSize attributedLabelSize = [self.attributedLabel sizeThatFits:self.bounds.size];
    self.attributedLabel.frame = (CGRect) {
        .origin = CGPointMake(0, CGRectGetMaxY(self.titleLabel.frame)),
        .size = attributedLabelSize
    };
}

- (CGSize)sizeThatFits:(CGSize)size
{
    CGSize titleLabelSize = [self.titleLabel sizeThatFits:size];
    CGSize attributedLabelSize = [self.attributedLabel sizeThatFits:size];
    return CGSizeMake(MAX(titleLabelSize.width, attributedLabelSize.width),
                      titleLabelSize.height + attributedLabelSize.height);
}

@end
