//
//  AVLevelsViewController.m
//  Avenue
//
//  Created by Zach Kagin on 12/25/16.
//  Copyright © 2016 Zach Kagin. All rights reserved.
//

#import "AVExitBar.h"
#import "AVTitleBar.h"
#import "AVMainViewController.h"
#import "AVRootViewController.h"
#import "AVLevelsViewController.h"
#import "AVLevelCollectionViewCell.h"
#import "AVGameViewController.h"
#import "AVGlobalStateHelper.h"
#import "UIView+Avenue.h"
#import "UIColor+Avenue.h"

NSString * const kLevelCellReuseIdentifier = @"kLevelCellReuseIdentifier";
static const CGFloat kLevelButtonSpacing = 12.0f;

@interface AVLevelsViewController () <AVExitBarDelegate>
@end

@implementation AVLevelsViewController {
    NSUInteger _maxLevel;
    UICollectionViewFlowLayout *_levelsLayout;
    UICollectionView *_levelsGrid;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _maxLevel = [AVGlobalStateHelper maxLevel];
    
    self.view.backgroundColor = [UIColor backgroundColor];
    
    _levelsLayout = [[UICollectionViewFlowLayout alloc] init];
    _levelsLayout.minimumInteritemSpacing = kLevelButtonSpacing;
    _levelsLayout.minimumLineSpacing = kLevelButtonSpacing;
    _levelsGrid = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:_levelsLayout];
    _levelsGrid.dataSource = self;
    _levelsGrid.delegate = self;
    _levelsGrid.backgroundColor = [UIColor clearColor];
    _levelsGrid.showsVerticalScrollIndicator = NO;
    _levelsGrid.translatesAutoresizingMaskIntoConstraints = NO;
    [_levelsGrid registerClass:[AVLevelCollectionViewCell class] forCellWithReuseIdentifier:kLevelCellReuseIdentifier];
    
    [self.view addSubview:_levelsGrid];
    [_levelsGrid resizeHorizontallyWithSuperviewAndDefaultPadding];
    [_levelsGrid centerVerticallyWithSuperview];
    [_levelsGrid setHeightConstraint:340.0f];
    
    AVTitleBar *titleBar = [[AVTitleBar alloc] init];
    titleBar.titleLabel.text = @"Choose a level";
    [self.view addSubview:titleBar];
    [titleBar centerHorizontallyWithSuperview];
    [titleBar pinToTopOfSuperview];

    AVExitBar *actionBar = [[AVExitBar alloc] initWithDelegate:self];
    [self.view addSubview:actionBar];
    [actionBar centerHorizontallyWithSuperview];
    [actionBar pinToBottomOfSuperview];
}

#pragma mark - UICollectionViewDataSource Methods
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _maxLevel;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AVLevelCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kLevelCellReuseIdentifier
                                                                           forIndexPath:indexPath];
    cell.levelLabel.text = [NSString stringWithFormat:@"%ld", indexPath.row + 1];
    cell.levelLabel.font = [UIFont systemFontOfSize:24.0f weight:UIFontWeightHeavy];
    cell.backgroundColor = [UIColor blueCellColor];
    return cell;
}

#pragma mark - UICollectionViewDelegate Methods

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *gameController = [[AVGameViewController alloc] initWithInitialLevel:indexPath.row + 1];
    [AVRootViewController transitionToViewController:gameController];
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat dimension = (_levelsGrid.frame.size.width - 4 * kLevelButtonSpacing) / 5;
    return CGSizeMake(dimension, dimension);
}

#pragma mark - AVExitBarDelegate Methods

- (void)actionBarDidTapExitButton:(AVExitBar *)actionBar
{
    AVMainViewController *mainViewController = [[AVMainViewController alloc] initWithHasInitialAnimation:NO];
    [AVRootViewController transitionToViewController:mainViewController];
}

@end
