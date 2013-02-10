//
//  JJRecentAnimationsView.m
//  JJDebugTools
//
//  Created by Jacob Jennings on 2/9/13.
//  Copyright (c) 2013 Jacob Jennings. All rights reserved.
//

#import "JJRecentAnimationsView.h"
#import "CALayer+JJRecentAnimations.h"
#import "JJButton.h"
#import "JJLabel.h"
#import "TTTAttributedLabel.h"
#import "JJTitledAttributedLabelView.h"
#import "NSString+JJHighlightColon.h"

static UIEdgeInsets const kInsets = (UIEdgeInsets) { .top = 3, .left = 6, .bottom = 3, .right = 6 };
static CGFloat const kSectionSpacing = 4;
static CGFloat const kScrollAmountAtATime = 90;

@interface JJRecentAnimationsView ()

@property (nonatomic, strong) JJButton *backgroundButton;
@property (nonatomic, strong) JJLabel *titleLabel;
@property (nonatomic, strong) NSArray *titledAttributedViews;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end

@implementation JJRecentAnimationsView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(animationCommitted) name:@"UIViewAnimationDidCommitNotification" object:nil];
        
        self.backgroundButton = [[JJButton alloc] init];
        [self addSubview:self.backgroundButton];
        
        self.titleLabel = [[JJLabel alloc] init];
        self.titleLabel.text = @"Recent Animations";
        self.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18];
        [self addSubview:self.titleLabel];

        self.scrollView = [[UIScrollView alloc] init];
        [self addSubview:self.scrollView];
        
        self.dateFormatter = [[NSDateFormatter alloc] init];
        [self.dateFormatter setDateFormat:@"hh:mm:ss.SSS"];
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
    
    self.scrollView.frame = (CGRect) {
        .origin.x = 0,
        .origin.y = CGRectGetMaxY(self.titleLabel.frame),
        .size.width = self.bounds.size.width,
        .size.height = self.bounds.size.height - CGRectGetMaxY(self.titleLabel.frame) - kInsets.bottom
    };
    
    CGFloat lastY = 0;
    for (UIView *titledAttributedLabelView in self.titledAttributedViews)
    {
        CGSize titledAttributedLabelViewSize = [titledAttributedLabelView sizeThatFits:insetSize];
        titledAttributedLabelView.frame = CGRectMake(kInsets.left, lastY, insetSize.width, titledAttributedLabelViewSize.height);
        lastY = CGRectGetMaxY(titledAttributedLabelView.frame) + kSectionSpacing;
    }
    self.scrollView.contentSize = CGSizeMake(self.bounds.size.width, lastY);
}

- (void)animationCommitted
{
    [[UIApplication sharedApplication].keyWindow.rootViewController.view.layer saveSnapshotOfAnimationStateRecursive];
}

- (void)setHierarchyLayer:(CALayer *)hierarchyLayer
{
    _hierarchyLayer = hierarchyLayer;
    
    for (UIView *view in self.titledAttributedViews)
    {
        [view removeFromSuperview];
    }
    
    NSDictionary *dateToAnimationDetailsDictionary = [hierarchyLayer dateToAnimationDetailsStringDictionary];
    NSMutableArray *titledAttributedLabelViewsMutable = [[NSMutableArray alloc] init];
    for (NSDate *date in [[dateToAnimationDetailsDictionary allKeys] sortedArrayUsingSelector:@selector(compare:)])
    {
        JJTitledAttributedLabelView *titleAttributedLabelView = [[JJTitledAttributedLabelView alloc] init];
        titleAttributedLabelView.titleLabel.text = [self.dateFormatter stringFromDate:date];
        titleAttributedLabelView.attributedLabel.attributedText = [dateToAnimationDetailsDictionary[date] attributedStringHighlightingNameColon];
        [titledAttributedLabelViewsMutable addObject:titleAttributedLabelView];
        [self.scrollView addSubview:titleAttributedLabelView];
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
