//
//  DetailViewController.h
//  KandiTAG
//
//  Created by Jim Chen on 12/13/14.
//  Copyright (c) 2014 Jim. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (nonatomic, strong) NSString* fbid;
@property (nonatomic, strong) NSString* user_name;
@property (nonatomic) NSInteger placement;

-(instancetype)initWithFacebookId:(NSString*)facebookid name:(NSString*)name placement:(NSInteger)place;

@end
