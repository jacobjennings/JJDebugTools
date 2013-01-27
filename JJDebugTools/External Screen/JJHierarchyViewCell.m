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

#define CellFont [UIFont fontWithName:@"HelveticaNeue" size:12]

@interface JJHierarchyViewCell ()

@property (nonatomic, strong) UILabel *classNameLabel;
@property (nonatomic, strong) UILabel *propertyNameLabel;

@end

@implementation JJHierarchyViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _classNameLabel = [[UILabel alloc] init];
        _classNameLabel.backgroundColor = [UIColor clearColor];
        _classNameLabel.textAlignment = NSTextAlignmentCenter;
        _classNameLabel.font = CellFont;
        [self addSubview:_classNameLabel];
        
        _propertyNameLabel = [[UILabel alloc] init];
        _propertyNameLabel.backgroundColor = [UIColor clearColor];
        _propertyNameLabel.textAlignment = NSTextAlignmentCenter;
        _propertyNameLabel.font = CellFont;
        [self addSubview:_propertyNameLabel];
        
        self.backgroundColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:0.2];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGSize classNameLabelSizeThatFits = [self.classNameLabel sizeThatFits:self.bounds.size];
    self.classNameLabel.frame = (CGRect) {
        .origin = CGPointZero,
        .size = CGSizeMake(MIN(self.bounds.size.width, classNameLabelSizeThatFits.width),
                           classNameLabelSizeThatFits.height) };
    
    CGSize propertyNameLabelSizeThatFits = [self.propertyNameLabel sizeThatFits:self.bounds.size];
    self.propertyNameLabel.frame = CGRectMake(0,
                                              CGRectGetMaxY(self.classNameLabel.frame),
                                              MIN(propertyNameLabelSizeThatFits.width, self.bounds.size.width),
                                              propertyNameLabelSizeThatFits.height);
    
}

- (CGSize)sizeThatFits:(CGSize)size
{
    return [self.classNameLabel sizeThatFits:size];
}

- (void)setHierarchyView:(UIView *)hierarchyView
{
    _hierarchyView = hierarchyView;
    
    self.classNameLabel.text = [NSString stringWithFormat:@"%@ %@",
                                NSStringFromClass([hierarchyView class]),
                                NSStringFromCGRect(hierarchyView.frame)];
    NSString *propertyNameString = [hierarchyView propertyOfSuperName];
    UIViewController *controller = [hierarchyView findAssociatedController];
    if (propertyNameString && controller)
    {
        self.propertyNameLabel.text = [NSString stringWithFormat:@"Property %@ on controller %@", propertyNameString, NSStringFromClass([controller class])];
    }
    else if (propertyNameString && hierarchyView.superview && ![hierarchyView.superview isMemberOfClass:[UIView class]])
    {
        self.propertyNameLabel.text = [NSString stringWithFormat:@"Property %@ on superview %@", propertyNameString, NSStringFromClass(hierarchyView.superview.class)];
    }
    else
    {
        self.propertyNameLabel.text = nil;
    }
}

@end
