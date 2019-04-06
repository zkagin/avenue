//
//  AVExitBar.m
//  Avenue
//
//  Created by Zach Kagin on 5/29/17.
//  Copyright © 2017 Zach Kagin. All rights reserved.
//

#import "AVExitBar.h"
#import "UIView+Avenue.h"

static const CGFloat kExitButtonFontSize = 34.0f;
static const CGFloat kExitBarHeight = 80.0f;

@implementation AVExitBar {
    UIButton *_exitButton;
    __weak id<AVExitBarDelegate> _delegate;
}

- (instancetype)initWithDelegate:(id<AVExitBarDelegate>)delegate
{
    self = [super init];
    if (self) {
        _delegate = delegate;

        _exitButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_exitButton setTitle:@"\u2716" forState:UIControlStateNormal];
        [_exitButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _exitButton.titleLabel.font = [UIFont systemFontOfSize:kExitButtonFontSize weight:UIFontWeightHeavy];
        [_exitButton addTarget:self action:@selector(av_didTapExitButton) forControlEvents:UIControlEventTouchUpInside];
        _exitButton.translatesAutoresizingMaskIntoConstraints = NO;

        [self addSubview:_exitButton];
        [_exitButton centerVerticallyWithSuperview];
        [_exitButton resizeHorizontallyWithSuperview];
        [self.heightAnchor constraintEqualToConstant:kExitBarHeight].active = YES;
        self.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return self;
}

#pragma mark - Button Actions

- (void)av_didTapExitButton
{
    [_delegate actionBarDidTapExitButton:self];
}

@end
