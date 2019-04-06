//
//  UIView+Avenue.m
//  Avenue
//
//  Created by Zach Kagin on 12/25/16.
//  Copyright © 2016 Zach Kagin. All rights reserved.
//

#import "UIView+Avenue.h"

@implementation UIView (LayoutAdditions)

- (instancetype)initForAutolayout
{
    self = [self init];
    if (self) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return self;
}

- (void)centerHorizontallyWithSuperview
{
    [self.centerXAnchor constraintEqualToAnchor:self.superview.centerXAnchor].active = YES;
}

- (void)centerVerticallyWithSuperview
{
    [self.centerYAnchor constraintEqualToAnchor:self.superview.centerYAnchor].active = YES;
}

- (void)resizeHorizontallyWithSuperview
{
    [self.widthAnchor constraintEqualToAnchor:self.superview.widthAnchor].active = YES;
}

- (void)resizeVerticallyWithSuperview
{
    [self.heightAnchor constraintEqualToAnchor:self.superview.heightAnchor].active = YES;
}

- (void)resizeHorizontallyWithSuperviewAndPadding:(CGFloat)padding
{
    [self.leadingAnchor constraintEqualToAnchor:self.superview.leadingAnchor constant:padding].active = YES;
    [self.trailingAnchor constraintEqualToAnchor:self.superview.trailingAnchor constant:-padding].active = YES;
}

- (void)pinToBottomOfSuperviewSafeAreaLayoutGuide
{
    [self.bottomAnchor constraintEqualToAnchor:self.superview.safeAreaLayoutGuide.bottomAnchor].active = YES;
}

- (void)pinToTopOfSuperviewSafeAreaLayoutGuide
{
    [self.topAnchor constraintEqualToAnchor:self.superview.safeAreaLayoutGuide.topAnchor].active = YES;
}

- (void)pinToTopOfSuperviewWithPadding:(CGFloat)padding
{
    [self.topAnchor constraintEqualToAnchor:self.superview.topAnchor constant:padding].active = YES;
}

@end
