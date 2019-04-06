//
//  AVGameCollectionViewCell.h
//  Avenue
//
//  Created by Zach Kagin on 2/12/17.
//  Copyright © 2017 Zach Kagin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * A basic cell used for displaying cells on the game board.
 */
@interface AVGameCollectionViewCell : UICollectionViewCell

@property (nonatomic, readonly, strong) UILabel *valueLabel;

@end

NS_ASSUME_NONNULL_END
