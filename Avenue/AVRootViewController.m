//
//  AVRootViewController.m
//  Avenue
//
//  Created by Zach Kagin on 6/3/17.
//  Copyright © 2017 Zach Kagin. All rights reserved.
//

#import "AVRootViewController.h"
#import "AVMainViewController.h"

static UIViewController *_currentChildController;   // Currently displayed VC.
static UIViewController *_rootViewController;       // Root container VC.

@implementation AVRootViewController

- (void)viewDidLoad
{
    _rootViewController = self;
    UIViewController *mainViewController = [[AVMainViewController alloc] initWithHasInitialAnimation:YES];
    [self addChildViewController:mainViewController];
    mainViewController.view.frame = self.view.frame;
    [self.view addSubview:mainViewController.view];
    [mainViewController didMoveToParentViewController:self];
    _currentChildController = mainViewController;
}

+ (void)transitionToViewController:(UIViewController *)viewController
{
    [_currentChildController willMoveToParentViewController:nil];
    [_rootViewController addChildViewController:viewController];
    viewController.view.frame = _rootViewController.view.frame;
    
    [_rootViewController transitionFromViewController:_currentChildController
                                     toViewController:viewController
                                             duration:0.3f
                                              options:UIViewAnimationOptionTransitionCrossDissolve
                                           animations:^{ }
                                           completion:^(BOOL finished) {
                                               [_currentChildController removeFromParentViewController];
                                               [viewController didMoveToParentViewController:nil];
                                               _currentChildController = viewController;
                                           }];
}

@end
