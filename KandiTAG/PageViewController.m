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
#import "Constants.h"
#import "AppDelegate.h"
#import "MessagingNavigationController.h"
#import "KandiTableViewController.h"

@interface PageViewController () {
    UIButton *left;
    UIButton *right;
    UIViewController *vc1;
    UINavigationController *vc2;
    UINavigationController *vc3;
    UINavigationController *vc4;
    UIViewController *settingsVC;
    UIButton *settingsgear;
    UIButton *camera;
    UIButton *camera1;
    UIButton *messages;
    UIButton *tag;
    UIButton *tag1;
    UIButton *kandi;
    UIButton *add;
}

@end

@implementation PageViewController {
    NSArray *myViewControllers;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self;
    self.dataSource = self;
    
    vc1 = [[QRScannerViewController alloc] init];
    
    vc2 = [[KandiTagNavigationController alloc] initWithFlag:KANDI];
    
    vc3 = [[KandiTagNavigationController alloc] initWithFlag:TAG];
    
    vc4 =[[KandiTagNavigationController alloc] initWithFlag:MESSAGE];
    
    settingsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingsViewController"];
    
    myViewControllers = @[vc1, vc2, vc3, vc4];
    
    [self setViewControllers:@[vc1] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    BOOL didRunbefore = [[NSUserDefaults standardUserDefaults] boolForKey:@"didRunBefore"];
    
    if (!didRunbefore) {
        UIAlertView *welcomeAlert = [[UIAlertView alloc] initWithTitle:@"Welcome!" message:@"To get started, scan a KandiTAG" delegate:self cancelButtonTitle:@"Got it!" otherButtonTitles:nil, nil];
        [welcomeAlert show];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"didRunBefore"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    //buttons on qrscanner
    left = [[UIButton alloc] initWithFrame:CGRectMake(10, self.view.frame.size.height - 60, 50, 50)];
    [left setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
    [left addTarget:self action:@selector(reverseMessages) forControlEvents:UIControlEventTouchUpInside];
    [vc1.view addSubview:left];
    
    right = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 60, self.view.frame.size.height - 60, 50, 50)];
    [right setImage:[UIImage imageNamed:@"right"] forState:UIControlStateNormal];
    [right addTarget:self action:@selector(kandi) forControlEvents:UIControlEventTouchUpInside];
    [vc1.view addSubview:right];
    
    settingsgear = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2.36, self.view.frame.size.height - 60, 50, 50)];
    [settingsgear setImage:[UIImage imageNamed:@"gears"] forState:UIControlStateNormal];
    [settingsgear addTarget:self action:@selector(settings) forControlEvents:UIControlEventTouchUpInside];
    [vc1.view addSubview:settingsgear];
    
    //camera button on kandi
    camera = [[UIButton alloc] initWithFrame:CGRectMake(15, 25, 30, 30)];
    [camera setImage:[UIImage imageNamed:@"qrScannerButton"] forState:UIControlStateNormal];
    [camera addTarget:self action:@selector(camera) forControlEvents:UIControlEventTouchUpInside];
    [vc2.view addSubview:camera];
    
    //camera button on message
    camera1 = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 45, 25, 30, 30)];
    [camera1 setImage:[UIImage imageNamed:@"qrScannerButton"] forState:UIControlStateNormal];
    [camera1 addTarget:self action:@selector(camera) forControlEvents:UIControlEventTouchUpInside];
    [vc4.view addSubview:camera1];
    
    //tag button on message
    tag = [[UIButton alloc] initWithFrame:CGRectMake(15, 25, 30, 30)];
    [tag setImage:[UIImage imageNamed:@"tagIcon"] forState:UIControlStateNormal];
    [tag addTarget:self action:@selector(reverseTag) forControlEvents:UIControlEventTouchUpInside];
    [vc4.view addSubview:tag];
    
    //tag button on kandi
    tag1 = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 45, 25, 30, 30)];
    [tag1 setImage:[UIImage imageNamed:@"tagIcon"] forState:UIControlStateNormal];
    [tag1 addTarget:self action:@selector(tag) forControlEvents:UIControlEventTouchUpInside];
    [vc2.view addSubview:tag1];
    
    //kandi button on tag
    kandi = [[UIButton alloc] initWithFrame:CGRectMake(15, 25, 30, 30)];
    [kandi setImage:[UIImage imageNamed:@"kandiIcon"] forState:UIControlStateNormal];
    [kandi addTarget:self action:@selector(reverseKandi) forControlEvents:UIControlEventTouchUpInside];
    [vc3.view addSubview:kandi];
    
    //message button on tag
    messages = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 45, 25, 30, 30)];
    [messages setImage:[UIImage imageNamed:@"messageIcon"] forState:UIControlStateNormal];
    [messages addTarget:self action:@selector(messages) forControlEvents:UIControlEventTouchUpInside];
    [vc3.view addSubview:messages];
    
    add = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 45, 25, 30, 30)];
    [add setImage:[UIImage imageNamed:@"addButton"] forState:UIControlStateNormal];
    [add addTarget:self action:@selector(addKandiTag) forControlEvents:UIControlEventTouchUpInside];
    //[settingsVC.view addSubview:add];
    
    [left bringSubviewToFront:vc1.view];
    [right bringSubviewToFront:vc1.view];
    [settingsgear bringSubviewToFront:vc1.view];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [vc1.view addSubview:left];
    [vc1.view addSubview:right];
    [vc1.view addSubview:settingsgear];
    [vc2.view addSubview:camera];
    [vc4.view addSubview:camera1];
    [vc4.view addSubview:tag];
    [vc2.view addSubview:tag1];
    [vc3.view addSubview:kandi];
    [vc3.view addSubview:messages];
    [left bringSubviewToFront:vc1.view];
    [right bringSubviewToFront:vc1.view];
    [settingsgear bringSubviewToFront:vc1.view];
    
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:NO];
    
    [vc1.view addSubview:left];
    [vc1.view addSubview:right];
    [vc1.view addSubview:settingsgear];
    [vc2.view addSubview:camera];
    [vc4.view addSubview:camera1];
    [vc4.view addSubview:tag];
    [vc2.view addSubview:tag1];
    [vc3.view addSubview:kandi];
    [vc3.view addSubview:messages];
    [left bringSubviewToFront:vc1.view];
    [right bringSubviewToFront:vc1.view];
    [settingsgear bringSubviewToFront:vc1.view];
}

-(void)addKandiTag {
    NSLog(@"need to add kanditag");
}

-(void)messages {
    [self setViewControllers:@[vc4] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];

}

-(void)reverseMessages {
    [self setViewControllers:@[vc4] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];

}

-(void)camera {
    [self setViewControllers:@[vc1] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
}

-(void)settings {
    
    settingsVC.view.frame = self.view.bounds;
    [self.view addSubview:settingsVC.view];
    [self addChildViewController:settingsVC];
    [settingsVC didMoveToParentViewController:self];

    [vc1.view addSubview:left];
    [vc1.view addSubview:right];
    [vc1.view addSubview:settingsgear];
    [vc2.view addSubview:camera];
    [vc4.view addSubview:camera1];
    [vc4.view addSubview:tag];
    [vc2.view addSubview:tag1];
    [vc3.view addSubview:kandi];
    [vc3.view addSubview:messages];
    [left bringSubviewToFront:vc1.view];
    [right bringSubviewToFront:vc1.view];
    [settingsgear bringSubviewToFront:vc1.view];
}

-(void)kandi {
    [self setViewControllers:@[vc2] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];

}

-(void)reverseKandi {
    [self setViewControllers:@[vc2] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];

}

-(void)tag {
    [self setViewControllers:@[vc3] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];

}

-(void)reverseTag {
    [self setViewControllers:@[vc3] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];

}

-(UIViewController *)viewControllerAtIndex:(NSUInteger)index {
    return myViewControllers[index];
}

#pragma mark - Page View Controller Data Source

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController
     viewControllerBeforeViewController:(UIViewController *)viewController {
    NSUInteger currentIndex = [myViewControllers indexOfObject:viewController];
    
    --currentIndex;
    currentIndex = currentIndex % (myViewControllers.count);
    
    if (currentIndex == NSNotFound) {

        return nil;
    }
    
    [vc1.view addSubview:left];
    [vc1.view addSubview:right];
    [vc1.view addSubview:settingsgear];
    [vc2.view addSubview:camera];
    [vc4.view addSubview:camera1];
    [vc4.view addSubview:tag];
    [vc2.view addSubview:tag1];
    [vc3.view addSubview:kandi];
    [vc3.view addSubview:messages];
    [left bringSubviewToFront:vc1.view];
    [right bringSubviewToFront:vc1.view];
    [settingsgear bringSubviewToFront:vc1.view];
    return [myViewControllers objectAtIndex:currentIndex];
}

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController
      viewControllerAfterViewController:(UIViewController *)viewController {
    NSUInteger currentIndex = [myViewControllers indexOfObject:viewController];
    
    ++currentIndex;
    currentIndex = currentIndex % (myViewControllers.count);
    
    if (currentIndex == NSNotFound) {

        return nil;
    }
    
    [vc1.view addSubview:left];
    [vc1.view addSubview:right];
    [vc1.view addSubview:settingsgear];
    [vc2.view addSubview:camera];
    [vc4.view addSubview:camera1];
    [vc4.view addSubview:tag];
    [vc2.view addSubview:tag1];
    [vc3.view addSubview:kandi];
    [vc3.view addSubview:messages];
    [left bringSubviewToFront:vc1.view];
    [right bringSubviewToFront:vc1.view];
    [settingsgear bringSubviewToFront:vc1.view];
    return [myViewControllers objectAtIndex:currentIndex];
    
}
 
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
