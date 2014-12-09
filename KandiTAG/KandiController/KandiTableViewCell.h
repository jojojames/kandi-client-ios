//
//  KandiTableViewCell.h
//  KandiTAG
//
//  Created by James Nguyen on 10/22/14.
//  Copyright (c) 2014 Jim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SLExpandableTableView.h>
#import "Constants.h"

@interface KandiTableViewCell : UITableViewCell

@property (strong, nonatomic) UIImageView* profileIcon;
-(void)setImageUsingFacebookId:(NSString*)c_facebookId;
@property (nonatomic) BOOL hasImage;


@end
