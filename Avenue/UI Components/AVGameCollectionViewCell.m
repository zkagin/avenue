//
//  AVGameCollectionViewCell.m
//  Avenue
//
//  Created by Zach Kagin on 2/12/17.
//  Copyright © 2017 Zach Kagin. All rights reserved.
//

#import "AVGameCollectionViewCell.h"
#import "UIColor+Avenue.h"
#import "UIView+Avenue.h"

@implementation AVGameCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _valueLabel = [[UILabel alloc] init];
        _valueLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:_valueLabel];
        [_valueLabel centerHorizontallyWithSuperview];
        [_valueLabel centerVerticallyWithSuperview];
        self.layer.borderColor = [UIColor backgroundColor].CGColor;
        self.layer.borderWidth = 1.0f;
        self.layer.cornerRadius = 2.0f;
    }
    return self;
}

@end
