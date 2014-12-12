//
//  DetailTableViewController.m
//  KandiTAG
//
//  Created by Jim Chen on 12/8/14.
//  Copyright (c) 2014 Jim. All rights reserved.
//

#import "DetailTableViewController.h"
#import "KandiTableViewCell.h"
#import "AppDelegate.h"
#import "KandiProfileViewController.h"
#import "ChatTableViewController.h"
#import "MessagesTableViewController.h"
#import "MessagingNavigationController.h"
#import "KandiDetailTableViewCell.h"

@interface DetailTableViewController () {
    ChatTableViewController *chatController;
    MessagingNavigationController *messagingNavController;
    UIButton *dismiss;
    KandiDetailTableViewCell *cell;
    UIView *shadedView;
}

@end

@implementation DetailTableViewController
@synthesize responseData;
@synthesize loadedDataSource;
@synthesize tags;
@synthesize displayType;
@synthesize selectedQrCodeId;
@synthesize indicator;
@synthesize json;

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
#define PARTYA @"partyA"
#define PARTYB @"partyB"
#define CONVO @"convo"
#define NAMEA @"nameA"
#define NAMEB @"nameB"

-(instancetype)initWithFlag:(DisplayType)flag {
    self = [super init];
    if (self) {
        responseData = [[NSMutableData alloc] init];
        loadedDataSource = NO;
        tags = [[NSMutableArray alloc] init];
        displayType = flag;
    }
    //return
    return self;
}

-(instancetype)initWithFlag:(DisplayType)flag andQRCode:(NSString*)qrCode {
    self = [self initWithFlag:flag];
    if (self) {
        self.selectedQrCodeId = qrCode;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"DetailTableView has been loaded");
    
    [self.tableView registerClass:[KandiDetailTableViewCell class] forCellReuseIdentifier:@"KandiDetailTableViewCell"];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 10)];
    view.backgroundColor = [UIColor clearColor];
    [self.tableView setTableHeaderView:view];
    [self.tableView setTableFooterView:view];
    
    self.view.layer.borderWidth = 0.25f;
    self.view.layer.borderColor = [UIColor blackColor].CGColor;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewWillAppear:(BOOL)animated {
    
     indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
     indicator.frame = CGRectMake(0.0, 0.0, 50.0, 50.0);
     indicator.color = [UIColor colorWithRed:50.0f/255.0 green:197.0f/255.0 blue:244.0f/255.0 alpha:1.0f];
     indicator.center = self.view.center;
     [self.view addSubview:indicator];
     [indicator bringSubviewToFront:self.view];
    //[indicator startAnimating];

    [UIApplication sharedApplication].networkActivityIndicatorVisible = TRUE;
    
    switch (displayType) {
        case TAG:
            self.title = @"TAG";
            [[AppDelegate KandiAppDelegate].network getCurrentTags:self];
            //[self.view addSubview:loading];
            //[indicator startAnimating];
            break;
        case KANDI:
            self.title = @"KANDI";
            [[AppDelegate KandiAppDelegate].network getOriginalTags:self];
            //[self.view addSubview:loading];
            //[indicator startAnimating];
            break;
        case DETAIL:
            self.title = @"DETAIL";
            [[AppDelegate KandiAppDelegate].network getAllTags:self withQRcode:self.selectedQrCodeId];
            self.refreshControl.hidden = YES;
            //[self.view addSubview:loading];
            //[indicator startAnimating];
            break;
        case MESSAGE:
            self.title = @"MESSAGE";
            [[AppDelegate KandiAppDelegate].network getAllMessages:self];
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (loadedDataSource)
        return [tags count];
    else
        return 0;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //these are the detail view cells, the expanded view
    
    json = [tags objectAtIndex:indexPath.row];
    //NSDictionary* original = [json objectForKey:ORIGINAL];
    NSDictionary* current = [json objectForKey:CURRENT];
    
    //NSString* o_qrcodeId = [original objectForKey:QRCODE_ID];
    //NSString* o_userId = [original objectForKey:USER_ID];
    //NSString* o_placement = [original objectForKey:PLACEMENT];
    //NSString* o_ownershipId = [original objectForKey:OWNERSHIP_ID];
    
   //NSString* c_userId = [current objectForKey:USER_ID];
    NSString* c_userName = [current objectForKey:USER_NAME];
    NSString* c_facebookId = [current objectForKey:FACEBOOK_ID];
    
    static NSString *CellIdentifier = @"KandiDetailTableViewCell";
    
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[KandiDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
        
    cell.textLabel.text = c_userName;
    [cell setImageUsingFacebookId:c_facebookId];
    
    cell.backgroundColor = [UIColor clearColor];
    //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    //cell.backgroundColor = [UIColor colorWithRed:247.0f/255.0 green:247.0f/255.0 blue:100.0f/255.0 alpha:0.6f];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    json = [tags objectAtIndex:indexPath.row];
    //NSDictionary* original = [json objectForKey:ORIGINAL];
    NSDictionary* current = [json objectForKey:CURRENT];
    //NSDictionary* messagehistory = [json objectForKey:MESSAGEHISTORY];
    //NSDictionary* convo = [json objectForKey:CONVO];
    
    //NSString* o_qrcodeId = [original objectForKey:QRCODE_ID];
    //NSString* o_userId = [original objectForKey:USER_ID];
    //NSString* o_placement = [original objectForKey:PLACEMENT];
    //NSString* o_ownershipId = [original objectForKey:OWNERSHIP_ID];
    
    //NSString* c_userId = [current objectForKey:USER_ID];
    NSString* c_userName = [current objectForKey:USER_NAME];
    NSString* c_facebookId = [current objectForKey:FACEBOOK_ID];
    
    //NSString* mh_message = [messagehistory objectForKey:MESSAGE_KT];
    //NSString* mh_sender = [messagehistory objectForKey:SENDER];
    //NSString* mh_recipient = [messagehistory objectForKey:RECIPIENT];
    //NSString* mh_timestamp = [messagehistory objectForKey:TIMESTAMP];
    
    //NSString* c_partyA = [convo objectForKey:PARTYA];
    //NSString* c_partyB = [convo objectForKey:PARTYB];
    //NSString* c_message = [convo objectForKey:MESSAGE_KT];
    //NSString* c_nameA = [convo objectForKey:NAMEA];
    //NSString* c_nameB = [convo objectForKey:NAMEB];
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
        
    NSString *facebookId = [AppDelegate KandiAppDelegate].facebookId;
    
    chatController = [[ChatTableViewController alloc] initWithFacebookId:c_facebookId andUserName:c_userName];

    
    if (![c_facebookId isEqual:facebookId]) {
        
        messagingNavController = [[MessagingNavigationController alloc] init];
        
        [self presentViewController:messagingNavController animated:YES completion:nil];
        
        [messagingNavController pushViewController:chatController animated:NO];
        
        dismiss = [[UIButton alloc] initWithFrame:CGRectMake(15, 30, 25, 25)];
        [dismiss addTarget:self action:@selector(removeMessagingController) forControlEvents:UIControlEventTouchUpInside];
        [dismiss setImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
        [messagingNavController.view addSubview:dismiss];
    }
}

-(void)removeMessagingController {
    [messagingNavController dismissViewControllerAnimated:YES completion:nil];
    messagingNavController.presentingViewController.view.hidden = YES;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ROW_HEIGHT;
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
            tags = jsonArray;
            for (int i=0; i<[jsonArray count]; i++) {
                json = [jsonArray objectAtIndex:i];
                loadedDataSource = YES;
                if ([json count]) {
                    // we'll consider it a success if there's any json
                    NSDictionary* original = [json objectForKey:ORIGINAL];
                    NSDictionary* current = [json objectForKey:CURRENT];
                    
                    //NSString* o_qrcodeId = [original objectForKey:QRCODE_ID];
                    //NSString* o_userId = [original objectForKey:USER_ID];
                    //NSString* o_placement = [original objectForKey:PLACEMENT];
                    //NSString* o_ownershipId = [original objectForKey:OWNERSHIP_ID];
                    
                    //NSString* c_userId = [current objectForKey:USER_ID];
                    //NSString* c_userName = [current objectForKey:USER_NAME];
                    //NSString* c_facebookId = [current objectForKey:FACEBOOK_ID];

                }
            }
            
            if (loadedDataSource)
                [self.tableView reloadData];
        } else {
            // NSString* error = [jsonResponse objectForKey:@"error"];
            //NSLog(@"%@", error);
        }
    }
    
    [indicator stopAnimating];
    [self.refreshControl endRefreshing];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

@end
