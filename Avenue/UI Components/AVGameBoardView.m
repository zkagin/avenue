//
//  AVGameBoardView.m
//  Avenue
//
//  Created by Zach Kagin on 5/29/17.
//  Copyright © 2017 Zach Kagin. All rights reserved.
//

#import "AVGameBoardView.h"

#import "AVGameCollectionViewCell.h"
#import "AVGameGraph.h"
#import "UIColor+Avenue.h"
#import "UIView+Avenue.h"

NSString *const kBoardCellReuseIdentifier = @"kBoardCellReuseIdentifier";

@interface AVGameBoardView () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, readonly) NSIndexPath *selectedIndex; // The last item in the current path.
@end

@implementation AVGameBoardView {
    __weak id<AVGameBoardViewDelegate> _delegate; // The delegate to notify of user actions.
    NSMutableArray<NSIndexPath *> *_currentPath;  // A list of currently selected cells.
    NSArray<NSIndexPath *> *_optimalPath; // The correct path, or nil when the current path is correct or incomplete.
    NSArray<NSArray<NSNumber *> *> *_gridInformation; // The backing numbers for the grid.

    // A dictionary mapping numbers to other randomly generated numbers, for the purpose of allowing colors to be
    // random, but consistent across moves and refreshes.
    NSMutableDictionary<NSNumber *, NSNumber *> *_randomNumberMapping;
}

- (instancetype)initWithDelegate:(id<AVGameBoardViewDelegate>)delegate;
{
    UICollectionViewFlowLayout *boardLayout = [[UICollectionViewFlowLayout alloc] init];
    boardLayout.minimumInteritemSpacing = 0.0f;
    self = [super initWithFrame:CGRectZero collectionViewLayout:boardLayout];
    if (self) {
        self.translatesAutoresizingMaskIntoConstraints = NO;

        // Defaults in case nothing has been set.
        self.boardSize = 2;
        self.upperRange = 5;
        self.colorScale = 1;
        self.randomColors = NO;
        _delegate = delegate;
        _randomNumberMapping = [[NSMutableDictionary alloc] init];

        self.dataSource = self;
        self.delegate = self;
        self.backgroundColor = [UIColor clearColor];
        [self registerClass:[AVGameCollectionViewCell class] forCellWithReuseIdentifier:kBoardCellReuseIdentifier];
        [self.widthAnchor constraintEqualToAnchor:self.heightAnchor multiplier:1].active = YES;

        // Add a gesture recognizer to allow swiping to move cells.
        UIPanGestureRecognizer *panGestureRecognizer =
            [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(av_didSwipe:)];
        [self addGestureRecognizer:panGestureRecognizer];

        [self resetBoardWithNewGrid];
    }
    return self;
}

- (NSIndexPath *)selectedIndex
{
    return _currentPath.lastObject;
}

#pragma mark - Public Methods

- (void)resetBoardWithNewGrid
{
    _optimalPath = nil;
    _gridInformation = [self av_generateGridInformation];
    _levelIsCompleted = NO;

    // Reset the current path.
    _currentPath = [NSMutableArray new];
    [_currentPath addObject:[NSIndexPath indexPathForRow:0 inSection:0]];
    [self reloadData];

    [_delegate gameBoardViewDidUpdateScore:self];
}

- (NSInteger)currentScore
{
    return [self av_scoreForPath:_currentPath];
}

#pragma mark - UICollectionViewDataSource Methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.boardSize;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.boardSize;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AVGameCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kBoardCellReuseIdentifier
                                                                               forIndexPath:indexPath];

    cell.valueLabel.font = [UIFont systemFontOfSize:(36 - 2 * self.boardSize) weight:UIFontWeightLight];
    NSInteger cellValue = _gridInformation[indexPath.row][indexPath.section].integerValue; // The score of the cell.

    // Configure the text to show the End text, Star for the beginning, or the value of the cell.
    if (indexPath == [NSIndexPath indexPathForRow:self.boardSize - 1 inSection:self.boardSize - 1]) {
        cell.valueLabel.text = @"End";
    } else if (indexPath == [NSIndexPath indexPathForRow:0 inSection:0]) {
        cell.valueLabel.text = @"\u2605";
    } else {
        cell.valueLabel.text = [NSString stringWithFormat:@"%ld", (long)cellValue];
    }

    // Configure the color of the cell, wit the current path a dark blue and others depending on their value.
    if ([_currentPath containsObject:indexPath]) {
        cell.backgroundColor = [UIColor blueCellColor];
        cell.valueLabel.textColor = [UIColor whiteColor];
    } else {
        cell.backgroundColor = [self av_colorForValue:cellValue];
        cell.valueLabel.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.85f];
    }

    // If the _optimalPath is not nil, we also show the correct path through a gray scale.
    if ([_optimalPath containsObject:indexPath]) {
        if ([_currentPath containsObject:indexPath]) {
            cell.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.75f];
        } else {
            cell.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5f];
        }
    }

    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                    layout:(UICollectionViewLayout *)collectionViewLayout
    sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat dimension = (self.frame.size.width) / self.boardSize;
    return CGSizeMake(dimension, dimension);
}

#pragma mark - UICollectionViewDelegate Methods

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self av_didTapIndexPath:indexPath];
}

#pragma mark - Move Actions

- (void)av_didSwipe:(UIPanGestureRecognizer *)sender
{
    // Don't allow actions if the game is over.
    if ([self av_isGameOver]) {
        return;
    }

    NSIndexPath *newIndexPath = [self indexPathForItemAtPoint:[sender locationInView:self]];
    if (newIndexPath == nil) {
        return;
    }

    // Check if the swipe is backwards, in which case this undoes the move.
    // The user must have at least two cells selected for this to work.
    if (_currentPath.count >= 2) {
        NSIndexPath *priorCell = _currentPath[_currentPath.count - 2];
        if ([newIndexPath isEqual:priorCell]) {
            [self av_undoMoves:1];
            return;
        }
    }
    [self av_attemptMoveToIndexPath:newIndexPath];
}

- (void)av_didTapIndexPath:(NSIndexPath *)indexPath
{
    // Don't allow actions if the game is over.
    if ([self av_isGameOver]) {
        return;
    }

    if ([indexPath isEqual:[_currentPath lastObject]]) {
        // If the cell is equal to the last object, the last move is undone.
        [self av_undoMoves:1];
    } else if ([_currentPath containsObject:indexPath]) {
        // If the cell is already on the path, it returns the user to the cell they tapped.
        NSInteger movesToUndo = _currentPath.count - [_currentPath indexOfObject:indexPath] - 1;
        [self av_undoMoves:movesToUndo];
    } else {
        // Otherwise, it attempts to move to the new cell.
        [self av_attemptMoveToIndexPath:indexPath];
    }
}

- (void)av_undoMoves:(NSInteger)numberOfMoves
{
    for (NSInteger move = 0; move < numberOfMoves; move++) {
        if (_currentPath.count >= 2) {
            [_currentPath removeLastObject];
        }
    }
    [self reloadData];
    [_delegate gameBoardViewDidUpdateScore:self];
}

- (void)av_attemptMoveToIndexPath:(NSIndexPath *)indexPath
{
    NSCAssert(indexPath != nil, @"attempting to move to a nil indexPath");
    if ([_currentPath containsObject:indexPath]) {
        return;
    }

    NSIndexPath *newMove = nil;
    if (indexPath.row == self.selectedIndex.row && indexPath.section == self.selectedIndex.section - 1) {
        newMove = [self av_moveUp];
    } else if (indexPath.row == self.selectedIndex.row + 1 && indexPath.section == self.selectedIndex.section) {
        newMove = [self av_moveRight];
    } else if (indexPath.row == self.selectedIndex.row && indexPath.section == self.selectedIndex.section + 1) {
        newMove = [self av_moveDown];
    } else if (indexPath.row == self.selectedIndex.row - 1 && indexPath.section == self.selectedIndex.section) {
        newMove = [self av_moveLeft];
    }
    if (newMove) {
        [_currentPath addObject:newMove];
        [self reloadData];
        if ([self av_isGameOver]) {
            [self av_endGame];
        } else {
            [_delegate gameBoardViewDidUpdateScore:self];
        }
    }
}

- (NSIndexPath *)av_moveUp
{
    return [NSIndexPath indexPathForRow:self.selectedIndex.row inSection:self.selectedIndex.section - 1];
}

- (NSIndexPath *)av_moveRight
{
    return [NSIndexPath indexPathForRow:self.selectedIndex.row + 1 inSection:self.selectedIndex.section];
}

- (NSIndexPath *)av_moveDown
{
    return [NSIndexPath indexPathForRow:self.selectedIndex.row inSection:self.selectedIndex.section + 1];
}

- (NSIndexPath *)av_moveLeft
{
    return [NSIndexPath indexPathForRow:self.selectedIndex.row - 1 inSection:self.selectedIndex.section];
}

#pragma mark - Game State

- (BOOL)av_isGameOver
{
    return self.selectedIndex == [NSIndexPath indexPathForRow:_gridInformation.count - 1
                                                    inSection:_gridInformation.count - 1];
}

/** Ends the game, calculating whether the user got the optimal path. */
- (void)av_endGame
{
    _optimalPath = [AVGameGraph calculateShortestPathWithIndexPathsForGrid:_gridInformation];
    NSUInteger delta = [self av_scoreForPath:_currentPath] - [self av_scoreForPath:_optimalPath];
    if (delta == 0) {
        _optimalPath = nil; // If score is perfect, don't do highlights, since the optimal path may be different.
    }
    [self reloadData];
    _levelIsCompleted = YES;
    [_delegate gameBoardViewDidCompletePath:self withScoreDelta:delta];
}

#pragma mark - Graph Methods

- (NSArray<NSArray<NSNumber *> *> *)av_generateGridInformation
{
    NSMutableArray<NSArray<NSNumber *> *> *gridInformationArray = [[NSMutableArray alloc] init];
    for (NSUInteger row = 0; row < self.boardSize; row++) {
        NSMutableArray<NSNumber *> *columnArray = [NSMutableArray new];
        for (NSUInteger column = 0; column < self.boardSize; column++) {
            NSNumber *value = @(1 + arc4random() % self.upperRange);
            if ((row == self.boardSize - 1 && column == self.boardSize - 1) || (row == 0 && column == 0)) {
                value = @(0);
            }
            [columnArray addObject:value];
        }
        [gridInformationArray addObject:[columnArray copy]];
    }
    return [gridInformationArray copy];
}

- (NSInteger)av_scoreForPath:(NSArray<NSIndexPath *> *)path
{
    NSInteger score = 0;
    for (NSUInteger i = 0; i < path.count; i++) {
        NSIndexPath *indexPath = path[i];
        score += _gridInformation[indexPath.row][indexPath.section].integerValue;
    }
    return score;
}

#pragma mark - Helpers

- (UIColor *)av_colorForValue:(NSInteger)value
{
    NSInteger newValue = value;
    if (self.randomColors) {
        if (_randomNumberMapping[@(value)]) {
            newValue = _randomNumberMapping[@(value)].integerValue;
        } else {
            newValue = 1 + arc4random() % self.upperRange;
            _randomNumberMapping[@(value)] = @(newValue);
        }
    }
    CGFloat multiplier = self.colorScale * (CGFloat)(newValue - 1) / (CGFloat)(self.upperRange - 1);
    CGFloat offColor = (200 - 75 * multiplier) / 255.0f;
    CGFloat onColor = (255 - 10 * multiplier) / 255.0f;
    return [UIColor colorWithRed:offColor green:offColor blue:onColor alpha:1.0f];
}

@end
