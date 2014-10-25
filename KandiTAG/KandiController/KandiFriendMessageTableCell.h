//
//  KandiFriendMessageTableCell.h
//  KandiTAG
//
//  Created by James Nguyen on 10/22/14.
//  Copyright (c) 2014 Jim. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KandiFriendMessageTableCell : UITableViewCell
@property (strong, nonatomic) UIImageView* profileIcon;
@property (strong, nonatomic) UILabel* label;
@property (strong, nonatomic) UIButton* addFriendButton;
@property (strong, nonatomic) UIButton* sendMessageButton;
@end
