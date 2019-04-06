//
//  AVLevelCollectionViewCell.h
//  Avenue
//
//  Created by Zach Kagin on 2/12/17.
//  Copyright © 2017 Zach Kagin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * A basic cell used for displaying cells on the level selection menu.
 */
@interface AVLevelCollectionViewCell : UICollectionViewCell

@property (nonatomic, readonly, strong) UILabel *levelLabel;

@end

NS_ASSUME_NONNULL_END
