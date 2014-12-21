//
//  DetailCollectionViewCell.h
//  KandiTAG
//
//  Created by Jim Chen on 12/13/14.
//  Copyright (c) 2014 Jim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "Constants.h"

@interface DetailCollectionViewCell : UICollectionViewCell <FBGraphUser, NSURLConnectionDataDelegate>

@property (nonatomic, strong) UIImageView *profileImage;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIView *background;

-(instancetype)init;

@end
