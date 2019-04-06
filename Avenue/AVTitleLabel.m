//
//  AVTitleLabel.m
//  Avenue
//
//  Created by Zach Kagin on 9/2/17.
//  Copyright © 2017 Zach Kagin. All rights reserved.
//

#import "AVTitleLabel.h"

#import "UIView+Avenue.h"

static const CGFloat kTitleLabelFontSize = 26.0f;
static const CGFloat kTitleLabelHeight = 64.0f;

@implementation AVTitleLabel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.font = [UIFont systemFontOfSize:kTitleLabelFontSize weight:UIFontWeightBold];
        [self.heightAnchor constraintEqualToConstant:kTitleLabelHeight].active = YES;
        
    }
    return self;
}

@end
