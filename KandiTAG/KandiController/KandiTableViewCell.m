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


#define PROFILE_ICON_SIZE 55


-(instancetype)init {
    self = [super init];
    if (self) {
        self.profileIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, PROFILE_ICON_SIZE, PROFILE_ICON_SIZE)];
        self.profileIcon.backgroundColor = [UIColor yellowColor];
        [self.contentView addSubview:self.profileIcon];
        hasImage = NO;
    }
    return self;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.profileIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, PROFILE_ICON_SIZE, PROFILE_ICON_SIZE)];
        UIImageView *defaultPic = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 45, 45)];
        defaultPic.image = [UIImage imageNamed:@"OfficialKTLogo"];
        self.profileIcon.backgroundColor = [UIColor colorWithRed:255.0f/255.0 green:255.0f/255.0 blue:100.0f/255.0 alpha:0.6f];
        self.profileIcon.image = defaultPic.image;
        [self.contentView addSubview:self.profileIcon];
    }

    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    CGRect frame = self.contentView.frame;
    self.profileIcon.frame = CGRectMake(10, frame.size.height / 2 - self.profileIcon.frame.size.height / 2, self.profileIcon.frame.size.width, self.profileIcon.frame.size.height);
    self.textLabel.frame = CGRectMake(self.profileIcon.frame.origin.x + self.profileIcon.frame.size.width + 10, self.textLabel.frame.origin.y, 235, self.textLabel.frame.size.height);
    //self.textLabel.frame = CGRectMake(self.profileIcon.frame.origin.x + self.profileIcon.frame.size.width + 10, 10, 230, 35);
    //self.textLabel.backgroundColor = [UIColor yellowColor];
    //self.detailTextLabel.frame = CGRectMake(self.profileIcon.frame.origin.x + self.profileIcon.frame.size.width + 10, 36, 230, 35);
    //self.detailTextLabel.backgroundColor = [UIColor redColor];
    //self.detailTextLabel.frame = CGRectMake(self.profileIcon.frame.origin.x + self.profileIcon.frame.size.width + 20, self.detailTextLabel.frame.origin.y, self.detailTextLabel.frame.size.width, self.detailTextLabel.frame.size.height);
    self.textLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:16];
    self.detailTextLabel.font = [UIFont fontWithName:@"Verdana" size:18];
    self.profileIcon.layer.cornerRadius = self.profileIcon.frame.size.width / 2;
   // [self.profileIcon layer].cornerRadius = 13.5f;
    self.profileIcon.layer.borderWidth = 1.5f;
    self.profileIcon.layer.borderColor = [UIColor whiteColor].CGColor;
    [self.profileIcon layer].masksToBounds = YES;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    [self setClipsToBounds:animated];
    // Configure the view for the selected state
}

-(void)setImageUsingFacebookId:(NSString*)c_facebookId {
    if (!hasImage) {
        hasImage = YES;
        NSURL *profilePictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?width=150&height=150", c_facebookId]];
        NSData *picData = [NSData dataWithContentsOfURL:profilePictureURL];
        self.profileIcon.image = [UIImage imageWithData:picData];
    }
}


@end
