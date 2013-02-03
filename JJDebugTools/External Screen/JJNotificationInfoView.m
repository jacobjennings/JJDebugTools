//
//  JJNotificationInfoView.m
//  JJDebugTools
//
//  Created by Jacob Jennings on 1/30/13.
//  Copyright (c) 2013 Jacob Jennings. All rights reserved.
//

#import "JJNotificationInfoView.h"
#import "UIView+JJHotkeyViewTraverser.h"
#import "NSObject+JJPropertyInspection.h"
#import "JJButton.h"
#import "JJLabel.h"

static UIEdgeInsets const kNotificationViewInsets = (UIEdgeInsets) { .top = 3, .left = 6, .bottom = 3, .right = 6 };

@interface JJNotificationInfoView ()

@property (nonatomic, strong) JJButton *backgroundButton;
@property (nonatomic, strong) JJLabel *titleLabel;
@property (nonatomic, strong) UITextView *notificationInfoTextView;
@property (nonatomic, strong) NSMutableArray *notificationNames;
@property (nonatomic, strong) NSTimer *updateLabelTimer;
@property (nonatomic, assign) NSUInteger numberOfRowsThatFit;

@end

@implementation JJNotificationInfoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notification:) name:nil object:nil];
        
        _backgroundButton = [[JJButton alloc] init];
        [self addSubview:_backgroundButton];
        
        _titleLabel = [[JJLabel alloc] init];
        _titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18];
        _titleLabel.text = @"Notifications";
        [self addSubview:_titleLabel];
        
        _notificationInfoTextView = [[UITextView alloc] init];
        _notificationInfoTextView.textColor = [UIColor whiteColor];
        _notificationInfoTextView.backgroundColor = [UIColor clearColor];
        _notificationInfoTextView.font = [UIFont fontWithName:@"HelveticaNeue" size:11];
        [self addSubview:_notificationInfoTextView];
        
        _notificationNames = [[NSMutableArray alloc] initWithCapacity:1000];
        
        _updateLabelTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(update) userInfo:nil repeats:YES];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.backgroundButton.frame = self.bounds;
    
    CGSize titleLabelSize = [self.titleLabel sizeThatFits:self.bounds.size];
    self.titleLabel.frame = (CGRect) {
        .origin = CGPointMake(kNotificationViewInsets.left, kNotificationViewInsets.top),
        .size = titleLabelSize
    };
    [self.titleLabel centerVertically];
    
    CGSize notificationInfoLabelSize = [self.notificationInfoTextView sizeThatFits:self.bounds.size];
    CGRect notificationInfoLabelFrame = CGRectCenter(notificationInfoLabelSize, self.bounds);
    notificationInfoLabelFrame.origin.y = CGRectGetMaxY(self.titleLabel.frame);
    self.notificationInfoTextView.frame = notificationInfoLabelFrame;
    self.numberOfRowsThatFit = floor((self.bounds.size.height - kNotificationViewInsets.top - kNotificationViewInsets.bottom - self.titleLabel.frame.size.height - 10) /
                                     self.notificationInfoTextView.font.lineHeight);
    [self pruneSavedNotificationNames];
}

- (void)notification:(NSNotification *)notification
{
    if ([notification.name hasPrefix:@"WebView"] || [notification.name hasPrefix:@"WAK"] || [notification.name hasPrefix:@"JJPrivate"])
    {
        return;
    }
    @synchronized(self)
    {
        [self.notificationNames addObject:[NSString stringWithFormat:@"%@\n", notification.name]];
    }
    [self pruneSavedNotificationNames];
}

- (void)pruneSavedNotificationNames
{
    @synchronized(self)
    {
        if ([self.notificationNames count] > self.numberOfRowsThatFit)
        {
            [self.notificationNames removeObjectsInRange:NSMakeRange(0, [self.notificationNames count] - self.numberOfRowsThatFit)];
        }
    }
}

- (void)update
{
    NSMutableString *stringMut = [[NSMutableString alloc] init];
    @synchronized(self)
    {
        for (NSString *string in self.notificationNames)
        {
            [stringMut appendString:string];
        }
    }
    self.notificationInfoTextView.text = [stringMut copy];
    [self setNeedsLayout];
}

@end
