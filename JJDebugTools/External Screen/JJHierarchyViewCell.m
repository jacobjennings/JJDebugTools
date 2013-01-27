//
//  JJHierarchyViewCell.m
//  JJDebugTools
//
//  Created by Jacob Jennings on 1/26/13.
//  Copyright (c) 2013 Jacob Jennings. All rights reserved.
//

#import "JJHierarchyViewCell.h"

@interface JJHierarchyViewCell ()

@property (nonatomic, strong) UILabel *classNameLabel;

@end

@implementation JJHierarchyViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _classNameLabel = [[UILabel alloc] init];
        _classNameLabel.backgroundColor = [UIColor clearColor];
        _classNameLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_classNameLabel];
        
        self.backgroundColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:0.2];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
//    CGSize classNameLabelSizeThatFits = [self.classNameLabel sizeThatFits:self.bounds.size];
    self.classNameLabel.frame = self.bounds;
}

- (CGSize)sizeThatFits:(CGSize)size
{
    return [self.classNameLabel sizeThatFits:size];
}

- (void)setHierarchyView:(UIView *)hierarchyView
{
    _hierarchyView = hierarchyView;
    
    self.classNameLabel.text = NSStringFromClass([hierarchyView class]);
}

@end
