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

@interface KandiTableViewController ()

@end

@implementation KandiTableViewController
@synthesize responseData;
@synthesize loadedDataSource;
@synthesize tags;
@synthesize displayType;
@synthesize selectedQrCodeId;
@synthesize indicator;

#define ORIGINAL @"original"
#define CURRENT @"current"
#define QRCODE_ID @"qrcode_id"
#define USER_ID @"user_id"
#define PLACEMENT @"placement"
#define OWNERSHIP_ID @"ownership_id"
#define USER_NAME @"user_name"
#define FACEBOOK_ID @"facebookid"

-(instancetype)initWithFlag:(DisplayType)flag {
    self = [super init];
    if (self) {
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

-(void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[KandiTableViewCell class] forCellReuseIdentifier:@"KandiTableViewCell"];
}

-(void)viewWillAppear:(BOOL)animated {
    indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
    indicator.center = self.view.center;
    [self.view addSubview:indicator];
    [indicator bringSubviewToFront:self.view];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = TRUE;
    
    switch (displayType) {
        case TAG:
            self.title = @"Tags";
            [[AppDelegate KandiAppDelegate].network getCurrentTags:self];
            [indicator startAnimating];
            break;
        case KANDI:
            self.title = @"Kandi";
            [[AppDelegate KandiAppDelegate].network getOriginalTags:self];
            [indicator startAnimating];
            break;
        case DETAIL:
            self.title = @"Detail";
            [[AppDelegate KandiAppDelegate].network getAllTags:self withQRcode:self.selectedQrCodeId];
            [indicator startAnimating];
            break;
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


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"KandiTableViewCell";
    
    KandiTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[KandiTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.backgroundColor = [UIColor whiteColor];
    
    NSDictionary* json = [tags objectAtIndex:indexPath.row];
    NSDictionary* original = [json objectForKey:ORIGINAL];
    NSDictionary* current = [json objectForKey:CURRENT];
    
    NSString* o_qrcodeId = [original objectForKey:QRCODE_ID];
    NSString* o_userId = [original objectForKey:USER_ID];
    NSString* o_placement = [original objectForKey:PLACEMENT];
    NSString* o_ownershipId = [original objectForKey:OWNERSHIP_ID];
    NSString* c_userId = [current objectForKey:USER_ID];
    NSString* c_userName = [current objectForKey:USER_NAME];
    NSString* c_facebookId = [current objectForKey:FACEBOOK_ID];
    
    cell.textLabel.text = c_userName;
    [cell setImageUsingFacebookId:c_facebookId];
    return cell;
}

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary* json = [tags objectAtIndex:indexPath.row];
    NSDictionary* original = [json objectForKey:ORIGINAL];
    NSDictionary* current = [json objectForKey:CURRENT];
    
    NSString* o_qrcodeId = [original objectForKey:QRCODE_ID];
    NSString* o_userId = [original objectForKey:USER_ID];
    NSString* o_placement = [original objectForKey:PLACEMENT];
    NSString* o_ownershipId = [original objectForKey:OWNERSHIP_ID];
    
    NSString* c_userId = [current objectForKey:USER_ID];
    NSString* c_userName = [current objectForKey:USER_NAME];
    NSString* c_facebookId = [current objectForKey:FACEBOOK_ID];
    
    switch (displayType) {
        case TAG:
        {
            KandiTableViewController* detailController = [[KandiTableViewController alloc] initWithFlag:DETAIL andQRCode:o_qrcodeId];
            [self.navigationController pushViewController:detailController animated:YES];
            break;
        }
        case KANDI:
        {
            KandiTableViewController* detailController = [[KandiTableViewController alloc] initWithFlag:DETAIL andQRCode:o_qrcodeId];
            [self.navigationController pushViewController:detailController animated:YES];
            break;
        }
        case DETAIL:
        {
            KandiProfileViewController* profileController = [[KandiProfileViewController alloc] initWithFacebookId:c_facebookId];
            [self.navigationController pushViewController:profileController animated:YES];
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
            for (int i=0; i<[jsonArray count]; i++) {
                NSDictionary* json = [jsonArray objectAtIndex:i];
                loadedDataSource = YES;
                if ([json count]) {
                    // we'll consider it a success if there's any json
                    NSDictionary* original = [json objectForKey:ORIGINAL];
                    NSDictionary* current = [json objectForKey:CURRENT];
                    
                    NSString* o_qrcodeId = [original objectForKey:QRCODE_ID];
                    NSString* o_userId = [original objectForKey:USER_ID];
                    NSString* o_placement = [original objectForKey:PLACEMENT];
                    NSString* o_ownershipId = [original objectForKey:OWNERSHIP_ID];
                    
                    NSString* c_userId = [current objectForKey:USER_ID];
                    NSString* c_userName = [current objectForKey:USER_NAME];
                    NSString* c_facebookId = [current objectForKey:FACEBOOK_ID];
                }
            }
            
            if (loadedDataSource)
                [self.tableView reloadData];
        } else {
            NSString* error = [jsonResponse objectForKey:@"error"];
            NSLog(@"%@", error);
        }
    }
    
    [indicator stopAnimating];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

@end
