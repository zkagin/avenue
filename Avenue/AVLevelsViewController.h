//
//  AVLevelsViewController.h
//  Avenue
//
//  Created by Zach Kagin on 12/25/16.
//  Copyright © 2016 Zach Kagin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * A VC for selecting which level to play.
 */
@interface AVLevelsViewController : UIViewController

/**
 * Creates a level controller.
 *
 * @param level Which level to have selected on load. Setting to 0 will default to the maximum available level.
 */
- (instancetype)initWithInitialLevel:(NSUInteger)level;

// Unavailable initializers
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;
- (instancetype)initWithNibName:(nullable NSString *)nibNameOrNil
                         bundle:(nullable NSBundle *)nibBundleOrNil NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
