//
//  QRBox.m
//  KandiTAG
//
//  Created by Jim Chen on 9/8/14.
//  Copyright (c) 2014 Jim. All rights reserved.
//

#import "QRBox.h"

@interface QRBox () {
    CAShapeLayer *_outline;
}
@end

@implementation QRBox

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _outline = [CAShapeLayer new];
        _outline.strokeColor = [[[UIColor colorWithRed:0.0f/255.0 green:255.0f/255.0 blue:255.0f/255.0 alpha:0.97f] colorWithAlphaComponent:0.8] CGColor];
        _outline.lineWidth = 3.0;
        _outline.fillColor = [[UIColor clearColor] CGColor];
        [self.layer addSublayer:_outline];
        
    }
    return self;
}


- (void)setCorners:(NSArray *)corners
{
    if(corners != _corners) {
        _corners = corners;
        _outline.path = [[self createPathFromPoints:corners] CGPath];
    }
}

- (UIBezierPath *)createPathFromPoints:(NSArray *)points
{
    UIBezierPath *path = [UIBezierPath new];
    // Start at the first corner
    [path moveToPoint:[[points firstObject] CGPointValue]];
    
    // Now draw lines around the corners
    for (NSUInteger i = 1; i < [points count]; i++) {
        [path addLineToPoint:[points[i] CGPointValue]];
    }
    
    // And join it back to the first corner
    [path addLineToPoint:[[points firstObject] CGPointValue]];
    
    return path;
}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
