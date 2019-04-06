//
//  AVGameBoardView.h
//  Avenue
//
//  Created by Zach Kagin on 5/29/17.
//  Copyright © 2017 Zach Kagin. All rights reserved.
//

#import "UIColor+Avenue.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol AVGameBoardViewDelegate;

/**
 * A grid of numbers that allows the user to swipe or tap to make and undo moves.
 */
@interface AVGameBoardView : UICollectionView

- (instancetype)initWithDelegate:(id<AVGameBoardViewDelegate>)delegate;

// Unavailable initializers.
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout NS_UNAVAILABLE;

/**
 * Resets the board.
 */
- (void)resetBoardWithNewGrid;

/**
 * Properties related to the setup and rules of the board.
 */
@property (nonatomic, readwrite) NSInteger boardSize;  // The number of rows and columns.
@property (nonatomic, readwrite) NSInteger upperRange; // The upper range of numbers allowed on the board.
@property (nonatomic, readwrite) CGFloat colorScale;   // 1 = Full color palette, 0 = Gray scale.
@property (nonatomic, readwrite) BOOL randomColors;    // Whether or not color strength should be linear to the number.

/**
 * Information about the grid.
 */
@property (nonatomic, readonly) BOOL levelIsCompleted;  // Yes if the level is completed and moves are not allowed.
@property (nonatomic, readonly) NSInteger currentScore; // The current sum of the path the user has.

@end

@protocol AVGameBoardViewDelegate

/** Called when the board has completed the path, and what the delta from a perfect score is. */
- (void)gameBoardViewDidCompletePath:(AVGameBoardView *)gameBoardView withScoreDelta:(NSUInteger)scoreDelta;

/** Called whenever the score is updated on the board, which is whenever the user makes or undoes a move. */
- (void)gameBoardViewDidUpdateScore:(AVGameBoardView *)gameBoardView;

@end

NS_ASSUME_NONNULL_END
