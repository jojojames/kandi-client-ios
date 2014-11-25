//
//  MessageTableViewCell.h
//  KandiTAG
//
//  Created by Jim Chen on 11/24/14.
//  Copyright (c) 2014 Jim. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageTableViewCell : UITableViewCell
@property (strong, nonatomic) UIImageView* profileIcon;
-(void)setImageUsingFacebookId:(NSString*)c_facebookId;
@property (nonatomic) BOOL hasImage;

@property (nonatomic, strong) UITextField *messageTextField;

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIButton *expandButton;

@property (nonatomic, assign, getter=isLoading) BOOL loading;



@end
