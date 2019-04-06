//
//  AVGameControlBar.m
//  Avenue
//
//  Created by Zach Kagin on 7/4/17.
//  Copyright © 2017 Zach Kagin. All rights reserved.
//

#import "AVGameControlBar.h"

#import "UIView+Avenue.h"

static const CGFloat kScoreFontSize = 18.0f;
static const CGFloat kActionButtonFontSize = 36.0f;

@implementation AVGameControlBar {
    __weak id<AVGameControlBarDelegate> _delegate;
    UILabel *_currentScoreLabel;
    UILabel *_perfectScoreLabel;
    UIButton *_actionButton;
}

#pragma mark - Lifecycle Methods

- (instancetype)initWithDelegate:(id<AVGameControlBarDelegate>)delegate
{
    self = [super init];
    if (self) {
        _delegate = delegate;
        self.currentScore = 0;
        self.perfectScore = 0;
        [self av_setupSubviews];
    }
    return self;
}

- (void)av_setupSubviews
{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    _currentScoreLabel = [[UILabel alloc] init];
    _currentScoreLabel.font = [UIFont systemFontOfSize:kScoreFontSize weight:UIFontWeightHeavy];
    _currentScoreLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_currentScoreLabel];
    
    _perfectScoreLabel = [[UILabel alloc] init];
    _perfectScoreLabel.font = [UIFont systemFontOfSize:kScoreFontSize weight:UIFontWeightHeavy];
    _perfectScoreLabel.textAlignment = NSTextAlignmentRight;
    _perfectScoreLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_perfectScoreLabel];
    
    _actionButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_actionButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _actionButton.titleLabel.font = [UIFont systemFontOfSize:kActionButtonFontSize weight:UIFontWeightHeavy];
    [_actionButton addTarget:self action:@selector(av_didTapActionButton) forControlEvents:UIControlEventTouchUpInside];
    _actionButton.translatesAutoresizingMaskIntoConstraints = NO;
    [_actionButton setTitle:@"\u21ba" forState:UIControlStateNormal];
    [self addSubview:_actionButton];
    
    
    [self addConstraints:
        [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_currentScoreLabel]-[_actionButton]-[_perfectScoreLabel(==_currentScoreLabel)]-|"
                                                options:NSLayoutFormatDirectionLeftToRight
                                                metrics:nil
                                                  views:NSDictionaryOfVariableBindings(_currentScoreLabel, _actionButton, _perfectScoreLabel)]];
    [_currentScoreLabel pinToTopOfSuperviewWithPadding:10.0f];
    [_perfectScoreLabel pinToTopOfSuperviewWithPadding:10.0f];
    [_actionButton resizeVerticallyWithSuperview];

    [_currentScoreLabel setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    [_perfectScoreLabel setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    [_actionButton setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    
    [self av_updateLabelText];
}

#pragma mark - Public Methods

- (void)setCurrentScore:(NSUInteger)currentScore
{
    _currentScore = currentScore;
    [self av_updateLabelText];
}

- (void)setPerfectScore:(NSUInteger)perfectScore
{
    _perfectScore = perfectScore;
    [self av_updateLabelText];
}

- (void)showResetActionButton
{
    _actionButton.hidden = NO;
}

- (void)hideResetActionButton
{
    _actionButton.hidden = YES;
}

#pragma mark - Private Methods

- (void)av_didTapActionButton
{
    [_delegate gameControlBarDidTapActionButton:self];
}

- (void)av_updateLabelText
{
    if (self.currentScore == 0) {
        _currentScoreLabel.text = @"";
    } else {
        _currentScoreLabel.text = [NSString stringWithFormat:@"Current: %ld",(long)self.currentScore];
    }
    if (self.perfectScore == 0) {
        _perfectScoreLabel.text = @"";
    } else {
        _perfectScoreLabel.text = [NSString stringWithFormat:@"Goal: %ld",(long)self.perfectScore];
    }
}

@end
