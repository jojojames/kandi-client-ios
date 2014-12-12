//
//  ContainerViewController.m
//  KandiTAG
//
//  Created by Jim Chen on 12/10/14.
//  Copyright (c) 2014 Jim. All rights reserved.
//

#import "ContainerViewController.h"
#import "Interactive.h"

@implementation ContainerViewController

-(id)initWithPanTarget:(id<InteractiveContainerPanTarget>)panTarget
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _panTarget = panTarget;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Just to differentiate use visually
    self.view.backgroundColor = [UIColor orangeColor];
    
    // Set up our done button
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [doneButton setTitle:@"Dismiss" forState:UIControlStateNormal];
    [doneButton addTarget:self action:@selector(doneWasPressed:) forControlEvents:UIControlEventTouchUpInside];
    doneButton.frame = CGRectMake(0, 0, 100, 44);
    doneButton.center = self.view.center;
    [self.view addSubview:doneButton];
    
    UIScreenEdgePanGestureRecognizer *gestureRecognizer = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self.panTarget action:@selector(userDidPan:)];
    gestureRecognizer.edges = UIRectEdgeRight;
    [self.view addGestureRecognizer:gestureRecognizer];
}

-(void)doneWasPressed:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
