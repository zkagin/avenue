//
//  AVLevelsViewController.m
//  Avenue
//
//  Created by Zach Kagin on 12/25/16.
//  Copyright © 2016 Zach Kagin. All rights reserved.
//

#import "AVExitBar.h"
#import "AVTitleLabel.h"
#import "AVMainViewController.h"
#import "AVRootViewController.h"
#import "AVLevelsViewController.h"
#import "AVLevelCollectionViewCell.h"
#import "AVLevelCollectionViewLayout.h"
#import "AVGameViewController.h"
#import "AVGlobalStateHelper.h"
#import "UIView+Avenue.h"
#import "UIColor+Avenue.h"

NSString * const kLevelCellReuseIdentifier = @"kLevelCellReuseIdentifier";
static const CGFloat kLevelButtonSpacing = 100.0f;
static const CGFloat kLevelButtonSize = 100.0f;
static const CGFloat kLevelButtonFontSize = 22.0f;

@interface AVLevelsViewController ()
    <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout,AVExitBarDelegate>
@end

@implementation AVLevelsViewController {
    NSUInteger _initialLevel;       // Initially selected level on load.
    NSUInteger _maxLevel;           // Total number of levels available.
    UICollectionView *_levelsGrid;  // The collection view showing the level selector.
    BOOL _didScrollToInitialLevel;  // Whether or not the initial scrolling to the correct level has happened.
}

- (instancetype)initWithInitialLevel:(NSUInteger)level
{
    self = [super init];
    if (self) {
        _maxLevel = [AVGlobalStateHelper maxLevel];
        // If the level is 0, that indicates it should use the maximum available level.
        _initialLevel = level == 0 ? _maxLevel : level;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor backgroundColor];
    
    UICollectionViewFlowLayout *levelsLayout = [[AVLevelCollectionViewLayout alloc] init];
    levelsLayout.minimumInteritemSpacing = kLevelButtonSpacing;
    levelsLayout.minimumLineSpacing = kLevelButtonSpacing;
    
    _levelsGrid = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:levelsLayout];
    _levelsGrid.dataSource = self;
    _levelsGrid.delegate = self;
    _levelsGrid.backgroundColor = [UIColor clearColor];
    _levelsGrid.showsHorizontalScrollIndicator = NO;
    _levelsGrid.translatesAutoresizingMaskIntoConstraints = NO;
    [_levelsGrid registerClass:[AVLevelCollectionViewCell class] forCellWithReuseIdentifier:kLevelCellReuseIdentifier];
    
    // Adds an inset so that the first and last levels can be correctly centered.
    CGFloat inset = (self.view.frame.size.width - kLevelButtonSize)/2;
    _levelsGrid.contentInset = UIEdgeInsetsMake(0, inset, 0, inset);
    
    [self.view addSubview:_levelsGrid];
    [_levelsGrid resizeHorizontallyWithSuperview];
    [_levelsGrid centerVerticallyWithSuperview];
    [_levelsGrid.heightAnchor constraintEqualToConstant:kLevelButtonSize*2].active = YES;
    
    // Create additional labels.
    AVTitleLabel *titleLabel = [[AVTitleLabel alloc] init];
    titleLabel.text = @"Choose a level";
    [self.view addSubview:titleLabel];
    [titleLabel centerHorizontallyWithSuperview];
    [titleLabel pinToTopOfSuperviewSafeAreaLayoutGuide];
    
    AVExitBar *exitBar = [[AVExitBar alloc] initWithDelegate:self];
    [self.view addSubview:exitBar];
    [exitBar centerHorizontallyWithSuperview];
    [exitBar pinToBottomOfSuperviewSafeAreaLayoutGuide];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    // This is needed to scroll to the current level as quickly as possible, before the user sees the screen.
    // Unfortunately, viewDidLoad is called too early for this to work.
    if (self.viewLoaded && !_didScrollToInitialLevel) {
        [_levelsGrid scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:_initialLevel-1 inSection:0]
                            atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                                    animated:NO];
        _didScrollToInitialLevel = YES;
    }
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
    cell.levelLabel.text = [NSString stringWithFormat:@"%ld", (long)indexPath.row + 1];
    cell.levelLabel.font = [UIFont systemFontOfSize:kLevelButtonFontSize weight:UIFontWeightHeavy];
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
    return CGSizeMake(kLevelButtonSize, kLevelButtonSize);
}

#pragma mark - AVExitBarDelegate Methods

- (void)actionBarDidTapExitButton:(AVExitBar *)actionBar
{
    AVMainViewController *mainViewController = [[AVMainViewController alloc] initWithHasInitialAnimation:NO];
    [AVRootViewController transitionToViewController:mainViewController];
}

@end
