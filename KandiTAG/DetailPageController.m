//
//  DetailPageController.m
//  KandiTAG
//
//  Created by Jim Chen on 12/13/14.
//  Copyright (c) 2014 Jim. All rights reserved.
//

#import "DetailPageController.h"
#import "AppDelegate.h"
#import "Sender.h"
#import "DetailViewController.h"

@interface DetailPageController ()

@end

@implementation DetailPageController {
    NSArray *profilePages;
    Sender *sender;
    NSMutableArray *nameList;
    NSMutableArray *fbIdList;
    DetailViewController *dvc1;
    DetailViewController *dvc2;
    DetailViewController *dvc3;
    DetailViewController *dvc4;
    DetailViewController *dvc5;
}

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
        fbIdList = [[NSMutableArray alloc] init];
        nameList = [[NSMutableArray alloc] init];
        displayType = flag;
    }
    
    return self;
}

-(instancetype)initWithFlag:(DisplayType)flag andQRCode:(NSString*)qrCode andTransitionStyle:(UIPageViewControllerTransitionStyle)transitionStyle{
    self = [self initWithFlag:flag];
    if (self) {
        self.selectedQrCodeId = qrCode;
        [[AppDelegate KandiAppDelegate].network getAllTags:self withQRcode:qrCode];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.delegate = self;
    self.dataSource = self;

    
}

-(UIViewController *)viewControllerAtIndex:(NSUInteger)index {
    return profilePages[index];
}

#pragma mark - Page View Controller Data Source

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController
     viewControllerBeforeViewController:(UIViewController *)viewController {
    NSUInteger currentIndex = [profilePages indexOfObject:viewController];
    
    if (profilePages.count > 1) {
    --currentIndex;
    currentIndex = currentIndex % (profilePages.count);
    
    if (currentIndex == NSNotFound) {
        
        return nil;
    }
    

    return [profilePages objectAtIndex:currentIndex];
    }
    return nil;
}

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController
      viewControllerAfterViewController:(UIViewController *)viewController {
    NSUInteger currentIndex = [profilePages indexOfObject:viewController];
    
    
    if (profilePages.count > 1) {
    ++currentIndex;
    currentIndex = currentIndex % (profilePages.count);
    
        
    if (currentIndex == NSNotFound) {
        
        return nil;
    }
    

    return [profilePages objectAtIndex:currentIndex];
    }
    return nil;
    
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
            
            for (json in tags) {
                sender = [Sender new];
                sender.facebookID = [[json objectForKey:CURRENT] objectForKey:FACEBOOK_ID];
                [fbIdList addObject:sender.facebookID];
            }
            
            for (json in tags) {
                sender = [Sender new];
                sender.userName = [[json objectForKeyedSubscript:CURRENT] objectForKey:USER_NAME];
                [nameList addObject:sender.userName];
            }
            
            int count = fbIdList.count;
            NSLog(@"count: %d", count);
            
            switch (count) {
                case 1:
                    dvc1 = [[DetailViewController alloc] initWithFacebookId:fbIdList[0] name:nameList[0] placement:1];
                    profilePages = @[dvc1];
                    [self setViewControllers:@[dvc1] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];

                    NSLog(@"case 1");
                    break;
                case 2:
                    dvc1 = [[DetailViewController alloc] initWithFacebookId:fbIdList[0] name:nameList[0] placement:1];
                    dvc2 = [[DetailViewController alloc] initWithFacebookId:fbIdList[1] name:nameList[1] placement:2];
                    [self setViewControllers:@[dvc2] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
                    profilePages = @[dvc1, dvc2];
                    NSLog(@"case 2");
                    break;
                case 3:
                    dvc1 = [[DetailViewController alloc] initWithFacebookId:fbIdList[0] name:nameList[0] placement:1];
                    dvc2 = [[DetailViewController alloc] initWithFacebookId:fbIdList[1] name:nameList[1] placement:2];
                    dvc3 = [[DetailViewController alloc] initWithFacebookId:fbIdList[2] name:nameList[2] placement:3];
                    [self setViewControllers:@[dvc3] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];

                    profilePages = @[dvc1, dvc2, dvc3];
                    NSLog(@"case 3");
                    break;
                case 4:
                    dvc1 = [[DetailViewController alloc] initWithFacebookId:fbIdList[0] name:nameList[0] placement:1];
                    dvc2 = [[DetailViewController alloc] initWithFacebookId:fbIdList[1] name:nameList[1] placement:2];
                    dvc3 = [[DetailViewController alloc] initWithFacebookId:fbIdList[2] name:nameList[2] placement:3];
                    dvc4 = [[DetailViewController alloc] initWithFacebookId:fbIdList[3] name:nameList[3] placement:4];
                    [self setViewControllers:@[dvc4] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
                    profilePages = @[dvc1, dvc2, dvc3, dvc4];
                    NSLog(@"case 4");
                    break;
                case 5:
                    dvc1 = [[DetailViewController alloc] initWithFacebookId:fbIdList[0] name:nameList[0] placement:1];
                    dvc2 = [[DetailViewController alloc] initWithFacebookId:fbIdList[1] name:nameList[1] placement:2];
                    dvc3 = [[DetailViewController alloc] initWithFacebookId:fbIdList[2] name:nameList[2] placement:3];
                    dvc4 = [[DetailViewController alloc] initWithFacebookId:fbIdList[3] name:nameList[3] placement:4];
                    dvc5 = [[DetailViewController alloc] initWithFacebookId:fbIdList[4] name:nameList[4] placement:5];
                    [self setViewControllers:@[dvc5] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
                    profilePages = @[dvc1, dvc2, dvc3, dvc4, dvc5];
                    NSLog(@"case 5");
                    break;
                    
                default:
                    break;
            }
            
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
                [collectionView reloadData];
            NSLog(@"detailView tableView reloadData");
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
