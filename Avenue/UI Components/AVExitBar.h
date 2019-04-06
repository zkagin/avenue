//
//  AVExitBar.h
//  Avenue
//
//  Created by Zach Kagin on 5/29/17.
//  Copyright © 2017 Zach Kagin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AVExitBarDelegate;

/**
 * A view containing an exit button, which will call the delegate when tapped.
 */
@interface AVExitBar : UIView

- (instancetype)initWithDelegate:(id<AVExitBarDelegate>)delegate;

@end

@protocol AVExitBarDelegate

/**
 * Called when the exit button is tapped.
 */
- (void)actionBarDidTapExitButton:(AVExitBar *)actionBar;

@end
