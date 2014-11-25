//
//  KandiDetailTableViewCell.h
//  KandiTAG
//
//  Created by Jim Chen on 11/13/14.
//  Copyright (c) 2014 Jim. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KandiDetailTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIButton *expandButton;

@property (strong, nonatomic) UIImageView* profileIcon;
-(void)setImageUsingFacebookId:(NSString*)c_facebookId;
@property (nonatomic) BOOL hasImage;

@end

