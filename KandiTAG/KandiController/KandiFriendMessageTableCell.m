//
//  KandiFriendMessageTableCell.m
//  KandiTAG
//
//  Created by James Nguyen on 10/22/14.
//  Copyright (c) 2014 Jim. All rights reserved.
//

#import "KandiFriendMessageTableCell.h"

@implementation KandiFriendMessageTableCell
@synthesize profileIcon;
@synthesize addFriendButton;
@synthesize sendMessageButton;
@synthesize label;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.profileIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
        self.profileIcon.backgroundColor = [UIColor orangeColor];
        
        self.addFriendButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        self.sendMessageButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        self.addFriendButton.backgroundColor = [UIColor greenColor];
        self.sendMessageButton.backgroundColor = [UIColor redColor];
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
        self.label.backgroundColor = [UIColor grayColor];
        self.label.text = @"DSF";
        self.label.textColor = [UIColor blackColor];
        
        [self.contentView addSubview:self.addFriendButton];
        [self.contentView addSubview:self.sendMessageButton];
        [self.contentView addSubview:self.profileIcon];
        [self.contentView addSubview:self.label];
        self.contentView.backgroundColor = [UIColor purpleColor];
    }
    
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    CGRect frame = self.contentView.frame;
    self.profileIcon.frame = CGRectMake(10, frame.size.height / 2 - self.profileIcon.frame.size.height / 2, self.profileIcon.frame.size.width, self.profileIcon.frame.size.height);
    self.label.frame = CGRectMake(self.profileIcon.frame.origin.x + self.profileIcon.frame.size.width + 20, frame.size.height / 2 - self.label.frame.size.height / 2, self.label.frame.size.width, self.label.frame.size.height);
    
        self.label.frame = CGRectMake(self.profileIcon.frame.origin.x + self.profileIcon.frame.size.width + 10, 0, 150, 40);
    
    self.addFriendButton.frame = CGRectMake(frame.size.width - 10 - self.addFriendButton.frame.size.width, frame.size.height / 2 - self.addFriendButton.frame.size.height / 2, self.addFriendButton.frame.size.width, self.addFriendButton.frame.size.height);
    
    self.sendMessageButton.frame = CGRectMake(self.addFriendButton.frame.origin.x - 10 - self.sendMessageButton.frame.size.width, frame.size.height / 2 - self.sendMessageButton.frame.size.height / 2, self.sendMessageButton.frame.size.width, self.sendMessageButton.frame.size.height);
}

@end
