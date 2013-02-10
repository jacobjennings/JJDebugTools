//
//  NSString+JJHighlightColon.m
//  JJDebugTools
//
//  Created by Jacob Jennings on 2/9/13.
//  Copyright (c) 2013 Jacob Jennings. All rights reserved.
//

#import "NSString+JJHighlightColon.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreText/CoreText.h>

@implementation NSString (JJHighlightColon)

- (NSAttributedString *)attributedStringHighlightingNameColon
{
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"(^|\n)[^[:\t ]]*:" options:0 error:&error];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self];
    NSRange searchRange = NSMakeRange(0, [self length]);
    [attributedString addAttribute:(NSString *)kCTForegroundColorAttributeName value:[UIColor whiteColor] range:searchRange];
    [regex enumerateMatchesInString:self options:0 range:searchRange usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        [attributedString addAttribute:(NSString *)kCTForegroundColorAttributeName value:[UIColor colorWithRed:0.9 green:0.8 blue:1 alpha:1] range:result.range];
    }];
    if (error)
    {
        NSLog(@"Error in attributedStringHighlightingNameColon %@", error);
    }
    return attributedString;
}

@end
