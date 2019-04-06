//
//  AVRootViewController.h
//  Avenue
//
//  Created by Zach Kagin on 6/3/17.
//  Copyright © 2017 Zach Kagin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * Overall root container controller for the app.
 */
@interface AVRootViewController : UIViewController

/**
 * Generalized way to animate a transition from one view controller to another one.
 *
 * @param viewController    The viewController to transition to.
 */
+ (void)transitionToViewController:(UIViewController *)viewController;

@end

NS_ASSUME_NONNULL_END
