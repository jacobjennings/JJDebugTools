//
//  JJLabel.m
//  Rest Client
//
//  Created by Jacob Jennings on 5/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "JJLabel.h"

@implementation JJLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.font = [UIFont fontWithName:@"HelveticaNeue" size:15];
        self.textColor = [UIColor whiteColor];
        self.shadowOffset = CGSizeMake(0, 1);
        self.shadowColor = [UIColor colorWithWhite:0 alpha:1];
        self.numberOfLines = 0;
        self.lineBreakMode = NSLineBreakByWordWrapping;

    }
    return self;
}

@end
