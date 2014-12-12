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

#define PROFILE_ICON_SIZE 60

-(instancetype)init {
    self = [super init];
    if (self) {
        
        self.transitioningDelegate = self;
        self.modalPresentationStyle = UIModalPresentationCustom;
        
        //self.profileIcon1 = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 12, self.view.frame.size.height - 120, PROFILE_ICON_SIZE, PROFILE_ICON_SIZE)];
        self.profileIcon1 = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width /2.45, self.view.frame.size.height /4, PROFILE_ICON_SIZE, PROFILE_ICON_SIZE)];
        self.profileIcon1.layer.borderColor = [UIColor whiteColor].CGColor;
        self.profileIcon1.clipsToBounds = YES;
        self.profileIcon1.layer.cornerRadius = self.profileIcon1.frame.size.width/2;
        self.profileIcon1.layer.borderWidth = 3.0f;
        //[self.view addSubview:self.profileIcon1];
        
        //self.profileIcon2 = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 3.9, self.view.frame.size.height - 120, PROFILE_ICON_SIZE, PROFILE_ICON_SIZE)];
        self.profileIcon2 = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 1.5  , self.view.frame.size.height /2.9, PROFILE_ICON_SIZE, PROFILE_ICON_SIZE)];
        self.profileIcon2.layer.borderColor = [UIColor whiteColor].CGColor;
        self.profileIcon2.clipsToBounds = YES;
        self.profileIcon2.layer.cornerRadius = self.profileIcon2.frame.size.width/2;
        self.profileIcon2.layer.borderWidth = 3.0f;
        //[self.view addSubview:self.profileIcon2];
        
        //self.profileIcon3 = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2.35, self.view.frame.size.height - 120, PROFILE_ICON_SIZE, PROFILE_ICON_SIZE)];
        self.profileIcon3 = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 1.75, self.view.frame.size.height /2, PROFILE_ICON_SIZE, PROFILE_ICON_SIZE)];
        self.profileIcon3.layer.borderColor = [UIColor whiteColor].CGColor;
        self.profileIcon3.clipsToBounds = YES;
        self.profileIcon3.layer.cornerRadius = self.profileIcon3.frame.size.width/2;
        self.profileIcon3.layer.borderWidth = 3.0f;
        //[self.view addSubview:self.profileIcon3];
        
        //self.profileIcon4 = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 1.68, self.view.frame.size.height - 120, PROFILE_ICON_SIZE, PROFILE_ICON_SIZE)];
        self.profileIcon4 = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 4  , self.view.frame.size.height /2, PROFILE_ICON_SIZE, PROFILE_ICON_SIZE)];
        self.profileIcon4.layer.borderColor = [UIColor whiteColor].CGColor;
        self.profileIcon4.clipsToBounds = YES;
        self.profileIcon4.layer.cornerRadius = self.profileIcon4.frame.size.width/2;
        self.profileIcon4.layer.borderWidth = 3.0f;
        //[self.view addSubview:self.profileIcon4];
        
        //self.profileIcon5 = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 1.31, self.view.frame.size.height - 120, PROFILE_ICON_SIZE, PROFILE_ICON_SIZE)];
        self.profileIcon5 = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 6.5 , self.view.frame.size.height /2.9, PROFILE_ICON_SIZE, PROFILE_ICON_SIZE)];
        self.profileIcon5.layer.borderColor = [UIColor whiteColor].CGColor;
        self.profileIcon5.clipsToBounds = YES;
        self.profileIcon5.layer.cornerRadius = self.profileIcon5.frame.size.width/2;
        self.profileIcon5.layer.borderWidth = 3.0f;
        //[self.view addSubview:self.profileIcon5];
        
        NSTimer *one = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(addProfileIcon1PicWithTimer) userInfo:nil repeats:NO];
        NSTimer *two = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(addProfileIcon2PicWithTimer) userInfo:nil repeats:NO];
        NSTimer *three = [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(addProfileIcon3PicWithTimer) userInfo:nil repeats:NO];
        NSTimer *four = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(addProfileIcon4PicWithTimer) userInfo:nil repeats:NO];
        NSTimer *five = [NSTimer scheduledTimerWithTimeInterval:2.5 target:self selector:@selector(addProfileIcon5PicWithTimer) userInfo:nil repeats:NO];
    }
    return self;
}

-(void)addProfileIcon1PicWithTimer {
    if (self.profileIcon1.image !=nil) {
    [self.view addSubview:self.profileIcon1];
    }
}
-(void)addProfileIcon2PicWithTimer {
    if (self.profileIcon2.image !=nil) {
    [self.view addSubview:self.profileIcon2];
     }
}
-(void)addProfileIcon3PicWithTimer {
    if (self.profileIcon3.image !=nil) {
    [self.view addSubview:self.profileIcon3];
     }
}
-(void)addProfileIcon4PicWithTimer {
    if (self.profileIcon4.image !=nil) {
    [self.view addSubview:self.profileIcon4];
     }
}
-(void)addProfileIcon5PicWithTimer {
    if (self.profileIcon5.image !=nil) {
    [self.view addSubview:self.profileIcon5];
     }
}

-(void)removePic {
    self.profileIcon1.image = nil;
    self.profileIcon2.image = nil;
    self.profileIcon3.image = nil;
    self.profileIcon4.image = nil;
    self.profileIcon5.image = nil;
    
}

-(void)setImageUsingFacebookIdfor1:(NSString *)facebookidforpic {
    if (!hasImage) {
        hasImage = YES;
        NSURL *profilePictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?width=150&height=150", facebookidforpic]];
        NSData *picData = [NSData dataWithContentsOfURL:profilePictureURL];
        //self.profileIcon.image = [UIImage imageNamed:@"plusone"];
        //self.profileIcon.image = [UIImage imageWithData:picData];
        self.profileIcon1.image = [UIImage imageWithData:picData];
    }
}

-(void)setImageUsingFacebookIdfor2:(NSString *)facebookidforpic {
   // if (!hasImage) {
        hasImage = YES;
        NSURL *profilePictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?width=150&height=150", facebookidforpic]];
        NSData *picData = [NSData dataWithContentsOfURL:profilePictureURL];
        //self.profileIcon.image = [UIImage imageNamed:@"plusone"];
        //self.profileIcon.image = [UIImage imageWithData:picData];
        self.profileIcon2.image = [UIImage imageWithData:picData];
   // }
}

-(void)setImageUsingFacebookIdfor3:(NSString *)facebookidforpic {
   // if (!hasImage) {
        hasImage = YES;
        NSURL *profilePictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?width=150&height=150", facebookidforpic]];
        NSData *picData = [NSData dataWithContentsOfURL:profilePictureURL];
        //self.profileIcon.image = [UIImage imageNamed:@"plusone"];
        //self.profileIcon.image = [UIImage imageWithData:picData];
        self.profileIcon3.image = [UIImage imageWithData:picData];
  //  }
}

-(void)setImageUsingFacebookIdfor4:(NSString *)facebookidforpic {
   // if (!hasImage) {
        hasImage = YES;
        NSURL *profilePictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?width=150&height=150", facebookidforpic]];
        NSData *picData = [NSData dataWithContentsOfURL:profilePictureURL];
        //self.profileIcon.image = [UIImage imageNamed:@"plusone"];
        //self.profileIcon.image = [UIImage imageWithData:picData];
        self.profileIcon4.image = [UIImage imageWithData:picData];
  //  }
}

-(void)setImageUsingFacebookIdfor5:(NSString *)facebookidforpic {
  //  if (!hasImage) {
        hasImage = YES;
        NSURL *profilePictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?width=150&height=150", facebookidforpic]];
        NSData *picData = [NSData dataWithContentsOfURL:profilePictureURL];
        //self.profileIcon.image = [UIImage imageNamed:@"plusone"];
        //self.profileIcon.image = [UIImage imageWithData:picData];
        self.profileIcon5.image = [UIImage imageWithData:picData];
  //  }
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
