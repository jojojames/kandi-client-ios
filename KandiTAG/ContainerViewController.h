//
//  ContainerViewController.h
//  KandiTAG
//
//  Created by Jim Chen on 12/10/14.
//  Copyright (c) 2014 Jim. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ContainerViewController;

@protocol InteractiveContainerPanTarget <NSObject>

-(void)userDidPan:(UIScreenEdgePanGestureRecognizer*)gestureRecognizer;

@end

@interface ContainerViewController : UIViewController

-(id)initWithPanTarget:(id<InteractiveContainerPanTarget>)panTarget;

@property (nonatomic, readonly) id<InteractiveContainerPanTarget> panTarget;

@end
