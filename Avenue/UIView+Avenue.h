//
//  UIView+Avenue.h
//  Avenue
//
//  Created by Zach Kagin on 12/25/16.
//  Copyright © 2016 Zach Kagin. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * A category for making basic layout quicker and more readable.
 */
@interface UIView (LayoutAdditions)

- (instancetype)initForAutolayout;

- (void)centerHorizontallyWithSuperview;
- (void)centerVerticallyWithSuperview;
- (void)resizeHorizontallyWithSuperview;
- (void)resizeHorizontallyWithSuperviewAndPadding:(CGFloat)padding;
- (void)resizeVerticallyWithSuperview;
- (void)pinToBottomOfSuperviewSafeAreaLayoutGuide;
- (void)pinToTopOfSuperviewSafeAreaLayoutGuide;
- (void)pinToTopOfSuperviewWithPadding:(CGFloat)padding;

@end
