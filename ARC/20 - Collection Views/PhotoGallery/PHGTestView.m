//
//  PHGTestView.m
//  PhotoGallery
//
//  Created by Joe Keeley on 7/21/13.
//  Copyright (c) 2013 ICF. All rights reserved.
//

#import "PHGTestView.h"

@implementation PHGTestView

#pragma mark - ⊂((・猿・))⊃ Override

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    //// General Declarations
    CGContextRef context = UIGraphicsGetCurrentContext();

    //// Color Declarations
    UIColor *strokeColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
    UIColor *fillColor2 = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1];

    //// Shadow Declarations
    UIColor *shadow = strokeColor;
    CGSize shadowOffset = CGSizeMake(0.1, 3.1);
    CGFloat shadowBlurRadius = 5;

    //// Bezier Drawing
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:CGPointMake(16.5, 36.5)];
    [bezierPath addLineToPoint:CGPointMake(23.5, 28.5)];
    [bezierPath addLineToPoint:CGPointMake(220.5, 28.5)];
    [bezierPath addLineToPoint:CGPointMake(228.5, 36.5)];
    [bezierPath addLineToPoint:CGPointMake(16.5, 36.5)];
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

@end
