//
//  AVGameViewController.m
//  Avenue
//
//  Created by Zach Kagin on 2/9/17.
//  Copyright © 2017 Zach Kagin. All rights reserved.
//

#import "AVGameViewController.h"

#import "AVBoardConfiguration.h"
#import "AVExitBar.h"
#import "AVGameBoardView.h"
#import "AVGameCollectionViewCell.h"
#import "AVGameControlBar.h"
#import "AVGameGraph.h"
#import "AVGlobalStateHelper.h"
#import "AVLevelsViewController.h"
#import "AVMainViewController.h"
#import "AVRootViewController.h"
#import "AVTitleLabel.h"
#import "UIColor+Avenue.h"
#import "UIView+Avenue.h"

CGFloat static const kAnimationDuration = 0.3f;

@interface AVGameViewController () <AVGameBoardViewDelegate, AVExitBarDelegate, AVGameControlBarDelegate>
@end

@implementation AVGameViewController {
    NSInteger _currentLevel;           // The current level being played.
    AVGameBoardView *_gameBoardView;   // The game board itself.
    AVTitleLabel *_titleLabel;         // An updating title label displaying the level.
    AVGameControlBar *_gameControlBar; // The control bar below the board.
    AVExitBar *_exitBar;               // An exit bar to exit this screen.
}

- (instancetype)initWithInitialLevel:(NSUInteger)level
{
    self = [super init];
    if (self) {
        _currentLevel = level;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor backgroundColor];

    _titleLabel = [[AVTitleLabel alloc] init];
    _titleLabel.text = [NSString stringWithFormat:@"Level %ld", (long)_currentLevel];
    [self.view addSubview:_titleLabel];
    [_titleLabel centerHorizontallyWithSuperview];
    [_titleLabel pinToTopOfSuperviewSafeAreaLayoutGuide];

    _gameBoardView = [[AVGameBoardView alloc] initWithDelegate:self];
    [self.view addSubview:_gameBoardView];
    [_gameBoardView resizeHorizontallyWithSuperview];
    [_gameBoardView centerVerticallyWithSuperview];

    _gameControlBar = [[AVGameControlBar alloc] initWithDelegate:self];
    [self.view addSubview:_gameControlBar];
    [_gameControlBar resizeHorizontallyWithSuperview];
    [_gameControlBar.topAnchor constraintEqualToAnchor:_gameBoardView.bottomAnchor constant:0].active = YES;

    _exitBar = [[AVExitBar alloc] initWithDelegate:self];
    [self.view addSubview:_exitBar];
    [_exitBar centerHorizontallyWithSuperview];
    [_exitBar pinToBottomOfSuperviewSafeAreaLayoutGuide];

    // Update everything to start the game.
    [self av_updateGameBoardViewWithCurrentState];
    [_gameBoardView resetBoardWithNewGrid];
}

#pragma mark - UI Helpers

/**
 * Fades the provided views out and then back in, while calling the block in between.
 */
+ (void)av_fadeViewsOutAndIn:(NSArray<UIView *> *)views withBlock:(void (^)(void))block
{
    [UIView animateWithDuration:kAnimationDuration
        animations:^{
            for (UIView *view in views) {
                view.alpha = 0.0f;
            }
        }
        completion:^(BOOL finished) {
            block();
            [UIView animateWithDuration:kAnimationDuration
                             animations:^{
                                 for (UIView *view in views) {
                                     view.alpha = 1.0f;
                                 }
                             }];
        }];
}

/**
 * Updates the game control bar with the current and ideal score.
 * If perfectScore is provided, the reset action button is also shown.
 */
- (void)av_updateActionButtonTextWithCurrentScore:(NSUInteger)score perfectScore:(NSUInteger)perfectScore
{
    _gameControlBar.currentScore = score;
    _gameControlBar.perfectScore = perfectScore;
    if (perfectScore != 0) {
        [_gameControlBar showResetActionButton];
    } else {
        [_gameControlBar hideResetActionButton];
    }
}

#pragma mark - Board Attributes And Updates

- (void)av_updateGameBoardViewWithCurrentState
{
    _gameBoardView.boardSize = [AVBoardConfiguration boardSizeForLevel:_currentLevel];
    _gameBoardView.upperRange = [AVBoardConfiguration boardUpperRangeForLevel:_currentLevel];
    _gameBoardView.colorScale = [AVBoardConfiguration boardColorScaleForLevel:_currentLevel];
    _gameBoardView.randomColors = [AVBoardConfiguration boardRandomColorsForLevel:_currentLevel];
}

#pragma mark - Level Methods

- (void)av_resetCurrentLevel
{
    NSArray *viewsToFade = @[ _gameBoardView, _gameControlBar ];
    [AVGameViewController av_fadeViewsOutAndIn:viewsToFade
                                     withBlock:^{
                                         [self->_gameBoardView resetBoardWithNewGrid];
                                     }];
}

- (void)av_incrementToNewLevel
{
    NSArray *viewsToFade = @[ _titleLabel, _gameBoardView, _gameControlBar ];
    [AVGameViewController av_fadeViewsOutAndIn:viewsToFade
                                     withBlock:^{
                                         self->_currentLevel += 1;
                                         [AVGlobalStateHelper updateMaxLevel:self->_currentLevel];
                                         self->_titleLabel.text =
                                             [NSString stringWithFormat:@"Level %ld", (long)self->_currentLevel];
                                         [self av_updateGameBoardViewWithCurrentState];
                                         [self->_gameBoardView resetBoardWithNewGrid];
                                     }];
}

#pragma mark - AVGameBoardViewDelegate Methods

- (void)gameBoardViewDidCompletePath:(AVGameBoardView *)gameBoardView withScoreDelta:(NSUInteger)scoreDelta
{
    if (scoreDelta == 0) {
        [self av_incrementToNewLevel];
    } else {
        [self av_updateActionButtonTextWithCurrentScore:_gameBoardView.currentScore
                                           perfectScore:_gameBoardView.currentScore - scoreDelta];
    }
}

- (void)gameBoardViewDidUpdateScore:(AVGameBoardView *)gameBoardView
{
    [self av_updateActionButtonTextWithCurrentScore:gameBoardView.currentScore perfectScore:0];
}

#pragma mark - AVExitBarDelegate Methods

- (void)actionBarDidTapExitButton:(AVExitBar *)actionBar
{
    AVLevelsViewController *levelsViewController = [[AVLevelsViewController alloc] initWithInitialLevel:_currentLevel];
    [AVRootViewController transitionToViewController:levelsViewController];
}

#pragma mark - AVGameControlBarDelegate Methods

- (void)gameControlBarDidTapActionButton:(AVGameControlBar *)gameControlBar
{
    [self av_resetCurrentLevel];
}

@end
