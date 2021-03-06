//
//  DetailView.m
//  KandiTAG
//
//  Created by Jim Chen on 12/11/14.
//  Copyright (c) 2014 Jim. All rights reserved.
//

#import "DetailView.h"
#import "AppDelegate.h"

@interface DetailView ()

@end

@implementation DetailView {
    BOOL isfirstTimeTransform;
    UICollectionViewCell *cell;
    UILabel *cellLabel;
    UILabel *nameLabel;
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

#define TRANSFORM_CELL_VALUE CGAffineTransformMakeScale(0.5, 0.5)
#define ANIMATION_SPEED 0.2


-(instancetype)initWithFlag:(DisplayType)flag {
    self = [super init];
    if (self) {
        responseData = [[NSMutableData alloc] init];
        loadedDataSource = NO;
        tags = [[NSMutableArray alloc] init];
        displayType = flag;
        isfirstTimeTransform = YES;
    }
    //return
    return self;
}

-(instancetype)initWithFlag:(DisplayType)flag andQRCode:(NSString*)qrCode {
    self = [self initWithFlag:flag];
    if (self) {
        self.selectedQrCodeId = qrCode;
        [[AppDelegate KandiAppDelegate].network getAllTags:self withQRcode:qrCode];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UICollectionViewFlowLayout *aFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    
    
    [aFlowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 180) collectionViewLayout:aFlowLayout];
    self.view = collectionView;
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    collectionView.pagingEnabled = YES;
    
    //[collectionView setContentInset:UIEdgeInsetsMake(0, self.view.frame.size.width / 4, 0, self.view.frame.size.width / 5)];
    
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    
    
    //[collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGesture:)];
    swipeGesture.direction = UISwipeGestureRecognizerDirectionUp;
    //[collectionView addGestureRecognizer:swipeGesture];
    
    //collectionView.center = self.view.center;
    
}

-(void)handleSwipeGesture {
    NSIndexPath *indexPath = [collectionView indexPathForCell:cell];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return tags.count;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 100, 0, 100);
}


// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
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
    
    cellLabel = [[UILabel alloc] initWithFrame:CGRectMake(-5, -10, 170, cell.bounds.size.height + 40)];
    cellLabel.backgroundColor = [UIColor whiteColor];
    cellLabel.tag = 200;
    
    nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, cell.bounds.size.height - 5, 170, 35)];
    nameLabel.text = c_userName;
    nameLabel.textAlignment = NSTextAlignmentCenter;
    
    cell=[self.collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    
    cell.backgroundColor=[UIColor clearColor];
    cell.layer.borderColor = [UIColor whiteColor].CGColor;
    cell.layer.borderWidth = 3.0f;
    
    UIImageView *userPic = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 160, 160)];
    NSURL *profilePictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?width=160&height=160", c_facebookId]];
    NSData *picData = [NSData dataWithContentsOfURL:profilePictureURL];
    userPic.image = [UIImage imageWithData:picData];
    
    [cell.contentView addSubview:cellLabel];
    [cell.contentView addSubview:nameLabel];
    [cell.contentView addSubview:userPic];
    
    if (indexPath.row == 0 && isfirstTimeTransform) { // make a bool and set YES initially, this check will prevent fist load transform
        isfirstTimeTransform = NO;
    }else{
        cell.transform = TRANSFORM_CELL_VALUE; // the new cell will always be transform and without animation
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Selected Image is Item %d",indexPath.row);
    cell = [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:indexPath.row  inSection:0]];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(160, 160);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    
    float pageWidth = 60 + 100; // width + space
    float currentOffset = scrollView.contentOffset.x;
    float targetOffset = targetContentOffset->x;
    float newTargetOffset = 0;
    
    if (targetOffset > currentOffset)
        newTargetOffset = ceilf(currentOffset / pageWidth) * pageWidth;
    else
        newTargetOffset = floorf(currentOffset / pageWidth) * pageWidth;
    
    if (newTargetOffset < 0)
        newTargetOffset = 0;
    else if (newTargetOffset > scrollView.contentSize.height)
        newTargetOffset = scrollView.contentSize.height;
    targetContentOffset->x = currentOffset;
    [scrollView setContentOffset:CGPointMake(currentOffset, 0) animated:YES];
    
    int index = currentOffset / pageWidth;
    
    if (index == 0) { // If first index
        cell = [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index  inSection:0]];
        //cell.layer.borderWidth = 3.0f;
        //cell.layer.cornerRadius = cell.frame.size.width/2;
        //cell.layer.masksToBounds = YES;
        //cell.clipsToBounds = YES;
        
        [UIView animateWithDuration:ANIMATION_SPEED animations:^{
            cell.transform = CGAffineTransformIdentity;
        }];
        cell = [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index + 1  inSection:0]];
        //cell.layer.borderWidth = 3.0f;
        //cell.layer.cornerRadius = cell.frame.size.width/2;
        //cell.layer.masksToBounds = YES;
        //cell.clipsToBounds = YES;
        [UIView animateWithDuration:ANIMATION_SPEED animations:^{
            cell.transform = TRANSFORM_CELL_VALUE;
        }];
    }else{
        cell = [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
        //cell.layer.borderWidth = 3.0f;
        //cell.layer.cornerRadius = cell.frame.size.width/2;
        //cell.layer.masksToBounds = YES;
        //cell.clipsToBounds = YES;
        [UIView animateWithDuration:ANIMATION_SPEED animations:^{
            cell.transform = CGAffineTransformIdentity;
        }];
        
        index --; // left
        cell = [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
        //cell.layer.borderWidth = 3.0f;
        //cell.layer.cornerRadius = cell.frame.size.width/2;
        //cell.layer.masksToBounds = YES;
        //cell.clipsToBounds = YES;
        [UIView animateWithDuration:ANIMATION_SPEED animations:^{
            cell.transform = TRANSFORM_CELL_VALUE;
        }];
        
        index ++;
        index ++; // right
        cell = [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
        //cell.layer.borderWidth = 3.0f;
        //cell.layer.cornerRadius = cell.frame.size.width/2;
        //cell.layer.masksToBounds = YES;
        //cell.clipsToBounds = YES;
        [UIView animateWithDuration:ANIMATION_SPEED animations:^{
            cell.transform = TRANSFORM_CELL_VALUE;
        }];
    }
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
