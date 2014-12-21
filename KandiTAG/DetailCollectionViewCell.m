//
//  DetailCollectionViewCell.m
//  KandiTAG
//
//  Created by Jim Chen on 12/13/14.
//  Copyright (c) 2014 Jim. All rights reserved.
//

#import "DetailCollectionViewCell.h"

@implementation DetailCollectionViewCell

@synthesize profileImage;
@synthesize nameLabel;
@synthesize background;

-(instancetype)init {
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, 150, 180);
        self.profileImage.frame = CGRectMake(10, 10, self.frame.size.width - 20, 150);
        self.profileImage.backgroundColor = [UIColor blackColor];
        self.nameLabel.frame = CGRectMake(0, self.frame.size.height - 30, self.frame.size.width, 30);
    }
    return self;
}

@end
