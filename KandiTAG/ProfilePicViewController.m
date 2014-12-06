//
//  ProfilePicViewController.m
//  KandiTAG
//
//  Created by Jim Chen on 12/5/14.
//  Copyright (c) 2014 Jim. All rights reserved.
//

#import "ProfilePicViewController.h"
#import "AppDelegate.h"

@interface ProfilePicViewController ()

@end

@implementation ProfilePicViewController

@synthesize hasImage;

#define PROFILE_ICON_SIZE 145

-(instancetype)initWithFacebookId:(NSString *)facebookidforpic {
    self = [super init];
    if (self) {
        self.facebookidforpic = facebookidforpic;
        self.view.backgroundColor = [UIColor clearColor];
        self.profileIcon = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 3.8, 2, PROFILE_ICON_SIZE, PROFILE_ICON_SIZE)];
        NSString *userfbid = [AppDelegate KandiAppDelegate].facebookId;
        if ([userfbid isEqualToString:self.facebookidforpic]) {
            self.profileIcon.layer.borderColor = [UIColor yellowColor].CGColor;
        } else {
            self.profileIcon.layer.borderColor = [UIColor greenColor].CGColor;
        }
        self.profileIcon.backgroundColor = [UIColor whiteColor];
        self.profileIcon.clipsToBounds = YES;
        self.profileIcon.layer.borderWidth = 5.0f;
        self.profileIcon.layer.cornerRadius = self.profileIcon.frame.size.width / 2;
        //hasImage = NO;
        NSURL *profilePictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?width=150&height=150", facebookidforpic]];
        NSData *picData = [NSData dataWithContentsOfURL:profilePictureURL];
        self.profileIcon.image = [UIImage imageWithData:picData];
        [self setImageUsingFacebookId:self.facebookidforpic];
        [self.view addSubview:self.profileIcon];
    }
    return self;
}

-(void)setImageUsingFacebookId:(NSString*)facebookidforpic {
    if (!hasImage) {
        hasImage = YES;
        NSURL *profilePictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?width=150&height=150", facebookidforpic]];
        NSData *picData = [NSData dataWithContentsOfURL:profilePictureURL];
        self.profileIcon.image = [UIImage imageWithData:picData];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
