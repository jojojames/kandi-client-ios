//
//  PageViewController.m
//  KandiTAG
//
//  Created by Jim Chen on 9/29/14.
//  Copyright (c) 2014 Jim. All rights reserved.
//

#import "PageViewController.h"
#import "KandiTagNavigationController.h"
#import "QRScannerViewController.h"

@interface PageViewController ()

@end

@implementation PageViewController {
    NSArray *myViewControllers;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self;
    self.dataSource = self;
    
    //UIViewController *vc1 = [self.storyboard instantiateViewControllerWithIdentifier:@"MainViewController"];
    
    UIViewController* vc1 = [[QRScannerViewController alloc] init];
    
    UITableViewController *vc2 = [self.storyboard instantiateViewControllerWithIdentifier:@"Tag"];
    UIViewController *vc3 = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingsViewController"];
    //UITableViewController *vc4 = [self.storyboard instantiateViewControllerWithIdentifier:@"Kandi"];
    
    UINavigationController *vc4 = [[KandiTagNavigationController alloc] init];
    
    myViewControllers = @[vc1, vc2, vc3, vc4];
    
    [self setViewControllers:@[vc2] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    BOOL didRunbefore = [[NSUserDefaults standardUserDefaults] boolForKey:@"didRunBefore"];
    
    if (!didRunbefore) {
        
        UIAlertView *welcomeAlert = [[UIAlertView alloc] initWithTitle:@"Welcome!" message:@"To get started, scan a KandiTAG" delegate:self cancelButtonTitle:@"Got it!" otherButtonTitles:nil, nil];
        
        [welcomeAlert show];
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"didRunBefore"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
}
  

-(UIViewController *)viewControllerAtIndex:(NSUInteger)index
{
    return myViewControllers[index];
}

#pragma mark - Page View Controller Data Source

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController
     viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger currentIndex = [myViewControllers indexOfObject:viewController];
    
    --currentIndex;
    currentIndex = currentIndex % (myViewControllers.count);
    
    if (currentIndex == NSNotFound) {
        return nil;
    }
    return [myViewControllers objectAtIndex:currentIndex];
}

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController
      viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger currentIndex = [myViewControllers indexOfObject:viewController];
    
    ++currentIndex;
    currentIndex = currentIndex % (myViewControllers.count);
    
    if (currentIndex == NSNotFound) {
        return nil;
    }
    
    return [myViewControllers objectAtIndex:currentIndex];
    
}
 
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
