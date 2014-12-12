//
//  Focus.m
//  KandiTAG
//
//  Created by Jim Chen on 12/12/14.
//  Copyright (c) 2014 Jim. All rights reserved.
//

#import "Focus.h"
#import <QuartzCore/QuartzCore.h>

@implementation Focus

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        [self setBackgroundColor:[UIColor clearColor]];
        [self.layer setBorderWidth:2.0];
        [self.layer setCornerRadius:4.0];
        [self.layer setBorderColor:[UIColor whiteColor].CGColor];
        
        CABasicAnimation* selectionAnimation = [CABasicAnimation
                                                animationWithKeyPath:@"borderColor"];
        selectionAnimation.toValue = (id)[UIColor colorWithRed:0.0f/255.0 green:255.0f/255.0 blue:255.0f/255.0 alpha:0.97f].CGColor;
        selectionAnimation.repeatCount = 8;
        [self.layer addAnimation:selectionAnimation
                          forKey:@"selectionAnimation"];
        
    }
    return self;
}

@end
