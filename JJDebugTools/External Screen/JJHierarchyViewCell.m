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
#import "JJButton.h"
#import "JJLabel.h"

static UIEdgeInsets const kCellInsets = (UIEdgeInsets) { .top = 3, .left = 6, .bottom = 3, .right = 6 };

#define CellFont [UIFont fontWithName:@"HelveticaNeue" size:15]

@interface JJHierarchyViewCell ()

@property (nonatomic, strong) JJLabel *classNameLabel;
@property (nonatomic, strong) JJLabel *propertyNameLabel;
@property (nonatomic, strong) JJButton *buttonBackground;

@end

@implementation JJHierarchyViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _buttonBackground = [[JJButton alloc] init];
        [self addSubview:_buttonBackground];
        
        _classNameLabel = [[JJLabel alloc] init];
        _classNameLabel.textAlignment = NSTextAlignmentCenter;
        _classNameLabel.font = CellFont;
        [self addSubview:_classNameLabel];
        
        _propertyNameLabel = [[JJLabel alloc] init];
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
    
    self.buttonBackground.frame = self.bounds;
    
    CGSize classNameLabelSizeThatFits = [self.classNameLabel sizeThatFits:self.bounds.size];
    classNameLabelSizeThatFits = CGSizeMake(MIN(self.bounds.size.width, classNameLabelSizeThatFits.width),
                                            classNameLabelSizeThatFits.height);
    self.classNameLabel.frame = (CGRect) {
        .origin = CGPointMake(round(self.bounds.size.width / 2 - classNameLabelSizeThatFits.width / 2),
                              round(self.bounds.size.height / 2 - classNameLabelSizeThatFits.height)),
        .size = classNameLabelSizeThatFits };
    
    CGSize propertyNameLabelSizeThatFits = [self.propertyNameLabel sizeThatFits:self.bounds.size];
    propertyNameLabelSizeThatFits = CGSizeMake(MIN(propertyNameLabelSizeThatFits.width, self.bounds.size.width),
                                               propertyNameLabelSizeThatFits.height);
    self.propertyNameLabel.frame = (CGRect) {
        .origin = CGPointMake(round(self.bounds.size.width / 2 - propertyNameLabelSizeThatFits.width / 2),
                              round(self.bounds.size.height / 2)),
        .size = propertyNameLabelSizeThatFits };
}

- (CGSize)sizeThatFits:(CGSize)size
{
    CGSize classNameLabelSizeThatFits = [self.classNameLabel sizeThatFits:size];
    CGSize propertyNameLabelSizeThatFits = [self.propertyNameLabel sizeThatFits:size];
    NSLog(@"%@ %@", NSStringFromCGSize(classNameLabelSizeThatFits), NSStringFromCGSize(propertyNameLabelSizeThatFits));
    return CGSizeMake(MAX(classNameLabelSizeThatFits.width, propertyNameLabelSizeThatFits.width) + kCellInsets.left + kCellInsets.right,
                      classNameLabelSizeThatFits.height + propertyNameLabelSizeThatFits.height + kCellInsets.top + kCellInsets.bottom);
}

- (void)setHierarchyView:(UIView *)hierarchyView
{
    _hierarchyView = hierarchyView;
    
    self.classNameLabel.text = [NSString stringWithFormat:@"%@ %@",
                                NSStringFromClass([hierarchyView class]),
                                NSStringFromCGRect(hierarchyView.frame)];
    NSString *propertyNameString = [hierarchyView propertyOfSuperName];
    self.propertyNameLabel.text = propertyNameString;
}

@end
