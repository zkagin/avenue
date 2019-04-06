//
//  AVGameControlBar.h
//  Avenue
//
//  Created by Zach Kagin on 7/4/17.
//  Copyright © 2017 Zach Kagin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AVGameControlBarDelegate;

/**
 * A bar for controlling and showing updates on the game board.
 */
@interface AVGameControlBar : UIView

- (instancetype)initWithDelegate:(id<AVGameControlBarDelegate>)delegate;

/** The current displayed score. When set to zero, hides this part of the label. */
@property (nonatomic, readwrite) NSUInteger currentScore;

/** The current perfect score. When set to zero, hides this part of the label. */
@property (nonatomic, readwrite) NSUInteger perfectScore;

/** Show the reset action button. */
- (void)showResetActionButton;

/** Hide the reset action button. */
- (void)hideResetActionButton;

@end

@protocol AVGameControlBarDelegate

/** Called when the reset action button is tapped. */
- (void)gameControlBarDidTapActionButton:(AVGameControlBar *)gameControlBar;

@end
