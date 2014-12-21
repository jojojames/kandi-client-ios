//
//  KandiViewController.m
//  KandiTAG
//
//  Created by Jim Chen on 12/10/14.
//  Copyright (c) 2014 Jim. All rights reserved.
//

#import "KandiViewController.h"
#import "KandiTableViewCell.h"
#import "AppDelegate.h"
#import "Sender.h"
#import "DetailTableViewController.h"
#import "ChatTableViewController.h"
#import "MessagingNavigationController.h"
#import "DetailView.h"
#import "DetailPageController.h"
#import "ProfileViewController.h"

@interface KandiViewController () {
    NSMutableArray *list;
    NSMutableArray *names;
    Sender *sender;
    Sender *sent;
    UIView *blur;
    UIImageView *background;
    DetailTableViewController *detailTableViewController;
    UIView *shadedView;
    UIButton *dismiss;
    ChatTableViewController *chatController;
    MessagingNavigationController *messagingNavController;
    DetailView *detailView;
    UIView *white;
    UIView *top;
    UIView *circle;
    UIButton *pullTableUp;
    DetailPageController *detailPageController;
    ProfileViewController *profileViewController;
}

@end

@implementation KandiViewController {
    UILabel *title;
    UIImageView *backgroundImage;
}

@synthesize responseData;
@synthesize loadedDataSource;
@synthesize tags;
@synthesize displayType;
@synthesize json;
@synthesize tableView;

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
        //NSLog(@"KandiViewController init");
        responseData = [[NSMutableData alloc] init];
        loadedDataSource = NO;
        tags = [[NSMutableArray alloc] init];
        displayType = flag;
    }

    return self;
}

-(instancetype)initWithFlag:(DisplayType)flag andQRCode:(NSString*)qrCode {
    self = [self initWithFlag:flag];
    if (self) {
        self.selectedQrCodeId = qrCode;
    }
    return self;
}

-(void)moveTitle {
    title.transform = CGAffineTransformMakeScale(0.95, 0.95);
}

-(void)moveTitleBack {
    title.transform = CGAffineTransformMakeScale(1.0, 1.0);
}

-(void)viewDidLoad {
    [super viewDidLoad];
    
    blur = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    blur.backgroundColor = [UIColor colorWithRed:224.0/255.0 green:224.0/255.0 blue:224.0/255.0 alpha:0.3];
    
    //white = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height/2.2, self.view.frame.size.width, self.view.frame.size.height)];
    white = [[UIView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height)];
    white.backgroundColor = [UIColor whiteColor];
    
    top = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    top.backgroundColor = [UIColor whiteColor];
    
    circle = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2.2, 27, 30, 30)];
    circle.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:51.0/255.0 alpha:0.8];
    circle.layer.cornerRadius = circle.frame.size.width/2;
    circle.clipsToBounds = YES;
    
    pullTableUp = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2.2, 27, 30, 30)];
    pullTableUp.backgroundColor = [UIColor clearColor];
    [pullTableUp addTarget:self action:@selector(pullTableUp) forControlEvents:UIControlEventTouchUpInside];
    
    //self.view.layer.borderWidth = 0.25f;
    //self.view.layer.borderColor = [UIColor blackColor].CGColor;
    
    switch (displayType) {
        case KANDI:
            backgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
            backgroundImage.image = [UIImage imageNamed:@"messageBackground"];
            //[self.view addSubview:backgroundImage];
            [self.view addSubview:white];
            [white addSubview:blur];
            //[self.view addSubview:blur];
            title = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, self.view.frame.size.width, 50)];
            title.text = @"Kandi";
            [title setTextAlignment:NSTextAlignmentCenter];
            [title setFont:[UIFont fontWithName:@"Rancho" size:35]];
            title.textColor = [UIColor colorWithRed:176.0/255.0 green:224.0/255.0 blue:230.0/255.0 alpha:1];
            [self.view addSubview:top];
            [self.view addSubview:circle];
            circle.hidden = YES;
            [self.view addSubview:title];
            [self.view addSubview:pullTableUp];
            break;
        case TAG:
            backgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
            backgroundImage.image = [UIImage imageNamed:@"tagBackground"];
            //[self.view addSubview:backgroundImage];
            [self.view addSubview:white];
            [white addSubview:blur];
            title = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, self.view.frame.size.width, 50)];
            title.text = @"Tag";
            [title setTextAlignment:NSTextAlignmentCenter];
            [title setFont:[UIFont fontWithName:@"Rancho" size:35]];
            title.textColor = [UIColor colorWithRed:176.0/255.0 green:224.0/255.0 blue:230.0/255.0 alpha:1];
            [self.view addSubview:top];
            [self.view addSubview:circle];
            circle.hidden = YES;
            [self.view addSubview:title];
            [self.view addSubview:pullTableUp];
            break;
        case MESSAGE:
            backgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
            backgroundImage.image = [UIImage imageNamed:@"messageBackground"];
            //[self.view addSubview:backgroundImage];
            [self.view addSubview:white];
            [white addSubview:blur];
            title = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, self.view.frame.size.width, 50)];
            title.text = @"Message";
            [title setTextAlignment:NSTextAlignmentCenter];
            [title setFont:[UIFont fontWithName:@"Rancho" size:35]];
            title.textColor = [UIColor colorWithRed:176.0/255.0 green:224.0/255.0 blue:230.0/255.0 alpha:1];
            [self.view addSubview:top];
            //[self.view addSubview:circle];
            [self.view addSubview:title];
            break;
            
        default:
            break;
    }
    
    //tableView = [[UITableView alloc] initWithFrame:CGRectMake(20, self.view.frame.size.height / 2.2, self.view.frame.size.width - 40, self.view.frame.size.height) style:UITableViewStyleGrouped];
    tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 66, self.view.frame.size.width , self.view.frame.size.height) style:UITableViewStyleGrouped];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLineEtched;
    tableView.separatorColor = [UIColor blackColor];
    [self.view addSubview:tableView];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 10)];
    view.backgroundColor = [UIColor clearColor];
    //[tableView setTableHeaderView:view];
    //[tableView setTableFooterView:view];
    
    [self.tableView registerClass:[KandiTableViewCell class] forCellReuseIdentifier:@"KandiTableViewCell"];


}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];

    [UIApplication sharedApplication].networkActivityIndicatorVisible = TRUE;
    
    
    switch (displayType) {
        case TAG:
            self.title = @"Tag";
            [[AppDelegate KandiAppDelegate].network getCurrentTags:self];
            //[self.view addSubview:loading];
            //[indicator startAnimating];
            break;
        case KANDI:
            self.title = @"Kandi";
            [[AppDelegate KandiAppDelegate].network getOriginalTags:self];
            //[self.view addSubview:loading];
            //[indicator startAnimating];
            break;
        case DETAIL:
            self.title = @"DETAIL";
            [[AppDelegate KandiAppDelegate].network getAllTags:self withQRcode:self.selectedQrCodeId];
            //self.refreshControl.hidden = YES;
            //[self.view addSubview:loading];
            //[indicator startAnimating];
            break;
        case MESSAGE:
            self.title = @"Message";
            [[AppDelegate KandiAppDelegate].network getAllMessages:self];
        default:
            break;
    }
}

-(void)refreshTable {
    [self.tableView reloadData];
}

/*

#pragma mark - scroll view

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSArray *rows = [self.tableView indexPathsForVisibleRows];
    for (NSIndexPath *path in rows) {
        KandiTableViewCell *cell = [self.tableView cellForRowAtIndexPath:path];
        float percent = [self cellDistanceAsPercentageFromTableViewCenterAtRow: cell];
        cell.layer.sublayerTransform = CATransform3DMakeScale(percent, percent, 1);
    }
}

//Calculate distance of the cell as a percentage from the bottom of the actual visible contentView
-(float)cellDistanceAsPercentageFromTableViewCenterAtRow:(KandiTableViewCell *)cell {
    float position = cell.frame.origin.y;
    
    float offsetFromTop = self.tableView.contentOffset.y;
    
    float percentFromBottom = (position-offsetFromTop+ROW_HEIGHT)/self.tableView.frame.size.height;
    percentFromBottom = MIN(MAX(percentFromBottom, 0), 1);
    
    return percentFromBottom;
}
 
 */



#pragma mark - Table view data source

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return tags.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 1; // you can have your own choice, of course
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor clearColor];
    return headerView;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //these are the detail view cells, the expanded view
    
    json = [tags objectAtIndex:indexPath.row];
    NSDictionary* original = [json objectForKey:ORIGINAL];
    NSDictionary* current = [json objectForKey:CURRENT];
    //NSDictionary* messagehistory = [json objectForKey:MESSAGEHISTORY];
    NSDictionary* convo = [json objectForKey:CONVO];
    
    NSString* o_qrcodeId = [original objectForKey:QRCODE_ID];
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
    
    NSString* c_partyA = [convo objectForKey:PARTYA];
    NSString* c_partyB = [convo objectForKey:PARTYB];
    NSString* c_message = [convo objectForKey:MESSAGE_KT];
    NSString* c_nameA = [convo objectForKey:NAMEA];
    NSString* c_nameB = [convo objectForKey:NAMEB];
    
    static NSString *CellIdentifier = @"KandiTableViewCell";
    static NSString *KandiTableViewCellid = @"KandiTableViewCell";
    static NSString *SeperatorCellid = @"SeperatorCell";
    
    KandiTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[KandiTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }

    
    NSString *facebookID = [AppDelegate KandiAppDelegate].facebookId;

    
    
    switch (displayType) {
        case MESSAGE: {
            if ([c_partyA isEqualToString:facebookID]) {
                [cell setImageUsingFacebookId:c_partyB];
                UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(75, 0, 230, 35)];
                [detailLabel setFont:[UIFont fontWithName:@"Helvetica-Light" size:12]];
                detailLabel.text = c_nameB;
                cell.textLabel.text = [NSString stringWithFormat:@"\"%@\"", c_message];
                cell.detailTextLabel.text = c_message;
                [cell.contentView addSubview:detailLabel];
            }
            else if ([c_partyB isEqualToString:facebookID]) {
                [cell setImageUsingFacebookId:c_partyA];
                UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(75, 0, 230, 35)];
                [detailLabel setFont:[UIFont fontWithName:@"Helvetica-Light" size:12]];
                detailLabel.text = c_nameA;
                cell.textLabel.text = [NSString stringWithFormat:@"\"%@\"", c_message];
                cell.detailTextLabel.text = c_message;
                [cell.contentView addSubview:detailLabel];
            }
        }
            break;
            
        default:
            cell.textLabel.text = c_userName;
            [cell setImageUsingFacebookId:c_facebookId];
            cell.detailTextLabel.text = o_qrcodeId;
            
            break;
    }
    
    cell.backgroundColor = [UIColor clearColor];
    return cell;
    
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //this is for the cells leading up to the messaging
    json = [tags objectAtIndex:indexPath.row];
    NSDictionary* original = [json objectForKey:ORIGINAL];
    NSDictionary* current = [json objectForKey:CURRENT];
    //NSDictionary* messagehistory = [json objectForKey:MESSAGEHISTORY];
    NSDictionary* convo = [json objectForKey:CONVO];
    
    NSString* o_qrcodeId = [original objectForKey:QRCODE_ID];
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
    
    NSString* c_partyA = [convo objectForKey:PARTYA];
    NSString* c_partyB = [convo objectForKey:PARTYB];
    //NSString* c_message = [convo objectForKey:MESSAGE_KT];
    NSString* c_nameA = [convo objectForKey:NAMEA];
    NSString* c_nameB = [convo objectForKey:NAMEB];
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    [self clear];
    
    NSLog(@"cell selected");
    
    switch (displayType) {
        case TAG:
        {
            
            detailView = [[DetailView alloc] initWithFlag:DETAIL andQRCode:o_qrcodeId];
            detailView.view.frame = CGRectMake(0, 66, self.view.frame.size.width, 190);
            detailView.view.backgroundColor = [UIColor clearColor];
            
            detailPageController = [[DetailPageController alloc] initWithFlag:DETAIL andQRCode:o_qrcodeId];
            detailPageController.view.frame = CGRectMake(0, 66, self.view.frame.size.width, 190);
            detailPageController.view.backgroundColor = [UIColor whiteColor];
            
            NSTimer *addDetailView = [NSTimer scheduledTimerWithTimeInterval:0.7 target:self selector:@selector(addDetailPageController) userInfo:nil repeats:NO];

            
            [UIView animateWithDuration:0.6 delay:0.1 options:UIViewAnimationCurveEaseOut animations:^{ [self.tableView setFrame:CGRectMake(0, self.view.frame.size.height / 2.2, self.view.frame.size.width, self.view.frame.size.height - self.view.frame.size.height/2.2)]; [white setFrame:CGRectMake(0, self.view.frame.size.height/2.2, self.view.frame.size.width, self.view.frame.size.height)];} completion:nil];

            break;
        }
        case KANDI:
        {
            
            profileViewController = [[ProfileViewController alloc] initWithUserName:c_userName andFbId:c_facebookId andController:self];
            profileViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
            [self presentViewController:profileViewController animated:YES completion:nil];
            
            
            /*
            detailView = [[DetailView alloc] initWithFlag:DETAIL andQRCode:o_qrcodeId];
            detailView.view.frame = CGRectMake(0, 66, self.view.frame.size.width, 190);
            detailView.view.backgroundColor = [UIColor clearColor];
            
            detailPageController = [[DetailPageController alloc] initWithFlag:DETAIL andQRCode:o_qrcodeId];
            detailPageController.view.frame = CGRectMake(0, 66, self.view.frame.size.width, 190);
            detailPageController.view.backgroundColor = [UIColor whiteColor];
            
            NSTimer *addDetailView = [NSTimer scheduledTimerWithTimeInterval:0.7 target:self selector:@selector(addDetailPageController) userInfo:nil repeats:NO];

            [UIView animateWithDuration:0.6 delay:0.1 options:UIViewAnimationCurveEaseOut animations:^{ [self.tableView setFrame:CGRectMake(0, self.view.frame.size.height / 2.2, self.view.frame.size.width, self.view.frame.size.height - self.view.frame.size.height/2.2)]; [white setFrame:CGRectMake(0, self.view.frame.size.height/2.2, self.view.frame.size.width, self.view.frame.size.height)];} completion:nil];
            
             */
            break;
        }
        case DETAIL:
        {
            chatController = [[ChatTableViewController alloc] initWithFacebookId:c_facebookId andUserName:c_userName];
            
            //[[AppDelegate KandiAppDelegate].network getMessageExchange:chatController withRecipient:c_facebookId];
            
            NSString *facebookId = [AppDelegate KandiAppDelegate].facebookId;
            
            if (![c_facebookId isEqual:facebookId]) {
                
                messagingNavController = [[MessagingNavigationController alloc] init];
                
                [self presentViewController:messagingNavController animated:NO completion:nil];
                
                [messagingNavController pushViewController:chatController animated:NO];
                
                dismiss = [[UIButton alloc] initWithFrame:CGRectMake(15, 30, 25, 25)];
                [dismiss addTarget:self action:@selector(removeMessagingController) forControlEvents:UIControlEventTouchUpInside];
                [dismiss setImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
                [messagingNavController.view addSubview:dismiss];
                
            }
            
            break;
        }
        case MESSAGE:
        {
            
            NSString *facebookId = [AppDelegate KandiAppDelegate].facebookId;
            
            
            if ([c_partyB isEqualToString:facebookId]) {
                NSLog(@"B");
                chatController = [[ChatTableViewController alloc] initWithFacebookId:c_partyA andUserName:c_nameA];
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
            
            if ([c_partyA isEqualToString:facebookId]) {
                NSLog(@"A");
                chatController = [[ChatTableViewController alloc] initWithFacebookId:c_partyB andUserName:c_nameB];
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
            
            break;
        }
        default:
            break;
            
    }
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
            NSLog(@"tags: %@", tags);
            
            list = [[NSMutableArray alloc] init];
            names = [[NSMutableArray alloc] init];
            
            for (json in tags) {
                sender = [Sender new];
                sender.facebookID = [[json objectForKey:CURRENT] objectForKey:FACEBOOK_ID];
                sender.userName = [[json objectForKey:CURRENT] objectForKey:USER_NAME];
                //[list addObject:sender.facebookID];
                //[names addObject:sender.userName];
            }
            
            //NSLog(@"list: %@", list);
            //NSLog(@"names: %@", names);
            
            
            for (int i=0; i<[jsonArray count]; i++) {
                json = [jsonArray objectAtIndex:i];
                loadedDataSource = YES;
                if ([json count]) {
                    // we'll consider it a success if there's any json
                    NSDictionary* original = [json objectForKey:ORIGINAL];
                    NSDictionary* current = [json objectForKey:CURRENT];
                    NSDictionary* messagehistory = [json objectForKey:MESSAGEHISTORY];
                    NSDictionary* convo = [json objectForKey:CONVO];
                    
                    /*
                     
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
                     
                     NSString* c_partyA = [convo objectForKey:PARTYA];
                     NSString* c_partyB = [convo objectForKey:PARTYB];
                     NSString* c_message = [convo objectForKey:MESSAGE_KT];
                     NSString* c_nameA = [convo objectForKey:NAMEA];
                     NSString* c_nameB = [convo objectForKey:NAMEB];
                     
                     */
                }
            }
            
            if (loadedDataSource)
                [tableView reloadData];
            NSLog(@"KandiViewController(%u).tableView reloadData", displayType);
        } else {
            // NSString* error = [jsonResponse objectForKey:@"error"];
            //NSLog(@"%@", error);
        }
    }
    
    //[indicator stopAnimating];
    //[self hideLoading];
    //[self.refreshControl endRefreshing];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)addProfileViewController {
    [self.view addSubview:profileViewController.view];
}

-(void)removeMessagingController {
    [messagingNavController dismissViewControllerAnimated:YES completion:nil];
}

-(void)clear {
    [detailView.view removeFromSuperview];
    [detailPageController.view removeFromSuperview];
}

-(void)pullTableUp {
    circle.hidden = YES;
    [detailPageController.view removeFromSuperview];
    [detailView.view removeFromSuperview];
    [UIView animateWithDuration:0.6 delay:0.1 options:UIViewAnimationCurveEaseIn animations:^{ [self.tableView setFrame:CGRectMake(0, 66, self.view.frame.size.width, self.view.frame.size.height)]; [white setFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height)];} completion:nil];
}

-(void)addDetailPageController {
    circle.hidden = NO;
    [self.view addSubview:detailPageController.view];
}

-(void)addDetailView {
    [self.view addSubview:detailView.view];
}

@end
