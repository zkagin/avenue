//
//  AVMainViewController.h
//  Avenue
//
//  Created by Zach Kagin on 12/25/16.
//  Copyright © 2016 Zach Kagin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * Main view controller for initial list of options.
 */
@interface AVMainViewController : UIViewController

/**
 * Creates a main view controller.
 *
 * @param hasInitialAnimation   Whether or not additional buttons should animate in after load.
 */
- (instancetype)initWithHasInitialAnimation:(BOOL)hasInitialAnimation;

// Unavailable initializers
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;
- (instancetype)initWithNibName:(nullable NSString *)nibNameOrNil
                         bundle:(nullable NSBundle *)nibBundleOrNil NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
