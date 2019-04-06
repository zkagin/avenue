//
//  AVMainViewController.m
//  Avenue
//
//  Created by Zach Kagin on 12/25/16.
//  Copyright © 2016 Zach Kagin. All rights reserved.
//

#import "AVMainViewController.h"

#import "AVGameViewController.h"
#import "AVGlobalStateHelper.h"
#import "AVInstructionViewController.h"
#import "AVLevelsViewController.h"
#import "AVRootViewController.h"
#import "UIColor+Avenue.h"
#import "UIView+Avenue.h"

static const CGFloat kIntroContainerBuffer = 16.0f;
static const CGFloat kIntroButtonFontSize = 32.0f;
static const CGFloat kAnimationDuration = 0.8f;
static const CGFloat kAnimationDelay = 0.8f;

@implementation AVMainViewController {
    BOOL _hasInitialAnimation;
    UIStackView *_containerStackView;
}

#pragma mark - Lifecycle Methods

- (instancetype)initWithHasInitialAnimation:(BOOL)hasInitialAnimation
{
    self = [super init];
    if (self) {
        _hasInitialAnimation = hasInitialAnimation;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor backgroundColor];

    // Create main stack view and set up constraints.
    _containerStackView = [AVMainViewController av_createStackView];
    [self.view addSubview:_containerStackView];
    [_containerStackView resizeHorizontallyWithSuperview];
    [_containerStackView centerVerticallyWithSuperview];

    // Create action buttons and add to the stack view.
    UIButton *titleButton = [AVMainViewController av_createActionButtonWithTitle:@"Avenue" isBold:YES];
    UIButton *playButton = [AVMainViewController av_createActionButtonWithTitle:@"Play" isBold:NO];
    UIButton *howToPlayButton = [AVMainViewController av_createActionButtonWithTitle:@"How to play" isBold:NO];
    [_containerStackView addArrangedSubview:titleButton];
    [_containerStackView addArrangedSubview:playButton];
    [_containerStackView addArrangedSubview:howToPlayButton];

    // If there is an initial animation, the Play and How to play buttons start hidden.
    if (_hasInitialAnimation) {
        playButton.hidden = YES;
        howToPlayButton.hidden = YES;
        playButton.alpha = 0;
        howToPlayButton.alpha = 0;
    }

    // Set up button targets.
    [playButton addTarget:self action:@selector(av_didTapPlay) forControlEvents:UIControlEventTouchUpInside];
    [howToPlayButton addTarget:self action:@selector(av_didTapHowToPlay) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewDidAppear:(BOOL)animated
{
    // If there is an initial animation, the Play and How to play buttons will appear here.
    if (_hasInitialAnimation) {
        UIView *playButton = _containerStackView.arrangedSubviews[1];
        UIView *howToPlayButton = _containerStackView.arrangedSubviews[2];
        [UIView animateWithDuration:kAnimationDuration
            delay:kAnimationDelay
            options:UIViewAnimationOptionCurveEaseInOut
            animations:^{
                playButton.hidden = NO;
                howToPlayButton.hidden = NO;
            }
            completion:^(BOOL finished) {
                [UIView animateWithDuration:kAnimationDuration
                                 animations:^{
                                     playButton.alpha = 1;
                                     howToPlayButton.alpha = 1;
                                 }
                                 completion:nil];
            }];
    }
}

#pragma mark - View Creation Methods

+ (UIStackView *)av_createStackView
{
    UIStackView *stackView = [[UIStackView alloc] initForAutolayout];
    stackView.axis = UILayoutConstraintAxisVertical;
    stackView.distribution = UIStackViewDistributionEqualCentering;
    stackView.spacing = kIntroContainerBuffer;
    return stackView;
}

+ (UIButton *)av_createActionButtonWithTitle:(NSString *)title isBold:(BOOL)isBold
{
    UIButton *actionButton = [[UIButton alloc] initForAutolayout];
    [actionButton setTitle:title forState:UIControlStateNormal];
    [actionButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    UIFontWeight fontWeight = isBold ? UIFontWeightBold : UIFontWeightMedium;
    actionButton.titleLabel.font = [UIFont systemFontOfSize:kIntroButtonFontSize weight:fontWeight];

    return actionButton;
}

#pragma mark - Action Methods

- (void)av_didTapHowToPlay
{
    AVInstructionViewController *howToPlayViewController = [[AVInstructionViewController alloc] init];
    [AVRootViewController transitionToViewController:howToPlayViewController];
}

- (void)av_didTapPlay
{
    NSUInteger maxLevel = [AVGlobalStateHelper maxLevel];
    if (maxLevel == 1) {
        // If the user has never completed a level, Play jumps straight to the game instead of the levels controller.
        UIViewController *gameController = [[AVGameViewController alloc] initWithInitialLevel:maxLevel];
        [AVRootViewController transitionToViewController:gameController];
    } else {
        UIViewController *levelsViewController = [[AVLevelsViewController alloc] initWithInitialLevel:maxLevel];
        [AVRootViewController transitionToViewController:levelsViewController];
    }
}

@end
