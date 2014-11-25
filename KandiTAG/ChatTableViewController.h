//
//  ChatTableViewController.h
//  KandiTAG
//
//  Created by Jim Chen on 10/30/14.
//  Copyright (c) 2014 Jim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageSendDelegate.h"

@interface ChatTableViewController : UIViewController <NSURLConnectionDataDelegate, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>


-(instancetype)initWithFacebookId:(NSString*)_facebookId andUserName:(NSString *)_userName;

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSString* facebookId;
@property (strong, nonatomic) NSString* userId;
@property (strong, nonatomic) UIImageView* profileIcon;
@property (strong, nonatomic) UIButton* facebookSend;
@property (strong, nonatomic) UIButton* facebookAdd;

@property (strong, nonatomic) MessageSendDelegate *messageSendDelegate;
@property (strong, nonatomic) NSMutableDictionary *sentMessages;

@property (strong, nonatomic) NSMutableData* responseData;
@property (nonatomic) BOOL loadedDataSource;

@property (strong, nonatomic) NSMutableArray* messages;
@property (strong, nonatomic) NSDictionary *json;

@property (strong, nonatomic) NSMutableArray *list;

@property (strong, nonatomic) NSString* userName;


@end
