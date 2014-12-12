//
//  Interactive.h
//  KandiTAG
//
//  Created by Jim Chen on 12/10/14.
//  Copyright (c) 2014 Jim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContainerViewController.h"

@interface Interactive : UIPercentDrivenInteractiveTransition <InteractiveContainerPanTarget>

-(id)initWithParentViewController:(UIViewController *)viewController;

@property (nonatomic, readonly) UIViewController *parentViewController;

-(void)presentMenu;

@end
