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
#import "Sender.h"
#import "Message.h"

@interface ChatTableViewController () {
    UILabel *messageLabel;
    UITextView *messageTextField;
    UIButton *send;
    NSMutableData *mutableData;
    Sender *sender;
    Message *messageList;
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
@synthesize sender;
@synthesize messageslisted;

#define FONT_SIZE 14.0f
#define CELL_CONTENT_WIDTH 320.0f
#define CELL_CONTENT_MARGIN 10.0f
#define PROFILE_ICON_SIZE 30
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
        
        [[AppDelegate KandiAppDelegate].network getMessageExchange:self withRecipient:self.facebookId];
        
        self.view.backgroundColor = [UIColor whiteColor];

        self.profileIcon.userInteractionEnabled = YES;
        
        self.navigationItem.title = _userName;
        
        userName = _userName;
        
        responseData = [[NSMutableData alloc] init];
        loadedDataSource = NO;
        messages = [[NSMutableArray alloc] init];
        
        UIImageView *profileImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, PROFILE_ICON_SIZE, PROFILE_ICON_SIZE)];
        NSURL *profilePictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?width=150&height=150", self.facebookId]];
        NSData *picData = [NSData dataWithContentsOfURL:profilePictureURL];
        profileImage.image = [UIImage imageWithData:picData];
        profileImage.layer.cornerRadius = profileImage.frame.size.width / 2;
        profileImage.frame = CGRectMake(10, profileImage.frame.size.height / 2 - profileImage.frame.size.height / 2, profileImage.frame.size.width, profileImage.frame.size.height);
        profileImage.clipsToBounds = YES;
        profileImage.layer.borderWidth = 1.0f;
        profileImage.layer.borderColor = [UIColor whiteColor].CGColor;
        
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:profileImage];
        self.navigationItem.rightBarButtonItem = item;
        
        messageslisted = [[NSMutableArray alloc] init];
        
        NSString *myfbid = [AppDelegate KandiAppDelegate].facebookId;
        NSString *username = [AppDelegate KandiAppDelegate].userName;
        
        //[[AppDelegate KandiAppDelegate].network getMessageExchange:self withRecipient:self.facebookId];
        
        [SIOSocket socketWithHost:@"http://kandi.jit.su/" response:^(SIOSocket *socket) {
            self.socket = socket;
            
            self.socket.onConnect = ^ () {
                NSLog(@"connected");
                [self.socket emit:@"setChat" args:@[myfbid, username, self.facebookId, self.userName]];
            };
            
            self.socket.onDisconnect = ^() {
                NSLog(@"disconnected");
            };
            
            self.socket.onError = ^(NSDictionary* error) {
                NSLog(@"%@", error);
            };
            
            [self.socket on:@"chat message" callback:^(id data) {
                NSString *string = (NSString*)data;
                NSLog(@"chat message:%@", string);
            }];
            
            [self.socket on:@"setChat" callback:^(id data) {
                NSMutableArray *string = (NSMutableArray*)data;
                NSLog(@"setChat:%@", string[0]);
                [messageslisted addObject:string[0]];
                NSLog(@"mess: %u", messageslisted.count);
                [tableView reloadData];
                
                //NSString *tempString = [self extractString:string[0] toLookFor:@"\"mssg\":" skipForwardX:0 toStopBefore:@",\"fID\""];
                //NSLog(@"tempString: %@", tempString);
                
                //[messageslisted addObject:string];
                //NSCharacterSet *trimForMessage = [NSCharacterSet characterSetWithCharactersInString:@"{\"mssg\":\"Hello\",\"fID\":\"10204530185312006\",\"tID\":\"1378441539116513\",\"date\":1418896750993}"];
                //NSString *messageString = [string[0] stringByTrimmingCharactersInSet:trimForMessage];
                //NSLog(@"messageString: %@", messageString);
                
                //NSCharacterSet *trimForFID = [NSCharacterSet characterSetWithCharactersInString:@"{\"mssg\":\"Hello\",\"fID\":\"\",\"tID\":\"1378441539116513\",\"date\":1418896750993}"];
                //NSString *fIDString = [string[0] stringByTrimmingCharactersInSet:trimForFID];
                //NSLog(@"fIDString: %@", fIDString);
                
                //NSCharacterSet *trimFortID = [NSCharacterSet characterSetWithCharactersInString:@"{\"mssg\":\"Hello\",\"fID\":\"10204530185312006\",\"tID\":\"\",\"date\":1418896750993}"];
                //NSString *tIDString = [string[0] stringByTrimmingCharactersInSet:trimFortID];
                //NSLog(@"tIDString: %@", tIDString);
                
                
            }];
            
            [self.socket on:@"pm" callback:^(id data) {
                NSString *string = (NSString*)data;
                NSLog(@"pm:%@", string);
            }];
            
            
        }];

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"ChatTableViewController viewDidLoad");
    
    NSLog(@"messageslisted: %@", messageslisted);
    
    NSLog(@"mess: %@", messageslisted[0]);
    
    tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 104) style:UITableViewStylePlain];
    //tableView.backgroundColor = [UIColor yellowColor];
    
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerClass:[ChatTableViewCell class] forCellReuseIdentifier:@"ChatTableViewCell"];
    [tableView registerClass:[MessageTableViewCell class] forCellReuseIdentifier:@"MessageTableViewCell"];
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
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
    
    messageTextField = [[UITextView alloc] initWithFrame:CGRectMake(5, self.view.frame.size.height - 35, self.view.frame.size.width /1.32, 30)];
    messageTextField.layer.cornerRadius = 10.0f;
    messageTextField.backgroundColor = [UIColor whiteColor];
    //messageTextField.placeholder = [NSString stringWithFormat:@" New Message"];
    //messageTextField.delegate = self;
    [self.view addSubview:messageTextField];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 10)];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableHeaderView:view];
    [tableView setTableFooterView:view];
    
    //UIGestureRecognizer *hideKeyboard = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardWillBeHidden:)];
    //[tableView addGestureRecognizer:hideKeyboard];
    //[self.view addGestureRecognizer:hideKeyboard];
    
    [tableView setContentOffset:CGPointMake(0, CGFLOAT_MAX)];
    
    [self.view addSubview:tableView];
    
}


- (NSString *)extractString:(NSString *)fullString toLookFor:(NSString *)lookFor skipForwardX:(NSInteger)skipForward toStopBefore:(NSString *)stopBefore
{
    
    NSRange firstRange = [fullString rangeOfString:lookFor];
    NSRange secondRange = [[fullString substringFromIndex:firstRange.location + skipForward] rangeOfString:stopBefore];
    NSRange finalRange = NSMakeRange(firstRange.location + skipForward, secondRange.location + [stopBefore length]);
    
    return [fullString substringWithRange:finalRange];
}

- (void)viewWillAppear:(BOOL)animated
{
    [[AppDelegate KandiAppDelegate].network getMessageExchange:self withRecipient:self.facebookId];
    
    [self.view addGestureRecognizer:
     [[UITapGestureRecognizer alloc] initWithTarget:self
                                             action:@selector(hideKeyboard:)]];
    
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self registerForKeyboardNotifications];
}

-(void)viewDidDisappear:(BOOL)animated {
    [self deregisterFromKeyboardNotifications];
    [super viewDidDisappear:animated];
    messageslisted = nil;
}

-(void)sendMSSG {

    if (messageTextField.text.length > 0) {
        NSString *message = [NSString new];
        message = messageTextField.text;
        
    
        NSString *myfbid = [AppDelegate KandiAppDelegate].facebookId;
        NSString *username = [AppDelegate KandiAppDelegate].userName;
        
        [[AppDelegate KandiAppDelegate].network saveConvo:self withMessage:message andRecipient:self.facebookId andName:self.userName];
    
        [self.socket emit:@"chat message" args:@[message, myfbid, self.facebookId]];
        [self.socket emit:@"pm" args:@[message, username, myfbid, self.userName, self.facebookId]];
    
        [self performSelector:@selector(getMessage) withObject:nil afterDelay:1.0];
    
        //[messageslisted addObject:message];
        messageTextField.text = nil;
        
    }
    
    //[UIView setAnimationsEnabled:NO];
    //[tableView beginUpdates];
    //[tableView reloadData];
    //[tableView endUpdates];
}

-(void)getMessage {
    [[AppDelegate KandiAppDelegate].network getMessageExchange:self withRecipient:self.facebookId];

}

-(void)registerForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardDidHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector: @selector(keyPressed:)
                                                 name: UITextFieldTextDidChangeNotification
                                               object: nil];
}

-(void)deregisterFromKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidEndEditingNotification object:nil];
}

-(void)keyboardWillShow:(NSNotification*)notification {
    //[self moveControls:notification up:YES];
    
    CGRect keyboardBounds;
    [[notification.userInfo valueForKey:UIKeyboardFrameBeginUserInfoKey] getValue:&keyboardBounds];
    [tableView setFrame:CGRectMake(0, 65, self.view.frame.size.width, self.view.frame.size.height - keyboardBounds.size.height - 90)];
    [messageLabel setFrame:CGRectMake(0, self.view.frame.size.height - keyboardBounds.size.height - 40, self.view.frame.size.width, 40)];
    [self.view addSubview:messageLabel];
    [messageTextField setFrame:CGRectMake(5, self.view.frame.size.height - 35 - keyboardBounds.size.height, self.view.frame.size.width /1.32, 30)];
    [self.view addSubview:messageTextField];
    [send setFrame:CGRectMake(self.view.frame.size.width - 65, self.view.frame.size.height - 32 - keyboardBounds.size.height, 57, 25)];
    [self.view addSubview:send];
    CGFloat height = self.tableView.contentSize.height - self.tableView.bounds.size.height;
    [self.tableView setContentOffset:CGPointMake(0, height) animated:YES];
}

-(void)keyboardWillBeHidden:(NSNotification*)notification {
    //[self moveControls:notification up:NO];
    [tableView setFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 104)];
    [messageLabel setFrame:CGRectMake(0, self.view.frame.size.height - 40, self.view.frame.size.width, 40)];
    [messageTextField setFrame:CGRectMake(5, self.view.frame.size.height - 35, self.view.frame.size.width /1.32, 30)];
    [send setFrame:CGRectMake(self.view.frame.size.width - 65, self.view.frame.size.height - 32 , 57, 25)];

}

-(void) keyPressed: (NSNotification*) notification{
    
    [messageTextField sizeToFit];
    [messageTextField layoutIfNeeded];
    // get the size of the text block so we can work our magic
    CGSize newSize = [messageTextField.text
                      sizeWithFont:[UIFont fontWithName:@"Rancho" size:25]
                      constrainedToSize:CGSizeMake(222,9999)
                      lineBreakMode:UILineBreakModeWordWrap];
    NSInteger newSizeH = newSize.height;
    NSInteger newSizeW = newSize.width;
    
    // I output the new dimensions to the console
    // so we can see what is happening
    NSLog(@"NEW SIZE : %d X %d", newSizeW, newSizeH);
    if (messageTextField.hasText)
    {
        // if the height of our new chatbox is
        // below 90 we can set the height
        if (newSizeH <= 90)
        {
            [messageTextField scrollRectToVisible:CGRectMake(0,0,1,1) animated:NO];
            
            // chatbox
            CGRect chatBoxFrame = messageTextField.frame;
            NSInteger chatBoxH = chatBoxFrame.size.height;
            NSInteger chatBoxW = chatBoxFrame.size.width;
            NSLog(@"CHAT BOX SIZE : %d X %d", chatBoxW, chatBoxH);
            chatBoxFrame.size.height = newSizeH + 12;
            messageTextField.frame = chatBoxFrame;
            
            // form view
            CGRect formFrame = tableView.frame;
            NSInteger viewFormH = formFrame.size.height;
            NSLog(@"FORM VIEW HEIGHT : %d", viewFormH);
            formFrame.size.height = 30 + newSizeH;
            formFrame.origin.y = 199 - (newSizeH - 18);
            tableView.frame = formFrame;
            
            // table view
            CGRect tableFrame = tableView.frame;
            NSInteger viewTableH = tableFrame.size.height;
            NSLog(@"TABLE VIEW HEIGHT : %d", viewTableH);
            tableFrame.size.height = 199 - (newSizeH - 18);
            tableView.frame = tableFrame;
        }
        
        // if our new height is greater than 90
        // sets not set the height or move things
        // around and enable scrolling
        if (newSizeH > 90)
        {
            messageTextField.scrollEnabled = YES;
        }
    }
}


-(void)moveControls:(NSNotification*)notification up:(BOOL)up {
    NSDictionary *userInfo = [notification userInfo];
    CGRect newFrame = [self getNewControlsFrame:userInfo up:up];
    
    [self animateControls:userInfo withFrame:newFrame];
}

-(CGRect)getNewControlsFrame:(NSDictionary*)userInfo up:(BOOL)up {
    CGRect kbFrame = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    kbFrame = [self.view convertRect:kbFrame fromView:nil];
    
    //CGRect newFrame = self.view.frame;
    CGRect newFrame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - kbFrame.size.height);
    //newFrame.origin.y += kbFrame.size.height * (up ? -1 : 1);
    
    return newFrame;
}

-(void)animateControls:(NSDictionary*)userInfo withFrame:(CGRect)newFrame {
    NSTimeInterval duration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve animationCurve = [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    [UIView animateWithDuration:duration delay:0 options:animationOptionsWithCurve(animationCurve) animations:^{self.view.frame = newFrame;} completion:^(BOOL finished){}];
}

- (IBAction)hideKeyboard:(id)sender {
    [self.view endEditing:YES];
}

//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //NSString *text = [messageslisted objectAtIndex:[indexPath row]];
    
 //   CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN *2), 20000.0f);
    
    //CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeCharacterWrap];
    
    //CGFloat height = MAX(size.height, 44.0f);
    
   // return height + (CELL_CONTENT_MARGIN * 2);
    
   // return CHAT_ROW_HEIGHT;
//}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return messageslisted.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    json = [messages objectAtIndex:(messages.count - indexPath.row - 1)];
    //NSDictionary* original = [json objectForKey:ORIGINAL];
    //NSDictionary* current = [json objectForKey:CURRENT];
    NSDictionary* messagehistory = [json objectForKey:MESSAGEHISTORY];
    
    NSString* mh_message = [messagehistory objectForKey:MESSAGE_KT];
    NSString* mh_sender = [messagehistory objectForKey:SENDER];
    //NSString* mh_recipient = [messagehistory objectForKey:RECIPIENT];
    //NSString* mh_timestamp = [messagehistory objectForKey:TIMESTAMP];
    
    NSString *cellIdentifier = @"ChatTableViewCell";
    
    ChatTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[ChatTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = messageslisted[messageslisted.count - indexPath.row - 1];
    [cell setImageUsingFacebookId:mh_sender];
    

    //cell.textLabel.text = [list objectAtIndex:indexPath.row];
    
    
 //   if (messageslisted.count > 0) {
 //       cell.textLabel.text = mh_message;
 //           for (int i = 0; i < messageslisted.count; i++) {
  //              cell.textLabel.text = messageslisted[i];
  //              }
        
   // }
    //cell.detailTextLabel.text = [list objectAtIndex:indexPath.row];
    //[cell setImageUsingFacebookId:[list objectAtIndex:indexPath.row]];
    //[cell setImageUsingFacebookId:self.facebookId];
   // UILabel *who = [[UILabel alloc] init];
   // who.text = [list objectAtIndex:indexPath.row];
    //[cell addSubview:who];
   // who.hidden = YES;
    

    //cell.textLabel.text = [showingMessages objectAtIndex:[showingMessages count]];
        
   // if ([who.text isEqualToString:facebookID]) {
   //     cell.textLabel.textAlignment = NSTextAlignmentRight;
   // } else {
   //     cell.textLabel.textAlignment = NSTextAlignmentLeft;
   // }
    
    //cell.textLabel.text = mh_message;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.numberOfLines = 0;
    [cell.textLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [cell.textLabel sizeToFit];
    
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
            
            list = [[NSMutableArray alloc] init];
            
            for (json in messages) {
                sender = [Sender new];
                sender.facebookID = [[json objectForKey:MESSAGEHISTORY] objectForKey:SENDER];
                [list addObject:sender.facebookID];
            }
            
            //NSLog(@"messages: %@", messages);
            //NSLog(@"messages.count: %u", messages.count);
            for (int i=0; i<[jsonArray count]; i++) {
                json = [jsonArray objectAtIndex:i];
                loadedDataSource = YES;
                if ([json count]) {
                    // we'll consider it a success if there's any json
                    //NSDictionary* original = [json objectForKey:ORIGINAL];
                    //NSDictionary* current = [json objectForKey:CURRENT];
                    //NSDictionary* messagehistory = [json objectForKey:MESSAGEHISTORY];
                    
                    //NSString* o_qrcodeId = [original objectForKey:QRCODE_ID];
                    //NSString* o_userId = [original objectForKey:USER_ID];
                    //NSString* o_placement = [original objectForKey:PLACEMENT];
                    //NSString* o_ownershipId = [original objectForKey:OWNERSHIP_ID];
                    
                    //NSString* c_userId = [current objectForKey:USER_ID];
                    //NSString* c_userName = [current objectForKey:USER_NAME];
                    //NSString* c_facebookId = [current objectForKey:FACEBOOK_ID];
                    
                    //NSString* mh_message = [messagehistory objectForKey:MESSAGE_KT];
                    //NSString* mh_sender = [messagehistory objectForKey:SENDER];
                    //NSString* mh_recipient = [messagehistory objectForKey:RECIPIENT];
                    //NSString* mh_timestamp = [messagehistory objectForKey:TIMESTAMP];
                    
                }
            }
            
            if (loadedDataSource) {
                [self.tableView reloadData];
                //NSRange range = NSMakeRange(0, [self numberOfSectionsInTableView:self.tableView]);
                //NSIndexSet *sections = [NSIndexSet indexSetWithIndexesInRange:range];
                //[self.tableView reloadSections:sections withRowAnimation:UITableViewRowAnimationAutomatic];
                //[tableView setContentOffset:CGPointMake(0, CGFLOAT_MAX) animated:NO];

                
            NSLog(@"ChatTableViewController.tableview reloadData");
        } else {
            // NSString* error = [jsonResponse objectForKey:@"error"];
            //NSLog(@"%@", error);
        }
        }
    
    }
    
    //[self.refreshControl endRefreshing];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
