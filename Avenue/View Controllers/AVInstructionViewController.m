//
//  AVInstructionViewController.m
//  Avenue
//
//  Created by Zach Kagin on 9/2/17.
//  Copyright © 2017 Zach Kagin. All rights reserved.
//

#import "AVInstructionViewController.h"

#import "AVExitBar.h"
#import "AVMainViewController.h"
#import "AVRootViewController.h"
#import "AVTitleLabel.h"
#import "UIColor+Avenue.h"
#import "UIView+Avenue.h"

@interface AVInstructionViewController () <AVExitBarDelegate>
@end

@implementation AVInstructionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor backgroundColor];

    UILabel *instructionsLabel = [[UILabel alloc] init];
    instructionsLabel.translatesAutoresizingMaskIntoConstraints = NO;
    instructionsLabel.font = [UIFont systemFontOfSize:22.0f weight:UIFontWeightRegular];
    NSString *instructionsString = @"1. Start at the top left corner.\n"
                                   @"2. Get to the bottom right corner with the lowest sum of numbers.\n"
                                   @"3. Swipe or tap to move or undo.";
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.paragraphSpacing = 15.0f;
    NSDictionary *attributes = @{NSParagraphStyleAttributeName : paragraphStyle};
    instructionsLabel.attributedText = [[NSAttributedString alloc] initWithString:instructionsString
                                                                       attributes:attributes];
    instructionsLabel.numberOfLines = 0;
    instructionsLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self.view addSubview:instructionsLabel];
    [instructionsLabel resizeHorizontallyWithSuperviewAndPadding:25.0f];
    [instructionsLabel centerVerticallyWithSuperview];

    AVTitleLabel *titleLabel = [[AVTitleLabel alloc] init];
    titleLabel.text = @"How to play";
    [self.view addSubview:titleLabel];
    [titleLabel centerHorizontallyWithSuperview];
    [titleLabel pinToTopOfSuperviewSafeAreaLayoutGuide];

    AVExitBar *exitBar = [[AVExitBar alloc] initWithDelegate:self];
    [self.view addSubview:exitBar];
    [exitBar centerHorizontallyWithSuperview];
    [exitBar pinToBottomOfSuperviewSafeAreaLayoutGuide];
}

#pragma mark - AVExitBarDelegate Methods

- (void)actionBarDidTapExitButton:(AVExitBar *)actionBar
{
    AVMainViewController *mainViewController = [[AVMainViewController alloc] initWithHasInitialAnimation:NO];
    [AVRootViewController transitionToViewController:mainViewController];
}

@end
