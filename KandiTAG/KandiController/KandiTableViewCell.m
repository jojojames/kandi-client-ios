//
//  KandiTableViewCell.m
//  KandiTAG
//
//  Created by James Nguyen on 10/22/14.
//  Copyright (c) 2014 Jim. All rights reserved.
//

#import "KandiTableViewCell.h"

@implementation KandiTableViewCell
@synthesize profileIcon;
@synthesize hasImage;

#define PROFILE_ICON_SIZE 60

-(instancetype)init {
    self = [super init];
    if (self) {
        self.profileIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, PROFILE_ICON_SIZE, PROFILE_ICON_SIZE)];
        self.profileIcon.backgroundColor = [UIColor orangeColor];
        [self.contentView addSubview:self.profileIcon];
        hasImage = NO;
    }
    return self;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.profileIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, PROFILE_ICON_SIZE, PROFILE_ICON_SIZE)];
        self.profileIcon.backgroundColor = [UIColor orangeColor];
        [self.contentView addSubview:self.profileIcon];
    }

    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    CGRect frame = self.contentView.frame;
    self.profileIcon.frame = CGRectMake(10, frame.size.height / 2 - self.profileIcon.frame.size.height / 2, self.profileIcon.frame.size.width, self.profileIcon.frame.size.height);
    self.textLabel.frame = CGRectMake(self.profileIcon.frame.origin.x + self.profileIcon.frame.size.width + 20, self.textLabel.frame.origin.y, self.textLabel.frame.size.width, self.textLabel.frame.size.height);
    [self.profileIcon layer].cornerRadius = 5.0f;
    [self.profileIcon layer].masksToBounds = YES;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

-(void)setImageUsingFacebookId:(NSString*)c_facebookId {
    if (!hasImage) {
        hasImage = YES;
        NSURL *profilePictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large", c_facebookId]];
        NSData *picData = [NSData dataWithContentsOfURL:profilePictureURL];
        self.profileIcon.image = [UIImage imageWithData:picData];
    }
}

@end
