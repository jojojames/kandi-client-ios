//
//  ChatTableViewController.m
//  KandiTAG
//
//  Created by Jim Chen on 10/30/14.
//  Copyright (c) 2014 Jim. All rights reserved.
//

#import "ChatTableViewController.h"
#import "AppDelegate.h"
#import "ChatTableViewCell.h"
#import "Constants.h"
#import "MessageTableViewCell.h"

@interface ChatTableViewController () {
    UILabel *messageLabel;
    UITextField *messageTextField;
    UIButton *send;
    NSMutableData *mutableData;
}

@end

@implementation ChatTableViewController

static inline UIViewAnimationOptions animationOptionsWithCurve(UIViewAnimationCurve curve)
{
    return (UIViewAnimationOptions)curve << 16;
}

@synthesize facebookId;
@synthesize messageSendDelegate;
@synthesize sentMessages;
@synthesize messages;
@synthesize loadedDataSource;
@synthesize responseData;
@synthesize json;
@synthesize list;
@synthesize tableView;
@synthesize userName;

#define ORIGINAL @"original"
#define CURRENT @"current"
#define QRCODE_ID @"qrcode_id"
#define USER_ID @"user_id"
#define PLACEMENT @"placement"
#define OWNERSHIP_ID @"ownership_id"
#define USER_NAME @"user_name"
#define FACEBOOK_ID @"facebookid"
#define MESSAGEHISTORY @"messagehistory"
#define MESSAGE_KT @"message"
#define SENDER @"sender"
#define RECIPIENT @"recipient"
#define TIMESTAMP @"timestamp"

-(instancetype)initWithFacebookId:(NSString*)_facebookId andUserName:(NSString *)_userName{
    self = [super init];
    if (self) {
        //self.profileIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 120, 120)];
        //[self.profileIcon layer].cornerRadius = 5.0f;
        //[self.profileIcon layer].masksToBounds = YES;
        
        self.facebookSend = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        self.facebookSend.frame = CGRectMake(0, 0, 130, 40);
        [self.facebookSend setTitle:@"Send Message" forState:UIControlStateNormal];

        self.facebookId = _facebookId;
        
        self.view.backgroundColor = [UIColor whiteColor];

        self.profileIcon.userInteractionEnabled = YES;
        
        self.navigationItem.title = _userName;
        
        userName = _userName;
        
        responseData = [[NSMutableData alloc] init];
        loadedDataSource = NO;
        messages = [[NSMutableArray alloc] init];

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 104) style:UITableViewStylePlain];
    
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerClass:[ChatTableViewCell class] forCellReuseIdentifier:@"ChatTableViewCell"];
    [tableView registerClass:[MessageTableViewCell class] forCellReuseIdentifier:@"MessageTableViewCell"];
    
    messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 40, self.view.frame.size.width, 40)];
    messageLabel.backgroundColor = [UIColor colorWithRed:224.0/255.0 green:224.0/255.0 blue:224.0/255.0 alpha:0.8];
    [self.view addSubview:messageLabel];
    
    send = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 65, self.view.frame.size.height - 32, 57, 25)];
    UIImage *buttonimage = [UIImage imageNamed:@"send"];
    [send setBackgroundImage:buttonimage forState:UIControlStateNormal];
    send.layer.cornerRadius = 5.0f;
    [send addTarget:self action:@selector(sendMSSG) forControlEvents:UIControlEventTouchUpInside];
    [send setBackgroundImage:[UIImage imageNamed:@"sent"] forState:UIControlStateHighlighted];
    [self.view addSubview:send];
    
    messageTextField = [[UITextField alloc] initWithFrame:CGRectMake(5, self.view.frame.size.height - 35, self.view.frame.size.width /1.32, 30)];
    messageTextField.layer.cornerRadius = 10.0f;
    messageTextField.backgroundColor = [UIColor whiteColor];
    messageTextField.placeholder = [NSString stringWithFormat:@" New Message"];
    [self.view addSubview:messageTextField];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 10)];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableHeaderView:view];
    [tableView setTableFooterView:view];
    
    UIGestureRecognizer *hideKeyboard = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardWillBeHidden:)];
    [tableView addGestureRecognizer:hideKeyboard];
    [self.view addGestureRecognizer:hideKeyboard];
    
    [tableView setContentOffset:CGPointMake(0, CGFLOAT_MAX)];
    
    [self.view addSubview:tableView];

}

-(void)registerForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardDidHideNotification object:nil];
}

-(void)deregisterFromKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self registerForKeyboardNotifications];
}

-(void)viewDidDisappear:(BOOL)animated {
    [self deregisterFromKeyboardNotifications];
    [super viewDidDisappear:animated];
}

-(void)sendMSSG {
    NSDate *currentTime = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY MM dd, hh-mm-ss"];
    NSString *timeString = [dateFormatter stringFromDate:currentTime];
    NSLog(@"timeString: %@", timeString);
    NSString *message = [NSString new];
    message = messageTextField.text;
    if (![sentMessages objectForKey:message]) {
    [[AppDelegate KandiAppDelegate].network sendMessage:messageSendDelegate withMessage:message andRecipient:self.facebookId andTime:timeString];
    [[AppDelegate KandiAppDelegate].network saveConvo:messageSendDelegate withMessage:message andRecipient:self.facebookId andName:userName];
        [[AppDelegate KandiAppDelegate].network getMessageExchange:self withRecipient:self.facebookId];
    }
    messageTextField.text = nil;
    [tableView reloadData];
    
}

-(void)keyboardWillShow:(NSNotification*)notification {
    [self moveControls:notification up:YES];
}

-(void)keyboardWillBeHidden:(NSNotification*)notification {
    [self moveControls:notification up:NO];
}

-(void)moveControls:(NSNotification*)notification up:(BOOL)up {
    NSDictionary *userInfo = [notification userInfo];
    CGRect newFrame = [self getNewControlsFrame:userInfo up:up];
    
    [self animateControls:userInfo withFrame:newFrame];
}

-(CGRect)getNewControlsFrame:(NSDictionary*)userInfo up:(BOOL)up {
    CGRect kbFrame = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    kbFrame = [self.view convertRect:kbFrame fromView:nil];
    
    CGRect newFrame = self.view.frame;
    newFrame.origin.y += kbFrame.size.height * (up ? -1 : 1);
    
    return newFrame;
}

-(void)animateControls:(NSDictionary*)userInfo withFrame:(CGRect)newFrame {
    NSTimeInterval duration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve animationCurve = [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    [UIView animateWithDuration:duration delay:0 options:animationOptionsWithCurve(animationCurve) animations:^{self.view.frame = newFrame;} completion:^(BOOL finished){}];
}

- (void)viewWillAppear:(BOOL)animated
{
    [[AppDelegate KandiAppDelegate].network getMessageExchange:self withRecipient:self.facebookId];
    
    [self.view addGestureRecognizer:
     [[UITapGestureRecognizer alloc] initWithTarget:self
                                             action:@selector(hideKeyboard:)]];

}

- (IBAction)hideKeyboard:(id)sender {
    [self.view endEditing:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CHAT_ROW_HEIGHT;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (loadedDataSource)
        return [messages count];
    else
        return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    json = [messages objectAtIndex:indexPath.row];
    NSDictionary* original = [json objectForKey:ORIGINAL];
    NSDictionary* current = [json objectForKey:CURRENT];
    NSDictionary* messagehistory = [json objectForKey:MESSAGEHISTORY];
    
    NSString* o_qrcodeId = [original objectForKey:QRCODE_ID];
    NSString* o_userId = [original objectForKey:USER_ID];
    NSString* o_placement = [original objectForKey:PLACEMENT];
    NSString* o_ownershipId = [original objectForKey:OWNERSHIP_ID];
    
    NSString* c_userId = [current objectForKey:USER_ID];
    NSString* c_userName = [current objectForKey:USER_NAME];
    NSString* c_facebookId = [current objectForKey:FACEBOOK_ID];
    
    NSString* mh_message = [messagehistory objectForKey:MESSAGE_KT];
    NSString* mh_sender = [messagehistory objectForKey:SENDER];
    NSString* mh_recipient = [messagehistory objectForKey:RECIPIENT];
    NSString* mh_timestamp = [messagehistory objectForKey:TIMESTAMP];
    
    NSString *cellIdentifier = @"ChatTableViewCell";
    NSString *otherCellId = @"MessageTableViewCell";
    
    ChatTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"ChatTableViewCell" forIndexPath:indexPath];
    //MessageTableViewCell *otherCell = [self.tableView dequeueReusableCellWithIdentifier:@"MessageTableViewCell" forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[ChatTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        //otherCell = [[MessageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:otherCellId];
    }
    
    NSString *facebookID = [AppDelegate KandiAppDelegate].facebookId;
    
    //if (mh_sender == facebookID) {
    
    cell.textLabel.text = mh_message;
        
    //}
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark NSURLConnectionDataDelegate
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [responseData setLength:0];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [responseData appendData:data];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    //if we get any connection error manage it here
    //for example use alert view to say no internet connection
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSError* error;
    
    // response data for the kandi REST calls always comes back as an array
    NSDictionary* jsonResponse = [NSJSONSerialization
                                  JSONObjectWithData:responseData
                                  options:kNilOptions
                                  error:&error];
    
    if ([jsonResponse objectForKey:@"success"]) {
        NSNumber* success = [jsonResponse objectForKey:@"success"];
        if ([success boolValue]) {
            NSMutableArray* jsonArray = [jsonResponse objectForKey:@"results"];
            messages = jsonArray;
            NSLog(@"messages: %@", messages);
            for (int i=0; i<[jsonArray count]; i++) {
                json = [jsonArray objectAtIndex:i];
                loadedDataSource = YES;
                if ([json count]) {
                    // we'll consider it a success if there's any json
                    NSDictionary* original = [json objectForKey:ORIGINAL];
                    NSDictionary* current = [json objectForKey:CURRENT];
                    NSDictionary* messagehistory = [json objectForKey:MESSAGEHISTORY];
                    
                    NSString* o_qrcodeId = [original objectForKey:QRCODE_ID];
                    NSString* o_userId = [original objectForKey:USER_ID];
                    NSString* o_placement = [original objectForKey:PLACEMENT];
                    NSString* o_ownershipId = [original objectForKey:OWNERSHIP_ID];
                    
                    NSString* c_userId = [current objectForKey:USER_ID];
                    NSString* c_userName = [current objectForKey:USER_NAME];
                    NSString* c_facebookId = [current objectForKey:FACEBOOK_ID];
                    
                    NSString* mh_message = [messagehistory objectForKey:MESSAGE_KT];
                    NSString* mh_sender = [messagehistory objectForKey:SENDER];
                    NSString* mh_recipient = [messagehistory objectForKey:RECIPIENT];
                    NSString* mh_timestamp = [messagehistory objectForKey:TIMESTAMP];

                }
            }
            
            if (loadedDataSource)
                [self.tableView reloadData];
        } else {
            // NSString* error = [jsonResponse objectForKey:@"error"];
            //NSLog(@"%@", error);
        }
    }
    
    
    //[self.refreshControl endRefreshing];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
