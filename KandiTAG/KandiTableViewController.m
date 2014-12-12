//
//  Kandi.m
//  KandiTAG
//
//  Created by Jim Chen on 9/28/14.
//  Copyright (c) 2014 Jim. All rights reserved.
//

#import "KandiTableViewController.h"
#import "KandiTableViewCell.h"
#import "AppDelegate.h"
#import "KandiProfileViewController.h"
#import "ChatTableViewController.h"
#import "MessagesTableViewController.h"
#import "MessagingNavigationController.h"
#import "KandiDetailTableViewCell.h"
#import "DetailTableViewController.h"
#import "ZFModalTransitionAnimator.h"
#import "Animator.h"
#import "Interactive.h"

@interface KandiTableViewController () {
    UILabel *loading;
    UIWebView *profile;
    UIButton *dismiss;
    KandiTableViewController *detailController;
    MessagingNavigationController *messagingNavController;
    ChatTableViewController *chatController;
    MessagesTableViewController *messagingTable;
    UIView *shadedView;
    DetailTableViewController *detailTableViewController;
    Animator *animator;
}

@end

@implementation KandiTableViewController
@synthesize responseData;
@synthesize loadedDataSource;
@synthesize tags;
@synthesize displayType;
@synthesize selectedQrCodeId;
@synthesize indicator;
@synthesize json;
@synthesize collectionView;

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

-(void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[KandiTableViewCell class] forCellReuseIdentifier:@"KandiTableViewCell"];
    [self.tableView registerClass:[KandiDetailTableViewCell class] forCellReuseIdentifier:@"KandiDetailTableViewCell"];
    //self.tableView.backgroundColor = [UIColor colorWithRed:224.0/255.0 green:224.0/255.0 blue:224.0/255.0 alpha:0.7];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 10)];
    view.backgroundColor = [UIColor clearColor];
    [self.tableView setTableHeaderView:view];
    [self.tableView setTableFooterView:view];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor clearColor];//[UIColor colorWithRed:255.0f/255.0 green:250.0f/255.0 blue:104.0f/255.0 alpha:1.0f];
    self.refreshControl.tintColor = [UIColor colorWithRed:200.0f/255.0 green:225.0f/255.0 blue:244.0f/255.0 alpha:1.0f];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM d YYYY, h:mm a"];
    NSString *title = [NSString stringWithFormat:@"Last Update: %@", [formatter stringFromDate:[NSDate date]]];
    //NSString *title = [NSString stringWithFormat:@""];
    NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[UIColor blackColor] forKey:NSForegroundColorAttributeName];
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
    self.refreshControl.attributedTitle = attributedString;
    [self.refreshControl addTarget:self action:@selector(viewWillAppear:) forControlEvents:UIControlEventValueChanged];
    
    self.view.layer.borderWidth = 0.25f;
    self.view.layer.borderColor = [UIColor blackColor].CGColor;
}

-(void)refreshTable {
    [self.refreshControl endRefreshing];
    [self.tableView reloadData];
}

-(void)viewWillAppear:(BOOL)animated {
    /*
    indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.frame = CGRectMake(0.0, 0.0, 50.0, 50.0);
    indicator.color = [UIColor colorWithRed:50.0f/255.0 green:197.0f/255.0 blue:244.0f/255.0 alpha:1.0f];
    indicator.center = self.view.center;
    [self.view addSubview:indicator];
    [indicator bringSubviewToFront:self.view];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = TRUE;
     */
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = TRUE;
    
    /*
    
    loading = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2.3, self.view.frame.size.height/2.5, 640, 30)];
    loading.text = @"Loading...";
    loading.font = [UIFont fontWithName:@"DINCondensed-Bold" size:15];
    [loading sendSubviewToBack:self.view];
     
     */
    
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
            self.refreshControl.hidden = YES;
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

/*
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    //1. Setup the CATransform3D structure
    CATransform3D rotation;
    rotation = CATransform3DMakeRotation( (90.0*M_PI)/180, 0.0, 0.7, 0.4);
    rotation.m34 = 1.0/ -600;
    
    
    //2. Define the initial state (Before the animation)
    cell.layer.shadowColor = [[UIColor blackColor]CGColor];
    cell.layer.shadowOffset = CGSizeMake(10, 10);
    cell.alpha = 0;
    
    cell.layer.transform = rotation;
    cell.layer.anchorPoint = CGPointMake(0, 0.5);
    
    //3. Define the final state (After the animation) and commit the animation
    [UIView beginAnimations:@"rotation" context:NULL];
    [UIView setAnimationDuration:0.8];
    cell.layer.transform = CATransform3DIdentity;
    cell.alpha = 1;
    cell.layer.shadowOffset = CGSizeMake(0, 0);
    [UIView commitAnimations];
}
*/

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
    
    KandiTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
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
    //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    //cell.backgroundColor = [UIColor colorWithRed:247.0f/255.0 green:247.0f/255.0 blue:100.0f/255.0 alpha:0.6f];

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
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

    
    switch (displayType) {
        case TAG:
        {
            detailTableViewController = [[DetailTableViewController alloc] initWithFlag:DETAIL andQRCode:o_qrcodeId];
            
            
            //detailController = [[KandiTableViewController alloc] initWithFlag:DETAIL andQRCode:o_qrcodeId];
            shadedView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
            shadedView.backgroundColor = [UIColor colorWithRed:224.0/255.0 green:224.0/255.0 blue:224.0/255.0 alpha:0.7];
            [self.view addSubview:shadedView];
            
            dismiss = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
            [dismiss addTarget:self action:@selector(removeDetailController) forControlEvents:UIControlEventTouchUpInside];
            dismiss.backgroundColor = [UIColor clearColor];
            [shadedView addSubview:dismiss];
            
            self.tableView.scrollEnabled = NO;
            
            detailTableViewController.tableView.frame = CGRectInset(self.view.bounds, 40, 100);
            detailTableViewController.tableView.backgroundColor = [UIColor whiteColor];
            detailTableViewController.tableView.layer.cornerRadius = 10.0f;
            detailTableViewController.tableView.layer.borderWidth = 0.0f;
            [self.view addSubview:detailTableViewController.tableView];
            [self addChildViewController:detailTableViewController];
            [detailTableViewController didMoveToParentViewController:self];
            [detailTableViewController.tableView reloadData];

            break;
        }
        case KANDI:
        {
            
            shadedView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
            shadedView.backgroundColor = [UIColor colorWithRed:224.0/255.0 green:224.0/255.0 blue:224.0/255.0 alpha:0.7];
            //[self.view addSubview:shadedView];
            dismiss = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
            [dismiss addTarget:self action:@selector(removeViewController) forControlEvents:UIControlEventTouchUpInside];
            dismiss.backgroundColor = [UIColor clearColor];
            //[shadedView addSubview:dismiss];
            
            detailTableViewController = [[DetailTableViewController alloc] initWithFlag:DETAIL andQRCode:o_qrcodeId];
            detailTableViewController.tableView.scrollEnabled = NO;
            self.tableView.scrollEnabled = NO;

            //detailTableViewController.tableView.backgroundColor = [UIColor blackColor];
            detailTableViewController.transitioningDelegate = self;
            detailTableViewController.modalPresentationStyle = UIModalPresentationCustom;
            [self presentViewController:detailTableViewController animated:YES completion:^ {
                [self call];
            }];
            
            
            /*
            
            detailTableViewController = [[DetailTableViewController alloc] initWithFlag:DETAIL andQRCode:o_qrcodeId];
            
            
            //detailController = [[KandiTableViewController alloc] initWithFlag:DETAIL andQRCode:o_qrcodeId];
            shadedView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
            shadedView.backgroundColor = [UIColor colorWithRed:224.0/255.0 green:224.0/255.0 blue:224.0/255.0 alpha:0.7];
            [self.view addSubview:shadedView];
            
            dismiss = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
            [dismiss addTarget:self action:@selector(removeDetailController) forControlEvents:UIControlEventTouchUpInside];
            dismiss.backgroundColor = [UIColor clearColor];
            [shadedView addSubview:dismiss];

            self.tableView.scrollEnabled = NO;
            
            detailTableViewController.tableView.frame = CGRectInset(self.view.bounds, 40, 100);
            detailTableViewController.tableView.backgroundColor = [UIColor whiteColor];
            detailTableViewController.tableView.layer.cornerRadius = 10.0f;
            detailTableViewController.tableView.layer.borderWidth = 0.0f;
            [self.view addSubview:detailTableViewController.tableView];
            [self addChildViewController:detailTableViewController];
            [detailTableViewController didMoveToParentViewController:self];
            [detailTableViewController.tableView reloadData];
            
            */
            
            
            /*
            detailController.tableView.frame = CGRectInset(self.view.bounds, 40, 100);
            //detailController.tableView.frame = self.view.frame;
            //detailController.tableView.backgroundColor = [UIColor colorWithRed:224.0/255.0 green:224.0/255.0 blue:224.0/255.0 alpha:1.0];
            detailController.tableView.backgroundColor = [UIColor whiteColor];
            detailController.tableView.layer.cornerRadius = 10.0f;
            detailController.tableView.layer.borderWidth = 0.0f;
            //detailController.tableView.layer.borderColor = [UIColor blackColor].CGColor;
            [self.view addSubview:detailController.tableView];
            [self addChildViewController:detailController];
            [detailController didMoveToParentViewController:self];

            [detailController.tableView reloadData];
             
             */
             
            break;
        }
        case DETAIL:
        {
            chatController = [[ChatTableViewController alloc] initWithFacebookId:c_facebookId andUserName:c_userName];
            
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

-(void)call {
    NSLog(@"called");
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
            //NSLog(@"tags: %@", tags);
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
                [self.tableView reloadData];
        } else {
           // NSString* error = [jsonResponse objectForKey:@"error"];
            //NSLog(@"%@", error);
        }
    }
    
    [indicator stopAnimating];
    [self hideLoading];
    [self.refreshControl endRefreshing];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

#pragma mark - Transitions

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                  presentingController:(UIViewController *)presenting
                                                                      sourceController:(UIViewController *)source {
    
    animator = [Animator new];
    animator.presenting = YES;
    return animator;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    animator = [Animator new];
    return animator;
}





#pragma mark - extras

-(void)removeViewController {
    [self dismissViewControllerAnimated:YES completion:nil];
    [shadedView removeFromSuperview];
    self.tableView.scrollEnabled = YES;
    NSLog(@"removeViewController");
}

-(void)removeDetailController {
    [detailTableViewController.view removeFromSuperview];
    [detailTableViewController removeFromParentViewController];
    [shadedView removeFromSuperview];
    self.tableView.scrollEnabled = YES;
}

-(void)removeMessagingController {
    [messagingNavController dismissViewControllerAnimated:YES completion:nil];
}

-(void)hideLoading {
    loading.hidden = YES;
}

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
