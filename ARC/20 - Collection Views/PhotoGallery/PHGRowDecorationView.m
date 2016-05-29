//
//  PHGRowDecorationView.m
//  PhotoGallery
//
//  Created by Joe Keeley on 7/5/13.
//  Copyright (c) 2013 ICF. All rights reserved.
//

#import "PHGRowDecorationView.h"
#import <QuartzCore/QuartzCore.h>

const NSString *kPHGRowDecorationViewKind = @"PHGRowDecorationView";

@implementation PHGRowDecorationView

#pragma mark - ⊂((・猿・))⊃ Lifecycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
    }
    return self;
}

#pragma mark - ⊂((・猿・))⊃ Override

- (void)drawRect:(CGRect)rect {
    //// General Declarations
    CGContextRef context = UIGraphicsGetCurrentContext();

    //// Color Declarations
    UIColor *strokeColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
    UIColor *fillColor2 = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1];

    //// Shadow Declarations
    UIColor *shadow = strokeColor;
    CGSize shadowOffset = CGSizeMake(0.1, 3.1);
    CGFloat shadowBlurRadius = 5;

    //// Frames
    CGRect frame = CGRectMake(0, 0, 320, 25);


    //// Bezier Drawing
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:CGPointMake(CGRectGetMinX(frame) + 3.5, CGRectGetMinY(frame) + 16.5)];
    [bezierPath addLineToPoint:CGPointMake(CGRectGetMinX(frame) + 13.8, CGRectGetMinY(frame) + 8.5)];
    [bezierPath addLineToPoint:CGPointMake(CGRectGetMinX(frame) + 303.73, CGRectGetMinY(frame) + 8.5)];
    [bezierPath addLineToPoint:CGPointMake(CGRectGetMinX(frame) + 315.5, CGRectGetMinY(frame) + 16.5)];
    [bezierPath addLineToPoint:CGPointMake(CGRectGetMinX(frame) + 3.5, CGRectGetMinY(frame) + 16.5)];
    [bezierPath closePath];
    CGContextSaveGState(context);
    CGContextSetShadowWithColor(context, shadowOffset, shadowBlurRadius, shadow.CGColor);
    [fillColor2 setFill];
    [bezierPath fill];
    CGContextRestoreGState(context);

    [fillColor2 setStroke];
    bezierPath.lineWidth = 1;
    [bezierPath stroke];


}

#pragma mark - ⊂((・猿・))⊃ Set_Get

+ (NSString *)kind {
    return (NSString *) kPHGRowDecorationViewKind;
}

@end
