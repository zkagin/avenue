//
//  AVLevelCollectionViewCell.m
//  Avenue
//
//  Created by Zach Kagin on 2/12/17.
//  Copyright © 2017 Zach Kagin. All rights reserved.
//

#import "AVLevelCollectionViewCell.h"
#import "UIColor+Avenue.h"
#import "UIView+Avenue.h"

@implementation AVLevelCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _levelLabel = [[UILabel alloc] init];
        _levelLabel.textColor = [UIColor whiteColor];
        _levelLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:_levelLabel];
        [_levelLabel centerHorizontallyWithSuperview];
        [_levelLabel centerVerticallyWithSuperview];
        self.layer.cornerRadius = 6.0f;
    }
    return self;
}

@end
